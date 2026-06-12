import { useEffect, useState } from 'react'
import { getDashboardSummary } from '../api/dashboardApi.js'
import { getAllFocusLogs } from '../api/focusLogApi.js'
import { FOCUS_SCORE, FOCUS_STATUS } from '../constants/index.js'

const KPI_GROUPS = [
  {
    id: 'system',
    label: 'Tổng quan hệ thống',
    description: 'Quy mô người dùng và nội dung học tập trong hệ thống.',
    cards: [
      { label: 'Người dùng', field: 'totalUsers',     icon: '👤', accent: 'kpi-blue'   },
      { label: 'Khóa học',  field: 'totalCourses',    icon: '📚', accent: 'kpi-indigo' },
      { label: 'Bài học',   field: 'totalLessons',    icon: '📖', accent: 'kpi-teal'   },
      { label: 'Câu hỏi',   field: 'totalQuestions',  icon: '❓', accent: 'kpi-green'  },
    ],
  },
  {
    id: 'learning',
    label: 'Phân tích học tập',
    description: 'Hiệu quả quiz và mức độ tập trung của người học.',
    cards: [
      { label: 'Lượt làm quiz',       field: 'totalQuizAttempts',  icon: '✏️', accent: 'kpi-indigo' },
      { label: 'Quiz trung bình',      field: 'averageQuizScore',   icon: '🎯', accent: 'kpi-blue',  suffix: '%' },
      { label: 'Tập trung trung bình', field: 'averageFocusScore',  icon: '🧠', accent: 'kpi-teal',  suffix: '%' },
    ],
  },
  {
    id: 'engagement',
    label: 'Tương tác bài học',
    description: 'Tín hiệu tương tác giúp đánh giá mức độ quan tâm.',
    cards: [
      { label: 'Lượt xem',        field: 'totalViews',    icon: '👁️',  accent: 'kpi-blue'   },
      { label: 'Lượt thích',      field: 'totalLikes',    icon: '👍',  accent: 'kpi-green'  },
      { label: 'Không thích',     field: 'totalDislikes', icon: '👎',  accent: 'kpi-danger' },
    ],
  },
]

const STATUS_LABELS = {
  [FOCUS_STATUS.FOCUSED]:    'Tập trung',
  [FOCUS_STATUS.DISTRACTED]: 'Mất tập trung',
  [FOCUS_STATUS.NO_FACE]:    'Không có mặt',
  [FOCUS_STATUS.DROWSY]:     'Buồn ngủ',
}

const STATUS_CLASS = {
  [FOCUS_STATUS.FOCUSED]:    'focus-status-good',
  [FOCUS_STATUS.DISTRACTED]: 'focus-status-bad',
  [FOCUS_STATUS.NO_FACE]:    'focus-status-bad',
  [FOCUS_STATUS.DROWSY]:     'focus-status-warn',
}

function fmt(value, suffix = '') {
  if (value == null) return `0${suffix}`
  if (typeof value === 'number' && !Number.isInteger(value)) return `${value.toFixed(1)}${suffix}`
  return `${value}${suffix}`
}

function fmtDt(iso) {
  if (!iso) return '—'
  try { return new Date(iso).toLocaleString('vi-VN', { hour12: false }) } catch { return iso }
}

function initials(name) {
  if (!name) return '?'
  return name.trim().split(/\s+/).map(w => w[0]).slice(0, 2).join('').toUpperCase()
}

const CHART_FIELDS = [
  { field: 'totalUsers',        label: 'Người dùng', color: '#3b82f6' },
  { field: 'totalCourses',      label: 'Khóa học',   color: '#6366f1' },
  { field: 'totalLessons',      label: 'Bài học',    color: '#0891b2' },
  { field: 'totalQuestions',    label: 'Câu hỏi',    color: '#059669' },
  { field: 'totalQuizAttempts', label: 'Lượt quiz',  color: '#8b5cf6' },
  { field: 'totalViews',        label: 'Lượt xem',   color: '#f59e0b' },
]

