import { useEffect, useState } from 'react'
import { getDashboardSummary } from '../api/dashboardApi.js'
import { getAllFocusLogs } from '../api/focusLogApi.js'
import { FOCUS_SCORE, FOCUS_STATUS } from '../constants/index.js'

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

const STATUS_LABELS = {
  [FOCUS_STATUS.FOCUSED]: 'Tập trung',
  [FOCUS_STATUS.DISTRACTED]: 'Mất tập trung',
  [FOCUS_STATUS.NO_FACE]: 'Không có mặt',
  [FOCUS_STATUS.DROWSY]: 'Buồn ngủ',
}

const STATUS_CLASS = {
  [FOCUS_STATUS.FOCUSED]: 'focus-status-good',
  [FOCUS_STATUS.DISTRACTED]: 'focus-status-bad',
  [FOCUS_STATUS.NO_FACE]: 'focus-status-bad',
  [FOCUS_STATUS.DROWSY]: 'focus-status-warn',
}

function formatValue(value, suffix = '') {
  if (value === null || value === undefined) {
    return `0${suffix}`
  }

  if (typeof value === 'number' && !Number.isInteger(value)) {
    return `${value.toFixed(1)}${suffix}`
  }

  return `${value}${suffix}`
}

function formatDateTime(isoString) {
  if (!isoString) return '—'
  try {
    const d = new Date(isoString)
    return d.toLocaleString('vi-VN', { hour12: false })
  } catch {
    return isoString
  }
}

function AdminDashboardPage() {
  const [summary, setSummary] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const [focusLogs, setFocusLogs] = useState([])
  const [logsLoading, setLogsLoading] = useState(true)
  const [logsError, setLogsError] = useState('')

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

  useEffect(() => {
    let isMounted = true

    const loadLogs = async () => {
      try {
        const data = await getAllFocusLogs()
        if (isMounted) setFocusLogs(Array.isArray(data) ? data : [])
      } catch (err) {
        if (isMounted) {
          setLogsError(err.response?.data?.message || 'Không thể tải nhật ký tập trung.')
        }
      } finally {
        if (isMounted) setLogsLoading(false)
      }
    }

    loadLogs()

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

      <section className="dashboard-section">
        <div className="dashboard-section-header">
          <div>
            <h2>Nhật ký tập trung người học</h2>
            <p className="muted">50 bản ghi tập trung gần nhất từ tất cả người học trong hệ thống.</p>
          </div>
        </div>

        {logsLoading && <p className="state-message">Đang tải nhật ký...</p>}
        {logsError && <p className="alert">{logsError}</p>}

        {!logsLoading && !logsError && focusLogs.length === 0 && (
          <p className="muted">Chưa có dữ liệu nhật ký tập trung.</p>
        )}

        {!logsLoading && focusLogs.length > 0 && (
          <div className="focus-log-table-wrapper">
            <table className="focus-log-table">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Người học</th>
                  <th>Bài học</th>
                  <th>Điểm tập trung</th>
                  <th>Trạng thái</th>
                  <th>Thời gian ghi</th>
                </tr>
              </thead>
              <tbody>
                {focusLogs.map((log, index) => (
                  <tr key={log.id}>
                    <td className="log-index">{index + 1}</td>
                    <td>{log.userName || `User #${log.userId}`}</td>
                    <td>{log.lessonTitle || `Bài #${log.lessonId}`}</td>
                    <td>
                      <span className={`focus-score-chip ${log.focusScore >= FOCUS_SCORE.GOOD ? 'score-good' : log.focusScore >= FOCUS_SCORE.MID ? 'score-mid' : 'score-low'}`}>
                        {log.focusScore != null ? `${Math.round(log.focusScore)}%` : '—'}
                      </span>
                    </td>
                    <td>
                      <span className={`focus-status-chip ${STATUS_CLASS[log.status] || 'focus-status-bad'}`}>
                        {STATUS_LABELS[log.status] || log.status || '—'}
                      </span>
                    </td>
                    <td className="log-time">{formatDateTime(log.recordedAt)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </section>
  )
}

export default AdminDashboardPage
