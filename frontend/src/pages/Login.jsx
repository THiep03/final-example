import { useState } from 'react'
import { Link, useLocation, useNavigate } from 'react-router-dom'
import axiosClient from '../api/axiosClient'
import { ROLES, ROUTES, STORAGE_KEYS } from '../constants/index.js'

function Login() {
  const navigate  = useNavigate()
  const location  = useLocation()
  const [formData, setFormData] = useState({ email: '', password: '' })
  const [showPw, setShowPw]     = useState(false)
  const [error, setError]       = useState('')
  const [loading, setLoading]   = useState(false)

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData(cur => ({ ...cur, [name]: value }))
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      const response = await axiosClient.post('/auth/login', formData)
      localStorage.setItem(STORAGE_KEYS.USER, JSON.stringify(response.data))
      if (response.data?.id) localStorage.setItem(STORAGE_KEYS.USER_ID, String(response.data.id))

      const isAdmin     = response.data?.role === ROLES.ADMIN
      const redirectTo  = location.state?.from?.pathname
      const safeRedirect = redirectTo?.startsWith('/admin') && !isAdmin ? ROUTES.HOME : redirectTo
      navigate(safeRedirect || (isAdmin ? ROUTES.ADMIN_DASHBOARD : ROUTES.COURSES), { replace: true })
    } catch (err) {
      setError(err.response?.data?.message || 'Email hoặc mật khẩu không đúng.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="auth-scene">
      {/* animated background blobs */}
      <div className="auth-blob auth-blob-1" />
      <div className="auth-blob auth-blob-2" />
      <div className="auth-blob auth-blob-3" />

      <div className="auth-split">
        {/* ── left: showcase ── */}
        <div className="auth-showcase">
          <div className="auth-logo">
            <span className="auth-logo-mark">HT</span>
            <span className="auth-logo-name">Học thích ứng</span>
          </div>

          <div className="auth-headline">
            <h1>Học đúng tiến độ.<br /><span className="auth-gradient-text">Tiến bộ mỗi ngày.</span></h1>
            <p>Nền tảng AI cá nhân hóa lộ trình học, theo dõi tiến độ và đưa ra phản hồi thông minh cho từng học viên.</p>
          </div>

          {/* mock preview card */}
          <div className="auth-preview-card">
            <div className="auth-preview-header">
              <span className="auth-preview-dot dot-red" />
              <span className="auth-preview-dot dot-yellow" />
              <span className="auth-preview-dot dot-green" />
              <span className="auth-preview-title">Phiên học hôm nay</span>
            </div>
            <div className="auth-preview-body">
              <div className="auth-preview-stat">
                <div className="auth-preview-stat-bar">
                  <div className="auth-preview-stat-fill" style={{ width: '72%' }} />
                </div>
                <div className="auth-preview-stat-row">
                  <span>Mức độ tập trung</span><strong>72%</strong>
                </div>
              </div>
              <div className="auth-preview-stat">
                <div className="auth-preview-stat-bar">
                  <div className="auth-preview-stat-fill" style={{ width: '88%', background: 'linear-gradient(90deg,#10b981,#34d399)' }} />
                </div>
                <div className="auth-preview-stat-row">
                  <span>Điểm quiz trung bình</span><strong>88%</strong>
                </div>
              </div>
              <div className="auth-preview-badges">
                <span className="auth-badge-pill">🔥 Streak 7 ngày</span>
                <span className="auth-badge-pill">⭐ Level 4</span>
                <span className="auth-badge-pill">📚 12 bài</span>
              </div>
            </div>
          </div>

          {/* social proof */}
          <div className="auth-social-proof">
            <div className="auth-avatars">
              <span className="auth-av" style={{ background: '#f43f5e' }}>N</span>
              <span className="auth-av" style={{ background: '#6366f1' }}>T</span>
              <span className="auth-av" style={{ background: '#0ea5e9' }}>H</span>
              <span className="auth-av" style={{ background: '#10b981' }}>A</span>
              <span className="auth-av auth-av-count">+99</span>
            </div>
            <p>Hơn <strong>1.200</strong> học viên đang học tập mỗi ngày</p>
          </div>
        </div>

        {/* ── right: glass form ── */}
        <div className="auth-form-side">
          <div className="auth-glass-card">
            <div className="auth-card-head">
              <p className="auth-eyebrow">Chào mừng trở lại</p>
              <h2>Đăng nhập</h2>
              <p className="auth-card-sub">Nhập thông tin tài khoản để tiếp tục.</p>
            </div>

            {error && (
              <div className="auth-error-box">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="7" stroke="#f43f5e" strokeWidth="1.5"/><path d="M8 5v3.5M8 11h.01" stroke="#f43f5e" strokeWidth="1.5" strokeLinecap="round"/></svg>
                <span>{error}</span>
              </div>
            )}

            <form className="auth-form" onSubmit={handleSubmit} noValidate>
              <div className="auth-field">
                <label htmlFor="l-email">Email</label>
                <div className="auth-input-row">
                  <svg className="auth-field-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><rect x="1.5" y="3.5" width="13" height="9" rx="1.5" stroke="currentColor" strokeWidth="1.3"/><path d="M1.5 5.5l6.5 4 6.5-4" stroke="currentColor" strokeWidth="1.3" strokeLinejoin="round"/></svg>
                  <input id="l-email" name="email" type="email" value={formData.email} onChange={handleChange} placeholder="ban@example.com" autoComplete="email" required />
                </div>
              </div>

              <div className="auth-field">
                <label htmlFor="l-password">Mật khẩu</label>
                <div className="auth-input-row">
                  <svg className="auth-field-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><rect x="3" y="7" width="10" height="7" rx="1.5" stroke="currentColor" strokeWidth="1.3"/><path d="M5 7V5a3 3 0 016 0v2" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/></svg>
                  <input id="l-password" name="password" type={showPw ? 'text' : 'password'} value={formData.password} onChange={handleChange} placeholder="Nhập mật khẩu" autoComplete="current-password" required />
                  <button className="auth-pw-eye" type="button" onClick={() => setShowPw(v => !v)} tabIndex={-1}>
                    {showPw
                      ? <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M1 8s2.5-5 7-5 7 5 7 5-2.5 5-7 5-7-5-7-5z" stroke="currentColor" strokeWidth="1.3"/><circle cx="8" cy="8" r="2" stroke="currentColor" strokeWidth="1.3"/><path d="M2 2l12 12" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/></svg>
                      : <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M1 8s2.5-5 7-5 7 5 7 5-2.5 5-7 5-7-5-7-5z" stroke="currentColor" strokeWidth="1.3"/><circle cx="8" cy="8" r="2" stroke="currentColor" strokeWidth="1.3"/></svg>
                    }
                  </button>
                </div>
              </div>

              <button className="auth-cta" type="submit" disabled={loading}>
                {loading
                  ? <><span className="auth-spin" />Đang đăng nhập...</>
                  : <>Đăng nhập <span className="auth-cta-arrow">→</span></>}
              </button>
            </form>

            <p className="auth-switch-row">
              Chưa có tài khoản? <Link to={ROUTES.REGISTER}>Đăng ký miễn phí</Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Login
