import { useEffect, useState } from 'react'
import { Link, useLocation, useParams } from 'react-router-dom'
import { getFeedbackByAttemptId } from '../api/feedbackApi.js'
import { getLessonById, getLessons } from '../api/lessonApi.js'
import { QUIZ_CONFIG, RECOMMENDATION, ROUTES, STORAGE_KEYS } from '../constants/index.js'
import { normalizeList, sameId } from '../utils/flowHelpers.js'

function getCurrentUser() {
  try { return JSON.parse(localStorage.getItem(STORAGE_KEYS.USER) || 'null') } catch { return null }
}

function getRecommendationInfo(recommendation) {
  if (recommendation === RECOMMENDATION.REVIEW_LESSON)  return { icon: '🔁', label: 'Ôn tập bài học',     desc: 'Hãy xem lại nội dung bài trước khi tiếp tục.',       color: '#f59e0b' }
  if (recommendation === RECOMMENDATION.NEXT_LESSON)    return { icon: '🚀', label: 'Học bài tiếp theo',   desc: 'Bạn đã nắm vững bài này, sẵn sàng tiến lên.',         color: '#10b981' }
  if (recommendation === RECOMMENDATION.PRACTICE_MORE)  return { icon: '💪', label: 'Luyện tập thêm',      desc: 'Cần thêm thời gian để củng cố kiến thức.',             color: '#6366f1' }
  return { icon: '📋', label: 'Chưa có gợi ý', desc: 'Hệ thống chưa đưa ra gợi ý cụ thể.', color: '#64748b' }
}

function ScoreRing({ value, label, color = '#2563eb', size = 88 }) {
  const r = 36
  const circ = 2 * Math.PI * r
  const pct = Math.min(Math.max(Number(value) || 0, 0), 100)
  const offset = circ - (pct / 100) * circ

  return (
    <div className="fb-score-ring" style={{ width: size, height: size }}>
      <svg width={size} height={size} viewBox="0 0 88 88">
        <circle cx="44" cy="44" r={r} fill="none" stroke="#f1f5f9" strokeWidth="7" />
        <circle
          cx="44" cy="44" r={r}
          fill="none"
          stroke={color}
          strokeWidth="7"
          strokeLinecap="round"
          strokeDasharray={circ}
          strokeDashoffset={offset}
          transform="rotate(-90 44 44)"
          style={{ transition: 'stroke-dashoffset 1s ease' }}
        />
      </svg>
      <div className="fb-score-ring-inner">
        <strong style={{ color }}>{pct}%</strong>
        <span>{label}</span>
      </div>
    </div>
  )
}

