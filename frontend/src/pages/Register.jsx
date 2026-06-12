import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import axiosClient from '../api/axiosClient'
import { ROUTES } from '../constants/index.js'

function Register() {
  const navigate  = useNavigate()
  const [formData, setFormData] = useState({ name: '', email: '', password: '' })
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
    if (formData.password.length < 6) {
      setError('Mật khẩu phải có ít nhất 6 ký tự.')
      return
    }
    setLoading(true)
    try {
      await axiosClient.post('/auth/register', formData)
      navigate(ROUTES.LOGIN, { state: { registered: true } })
    } catch (err) {
      setError(err.response?.data?.message || 'Đăng ký thất bại. Vui lòng thử lại.')
    } finally {
      setLoading(false)
    }
  }

  const pwLen = formData.password.length
  const pwLevel = pwLen === 0 ? '' : pwLen < 6 ? 'weak' : pwLen < 10 ? 'fair' : 'strong'
  const pwLabels = { weak: 'Yếu', fair: 'Trung bình', strong: 'Mạnh' }

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
            <h1>Bắt đầu hành trình<br /><span className="auth-gradient-text">học tập thông minh.</span></h1>
            <p>Hệ thống tự động phân tích năng lực, gợi ý bài học phù hợp và theo dõi sự tiến bộ của bạn theo thời gian thực.</p>
          </div>

          {/* feature list */}
          <div className="auth-feat-list">
            <div className="auth-feat-item">
              <span className="auth-feat-icon">🎯</span>
              <div>
                <strong>Quiz thích ứng</strong>
                <p>Câu hỏi tự động điều chỉnh theo trình độ của bạn</p>
              </div>
            </div>
            <div className="auth-feat-item">
              <span className="auth-feat-icon">🧠</span>
              <div>
                <strong>Phân tích tập trung AI</strong>
                <p>Theo dõi mức độ tập trung và đưa ra gợi ý cải thiện</p>
              </div>
            </div>
            <div className="auth-feat-item">
              <span className="auth-feat-icon">📈</span>
              <div>
                <strong>Báo cáo tiến độ</strong>
                <p>Dashboard trực quan theo dõi kết quả học tập</p>
              </div>
            </div>
          </div>

          <div className="auth-trust-badge">
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M7 1l1.5 3.5L12 5l-2.5 2.5.5 3.5L7 9.5 4 11l.5-3.5L2 5l3.5-.5L7 1z" stroke="#f59e0b" strokeWidth="1.2" fill="#fef3c7"/></svg>
            Miễn phí hoàn toàn — không cần thẻ tín dụng
          </div>
        </div>

        {/* ── right: glass form ── */}
        <div className="auth-form-side">
          <div className="auth-glass-card">
            <div className="auth-card-head">
              <p className="auth-eyebrow">Tạo tài khoản</p>
              <h2>Đăng ký</h2>
              <p className="auth-card-sub">Điền thông tin để bắt đầu học ngay hôm nay.</p>
            </div>

            {error && (
              <div className="auth-error-box">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="7" stroke="#f43f5e" strokeWidth="1.5"/><path d="M8 5v3.5M8 11h.01" stroke="#f43f5e" strokeWidth="1.5" strokeLinecap="round"/></svg>
                <span>{error}</span>
              </div>
            )}

            <form className="auth-form" onSubmit={handleSubmit} noValidate>
              <div className="auth-field">
                <label htmlFor="r-name">Họ và tên</label>
                <div className="auth-input-row">
                  <svg className="auth-field-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="5.5" r="2.5" stroke="currentColor" strokeWidth="1.3"/><path d="M2.5 13.5c0-3 2.5-5 5.5-5s5.5 2 5.5 5" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/></svg>
                  <input id="r-name" name="name" type="text" value={formData.name} onChange={handleChange} placeholder="Nguyễn Văn A" autoComplete="name" required />
                </div>
              </div>

              <div className="auth-field">
                <label htmlFor="r-email">Email</label>
                <div className="auth-input-row">
                  <svg className="auth-field-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><rect x="1.5" y="3.5" width="13" height="9" rx="1.5" stroke="currentColor" strokeWidth="1.3"/><path d="M1.5 5.5l6.5 4 6.5-4" stroke="currentColor" strokeWidth="1.3" strokeLinejoin="round"/></svg>
                  <input id="r-email" name="email" type="email" value={formData.email} onChange={handleChange} placeholder="ban@example.com" autoComplete="email" required />
                </div>
              </div>

              <div className="auth-field">
                <label htmlFor="r-password">Mật khẩu</label>
                <div className="auth-input-row">
                  <svg className="auth-field-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><rect x="3" y="7" width="10" height="7" rx="1.5" stroke="currentColor" strokeWidth="1.3"/><path d="M5 7V5a3 3 0 016 0v2" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/></svg>
                  <input id="r-password" name="password" type={showPw ? 'text' : 'password'} value={formData.password} onChange={handleChange} placeholder="Ít nhất 6 ký tự" autoComplete="new-password" required />
                  <button className="auth-pw-eye" type="button" onClick={() => setShowPw(v => !v)} tabIndex={-1}>
                    {showPw
                      ? <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M1 8s2.5-5 7-5 7 5 7 5-2.5 5-7 5-7-5-7-5z" stroke="currentColor" strokeWidth="1.3"/><circle cx="8" cy="8" r="2" stroke="currentColor" strokeWidth="1.3"/><path d="M2 2l12 12" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/></svg>
                      : <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M1 8s2.5-5 7-5 7 5 7 5-2.5 5-7 5-7-5-7-5z" stroke="currentColor" strokeWidth="1.3"/><circle cx="8" cy="8" r="2" stroke="currentColor" strokeWidth="1.3"/></svg>
                    }
                  </button>
                </div>
                {pwLevel && (
                  <div className="auth-strength-wrap">
                    <div className="auth-strength-track">
                      <div
                        className="auth-strength-bar"
                        data-lv={pwLevel}
                        style={{ width: `${Math.min(100, pwLen * 10)}%` }}
                      />
                    </div>
                    <span className="auth-strength-label" data-lv={pwLevel}>{pwLabels[pwLevel]}</span>
                  </div>
                )}
              </div>

              <button className="auth-cta" type="submit" disabled={loading}>
                {loading
                  ? <><span className="auth-spin" />Đang tạo tài khoản...</>
                  : <>Tạo tài khoản miễn phí <span className="auth-cta-arrow">→</span></>}
              </button>
            </form>

            <p className="auth-switch-row">
              Đã có tài khoản? <Link to={ROUTES.LOGIN}>Đăng nhập</Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Register
