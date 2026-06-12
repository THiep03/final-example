import * as faceapi from '@vladmandic/face-api'
import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { getCourseById } from '../api/courseApi.js'
import { createFocusLog } from '../api/focusLogApi.js'
import { getLessonById, getLessons } from '../api/lessonApi.js'
import {
  createLessonInteraction,
  getLessonInteractionStats,
  getLessonReaction,
} from '../api/lessonInteractionApi.js'
import { completeProgress, startProgress } from '../api/progressApi.js'
import { AI_CONFIG, FOCUS_SCORE, FOCUS_STATUS, ROUTES, STORAGE_KEYS, getLessonNoteKey } from '../constants/index.js'

const emptyStats = { totalViews: 0, totalLikes: 0, totalDislikes: 0 }
const recentViewEvents = new Map()

const getCurrentUser = () => {
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEYS.USER) || 'null')
  } catch {
    return null
  }
}

const shouldSendView = (userId, lessonId) => {
  const key = `${userId}:${lessonId}`
  const now = Date.now()
  const lastSentAt = recentViewEvents.get(key)
  if (lastSentAt && now - lastSentAt < 1500) return false
  recentViewEvents.set(key, now)
  return true
}

function formatValue(value, suffix = '') {
  if (value === null || value === undefined || value === '') return 'Chưa cập nhật'
  return suffix ? `${value} ${suffix}` : value
}

let modelsLoaded = false
async function loadModelsOnce() {
  if (modelsLoaded) return
  await Promise.all([
    faceapi.nets.tinyFaceDetector.loadFromUri(AI_CONFIG.MODELS_URL),
    faceapi.nets.faceLandmark68TinyNet.loadFromUri(AI_CONFIG.MODELS_URL),
  ])
  modelsLoaded = true
}

function euclideanDist(a, b) {
  return Math.sqrt((a.x - b.x) ** 2 + (a.y - b.y) ** 2)
}

function eyeAspectRatio(eye) {
  const a = euclideanDist(eye[1], eye[5])
  const b = euclideanDist(eye[2], eye[4])
  const c = euclideanDist(eye[0], eye[3])
  return (a + b) / (2 * (c || 1))
}

function calculateEAR(landmarks) {
  const leftEAR = eyeAspectRatio(landmarks.getLeftEye())
  const rightEAR = eyeAspectRatio(landmarks.getRightEye())
  return (leftEAR + rightEAR) / 2
}

function estimateHeadPose(landmarks) {
  const nose = landmarks.getNose()
  const leftEye = landmarks.getLeftEye()
  const rightEye = landmarks.getRightEye()
  const jaw = landmarks.getJawOutline()
  const noseTip = nose[3]

  const leftSum = leftEye.reduce((acc, pt) => ({ x: acc.x + pt.x, y: acc.y + pt.y }), { x: 0, y: 0 })
  const rightSum = rightEye.reduce((acc, pt) => ({ x: acc.x + pt.x, y: acc.y + pt.y }), { x: 0, y: 0 })
  const leftCenter = { x: leftSum.x / leftEye.length, y: leftSum.y / leftEye.length }
  const rightCenter = { x: rightSum.x / rightEye.length, y: rightSum.y / rightEye.length }

  const eyeMidX = (leftCenter.x + rightCenter.x) / 2
  const eyeMidY = (leftCenter.y + rightCenter.y) / 2
  const eyeSpan = Math.abs(rightCenter.x - leftCenter.x)

  const horizontalOffset = Math.abs(noseTip.x - eyeMidX) / (eyeSpan || 1)
  if (horizontalOffset >= 0.35) return false

  const chin = jaw[8]
  const faceHeight = chin.y - eyeMidY
  if (faceHeight > 0) {
    const noseVerticalRatio = (noseTip.y - eyeMidY) / faceHeight
    if (noseVerticalRatio < 0.15 || noseVerticalRatio > 0.80) return false
  }

  return true
}

function getYouTubeEmbedUrl(url) {
  if (!url) return null
  try {
    const u = new URL(url)
    if (u.hostname === 'youtu.be') {
      return `https://www.youtube.com/embed${u.pathname}`
    }
    if (u.hostname.includes('youtube.com')) {
      if (u.pathname === '/watch') {
        const v = u.searchParams.get('v')
        return v ? `https://www.youtube.com/embed/${v}` : null
      }
      if (u.pathname.startsWith('/embed/')) return url
    }
  } catch {
    return null
  }
  return null
}