function FeedbackPage() {
  const { attemptId } = useParams()
  const location = useLocation()
  const [feedback, setFeedback] = useState(null)
  const [nextLesson, setNextLesson] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    let isMounted = true
    const loadFeedback = async () => {
      setLoading(true)
      try {
        const stateFeedback = location.state?.feedback
        const user = getCurrentUser()
        const data = stateFeedback || (user?.id ? await getFeedbackByAttemptId(attemptId, user.id) : null)
        if (!data) throw new Error('Không tìm thấy phản hồi cho lượt làm quiz này.')

        let nextLessonData = null
        if (data.lessonId) {
          const currentLesson = await getLessonById(data.lessonId).catch(() => null)
          const lessons = currentLesson?.courseId ? await getLessons().catch(() => []) : []
          const sameCourseLessons = normalizeList(lessons)
            .filter((l) => sameId(l.courseId, currentLesson?.courseId))
            .sort((a, b) => (a.orderNumber || 0) - (b.orderNumber || 0))
          const idx = sameCourseLessons.findIndex((l) => sameId(l.id, data.lessonId))
          nextLessonData = idx >= 0 ? sameCourseLessons[idx + 1] || null : null
        }

        if (isMounted) { setFeedback(data); setNextLesson(nextLessonData); setError('') }
      } catch (err) {
        if (isMounted) setError(err.response?.data?.message || err.message || 'Không thể tải phản hồi.')
      } finally {
        if (isMounted) setLoading(false)
      }
    }
    loadFeedback()
    return () => { isMounted = false }
  }, [attemptId, location.state])

  if (loading) {
    return (
      <section className="page-shell wide-shell">
        <div className="ui-skeleton-page">
          <div className="ui-skeleton ui-sk-hero" />
          <div style={{ display: 'flex', gap: 16 }}>
            <div className="ui-skeleton ui-sk-card" />
            <div className="ui-skeleton ui-sk-card" />
            <div className="ui-skeleton ui-sk-card" />
          </div>
        </div>
      </section>
    )
  }

  if (error) {
    return (
      <section className="page-shell wide-shell">
        <div className="ui-empty-state">
          <div className="ui-empty-icon">❌</div>
          <h3>Không thể tải phản hồi</h3>
          <p>{error}</p>
          <div className="actions">
            <Link className="primary-button" to={ROUTES.DASHBOARD}>Xem bảng điều khiển</Link>
            <Link className="secondary-button" to={ROUTES.COURSES}>Quay lại khóa học</Link>
          </div>
        </div>
      </section>
    )
  }

  const passed = (feedback?.quizScore || 0) >= QUIZ_CONFIG.PASS_SCORE
  const rec = getRecommendationInfo(feedback?.recommendation)

  return (
    <section className="page-shell wide-shell fb-page">
      {/* Hero */}
      <div className={`fb-hero ${passed ? 'fb-hero-pass' : 'fb-hero-fail'}`}>
        <div className="fb-hero-left">
          <div className="fb-hero-badge">{passed ? '🎉 Đạt' : '⚡ Chưa đạt'}</div>
          <h1>{passed ? 'Xuất sắc! Tiếp tục phát huy.' : 'Cần luyện tập thêm.'}</h1>
          <p className="fb-hero-msg">{feedback?.message || 'Chưa có nội dung phản hồi.'}</p>
        </div>
        <div className="fb-hero-scores">
          <ScoreRing value={feedback?.quizScore ?? 0}  label="Quiz"     color={passed ? '#10b981' : '#f43f5e'} />
          <ScoreRing value={feedback?.focusScore ?? 0} label="Tập trung" color="#6366f1" />
        </div>
      </div>

      {/* Recommendation card */}
      <div className="fb-rec-card" style={{ '--rec-color': rec.color }}>
        <span className="fb-rec-icon">{rec.icon}</span>
        <div>
          <strong>{rec.label}</strong>
          <p>{rec.desc}</p>
        </div>
      </div>

      {/* Actions */}
      <div className="fb-actions">
        {feedback?.recommendation === RECOMMENDATION.REVIEW_LESSON && (
          <Link className="primary-button" to={ROUTES.lessonDetail(feedback.lessonId)}>🔁 Ôn tập bài học</Link>
        )}
        {feedback?.recommendation === RECOMMENDATION.NEXT_LESSON && nextLesson && (
          <Link className="primary-button" to={ROUTES.lessonDetail(nextLesson.id)}>🚀 Bài học tiếp theo</Link>
        )}
        {feedback?.recommendation === RECOMMENDATION.NEXT_LESSON && !nextLesson && (
          <Link className="primary-button" to={ROUTES.DASHBOARD}>📊 Xem dashboard</Link>
        )}
        {feedback?.recommendation === RECOMMENDATION.PRACTICE_MORE && (
          <Link className="primary-button" to={feedback?.lessonId ? ROUTES.quizPage(feedback.lessonId) : ROUTES.COURSES}>💪 Làm quiz lại</Link>
        )}
        <Link className="secondary-button" to={feedback?.lessonId ? ROUTES.lessonDetail(feedback.lessonId) : ROUTES.COURSES}>
          Quay lại bài học
        </Link>
        <Link className="secondary-button" to={ROUTES.DASHBOARD}>Bảng điều khiển</Link>
      </div>
    </section>
  )
}

export default FeedbackPage
