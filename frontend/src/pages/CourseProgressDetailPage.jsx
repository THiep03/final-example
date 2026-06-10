import { useEffect, useMemo, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { getCourses } from '../api/courseApi.js'
import { getLessons } from '../api/lessonApi.js'
import { getProgressByUserId } from '../api/progressApi.js'
import { getStoredUser, normalizeList, toNumericId } from '../utils/flowHelpers.js'

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

function isCompleted(progress) {
  return Boolean(progress?.isCompleted ?? progress?.completed)
}

function clampPercent(value) {
  return Math.min(Math.max(value || 0, 0), 100)
}

function CourseProgressDetailPage() {
  const { courseId } = useParams()
  const numericCourseId = Number(courseId)
  const user = useMemo(() => getStoredUser(), [])
  const [course, setCourse] = useState(null)
  const [courseLessons, setCourseLessons] = useState([])
  const [progressItems, setProgressItems] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    let isMounted = true

    const loadProgressDetail = async () => {
      if (!user?.id) {
        setError('Vui lòng đăng nhập để xem tiến trình học.')
        setLoading(false)
        return
      }

      try {
        const [coursesData, lessonsData, progressData] = await Promise.all([
          getCourses().catch(() => []),
          getLessons().catch(() => []),
          getProgressByUserId(user.id).catch(() => []),
        ])

        if (isMounted) {
          const safeCourses = normalizeList(coursesData)
          const safeLessons = normalizeList(lessonsData)
          const safeProgress = normalizeList(progressData)

          setCourse(safeCourses.find((item) => Number(item.id) === numericCourseId) || null)
          setCourseLessons(
            safeLessons
              .filter((lesson) => Number(lesson?.courseId) === numericCourseId)
              .sort((first, second) => (first.orderNumber || 0) - (second.orderNumber || 0)),
          )
          setProgressItems(safeProgress)
          setError('')
        }
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || 'Không thể tải chi tiết tiến trình học.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadProgressDetail()

    return () => {
      isMounted = false
    }
  }, [numericCourseId, user])

  const progressByLessonId = new Map(progressItems.map((item) => [toNumericId(item.lessonId), item]))
  const completedLessons = courseLessons.filter((lesson) => isCompleted(progressByLessonId.get(toNumericId(lesson.id))))
  const totalLessons = courseLessons.length
  const progressPercent = totalLessons === 0 ? 0 : (completedLessons.length / totalLessons) * 100

  if (loading) {
    return (
      <section className="page-shell wide-shell">
        <p className="state-message">Đang tải chi tiết tiến trình...</p>
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
      <Link className="text-link" to="/dashboard">
        Quay lại bảng điều khiển
      </Link>

      {error && <p className="alert">{error}</p>}

      <article className="dashboard-panel course-progress-detail-hero">
        <div>
          <p className="eyebrow">Tiến trình khóa học</p>
          <h1>{course?.title || `Khóa học #${numericCourseId}`}</h1>
          <p className="muted">
            {completedLessons.length} / {totalLessons} bài đã hoàn thành
          </p>
        </div>
        <strong>{progressPercent.toFixed(0)}%</strong>
        <div className="course-progress-bar" aria-label="Tiến độ khóa học">
          <span style={{ width: `${clampPercent(progressPercent)}%` }} />
        </div>
      </article>

      <section className="dashboard-panel">
        <div>
          <h2>Danh sách bài học</h2>
          <p className="muted">Theo dõi trạng thái hoàn thành từng bài học trong khóa học.</p>
        </div>

        {courseLessons.length === 0 ? (
          <p className="state-message">Chưa có bài học trong khóa học này.</p>
        ) : (
          <div className="lesson-progress-grid">
            {courseLessons.map((lesson) => {
              const lessonProgress = progressByLessonId.get(lesson.id)
              const completed = isCompleted(lessonProgress)

              return (
                <article className="lesson-progress-card" key={lesson.id}>
                  <div className="lesson-progress-card-header">
                    <div>
                      <p className="eyebrow">Bài {lesson.orderNumber || '-'}</p>
                      <h3>{lesson.title || `Bài học #${lesson.id}`}</h3>
                    </div>
                    <span className={`lesson-progress-badge ${completed ? 'is-completed' : 'is-pending'}`}>
                      {completed ? 'Đã hoàn thành' : 'Chưa hoàn thành'}
                    </span>
                  </div>

                  <p>{lesson.description || 'Chưa có mô tả cho bài học này.'}</p>

                  <div className="lesson-progress-meta">
                    <span>Thời lượng: {lesson.duration ? `${lesson.duration} phút` : '-'}</span>
                    <span>Thứ tự: {lesson.orderNumber || '-'}</span>
                    <span>Ngày hoàn thành: {completed ? formatDateTime(lessonProgress?.completedAt) : '-'}</span>
                  </div>

                  <Link className="secondary-button" to={`/lessons/${lesson.id}`}>
                    Xem bài học
                  </Link>
                </article>
              )
            })}
          </div>
        )}
      </section>
    </section>
  )
}

export default CourseProgressDetailPage
