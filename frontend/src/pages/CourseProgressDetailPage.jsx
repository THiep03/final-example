import { useEffect, useMemo, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { getCourses } from '../api/courseApi.js'
import { getLessons } from '../api/lessonApi.js'
import { getProgressByUserId } from '../api/progressApi.js'
import { getStoredUser, normalizeList, toNumericId } from '../utils/flowHelpers.js'

function formatDateTime(value) {
  if (!value) return '—'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return '—'
  return new Intl.DateTimeFormat('vi-VN', { dateStyle: 'short', timeStyle: 'short' }).format(date)
}

function isCompleted(progress) {
  return Boolean(progress?.isCompleted ?? progress?.completed)
}

function clampPercent(value) {
  return Math.min(Math.max(value || 0, 0), 100)
}

function ProgressRing({ pct }) {
  const r = 52, circ = 2 * Math.PI * r
  const offset = circ - (clampPercent(pct) / 100) * circ
  return (
    <svg width="120" height="120" viewBox="0 0 120 120" className="cpd-ring">
      <circle cx="60" cy="60" r={r} fill="none" stroke="rgba(255,255,255,0.12)" strokeWidth="9" />
      <circle
        cx="60" cy="60" r={r}
        fill="none"
        stroke="#38bdf8"
        strokeWidth="9"
        strokeLinecap="round"
        strokeDasharray={circ}
        strokeDashoffset={offset}
        transform="rotate(-90 60 60)"
        style={{ transition: 'stroke-dashoffset 1.2s ease' }}
      />
      <text x="60" y="56" textAnchor="middle" fill="#fff" fontSize="22" fontWeight="800" fontFamily="Inter,sans-serif">{Math.round(pct)}%</text>
      <text x="60" y="73" textAnchor="middle" fill="rgba(255,255,255,0.55)" fontSize="11" fontFamily="Inter,sans-serif">Hoàn thành</text>
    </svg>
  )
}

function CourseProgressDetailPage() {
  const { courseId } = useParams()
  const numericCourseId = Number(courseId)
  const user = useMemo(() => getStoredUser(), [])
  const [course, setCourse]           = useState(null)
  const [courseLessons, setCourseLessons] = useState([])
  const [progressItems, setProgressItems] = useState([])
  const [loading, setLoading]         = useState(true)
  const [error, setError]             = useState('')

  useEffect(() => {
    let isMounted = true
    const load = async () => {
      if (!user?.id) { setError('Vui lòng đăng nhập để xem tiến trình học.'); setLoading(false); return }
      try {
        const [coursesData, lessonsData, progressData] = await Promise.all([
          getCourses().catch(() => []),
          getLessons().catch(() => []),
          getProgressByUserId(user.id).catch(() => []),
        ])
        if (isMounted) {
          const safe = normalizeList(coursesData)
          const safeLessons = normalizeList(lessonsData)
          setCourse(safe.find((c) => Number(c.id) === numericCourseId) || null)
          setCourseLessons(
            safeLessons
              .filter((l) => Number(l?.courseId) === numericCourseId)
              .sort((a, b) => (a.orderNumber || 0) - (b.orderNumber || 0))
          )
          setProgressItems(normalizeList(progressData))
          setError('')
        }
      } catch (err) {
        if (isMounted) setError(err.response?.data?.message || 'Không thể tải chi tiết tiến trình học.')
      } finally {
        if (isMounted) setLoading(false)
      }
    }
    load()
    return () => { isMounted = false }
  }, [numericCourseId, user])

  const progressByLessonId = new Map(progressItems.map((p) => [toNumericId(p.lessonId), p]))
  const completedLessons   = courseLessons.filter((l) => isCompleted(progressByLessonId.get(toNumericId(l.id))))
  const totalLessons       = courseLessons.length
  const progressPercent    = totalLessons === 0 ? 0 : (completedLessons.length / totalLessons) * 100

  if (loading) {
    return (
      <section className="page-shell wide-shell">
        <div className="ui-skeleton-page">
          <div className="ui-skeleton ui-sk-hero" />
          <div className="ui-skeleton ui-sk-list" />
        </div>
      </section>
    )
  }

  if (!user?.id) {
    return (
      <section className="page-shell">
        <div className="ui-empty-state">
          <div className="ui-empty-icon">🔒</div>
          <h3>Cần đăng nhập</h3>
          <p>{error}</p>
          <Link className="primary-button" to="/login">Đăng nhập</Link>
        </div>
      </section>
    )
  }

  return (
    <section className="page-shell wide-shell cpd-page">
      <Link className="text-link" to="/dashboard">← Bảng điều khiển</Link>

      {error && <p className="alert">{error}</p>}

      {/* Hero */}
      <div className="cpd-hero">
        <div className="cpd-hero-left">
          <p className="eyebrow">Tiến trình khóa học</p>
          <h1>{course?.title || `Khóa học #${numericCourseId}`}</h1>
          <p className="cpd-hero-sub">
            <span className="cpd-done">{completedLessons.length}</span>
            <span> / {totalLessons} bài đã hoàn thành</span>
          </p>
          <div className="cpd-hero-bar-wrap">
            <div className="cpd-hero-bar" style={{ width: `${clampPercent(progressPercent)}%` }} />
          </div>
        </div>
        <ProgressRing pct={progressPercent} />
      </div>

      {/* Lesson list */}
      <div className="cpd-lesson-panel">
        <div className="cpd-panel-head">
          <h2>Danh sách bài học</h2>
          <p>Theo dõi trạng thái hoàn thành từng bài học.</p>
        </div>

        {courseLessons.length === 0 ? (
          <div className="ui-empty-state">
            <div className="ui-empty-icon">📚</div>
            <h3>Chưa có bài học</h3>
            <p>Khóa học này chưa có bài học nào.</p>
          </div>
        ) : (
          <div className="cpd-lesson-list">
            {courseLessons.map((lesson, i) => {
              const prog = progressByLessonId.get(toNumericId(lesson.id))
              const done = isCompleted(prog)
              return (
                <div className={`cpd-lesson-row ${done ? 'is-done' : ''}`} key={lesson.id}>
                  <div className="cpd-lesson-num">{lesson.orderNumber || i + 1}</div>
                  <div className="cpd-lesson-body">
                    <div className="cpd-lesson-title-row">
                      <h3>{lesson.title || `Bài học #${lesson.id}`}</h3>
                      <span className={`cpd-lesson-badge ${done ? 'done' : 'pending'}`}>
                        {done ? '✓ Hoàn thành' : '○ Chưa học'}
                      </span>
                    </div>
                    {lesson.description && <p className="cpd-lesson-desc">{lesson.description}</p>}
                    <div className="cpd-lesson-meta">
                      {lesson.duration && <span>⏱ {lesson.duration} phút</span>}
                      {done && prog?.completedAt && <span>✓ {formatDateTime(prog.completedAt)}</span>}
                    </div>
                  </div>
                  <Link className="secondary-button" to={`/lessons/${lesson.id}`}>
                    {done ? 'Xem lại' : 'Học ngay'}
                  </Link>
                </div>
              )
            })}
          </div>
        )}
      </div>
    </section>
  )
}

export default CourseProgressDetailPage