function LessonDetailPage() {
  const { id } = useParams()
  const webcamVideoRef = useRef(null)
  const webcamStreamRef = useRef(null)
  const detectionTimerRef = useRef(null)
  const logTimerRef = useRef(null)
  const focusFramesRef = useRef(0)
  const totalFramesRef = useRef(0)
  const distractedCountRef = useRef(0)
  const drowsyCountRef = useRef(0)

  const [lesson, setLesson] = useState(null)
  const [course, setCourse] = useState(null)
  const [courseLessons, setCourseLessons] = useState([])
  const [interactionStats, setInteractionStats] = useState(null)
  const [selectedReaction, setSelectedReaction] = useState(null)
  const [interactionError, setInteractionError] = useState('')
  const [interactingAction, setInteractingAction] = useState('')
  const [progressCompleted, setProgressCompleted] = useState(false)
  const [progressMessage, setProgressMessage] = useState('')
  const [progressError, setProgressError] = useState('')
  const [completingProgress, setCompletingProgress] = useState(false)

  const [cameraEnabled, setCameraEnabled] = useState(false)
  const [cameraStarting, setCameraStarting] = useState(false)
  const [cameraError, setCameraError] = useState('')
  const [modelsReady, setModelsReady] = useState(false)

  const [focusStatus, setFocusStatus] = useState('idle')
  const [focusScore, setFocusScore] = useState(null)
  const [focusAlert, setFocusAlert] = useState('')

  const [noteText, setNoteText] = useState('')

  const [videoError, setVideoError] = useState(false)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const stopDetection = useCallback(() => {
    clearInterval(detectionTimerRef.current)
    clearInterval(logTimerRef.current)
    detectionTimerRef.current = null
    logTimerRef.current = null
  }, [])

  const stopCamera = useCallback(() => {
    stopDetection()
    webcamStreamRef.current?.getTracks().forEach((track) => track.stop())
    webcamStreamRef.current = null
    if (webcamVideoRef.current) webcamVideoRef.current.srcObject = null
    setCameraEnabled(false)
    setCameraStarting(false)
    setFocusStatus('idle')
    setFocusAlert('')
  }, [stopDetection])

  useEffect(() => {
    loadModelsOnce().then(() => setModelsReady(true)).catch(() => {})
  }, [])

  useEffect(() => {
    let isMounted = true

    const refreshStats = async () => {
      try {
        const statsData = await getLessonInteractionStats(id)
        if (isMounted) setInteractionStats(statsData)
      } catch {
        if (isMounted) setInteractionStats(null)
      }
    }

    const sendViewInteraction = async () => {
      const user = getCurrentUser()
      if (!user?.id || !shouldSendView(user.id, id)) return
      try {
        await createLessonInteraction({ userId: user.id, lessonId: Number(id), action: 'view' })
        await refreshStats()
      } catch {
        // lỗi view không làm gián đoạn trang
      }
    }

    const loadLesson = async () => {
      setLoading(true)
      setInteractionError('')
      setProgressError('')
      setProgressMessage('')

      try {
        const user = getCurrentUser()

        if (user?.id) {
          const savedNote = localStorage.getItem(getLessonNoteKey(user.id, id))
          if (savedNote !== null && isMounted) setNoteText(savedNote)
        }

        const lessonData = await getLessonById(id)
        const reactionRequest = user?.id
          ? getLessonReaction(user.id, id).catch(() => ({ action: null }))
          : Promise.resolve({ action: null })
        const progressRequest = user?.id
          ? startProgress({ userId: user.id, lessonId: Number(id) }).catch(() => null)
          : Promise.resolve(null)

        const [statsData, reactionData, progressData, courseData, lessonsData] = await Promise.all([
          getLessonInteractionStats(id).catch(() => null),
          reactionRequest,
          progressRequest,
          lessonData?.courseId ? getCourseById(lessonData.courseId).catch(() => null) : Promise.resolve(null),
          getLessons().catch(() => []),
        ])

        const sameCourseLessons = (Array.isArray(lessonsData) ? lessonsData : [])
          .filter((item) => Number(item.courseId) === Number(lessonData.courseId))
          .sort((a, b) => (a.orderNumber || 0) - (b.orderNumber || 0))

        if (isMounted) {
          setLesson(lessonData)
          setCourse(courseData)
          setCourseLessons(sameCourseLessons)
          setInteractionStats(statsData)
          setSelectedReaction(reactionData?.action || null)
          setProgressCompleted(Boolean(progressData?.isCompleted || progressData?.completed))
          setVideoError(false)
          setError('')
        }

        sendViewInteraction()
      } catch (err) {
        if (isMounted) setError(err.response?.data?.message || 'Không thể tải chi tiết bài học.')
      } finally {
        if (isMounted) setLoading(false)
      }
    }

    loadLesson()
    return () => { isMounted = false }
  }, [id])

  useEffect(() => () => { stopCamera() }, [stopCamera])

  const sendFocusLog = useCallback(async (lessonId) => {
    const user = getCurrentUser()
    if (!user?.id || totalFramesRef.current === 0) return

    const score = Math.round((focusFramesRef.current / totalFramesRef.current) * 100)
    const status = score >= 70 ? 'focused' : score >= 40 ? 'distracted' : 'no_face'

    setFocusScore(score)
    focusFramesRef.current = 0
    totalFramesRef.current = 0

    try {
      await createFocusLog({
        userId: user.id,
        lessonId: Number(lessonId),
        status,
        focusScore: score,
        recordedAt: new Date().toISOString().replace('Z', ''),
      })
    } catch {
      // log thất bại không block UI
    }
  }, [])

  const startDetection = useCallback((lessonId) => {
    stopDetection()
    focusFramesRef.current = 0
    totalFramesRef.current = 0
    distractedCountRef.current = 0
    drowsyCountRef.current = 0

    detectionTimerRef.current = setInterval(async () => {
      const video = webcamVideoRef.current
      if (!video || video.readyState < 2) return

      try {
        const detection = await faceapi
          .detectSingleFace(video, new faceapi.TinyFaceDetectorOptions({ scoreThreshold: 0.4 }))
          .withFaceLandmarks(true)

        totalFramesRef.current += 1

        if (!detection) {
          distractedCountRef.current += 1
          drowsyCountRef.current = 0
          setFocusStatus(FOCUS_STATUS.NO_FACE)
          if (distractedCountRef.current >= AI_CONFIG.DISTRACT_ALERT_THRESHOLD) {
            setFocusAlert('⚠️ Không phát hiện khuôn mặt! Bạn có đang học không?')
          }
          return
        }

        const ear = calculateEAR(detection.landmarks)
        if (ear < AI_CONFIG.EAR_THRESHOLD) {
          drowsyCountRef.current += 1
          distractedCountRef.current += 1
          if (drowsyCountRef.current >= AI_CONFIG.DROWSY_ALERT_THRESHOLD) {
            setFocusStatus(FOCUS_STATUS.DROWSY)
            setFocusAlert('⚠️ Phát hiện buồn ngủ! Hãy tỉnh táo và tập trung vào bài học.')
          }
          return
        }

        drowsyCountRef.current = 0
        const focused = estimateHeadPose(detection.landmarks)
        if (focused) {
          focusFramesRef.current += 1
          distractedCountRef.current = 0
          setFocusStatus(FOCUS_STATUS.FOCUSED)
          setFocusAlert('')
        } else {
          distractedCountRef.current += 1
          setFocusStatus(FOCUS_STATUS.DISTRACTED)
          if (distractedCountRef.current >= AI_CONFIG.DISTRACT_ALERT_THRESHOLD) {
            setFocusAlert('⚠️ Bạn đang nhìn đi chỗ khác! Hãy tập trung vào bài học.')
          }
        }
      } catch {
        // detection lỗi bỏ qua frame này
      }
    }, AI_CONFIG.DETECTION_INTERVAL_MS)

    logTimerRef.current = setInterval(() => sendFocusLog(lessonId), AI_CONFIG.LOG_INTERVAL_MS)
  }, [stopDetection, sendFocusLog])

  const startCamera = useCallback(async () => {
    setCameraError('')
    if (!navigator.mediaDevices?.getUserMedia) {
      setCameraError('Trình duyệt của bạn chưa hỗ trợ mở camera.')
      return
    }
    setCameraStarting(true)
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: 'user' }, audio: false })
      webcamStreamRef.current = stream
      if (webcamVideoRef.current) webcamVideoRef.current.srcObject = stream
      setCameraEnabled(true)
      if (modelsReady && id) startDetection(id)
    } catch {
      setCameraError('Không thể mở camera. Vui lòng cấp quyền camera cho trình duyệt và thử lại.')
      setCameraEnabled(false)
    } finally {
      setCameraStarting(false)
    }
  }, [modelsReady, id, startDetection])

  useEffect(() => {
    if (cameraEnabled && modelsReady && id) startDetection(id)
  }, [modelsReady, cameraEnabled, id, startDetection])

  const handleNoteChange = (event) => {
    const value = event.target.value
    setNoteText(value)
    const user = getCurrentUser()
    if (user?.id) localStorage.setItem(getLessonNoteKey(user.id, id), value)
  }

  const nextLesson = useMemo(() => {
    if (!lesson || courseLessons.length === 0) return null
    const currentIndex = courseLessons.findIndex((item) => Number(item.id) === Number(lesson.id))
    if (currentIndex < 0) return null
    return courseLessons[currentIndex + 1] || null
  }, [courseLessons, lesson])

  const handleInteraction = async (action) => {
    const user = getCurrentUser()
    if (!user?.id) {
      setInteractionError('Vui lòng đăng nhập để tương tác với bài học.')
      return
    }
    setInteractingAction(action)
    setInteractionError('')
    try {
      await createLessonInteraction({ userId: user.id, lessonId: Number(id), action })
      const statsData = await getLessonInteractionStats(id)
      setInteractionStats(statsData)
      setSelectedReaction(action)
    } catch (err) {
      setInteractionError(err.response?.data?.message || 'Không thể ghi nhận tương tác. Vui lòng thử lại.')
    } finally {
      setInteractingAction('')
    }
  }

  const handleCompleteProgress = async () => {
    const user = getCurrentUser()
    if (!user?.id) {
      setProgressError('Vui lòng đăng nhập để đánh dấu hoàn thành bài học.')
      return
    }
    setCompletingProgress(true)
    setProgressError('')
    setProgressMessage('')
    try {
      const progressData = await completeProgress({ userId: user.id, lessonId: lesson.id })
      setProgressCompleted(Boolean(progressData?.isCompleted || progressData?.completed))
      setProgressMessage('Bài học đã hoàn thành')
    } catch (err) {
      setProgressError(err.response?.data?.message || 'Không thể cập nhật tiến trình học. Vui lòng thử lại.')
    } finally {
      setCompletingProgress(false)
    }
  }

  if (loading) {
    return (
      <section className="page-shell wide-shell">
        <p className="state-message">Đang tải bài học...</p>
      </section>
    )
  }

  if (error) {
    return (
      <section className="page-shell wide-shell">
        <p className="alert">{error}</p>
        <Link className="secondary-button inline-button" to="/courses">Quay lại khóa học</Link>
      </section>
    )
  }

  if (!lesson) {
    return (
      <section className="page-shell wide-shell">
        <p className="alert">Không tìm thấy bài học.</p>
        <Link className="secondary-button inline-button" to="/courses">Quay lại khóa học</Link>
      </section>
    )
  }

  const stats = interactionStats || emptyStats

  const focusStatusLabel = {
    [FOCUS_STATUS.IDLE]: 'Chờ phát hiện',
    [FOCUS_STATUS.FOCUSED]: 'Đang tập trung',
    [FOCUS_STATUS.DISTRACTED]: 'Mất tập trung',
    [FOCUS_STATUS.NO_FACE]: 'Không phát hiện khuôn mặt',
    [FOCUS_STATUS.DROWSY]: 'Phát hiện buồn ngủ',
  }[focusStatus] || 'Chờ phát hiện'

  const focusStatusClass = {
    [FOCUS_STATUS.FOCUSED]: 'is-on',
    [FOCUS_STATUS.DISTRACTED]: 'is-denied',
    [FOCUS_STATUS.NO_FACE]: 'is-denied',
    [FOCUS_STATUS.DROWSY]: 'is-warning',
  }[focusStatus] || 'is-off'

  return (
    <section className="page-shell wide-shell lesson-watch-page">
      <Link className="text-link" to={`/courses/${lesson.courseId}`}>Quay lại khóa học</Link>

      <article className="lesson-detail lesson-watch-layout">
        <div className="lesson-media-column">
          {/* Video bài giảng */}
          <section className="lesson-video-card" aria-label="Nội dung video bài học">
            <div className="lesson-card-heading">
              <div>
                <p className="eyebrow">Bài giảng</p>
                <h2>Nội dung bài học</h2>
              </div>
            </div>
            <div className="lesson-video-frame">
              {lesson.videoUrl && getYouTubeEmbedUrl(lesson.videoUrl) ? (
                <iframe
                  className="lesson-video"
                  src={getYouTubeEmbedUrl(lesson.videoUrl)}
                  title={lesson.title}
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                  allowFullScreen
                />
              ) : lesson.videoUrl && !videoError ? (
                <video className="lesson-video" controls src={lesson.videoUrl} onError={() => setVideoError(true)}>
                  Trình duyệt của bạn không hỗ trợ phát video.
                </video>
              ) : (
                <div className="video-placeholder lesson-empty-video">
                  <span className="video-play-orb" aria-hidden="true">▶</span>
                  <h2>Chưa có video cho bài học này</h2>
                  <p>Nội dung video sẽ hiển thị tại đây sau khi quản trị viên tải lên.</p>
                </div>
              )}
            </div>
          </section>

          {/* Webcam + AI Focus Detection */}
          <section className="webcam-focus-panel">
            <div className="webcam-focus-header">
              <div>
                <p className="eyebrow">Hỗ trợ tập trung</p>
                <h2>Theo dõi mức độ tập trung</h2>
                <p>Camera dùng để phân tích mức độ tập trung trong quá trình học bằng AI.</p>
              </div>
              <span className={`webcam-status ${cameraError ? 'is-denied' : cameraEnabled ? focusStatusClass : 'is-off'}`}>
                {cameraError ? 'Không có quyền camera' : cameraEnabled ? focusStatusLabel : 'Đang tắt'}
              </span>
            </div>

            {focusAlert && (
              <p className="alert compact-alert" role="alert">{focusAlert}</p>
            )}

            {cameraEnabled && focusScore !== null && (
              <div className="focus-score-display">
                <span>Điểm tập trung phiên vừa rồi:</span>
                <strong className={focusScore >= FOCUS_SCORE.GOOD ? 'score-good' : focusScore >= FOCUS_SCORE.MID ? 'score-mid' : 'score-low'}>
                  {focusScore}%
                </strong>
              </div>
            )}

            <div className="webcam-preview">
              <video
                ref={webcamVideoRef}
                autoPlay
                controls={false}
                disablePictureInPicture
                muted
                playsInline
                onClick={(event) => event.preventDefault()}
              />
              {!cameraEnabled && (
                <div className="webcam-placeholder">
                  <span aria-hidden="true">CAM</span>
                  <p>Camera chưa được bật</p>
                </div>
              )}
            </div>

            {cameraError && <p className="alert compact-alert">{cameraError}</p>}
            {!modelsReady && !cameraError && (
              <p className="muted compact-alert">Đang tải mô hình AI nhận diện khuôn mặt...</p>
            )}

            <div className="webcam-actions">
              <button
                className="secondary-button"
                type="button"
                disabled={cameraStarting || cameraEnabled || !modelsReady}
                onClick={startCamera}
              >
                {cameraStarting ? 'Đang mở camera...' : !modelsReady ? 'Đang tải AI...' : 'Bật camera'}
              </button>
              <button className="secondary-button" type="button" disabled={!cameraEnabled} onClick={stopCamera}>
                Tắt camera
              </button>
            </div>
            <p className="webcam-note">
              Dữ liệu camera chỉ xử lý cục bộ trên trình duyệt. Điểm tập trung được ghi lại mỗi 15 giây.
            </p>
          </section>

          {/* Ghi chú bài học */}
          <section className="lesson-notes-panel">
            <div className="lesson-card-heading">
              <div>
                <p className="eyebrow">Ghi chú</p>
                <h2>Ghi chú nội dung bài học</h2>
              </div>
            </div>
            <textarea
              className="lesson-note-textarea"
              placeholder="Ghi lại những điểm quan trọng trong bài học để ôn tập sau..."
              rows={6}
              value={noteText}
              onChange={handleNoteChange}
            />
            <p className="webcam-note">Ghi chú được lưu tự động trên thiết bị của bạn.</p>
          </section>
        </div>

        <aside className="lesson-detail-body lesson-info-panel">
          <div className="lesson-title-block">
            <span className="lesson-course-badge">{course?.title || 'Khóa học'}</span>
            <h1>{lesson.title || 'Bài học chưa đặt tên'}</h1>
            <p className="course-description">{lesson.description || 'Chưa có mô tả cho bài học này.'}</p>
          </div>

          <dl className="lesson-info-grid">
            <div>
              <dt>Thời lượng</dt>
              <dd>{formatValue(lesson.duration, 'phút')}</dd>
            </div>
            <div>
              <dt>Thứ tự</dt>
              <dd>{formatValue(lesson.orderNumber)}</dd>
            </div>
            <div>
              <dt>Trạng thái</dt>
              <dd>
                <span className={`lesson-progress-badge ${progressCompleted ? 'is-completed' : 'is-pending'}`}>
                  {progressCompleted ? 'Đã hoàn thành' : 'Chưa hoàn thành'}
                </span>
              </dd>
            </div>
          </dl>

          <div className="lesson-primary-actions">
            {progressCompleted ? (
              <p className="success-alert compact-alert">Bài học đã hoàn thành</p>
            ) : (
              <button
                className="primary-button"
                type="button"
                disabled={completingProgress}
                onClick={handleCompleteProgress}
              >
                {completingProgress ? 'Đang cập nhật...' : 'Đánh dấu hoàn thành'}
              </button>
            )}
            {progressMessage && !progressCompleted && <p className="success-alert compact-alert">{progressMessage}</p>}
            {progressError && <p className="alert compact-alert">{progressError}</p>}
            <Link className="primary-button quiz-cta-button" to={ROUTES.quizPage(lesson.id)}>Bắt đầu quiz</Link>
          </div>

          <div className="lesson-interaction-panel">
            <div className="lesson-compact-stats" aria-label="Thống kê tương tác bài học">
              <div className="lesson-compact-stat is-view">
                <span aria-hidden="true">👁</span>
                <strong>{stats.totalViews ?? 0}</strong>
                <small>lượt xem</small>
              </div>
              <div className="lesson-compact-stat is-like">
                <span aria-hidden="true">♥</span>
                <strong>{stats.totalLikes ?? 0}</strong>
                <small>lượt thích</small>
              </div>
              <div className="lesson-compact-stat is-dislike">
                <span aria-hidden="true">👎</span>
                <strong>{stats.totalDislikes ?? 0}</strong>
                <small>không thích</small>
              </div>
            </div>

            {interactionError && <p className="alert compact-alert">{interactionError}</p>}

            <div className="reaction-actions">
              <button
                className={`secondary-button reaction-button${selectedReaction === 'like' ? ' active' : ''}`}
                type="button"
                aria-pressed={selectedReaction === 'like'}
                disabled={Boolean(interactingAction)}
                onClick={() => handleInteraction('like')}
              >
                {interactingAction === 'like' ? 'Đang gửi...' : 'Thích'}
              </button>
              <button
                className={`secondary-button reaction-button${selectedReaction === 'dislike' ? ' active' : ''}`}
                type="button"
                aria-pressed={selectedReaction === 'dislike'}
                disabled={Boolean(interactingAction)}
                onClick={() => handleInteraction('dislike')}
              >
                {interactingAction === 'dislike' ? 'Đang gửi...' : 'Không thích'}
              </button>
            </div>
          </div>
        </aside>
      </article>

      {nextLesson && (
        <section className="next-lesson-section">
          <div className="section-heading compact-heading">
            <div>
              <p className="eyebrow">Lộ trình học</p>
              <h2>Tiếp tục học</h2>
            </div>
          </div>
          <article className="next-lesson-card">
            <div className="lesson-order">{nextLesson.orderNumber || '→'}</div>
            <div>
              <h3>{nextLesson.title || 'Bài học chưa đặt tên'}</h3>
              <p>{nextLesson.description || 'Chưa có mô tả cho bài học này.'}</p>
              <div className="lesson-meta">
                <span>{formatValue(nextLesson.duration, 'phút')}</span>
                <span>Thứ tự: {formatValue(nextLesson.orderNumber)}</span>
                <span>Chưa học</span>
              </div>
            </div>
            <Link className="primary-button lesson-button" to={`/lessons/${nextLesson.id}`}>Xem bài học</Link>
          </article>
        </section>
      )}
    </section>
  )
}

export default LessonDetailPage
