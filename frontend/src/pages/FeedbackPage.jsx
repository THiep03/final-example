import { useEffect, useState } from 'react'
import { Link, useLocation, useParams } from 'react-router-dom'
import { getFeedbackByAttemptId } from '../api/feedbackApi.js'
import { getLessonById, getLessons } from '../api/lessonApi.js'
import { normalizeList, sameId } from '../utils/flowHelpers.js'

function getCurrentUser() {
  try {
    return JSON.parse(localStorage.getItem('user') || 'null')
  } catch {
    return null
  }
}

function getRecommendationLabel(recommendation) {
  if (recommendation === 'review_lesson') {
    return 'Ôn tập bài học'
  }
  if (recommendation === 'next_lesson') {
    return 'Bài học tiếp theo'
  }
  if (recommendation === 'practice_more') {
    return 'Luyện tập thêm'
  }
  return 'Chưa có gợi ý'
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

        if (!data) {
          throw new Error('Không tìm thấy phản hồi cho lượt làm quiz này.')
        }

        let nextLessonData = null
        if (data.lessonId) {
          const currentLesson = await getLessonById(data.lessonId).catch(() => null)
          const lessons = currentLesson?.courseId ? await getLessons().catch(() => []) : []
          const sameCourseLessons = normalizeList(lessons)
            .filter((lesson) => sameId(lesson.courseId, currentLesson?.courseId))
            .sort((first, second) => (first.orderNumber || 0) - (second.orderNumber || 0))
          const currentIndex = sameCourseLessons.findIndex((lesson) => sameId(lesson.id, data.lessonId))
          nextLessonData = currentIndex >= 0 ? sameCourseLessons[currentIndex + 1] || null : null
        }

        if (isMounted) {
          setFeedback(data)
          setNextLesson(nextLessonData)
          setError('')
        }
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || err.message || 'Không thể tải phản hồi.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadFeedback()

    return () => {
      isMounted = false
    }
  }, [attemptId, location.state])

  if (loading) {
    return (
      <section className="page-shell wide-shell">
        <p className="state-message">Đang tải phản hồi...</p>
      </section>
    )
  }

  if (error) {
    return (
      <section className="page-shell wide-shell">
        <p className="alert">{error}</p>
        <div className="actions inline-button">
          <Link className="primary-button" to="/dashboard">
            Xem bảng điều khiển
          </Link>
          <Link className="secondary-button" to="/courses">
            Quay lại khóa học
          </Link>
        </div>
      </section>
    )
  }

  const passed = (feedback?.quizScore || 0) >= 70
  const recommendation = feedback?.recommendation

  return (
    <section className="page-shell wide-shell">
      <article className={`feedback-dashboard ${passed ? 'is-pass' : 'is-fail'}`}>
        <div className="feedback-hero">
          <div>
            <p className="eyebrow">Phản hồi học tập</p>
            <h1>{passed ? 'Tiến độ tốt' : 'Cần luyện tập thêm'}</h1>
            <p>{feedback?.message || 'Chưa có nội dung phản hồi.'}</p>
          </div>
          <span className="feedback-status">{passed ? 'Đạt' : 'Chưa đạt'}</span>
        </div>

        <dl className="feedback-metrics">
          <div>
            <dt>Điểm tập trung</dt>
            <dd>{feedback?.focusScore ?? 0}</dd>
          </div>
          <div>
            <dt>Điểm quiz</dt>
            <dd>{feedback?.quizScore ?? 0}</dd>
          </div>
          <div>
            <dt>Gợi ý</dt>
            <dd>{getRecommendationLabel(recommendation)}</dd>
          </div>
        </dl>

        <div className="actions">
          {recommendation === 'review_lesson' && (
            <Link className="primary-button" to={`/lessons/${feedback.lessonId}`}>
              Ôn tập bài học
            </Link>
          )}
          {recommendation === 'next_lesson' && nextLesson && (
            <Link className="primary-button" to={`/lessons/${nextLesson.id}`}>
              Bài học tiếp theo
            </Link>
          )}
          {recommendation === 'next_lesson' && !nextLesson && (
            <Link className="primary-button" to="/dashboard">
              Xem dashboard
            </Link>
          )}
          <Link className="secondary-button" to={feedback?.lessonId ? `/lessons/${feedback.lessonId}` : '/courses'}>
            Quay lại bài học
          </Link>
          <Link className="secondary-button" to="/dashboard">
            Xem bảng điều khiển
          </Link>
        </div>
      </article>
    </section>
  )
}

export default FeedbackPage
