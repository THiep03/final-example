import { useEffect, useState } from 'react'
import { getDashboardSummary } from '../api/dashboardApi.js'

const dashboardGroups = [
  {
    title: 'Tổng quan hệ thống',
    description: 'Theo dõi quy mô người dùng và nội dung học tập.',
    cards: [
      { label: 'Tổng người dùng', field: 'totalUsers' },
      { label: 'Tổng khóa học', field: 'totalCourses' },
      { label: 'Tổng bài học', field: 'totalLessons' },
      { label: 'Tổng câu hỏi', field: 'totalQuestions' },
    ],
  },
  {
    title: 'Phân tích học tập',
    description: 'Hiệu quả quiz và điểm tập trung trung bình của người học.',
    cards: [
      { label: 'Tổng lượt làm quiz', field: 'totalQuizAttempts' },
      { label: 'Điểm quiz trung bình', field: 'averageQuizScore', suffix: '%' },
      { label: 'Điểm tập trung trung bình', field: 'averageFocusScore', suffix: '%' },
    ],
  },
  {
    title: 'Tương tác bài học',
    description: 'Các tín hiệu tương tác giúp đánh giá mức độ quan tâm.',
    cards: [
      { label: 'Tổng lượt xem', field: 'totalViews' },
      { label: 'Tổng lượt thích', field: 'totalLikes' },
      { label: 'Tổng lượt không thích', field: 'totalDislikes' },
    ],
  },
]

function formatValue(value, suffix = '') {
  if (value === null || value === undefined) {
    return `0${suffix}`
  }

  if (typeof value === 'number' && !Number.isInteger(value)) {
    return `${value.toFixed(1)}${suffix}`
  }

  return `${value}${suffix}`
}

function AdminDashboardPage() {
  const [summary, setSummary] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    let isMounted = true

    const loadSummary = async () => {
      try {
        const data = await getDashboardSummary()
        if (isMounted) {
          setSummary(data)
          setError('')
        }
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || 'Không thể tải bảng điều khiển Admin.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadSummary()

    return () => {
      isMounted = false
    }
  }, [])

  if (loading) {
    return (
      <section className="page-shell wide-shell">
        <p className="state-message">Đang tải bảng điều khiển Admin...</p>
      </section>
    )
  }

  return (
    <section className="page-shell wide-shell dashboard-page">
      <div className="section-heading">
        <div>
          <p className="eyebrow">Quản trị</p>
          <h1>Bảng điều khiển Admin</h1>
        </div>
        <p className="muted">Tổng quan hệ thống, dữ liệu học tập và tương tác bài học.</p>
      </div>

      {error && <p className="alert">{error}</p>}

      {!error && summary && (
        <>
          {dashboardGroups.map((group) => (
            <section className="dashboard-section" key={group.title}>
              <div className="dashboard-section-header">
                <div>
                  <h2>{group.title}</h2>
                  <p className="muted">{group.description}</p>
                </div>
              </div>

              <div className="dashboard-grid">
                {group.cards.map((card) => (
                  <article className="dashboard-card" key={card.field}>
                    <span>{card.label}</span>
                    <strong>{formatValue(summary[card.field], card.suffix)}</strong>
                  </article>
                ))}
              </div>
            </section>
          ))}

          <section className="dashboard-panel">
            <div>
              <h2>Biểu đồ tổng quan</h2>
              <p className="muted">Khu vực biểu đồ minh họa xu hướng hệ thống.</p>
            </div>
            <div className="chart-placeholder" aria-label="Biểu đồ minh họa">
              {[
                summary.totalUsers,
                summary.totalCourses,
                summary.totalLessons,
                summary.totalQuestions,
                summary.totalQuizAttempts,
                summary.totalViews,
              ].map((value, index) => (
                <span
                  key={`${value || 0}-${index}`}
                  style={{ height: `${Math.min(Math.max(value || 12, 18), 92)}%` }}
                />
              ))}
            </div>
          </section>
        </>
      )}
    </section>
  )
}

export default AdminDashboardPage
