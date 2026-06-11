import { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { getCourses, getTrendingCourses } from '../api/courseApi.js'
import { getUserDashboard } from '../api/dashboardApi.js'
import { getLessons } from '../api/lessonApi.js'
import { getProgressByUserId } from '../api/progressApi.js'
import { ROUTES } from '../constants/index.js'
import { getStoredUser, normalizeList, sameId } from '../utils/flowHelpers.js'

function average(items, field) {
  const values = (Array.isArray(items) ? items : [])
    .map((item) => item[field])
    .filter((value) => typeof value === 'number')

  if (values.length === 0) {
    return 0
  }

  return values.reduce((total, value) => total + value, 0) / values.length
}

function isCompleted(progress) {
  return Boolean(progress?.isCompleted ?? progress?.completed)
}

function getCourseProgress(courseId, lessons, progressItems) {
  const courseLessons = normalizeList(lessons).filter((lesson) => sameId(lesson.courseId, courseId))
  const completedLessons = courseLessons.filter((lesson) =>
    isCompleted(normalizeList(progressItems).find((item) => sameId(item.lessonId, lesson.id))),
  )

  return {
    completed: completedLessons.length,
    total: courseLessons.length,
    percent: courseLessons.length === 0 ? 0 : (completedLessons.length / courseLessons.length) * 100,
  }
}

function Home() {
  const user = useMemo(() => getStoredUser(), [])
  const dashboardPath = user?.role === 'admin' ? '/admin/dashboard' : '/dashboard'
  const [courses, setCourses] = useState([])
  const [lessons, setLessons] = useState([])
  const [progress, setProgress] = useState([])
  const [quizAttempts, setQuizAttempts] = useState([])
  const [trendingCourses, setTrendingCourses] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let isMounted = true

    const loadHomeData = async () => {
      try {
        const [coursesData, lessonsData, trendingData, progressData, dashboardData] = await Promise.all([
          getCourses().catch(() => []),
          getLessons().catch(() => []),
          getTrendingCourses().catch(() => []),
          user?.id ? getProgressByUserId(user.id).catch(() => []) : Promise.resolve([]),
          user?.id ? getUserDashboard(user.id).catch(() => null) : Promise.resolve(null),
        ])

        if (isMounted) {
          setCourses(normalizeList(coursesData))
          setLessons(normalizeList(lessonsData))
          setTrendingCourses(normalizeList(trendingData))
          setProgress(normalizeList(progressData))
          setQuizAttempts(normalizeList(dashboardData?.quizAttempts))
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadHomeData()

    return () => {
      isMounted = false
    }
  }, [user])

  const completedLessons = progress.filter(isCompleted).length
  const averageQuizScore = average(quizAttempts, 'score')
  const totalLikes = trendingCourses.reduce((total, course) => total + (course.totalLikes || 0), 0)
  const latestProgress = [...progress]
    .sort((first, second) => new Date(second.lastWatchedAt || 0) - new Date(first.lastWatchedAt || 0))
    .find(Boolean)
  const latestLesson = lessons.find((lesson) => sameId(lesson.id, latestProgress?.lessonId))
  const latestCourse = courses.find((course) => sameId(course.id, latestProgress?.courseId || latestLesson?.courseId))
  const latestCourseProgress = latestCourse
    ? getCourseProgress(latestCourse.id, lessons, progress)
    : null

  return (
    <section className="home-page">
      <section className="home-hero">
        <div className="home-hero-content">
          <p className="eyebrow">Học thích ứng</p>
          <h1>Nền tảng học tập thích ứng</h1>
          <p>
            Cá nhân hóa tiến trình học, theo dõi kết quả quiz và nhận phản hồi học tập dựa trên dữ liệu thực tế của bạn.
          </p>
          <div className="actions">
            <Link className="primary-button" to={ROUTES.COURSES}>
              Khám phá khóa học
            </Link>
            <Link className="secondary-button" to={user ? dashboardPath : '/login'}>
              Tiếp tục học
            </Link>
          </div>
        </div>
      </section>

      <section className="home-section">
        <div className="home-section-heading">
          <h2>Tổng quan học tập</h2>
          {loading && <span>Đang cập nhật dữ liệu...</span>}
        </div>
        <div className="home-stat-grid">
          <article className="home-stat-card">
            <span>Số khóa học</span>
            <strong>{courses.length}</strong>
          </article>
          <article className="home-stat-card">
            <span>Bài học hoàn thành</span>
            <strong>{completedLessons}</strong>
          </article>
          <article className="home-stat-card">
            <span>Điểm quiz trung bình</span>
            <strong>{averageQuizScore.toFixed(1)}%</strong>
          </article>
          <article className="home-stat-card">
            <span>Lượt thích nhận được</span>
            <strong>{totalLikes}</strong>
          </article>
        </div>
      </section>

      <section className="home-section">
        <div className="home-section-heading">
          <h2>Tiếp tục học</h2>
        </div>
        {latestCourse ? (
          <article className="continue-learning-card">
            <div>
              <p className="eyebrow">Đang học</p>
              <h3>{latestCourse.title || 'Khóa học chưa đặt tên'}</h3>
              <p>{latestLesson?.title ? `Bài gần nhất: ${latestLesson.title}` : 'Tiếp tục lộ trình học của bạn.'}</p>
            </div>
            <strong>{latestCourseProgress.percent.toFixed(0)}%</strong>
            <div className="course-progress-bar">
              <span style={{ width: `${Math.min(latestCourseProgress.percent, 100)}%` }} />
            </div>
            <Link className="primary-button" to={latestLesson ? `/lessons/${latestLesson.id}` : `/courses/${latestCourse.id}`}>
              Tiếp tục học
            </Link>
          </article>
        ) : (
          <p className="state-message">Hãy bắt đầu một khóa học để tiếp tục lộ trình học tập.</p>
        )}
      </section>

      <section className="home-section">
        <div className="home-section-heading">
          <h2>Khóa học xu hướng</h2>
          <Link className="text-link" to={ROUTES.COURSES}>
            Xem tất cả
          </Link>
        </div>
        {trendingCourses.length === 0 ? (
          <p className="state-message">Chưa có dữ liệu xu hướng.</p>
        ) : (
          <div className="home-trending-list">
            {trendingCourses.slice(0, 3).map((course) => (
              <Link className="home-trending-card" key={course.id} to={`/courses/${course.id}`}>
                <div className="home-trending-thumb">
                  {course.thumbnailUrl ? <img src={course.thumbnailUrl} alt={course.title || 'Khóa học'} /> : <span>Khóa học</span>}
                </div>
                <div>
                  <h3>{course.title || 'Khóa học chưa đặt tên'}</h3>
                  <p>{course.description || 'Chưa có mô tả cho khóa học này.'}</p>
                  <div className="home-trending-meta">
                    <span>{course.totalViews ?? 0} lượt xem</span>
                    <span>{course.totalLikes ?? 0} lượt thích</span>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        )}
      </section>

      <footer className="home-footer">
        <strong>Học thích ứng</strong>
        <span>Học đúng tiến độ, nhận phản hồi kịp thời, cải thiện từng bài học.</span>
      </footer>
    </section>
  )
}

export default Home
