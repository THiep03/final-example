import { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { getCourses } from '../api/courseApi.js'
import { getUserDashboard } from '../api/dashboardApi.js'
import { getFeedbacksByUserId } from '../api/feedbackApi.js'
import { getLessons } from '../api/lessonApi.js'
import { getProgressByUserId } from '../api/progressApi.js'
import { QUIZ_CONFIG, RECOMMENDATION, ROUTES } from '../constants/index.js'
import { getStoredUser, normalizeList, toNumericId } from '../utils/flowHelpers.js'

function average(items, field) {
  const values = (Array.isArray(items) ? items : [])
    .map((item) => item[field])
    .filter((value) => typeof value === 'number')

  if (values.length === 0) {
    return 0
  }

  return values.reduce((total, value) => total + value, 0) / values.length
}

function recent(items, dateField, limit = 4) {
  return [...(Array.isArray(items) ? items : [])]
    .sort((first, second) => new Date(second[dateField] || 0) - new Date(first[dateField] || 0))
    .slice(0, limit)
}

function formatDateTime(value) {
  if (!value) {
    return 'Chưa cập nhật'
  }

  const date = new Date(value)

  if (Number.isNaN(date.getTime())) {
    return 'Chưa cập nhật'
  }

  return new Intl.DateTimeFormat('vi-VN', {
    dateStyle: 'short',
    timeStyle: 'short',
  }).format(date)
}

function isProgressCompleted(item) {
  return Boolean(item?.isCompleted ?? item?.completed)
}

function clampPercent(value) {
  return Math.min(Math.max(value || 0, 0), 100)
}

function getQuizDate(attempt) {
  return attempt?.finishedAt || attempt?.startedAt || attempt?.createdAt
}

function getRecommendationLabel(value) {
  const labels = {
    [RECOMMENDATION.NEXT_LESSON]: 'Học bài tiếp theo',
    [RECOMMENDATION.REVIEW_LESSON]: 'Ôn tập bài học',
    [RECOMMENDATION.PRACTICE_MORE]: 'Luyện tập thêm',
  }

  return labels[value] || 'Chưa có khuyến nghị'
}

function getFeedbackStatus(feedback) {
  if (feedback?.recommendation === RECOMMENDATION.NEXT_LESSON || (feedback?.quizScore ?? 0) >= QUIZ_CONFIG.PASS_SCORE) {
    return { className: 'is-good', label: 'Kết quả tốt' }
  }

  if (feedback?.recommendation === RECOMMENDATION.REVIEW_LESSON) {
    return { className: 'is-review', label: 'Nên ôn tập lại' }
  }

  return { className: 'is-practice', label: 'Cần luyện tập thêm' }
}

function truncateText(value, maxLength = 120) {
  if (!value) {
    return 'Chưa có nội dung phản hồi.'
  }

  if (value.length <= maxLength) {
    return value
  }

  return `${value.slice(0, maxLength).trim()}...`
}

function buildCourseProgress(courses, lessons, progressItems) {
  const safeCourses = normalizeList(courses)
  const safeLessons = normalizeList(lessons)
  const safeProgressItems = normalizeList(progressItems)

  if (safeProgressItems.length === 0 || safeLessons.length === 0) {
    return []
  }

  const courseById = new Map(safeCourses.map((course) => [toNumericId(course.id), course]))
  const lessonById = new Map(safeLessons.map((lesson) => [toNumericId(lesson.id), lesson]))
  const progressByLessonId = new Map(safeProgressItems.map((item) => [toNumericId(item.lessonId), item]))
  const activeCourseIds = new Set(
    safeProgressItems
      .map((item) => toNumericId(item.courseId) || toNumericId(lessonById.get(toNumericId(item.lessonId))?.courseId))
      .filter((courseId) => courseId !== null),
  )

  return [...activeCourseIds]
    .map((courseId) => {
      const course = courseById.get(courseId)
      const courseLessons = safeLessons
        .filter((lesson) => Number(lesson?.courseId) === courseId)
        .sort((first, second) => (first.orderNumber || 0) - (second.orderNumber || 0))
      const completedLessons = courseLessons.filter((lesson) => isProgressCompleted(progressByLessonId.get(toNumericId(lesson.id))))
      const totalLessons = courseLessons.length
      const progressPercent = totalLessons === 0 ? 0 : (completedLessons.length / totalLessons) * 100

      return {
        courseId,
        courseName: course?.title || `Khóa học #${courseId}`,
        totalLessons,
        completedLessonCount: completedLessons.length,
        progressPercent,
      }
    })
    .sort((first, second) => second.progressPercent - first.progressPercent)
}

function StudentDashboardPage() {
  const user = useMemo(() => getStoredUser(), [])
  const [dashboard, setDashboard] = useState(null)
  const [learningProgress, setLearningProgress] = useState([])
  const [userFeedbacks, setUserFeedbacks] = useState([])
  const [courses, setCourses] = useState([])
  const [lessons, setLessons] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [expandedFeedbackIds, setExpandedFeedbackIds] = useState([])

  useEffect(() => {
    let isMounted = true

    const loadDashboard = async () => {
      if (!user?.id) {
        setError('Vui lòng đăng nhập để xem bảng điều khiển.')
        setLoading(false)
        return
      }

      try {
        const [dashboardData, progressData, feedbackData, coursesData, lessonsData] = await Promise.all([
          getUserDashboard(user.id).catch(() => null),
          getProgressByUserId(user.id).catch(() => []),
          getFeedbacksByUserId(user.id).catch(() => []),
          getCourses().catch(() => []),
          getLessons().catch(() => []),
        ])
        if (isMounted) {
          setDashboard(dashboardData)
          setLearningProgress(normalizeList(progressData))
          setUserFeedbacks(normalizeList(feedbackData))
          setCourses(normalizeList(coursesData))
          setLessons(normalizeList(lessonsData))
          setError('')
        }
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || 'Không thể tải bảng điều khiển.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadDashboard()

    return () => {
      isMounted = false
    }
  }, [user])

  const progress = Array.isArray(learningProgress) ? learningProgress : []
  const quizAttempts = Array.isArray(dashboard?.quizAttempts) ? dashboard.quizAttempts : []
  const feedbacks = Array.isArray(userFeedbacks) ? userFeedbacks : []
  const focusLogs = Array.isArray(dashboard?.focusLogs) ? dashboard.focusLogs : []
  const averageScore = average(quizAttempts, 'score')
  const averageFocus = average(focusLogs, 'focusScore')
  const recentAttempts = recent(quizAttempts, 'finishedAt', 5)
  const recentFeedbacks = recent(feedbacks, 'createdAt', 3)
  const courseProgress = buildCourseProgress(courses, lessons, progress)
  const totalActiveCourses = courseProgress.length
  const totalLessons = courseProgress.reduce((total, course) => total + course.totalLessons, 0)
  const completedLessons = courseProgress.reduce((total, course) => total + course.completedLessonCount, 0)
  const fallbackCompletedLessons = progress.filter(isProgressCompleted).length
  const averageProgress = totalLessons === 0 ? 0 : (completedLessons / totalLessons) * 100
  const courseById = new Map(courses.map((course) => [toNumericId(course.id), course]))
  const lessonById = new Map(lessons.map((lesson) => [toNumericId(lesson.id), lesson]))
  const getLessonInfo = (lessonId) => {
    const lesson = lessonById.get(toNumericId(lessonId))
    const course = courseById.get(toNumericId(lesson?.courseId))

    return {
      courseName: course?.title || 'Chưa rõ khóa học',
      lessonName: lesson?.title || `Bài học #${lessonId || '-'}`,
    }
  }
  const latestFailedAttempt = recentAttempts.find((attempt) => attempt.resultStatus !== 'pass')
  const incompleteCourse = courseProgress.find((course) => course.progressPercent < 100)
  const learningSuggestions = [
    incompleteCourse
      ? {
          id: 'continue-course',
          title: `Tiếp tục học khóa ${incompleteCourse.courseName}`,
          description: `Bạn đã hoàn thành ${incompleteCourse.completedLessonCount}/${incompleteCourse.totalLessons} bài.`,
          to: `/dashboard/courses/${incompleteCourse.courseId}/progress`,
        }
      : null,
    latestFailedAttempt
      ? {
          id: 'review-lesson',
          title: `Ôn tập lại bài ${getLessonInfo(latestFailedAttempt.lessonId).lessonName}`,
          description: `Điểm gần nhất là ${latestFailedAttempt.score ?? 0}%, hãy xem lại nội dung bài học trước khi làm lại.`,
          to: `/lessons/${latestFailedAttempt.lessonId}`,
        }
      : null,
  ].filter(Boolean)
  const toggleFeedback = (feedbackId) => {
    setExpandedFeedbackIds((current) =>
      current.includes(feedbackId)
        ? current.filter((id) => id !== feedbackId)
        : [...current, feedbackId],
    )
  }

  if (loading) {
    return (
      <section className="page-shell wide-shell">
        <p className="state-message">Đang tải bảng điều khiển...</p>
      </section>
    )
  }

  if (!user?.id) {
    return (
      <section className="page-shell">
        <div className="panel home-panel">
          <p className="alert">{error}</p>
          <Link className="primary-button" to="/login">
            Đăng nhập
          </Link>
        </div>
      </section>
    )
  }

  return (
    <section className="page-shell wide-shell dashboard-page">
      <div className="section-heading">
        <div>
          <p className="eyebrow">Người học</p>
          <h1>{dashboard?.user?.name || user.name || 'Bảng điều khiển'}</h1>
        </div>
        <p className="muted">Theo dõi tiến trình học tập, kết quả quiz và mức độ tập trung.</p>
      </div>

      {error && <p className="alert">{error}</p>}

      {!error && (
        <>
          <div className="dashboard-grid dashboard-overview-grid">
            <article className="dashboard-card dashboard-stat-card stat-blue">
              <div className="stat-icon">Q</div>
              <span>Điểm quiz trung bình</span>
              <strong>{averageScore.toFixed(1)}%</strong>
            </article>
            <article className="dashboard-card dashboard-stat-card stat-teal">
              <div className="stat-icon">F</div>
              <span>Điểm tập trung trung bình</span>
              <strong>{averageFocus.toFixed(1)}%</strong>
            </article>
            <article className="dashboard-card dashboard-stat-card stat-indigo">
              <div className="stat-icon">C</div>
              <span>Số khóa học đang học</span>
              <strong>{totalActiveCourses}</strong>
            </article>
            <article className="dashboard-card dashboard-stat-card stat-green">
              <div className="stat-icon">L</div>
              <span>Bài học đã hoàn thành</span>
              <strong>{completedLessons || fallbackCompletedLessons}</strong>
            </article>
            <article className="dashboard-card dashboard-stat-card stat-orange">
              <div className="stat-icon">A</div>
              <span>Lượt làm quiz</span>
              <strong>{quizAttempts.length}</strong>
            </article>
          </div>

          <div className="dashboard-main-grid">
            <div className="dashboard-main-column">
              <section className="dashboard-panel course-progress-panel">
                <div className="dashboard-panel-heading">
                  <div>
                    <h2>Tiến trình học tập</h2>
                    <p className="muted">
                      Trung bình hoàn thành {averageProgress.toFixed(0)}% trên {totalLessons} bài học.
                    </p>
                  </div>
                </div>
                {courseProgress.length === 0 ? (
                  <p className="state-message">Chưa có dữ liệu tiến trình học</p>
                ) : (
                  <div className="course-progress-list">
                    {courseProgress.map((course) => (
                      <article className="course-progress-card compact-progress-card" key={course.courseId}>
                        <div className="course-progress-header">
                          <div>
                            <h3>{course.courseName}</h3>
                            <p>
                              {course.completedLessonCount} / {course.totalLessons} bài
                            </p>
                          </div>
                          <strong>{course.progressPercent.toFixed(0)}%</strong>
                        </div>

                        <div className="course-progress-bar" aria-label={`Tiến độ ${course.courseName}`}>
                          <span style={{ width: `${clampPercent(course.progressPercent)}%` }} />
                        </div>

                        <div className="course-progress-actions">
                          <Link className="secondary-button" to={`/dashboard/courses/${course.courseId}/progress`}>
                            Xem chi tiết
                          </Link>
                        </div>
                      </article>
                    ))}
                  </div>
                )}
              </section>

              <section className="dashboard-panel">
                <div className="dashboard-panel-heading">
                  <div>
                    <h2>Lịch sử quiz gần đây</h2>
                    <p className="muted">5 lượt làm quiz mới nhất của bạn.</p>
                  </div>
                </div>
                {recentAttempts.length === 0 ? (
                  <p className="state-message">Chưa có lượt làm quiz nào</p>
                ) : (
                  <div className="quiz-history-list">
                    {recentAttempts.map((attempt) => {
                      const info = getLessonInfo(attempt.lessonId)
                      const passed = attempt.resultStatus === 'pass'

                      return (
                        <article className="quiz-history-card" key={attempt.id}>
                          <div>
                            <strong>{info.lessonName}</strong>
                            <span>{info.courseName}</span>
                            <small>{formatDateTime(getQuizDate(attempt))}</small>
                          </div>
                          <div className="quiz-history-result">
                            <b>{attempt.score ?? 0}%</b>
                            <span className={`status-pill ${passed ? 'is-pass' : 'is-fail'}`}>
                              {passed ? 'Đạt' : 'Chưa đạt'}
                            </span>
                          </div>
                        </article>
                      )
                    })}
                  </div>
                )}
              </section>
            </div>

            <aside className="dashboard-main-column">
              <section className="dashboard-panel">
                <div className="dashboard-panel-heading">
                  <div>
                    <h2>Phản hồi gần đây</h2>
                    <p className="muted">3 phản hồi học tập mới nhất sau quiz.</p>
                  </div>
                </div>
                {recentFeedbacks.length === 0 ? (
                  <p className="state-message">Chưa có phản hồi học tập nào</p>
                ) : (
                  <div className="feedback-summary-list">
                    {recentFeedbacks.map((feedback) => {
                      const info = getLessonInfo(feedback.lessonId)
                      const status = getFeedbackStatus(feedback)
                      const expanded = expandedFeedbackIds.includes(feedback.id)
                      const message = feedback.message || 'Chưa có nội dung phản hồi.'
                      const hasLongMessage = message.length > 120

                      return (
                        <article className="feedback-summary-card" key={feedback.id}>
                          <div className="feedback-summary-header">
                            <div>
                              <strong>{info.lessonName}</strong>
                              <span>{info.courseName}</span>
                            </div>
                            <span className={`feedback-summary-status ${status.className}`}>{status.label}</span>
                          </div>

                          <div className="feedback-score-grid">
                            <span>Quiz: {feedback.quizScore ?? 0}%</span>
                            <span>Tập trung: {feedback.focusScore ?? 0}%</span>
                          </div>

                          <p>{expanded ? message : truncateText(message)}</p>
                          {hasLongMessage && (
                            <button className="ghost-button compact-button" type="button" onClick={() => toggleFeedback(feedback.id)}>
                              {expanded ? 'Thu gọn' : 'Xem thêm'}
                            </button>
                          )}
                          <small>
                            {getRecommendationLabel(feedback.recommendation)} • {formatDateTime(feedback.createdAt)}
                          </small>
                        </article>
                      )
                    })}
                  </div>
                )}
              </section>

              <section className="dashboard-panel">
                <div className="dashboard-panel-heading">
                  <div>
                    <h2>Gợi ý học tập</h2>
                    <p className="muted">Đề xuất nhanh dựa trên tiến độ và kết quả gần đây.</p>
                  </div>
                </div>
                {learningSuggestions.length === 0 ? (
                  <p className="state-message">Hãy bắt đầu một khóa học để nhận gợi ý</p>
                ) : (
                  <div className="learning-suggestion-list">
                    {learningSuggestions.map((suggestion) => (
                      <Link className="learning-suggestion-card" key={suggestion.id} to={suggestion.to}>
                        <strong>{suggestion.title}</strong>
                        <span>{suggestion.description}</span>
                      </Link>
                    ))}
                  </div>
                )}
              </section>
            </aside>
          </div>
        </>
      )}
    </section>
  )
}

export default StudentDashboardPage
