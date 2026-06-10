import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { getCourseById } from '../api/courseApi.js'
import { getLessonById, getLessons } from '../api/lessonApi.js'
import {
  createLessonInteraction,
  getLessonReaction,
  getLessonInteractionStats,
} from '../api/lessonInteractionApi.js'
import { completeProgress, startProgress } from '../api/progressApi.js'

const emptyStats = {
  totalViews: 0,
  totalLikes: 0,
  totalDislikes: 0,
}

const recentViewEvents = new Map()

const getCurrentUser = () => {
  try {
    return JSON.parse(localStorage.getItem('user') || 'null')
  } catch {
    return null
  }
}

const shouldSendView = (userId, lessonId) => {
  const key = `${userId}:${lessonId}`
  const now = Date.now()
  const lastSentAt = recentViewEvents.get(key)

  if (lastSentAt && now - lastSentAt < 1500) {
    return false
  }

  recentViewEvents.set(key, now)
  return true
}

function formatValue(value, suffix = '') {
  if (value === null || value === undefined || value === '') {
    return 'Chưa cập nhật'
  }

  return suffix ? `${value} ${suffix}` : value
}

function LessonDetailPage() {
  const { id } = useParams()
  const webcamVideoRef = useRef(null)
  const webcamStreamRef = useRef(null)
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
  const [videoError, setVideoError] = useState(false)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const stopCamera = useCallback(() => {
    webcamStreamRef.current?.getTracks().forEach((track) => track.stop())
    webcamStreamRef.current = null

    if (webcamVideoRef.current) {
      webcamVideoRef.current.srcObject = null
    }

    setCameraEnabled(false)
    setCameraStarting(false)
  }, [])

  useEffect(() => {
    let isMounted = true

    const refreshStats = async () => {
      try {
        const statsData = await getLessonInteractionStats(id)
        if (isMounted) {
          setInteractionStats(statsData)
        }
      } catch {
        if (isMounted) {
          setInteractionStats(null)
        }
      }
    }

    const sendViewInteraction = async () => {
      const user = getCurrentUser()

      if (!user?.id || !shouldSendView(user.id, id)) {
        return
      }

      try {
        await createLessonInteraction({
          userId: user.id,
          lessonId: Number(id),
          action: 'view',
        })
        await refreshStats()
      } catch {
        // Lượt xem không nên làm gián đoạn việc mở bài học.
      }
    }

    const loadLesson = async () => {
      setLoading(true)
      setInteractionError('')
      setProgressError('')
      setProgressMessage('')

      try {
        const user = getCurrentUser()
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
          .sort((first, second) => (first.orderNumber || 0) - (second.orderNumber || 0))

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
        if (isMounted) {
          setError(err.response?.data?.message || 'Không thể tải chi tiết bài học.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadLesson()

    return () => {
      isMounted = false
    }
  }, [id])

  useEffect(() => {
    return () => {
      stopCamera()
    }
  }, [stopCamera])

  const nextLesson = useMemo(() => {
    if (!lesson || courseLessons.length === 0) {
      return null
    }

    const currentIndex = courseLessons.findIndex((item) => Number(item.id) === Number(lesson.id))

    if (currentIndex < 0) {
      return null
    }

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
      await createLessonInteraction({
        userId: user.id,
        lessonId: Number(id),
        action,
      })
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
      const progressData = await completeProgress({
        userId: user.id,
        lessonId: lesson.id,
      })
      setProgressCompleted(Boolean(progressData?.isCompleted || progressData?.completed))
      setProgressMessage('Bài học đã hoàn thành')
    } catch (err) {
      setProgressError(err.response?.data?.message || 'Không thể cập nhật tiến trình học. Vui lòng thử lại.')
    } finally {
      setCompletingProgress(false)
    }
  }

  const startCamera = async () => {
    setCameraError('')

    if (!navigator.mediaDevices?.getUserMedia) {
      setCameraError('Trình duyệt của bạn chưa hỗ trợ mở camera.')
      return
    }

    setCameraStarting(true)
    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: {
          facingMode: 'user',
        },
        audio: false,
      })
      webcamStreamRef.current = stream

      if (webcamVideoRef.current) {
        webcamVideoRef.current.srcObject = stream
      }

      setCameraEnabled(true)
    } catch {
      setCameraError('Không thể mở camera. Vui lòng cấp quyền camera cho trình duyệt và thử lại.')
      setCameraEnabled(false)
    } finally {
      setCameraStarting(false)
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
        <Link className="secondary-button inline-button" to="/courses">
          Quay lại khóa học
        </Link>
      </section>
    )
  }

  if (!lesson) {
    return (
      <section className="page-shell wide-shell">
        <p className="alert">Không tìm thấy bài học.</p>
        <Link className="secondary-button inline-button" to="/courses">
          Quay lại khóa học
        </Link>
      </section>
    )
  }

  const stats = interactionStats || emptyStats

  return (
    <section className="page-shell wide-shell lesson-watch-page">
      <Link className="text-link" to={`/courses/${lesson.courseId}`}>
        Quay lại khóa học
      </Link>

      <article className="lesson-detail lesson-watch-layout">
        <div className="lesson-media-column">
          <section className="lesson-video-card" aria-label="Nội dung video bài học">
            <div className="lesson-card-heading">
              <div>
                <p className="eyebrow">Bài giảng</p>
                <h2>Nội dung bài học</h2>
              </div>
            </div>
            <div className="lesson-video-frame">
              {lesson.videoUrl && !videoError ? (
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

          <section className="webcam-focus-panel">
            <div className="webcam-focus-header">
              <div>
                <p className="eyebrow">Hỗ trợ tập trung</p>
                <h2>Theo dõi mức độ tập trung</h2>
                <p>Camera dùng để phân tích mức độ tập trung trong quá trình học.</p>
              </div>
              <span className={`webcam-status ${cameraError ? 'is-denied' : cameraEnabled ? 'is-on' : 'is-off'}`}>
                {cameraError ? 'Không có quyền camera' : cameraEnabled ? 'Đang bật' : 'Đang tắt'}
              </span>
            </div>

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

            <div className="webcam-actions">
              <button className="secondary-button" type="button" disabled={cameraStarting || cameraEnabled} onClick={startCamera}>
                {cameraStarting ? 'Đang mở camera...' : 'Bật camera'}
              </button>
              <button className="secondary-button" type="button" disabled={!cameraEnabled} onClick={stopCamera}>
                Tắt camera
              </button>
            </div>
            <p className="webcam-note">
              Dữ liệu camera chỉ dùng để phân tích mức độ tập trung trong phiên học.
            </p>
          </section>
        </div>

        <aside className="lesson-detail-body lesson-info-panel">
          <div className="lesson-title-block">
            <span className="lesson-course-badge">{course?.title || 'Khóa học'}</span>
            <h1>{lesson.title || 'Bài học chưa đặt tên'}</h1>
            <p className="course-description">
              {lesson.description || 'Chưa có mô tả cho bài học này.'}
            </p>
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
            <Link className="primary-button quiz-cta-button" to={`/quiz/${lesson.id}`}>
              Bắt đầu quiz
            </Link>
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
            <Link className="primary-button lesson-button" to={`/lessons/${nextLesson.id}`}>
              Xem bài học
            </Link>
          </article>
        </section>
      )}
    </section>
  )
}

export default LessonDetailPage
