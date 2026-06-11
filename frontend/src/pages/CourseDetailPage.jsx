import { useEffect, useMemo, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { getCourseById, getTrendingCourses } from '../api/courseApi.js'
import { getLessons } from '../api/lessonApi.js'
import { getProgressByUserId } from '../api/progressApi.js'
import { CONTENT_STATUS, ROUTES, STORAGE_KEYS } from '../constants/index.js'

function getCurrentUser() {
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEYS.USER) || 'null')
  } catch {
    return null
  }
}

function isCompleted(progress) {
  return Boolean(progress?.isCompleted ?? progress?.completed)
}

function formatValue(value, suffix = '') {
  if (value === null || value === undefined || value === '') {
    return 'Chưa cập nhật'
  }

  return suffix ? `${value} ${suffix}` : value
}

function getCourseInitial(title) {
  return title?.trim().charAt(0).toUpperCase() || 'K'
}

function CourseDetailPage() {
  const { id } = useParams()
  const user = useMemo(() => getCurrentUser(), [])
  const [course, setCourse] = useState(null)
  const [lessons, setLessons] = useState([])
  const [progressItems, setProgressItems] = useState([])
  const [courseStats, setCourseStats] = useState(null)
  const [imageError, setImageError] = useState(false)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    let isMounted = true

    const loadCourse = async () => {
      setLoading(true)
      try {
        const [courseData, lessonsData, trendingData, progressData] = await Promise.all([
          getCourseById(id),
          getLessons(),
          getTrendingCourses().catch(() => []),
          user?.id ? getProgressByUserId(user.id).catch(() => []) : Promise.resolve([]),
        ])
        const courseLessons = (Array.isArray(lessonsData) ? lessonsData : [])
          .filter((lesson) => Number(lesson.courseId) === Number(id))
          .sort((first, second) => (first.orderNumber || 0) - (second.orderNumber || 0))
        const stats = Array.isArray(trendingData)
          ? trendingData.find((item) => Number(item.id) === Number(id))
          : null

        if (isMounted) {
          setCourse(courseData)
          setLessons(courseLessons)
          setCourseStats(stats || null)
          setProgressItems(Array.isArray(progressData) ? progressData : [])
          setImageError(false)
          setError('')
        }
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || 'Không thể tải chi tiết khóa học.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadCourse()

    return () => {
      isMounted = false
    }
  }, [id, user])

  const completedLessonIds = useMemo(() => {
    return new Set(progressItems.filter(isCompleted).map((progress) => Number(progress.lessonId)))
  }, [progressItems])

  const firstIncompleteLesson = lessons.find((lesson) => !completedLessonIds.has(Number(lesson.id))) || lessons[0]
  const completedCount = lessons.filter((lesson) => completedLessonIds.has(Number(lesson.id))).length
  const totalViews = courseStats?.totalViews ?? 0
  const totalLikes = courseStats?.totalLikes ?? 0

  if (loading) {
    return (
      <section className="page-shell wide-shell">
        <p className="state-message">Đang tải khóa học...</p>
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

  if (!course) {
    return (
      <section className="page-shell wide-shell">
        <p className="alert">Không tìm thấy khóa học.</p>
        <Link className="secondary-button inline-button" to="/courses">
          Quay lại khóa học
        </Link>
      </section>
    )
  }

  return (
    <section className="page-shell wide-shell course-detail-page">
      <Link className="text-link" to="/courses">
        Quay lại khóa học
      </Link>

      <article className="course-detail course-detail-hero">
        <div className="course-detail-media">
          {course.thumbnailUrl && !imageError ? (
            <img src={course.thumbnailUrl} alt={course.title || 'Khóa học'} onError={() => setImageError(true)} />
          ) : (
            <div className="thumbnail-placeholder">
              <span>{getCourseInitial(course.title)}</span>
              <small>Chưa có ảnh đại diện</small>
            </div>
          )}
        </div>

        <div className="course-detail-body">
          <div className="course-title-row">
            <div>
              <p className="eyebrow">Lộ trình học tập</p>
              <h1>{course.title || 'Khóa học chưa đặt tên'}</h1>
            </div>
            <span className="status-badge">
              {course.status === CONTENT_STATUS.PUBLISHED ? 'Đã xuất bản' : 'Bản nháp'}
            </span>
          </div>

          <p className="course-description">
            {course.description || 'Chưa có mô tả cho khóa học này.'}
          </p>

          <div className="course-hero-stats" aria-label="Thống kê khóa học">
            <div>
              <strong>{lessons.length}</strong>
              <span>Bài học</span>
            </div>
            <div>
              <strong>{totalViews}</strong>
              <span>Lượt xem</span>
            </div>
            <div>
              <strong>{totalLikes}</strong>
              <span>Lượt thích</span>
            </div>
            <div>
              <strong>{completedCount}</strong>
              <span>Đã hoàn thành</span>
            </div>
          </div>

          {firstIncompleteLesson ? (
            <Link className="primary-button course-start-button" to={`/lessons/${firstIncompleteLesson.id}`}>
              {completedCount > 0 ? 'Tiếp tục học' : 'Bắt đầu học'}
            </Link>
          ) : (
            <p className="state-message">Khóa học này chưa có bài học để bắt đầu.</p>
          )}
        </div>
      </article>

      <section className="lessons-section learning-path-section">
        <div className="section-heading compact-heading">
          <div>
            <p className="eyebrow">Learning path</p>
            <h2>Lộ trình bài học</h2>
          </div>
          <p className="muted">
            {completedCount} / {lessons.length} bài đã hoàn thành
          </p>
        </div>

        {lessons.length === 0 ? (
          <p className="state-message">Chưa có bài học nào trong khóa học này.</p>
        ) : (
          <div className="lesson-list learning-path-list">
            {lessons.map((lesson, index) => {
              const completed = completedLessonIds.has(Number(lesson.id))

              return (
                <article className="lesson-card learning-path-card" key={lesson.id}>
                  <div className="roadmap-marker">
                    <span className={`roadmap-status-dot ${completed ? 'is-completed' : 'is-pending'}`}>
                      {completed ? '✓' : '○'}
                    </span>
                    <small>Bài {lesson.orderNumber || index + 1}</small>
                  </div>

                  <div className="lesson-content">
                    <div className="lesson-title-line">
                      <h3>{lesson.title || 'Bài học chưa đặt tên'}</h3>
                      <span className={`lesson-progress-badge ${completed ? 'is-completed' : 'is-pending'}`}>
                        {completed ? '✓ Đã hoàn thành' : '○ Chưa học'}
                      </span>
                    </div>
                    <p>{lesson.description || 'Chưa có mô tả cho bài học này.'}</p>

                    <div className="lesson-meta">
                      <span>{formatValue(lesson.duration, 'phút')}</span>
                      <span>Thứ tự: {formatValue(lesson.orderNumber)}</span>
                    </div>
                  </div>

                  <Link className="primary-button lesson-button" to={`/lessons/${lesson.id}`}>
                    Tiếp tục học
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

export default CourseDetailPage