function AdminDashboardPage() {
  const [summary, setSummary] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const [focusLogs, setFocusLogs] = useState([])
  const [logsLoading, setLogsLoading] = useState(true)
  const [logsError, setLogsError] = useState('')

  useEffect(() => {
    let alive = true
    getDashboardSummary()
      .then(data  => { if (alive) { setSummary(data); setError('') } })
      .catch(err  => { if (alive) setError(err.response?.data?.message || 'Không thể tải bảng điều khiển.') })
      .finally(() => { if (alive) setLoading(false) })
    return () => { alive = false }
  }, [])

  useEffect(() => {
    let alive = true
    getAllFocusLogs()
      .then(data  => { if (alive) setFocusLogs(Array.isArray(data) ? data : []) })
      .catch(err  => { if (alive) setLogsError(err.response?.data?.message || 'Không thể tải nhật ký tập trung.') })
      .finally(() => { if (alive) setLogsLoading(false) })
    return () => { alive = false }
  }, [])

  const maxChartValue = summary
    ? Math.max(...CHART_FIELDS.map(f => summary[f.field] || 0), 1)
    : 1

  if (loading) {
    return (
      <section className="page-shell wide-shell">
        <div className="adm-dash-loading">
          <span className="adm-dash-spinner" />
          <p>Đang tải bảng điều khiển...</p>
        </div>
      </section>
    )
  }

  return (
    <section className="page-shell wide-shell adm-dash">

      {/* ── HERO HEADER ── */}
      <header className="adm-dash-hero">
        <div className="adm-dash-hero-left">
          <p className="eyebrow">Quản trị hệ thống</p>
          <h1>Bảng điều khiển Admin</h1>
          <p className="adm-dash-hero-sub">
            Theo dõi toàn bộ hoạt động học tập, tương tác và dữ liệu tập trung của người học.
          </p>
        </div>
        {summary && (
          <div className="adm-dash-hero-kpis">
            <div className="adm-dash-hero-kpi">
              <strong>{fmt(summary.totalUsers)}</strong>
              <span>Người dùng</span>
            </div>
            <div className="adm-dash-hero-kpi">
              <strong>{fmt(summary.totalLessons)}</strong>
              <span>Bài học</span>
            </div>
            <div className="adm-dash-hero-kpi">
              <strong>{fmt(summary.averageQuizScore, '%')}</strong>
              <span>Quiz TB</span>
            </div>
          </div>
        )}
      </header>

      {error && <p className="alert">{error}</p>}

      {!error && summary && (
        <>
          {/* ── KPI GROUPS ── */}
          {KPI_GROUPS.map((group) => (
            <section className="adm-dash-section" key={group.id}>
              <div className="adm-dash-section-head">
                <div>
                  <h2>{group.label}</h2>
                  <p className="muted">{group.description}</p>
                </div>
              </div>
              <div className={`adm-kpi-grid cols-${group.cards.length}`}>
                {group.cards.map((card) => (
                  <article className={`adm-kpi-card ${card.accent}`} key={card.field}>
                    <div className="adm-kpi-icon">{card.icon}</div>
                    <div className="adm-kpi-body">
                      <strong className="adm-kpi-value">{fmt(summary[card.field], card.suffix)}</strong>
                      <span className="adm-kpi-label">{card.label}</span>
                    </div>
                  </article>
                ))}
              </div>
            </section>
          ))}

          {/* ── CHART + QUICK STATS ── */}
          <section className="adm-dash-section">
            <div className="adm-dash-section-head">
              <div>
                <h2>Biểu đồ tổng quan</h2>
                <p className="muted">So sánh trực quan các chỉ số quan trọng trong hệ thống.</p>
              </div>
            </div>
            <div className="adm-chart-panel">
              <div className="adm-bar-chart">
                {CHART_FIELDS.map((f) => {
                  const value = summary[f.field] || 0
                  const pct = Math.max((value / maxChartValue) * 100, 3)
                  return (
                    <div className="adm-bar-col" key={f.field}>
                      <span className="adm-bar-value">{value.toLocaleString('vi-VN')}</span>
                      <div className="adm-bar-track">
                        <div
                          className="adm-bar-fill"
                          style={{ height: `${pct}%`, background: f.color }}
                        />
                      </div>
                      <span className="adm-bar-label">{f.label}</span>
                    </div>
                  )
                })}
              </div>
              <div className="adm-quick-stats">
                <p className="adm-quick-stats-title">Tỷ lệ tương tác</p>
                {[
                  {
                    label: 'Tỷ lệ thích / xem',
                    value: summary.totalViews
                      ? `${((summary.totalLikes / summary.totalViews) * 100).toFixed(1)}%`
                      : '—',
                    color: '#16a34a',
                  },
                  {
                    label: 'Quiz / người dùng',
                    value: summary.totalUsers
                      ? `${(summary.totalQuizAttempts / summary.totalUsers).toFixed(1)} lần`
                      : '—',
                    color: '#2563eb',
                  },
                  {
                    label: 'Bài học / khóa học',
                    value: summary.totalCourses
                      ? `${(summary.totalLessons / summary.totalCourses).toFixed(1)} bài`
                      : '—',
                    color: '#0891b2',
                  },
                  {
                    label: 'Câu hỏi / bài học',
                    value: summary.totalLessons
                      ? `${(summary.totalQuestions / summary.totalLessons).toFixed(1)} câu`
                      : '—',
                    color: '#7c3aed',
                  },
                ].map((stat) => (
                  <div className="adm-quick-stat-row" key={stat.label}>
                    <span className="adm-quick-stat-dot" style={{ background: stat.color }} />
                    <span className="adm-quick-stat-label">{stat.label}</span>
                    <strong className="adm-quick-stat-val">{stat.value}</strong>
                  </div>
                ))}
              </div>
            </div>
          </section>
        </>
      )}

      {/* ── FOCUS LOG TABLE ── */}
      <section className="adm-dash-section">
        <div className="adm-dash-section-head">
          <div>
            <h2>Nhật ký tập trung người học</h2>
            <p className="muted">50 bản ghi tập trung gần nhất từ tất cả người học trong hệ thống.</p>
          </div>
          {focusLogs.length > 0 && (
            <span className="adm-log-count">{focusLogs.length} bản ghi</span>
          )}
        </div>

        {logsLoading && <p className="state-message">Đang tải nhật ký tập trung...</p>}
        {logsError  && <p className="alert">{logsError}</p>}

        {!logsLoading && !logsError && focusLogs.length === 0 && (
          <p className="state-message">Chưa có dữ liệu nhật ký tập trung.</p>
        )}

        {!logsLoading && focusLogs.length > 0 && (
          <div className="adm-log-table-wrap">
            <table className="adm-log-table">
              <thead>
                <tr>
                  <th className="col-idx">#</th>
                  <th>Người học</th>
                  <th>Bài học</th>
                  <th>Điểm tập trung</th>
                  <th>Trạng thái</th>
                  <th>Thời gian ghi</th>
                </tr>
              </thead>
              <tbody>
                {focusLogs.map((log, idx) => (
                  <tr key={log.id}>
                    <td className="col-idx adm-log-idx">{idx + 1}</td>
                    <td>
                      <div className="adm-log-user">
                        <span className="adm-user-avatar">{initials(log.userName)}</span>
                        <span className="adm-log-username">{log.userName || `User #${log.userId}`}</span>
                      </div>
                    </td>
                    <td className="adm-log-lesson">{log.lessonTitle || `Bài #${log.lessonId}`}</td>
                    <td>
                      <div className="adm-score-cell">
                        <span className={`adm-score-chip ${
                          log.focusScore >= FOCUS_SCORE.GOOD ? 'chip-good'
                          : log.focusScore >= FOCUS_SCORE.MID ? 'chip-mid'
                          : 'chip-bad'
                        }`}>
                          {log.focusScore != null ? `${Math.round(log.focusScore)}%` : '—'}
                        </span>
                        {log.focusScore != null && (
                          <div className="adm-score-bar-track">
                            <div
                              className={`adm-score-bar-fill ${
                                log.focusScore >= FOCUS_SCORE.GOOD ? 'bar-good'
                                : log.focusScore >= FOCUS_SCORE.MID ? 'bar-mid'
                                : 'bar-bad'
                              }`}
                              style={{ width: `${Math.min(log.focusScore, 100)}%` }}
                            />
                          </div>
                        )}
                      </div>
                    </td>
                    <td>
                      <span className={`adm-status-chip ${STATUS_CLASS[log.status] || 'focus-status-bad'}`}>
                        {STATUS_LABELS[log.status] || log.status || '—'}
                      </span>
                    </td>
                    <td className="adm-log-time">{fmtDt(log.recordedAt)}</td>
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
