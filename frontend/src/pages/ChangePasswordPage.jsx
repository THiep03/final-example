import { useMemo, useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { changePassword } from '../api/userApi.js'
import { ROUTES, STORAGE_KEYS } from '../constants/index.js'

function getStoredUserId() {
  const direct = localStorage.getItem(STORAGE_KEYS.USER_ID)
  if (direct) return Number(direct)
  try {
    const u = JSON.parse(localStorage.getItem(STORAGE_KEYS.USER) || 'null')
    return u?.id ? Number(u.id) : null
  } catch {
    return null
  }
}

function getStrength(pw) {
  if (!pw) return 0
  let score = 0
  if (pw.length >= 8) score++
  if (/[A-Z]/.test(pw)) score++
  if (/[0-9]/.test(pw)) score++
  if (/[^A-Za-z0-9]/.test(pw)) score++
  return score
}

const STRENGTH_LABEL = ['', 'Yếu', 'Trung bình', 'Mạnh', 'Rất mạnh']
const STRENGTH_LV = ['', 'weak', 'fair', 'strong', 'strong']

function ChangePasswordPage() {
  const navigate = useNavigate()
  const userId = useMemo(() => getStoredUserId(), [])

  const [form, setForm] = useState({ oldPassword: '', newPassword: '', confirm: '' })
  const [show, setShow] = useState({ old: false, new: false, confirm: false })
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState(false)

  const strength = getStrength(form.newPassword)

  const handleChange = (e) => {
    const { name, value } = e.target
    setForm(cur => ({ ...cur, [name]: value }))
    setError('')
  }

  const toggleShow = (field) => setShow(cur => ({ ...cur, [field]: !cur[field] }))

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (form.newPassword !== form.confirm) {
      setError('Mật khẩu mới và xác nhận không khớp.')
      return
    }
    if (form.newPassword.length < 6) {
      setError('Mật khẩu mới phải có ít nhất 6 ký tự.')
      return
    }
    if (!userId) {
      setError('Không tìm thấy thông tin người dùng.')
      return
    }

    setLoading(true)
    try {
      await changePassword(userId, {
        oldPassword: form.oldPassword,
        newPassword: form.newPassword,
      })
      setSuccess(true)
      setTimeout(() => navigate(ROUTES.PROFILE), 2000)
    } catch (err) {
      setError(err.response?.data?.message || 'Đổi mật khẩu thất bại. Vui lòng thử lại.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="auth-scene">
      <div className="auth-blob auth-blob-1" />
      <div className="auth-blob auth-blob-2" />
      <div className="auth-blob auth-blob-3" />

      <div className="cpw-center">
        <div className="auth-glass-card cpw-card">
          <div className="auth-card-head">
            <p className="auth-eyebrow">Bảo mật tài khoản</p>
            <h2>Đổi mật khẩu</h2>
            <p className="auth-card-sub">Nhập mật khẩu hiện tại và mật khẩu mới để cập nhật.</p>
          </div>

          {success ? (
            <div className="cpw-success">
              <div className="cpw-success-icon">✓</div>
              <p>Đổi mật khẩu thành công!</p>
              <p className="auth-card-sub">Đang chuyển về trang hồ sơ...</p>
            </div>
          ) : (
            <>
              {error && (
                <div className="auth-error-box">
                  <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="7" stroke="#f43f5e" strokeWidth="1.5"/><path d="M8 5v3.5M8 11h.01" stroke="#f43f5e" strokeWidth="1.5" strokeLinecap="round"/></svg>
                  <span>{error}</span>
                </div>
              )}

              <form className="auth-form" onSubmit={handleSubmit} noValidate>
                <div className="auth-field">
                  <label htmlFor="cp-old">Mật khẩu hiện tại</label>
                  <div className="auth-input-row">
                    <svg className="auth-field-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><rect x="3" y="7" width="10" height="7" rx="1.5" stroke="currentColor" strokeWidth="1.3"/><path d="M5 7V5a3 3 0 016 0v2" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/></svg>
                    <input id="cp-old" name="oldPassword" type={show.old ? 'text' : 'password'} value={form.oldPassword} onChange={handleChange} placeholder="Nhập mật khẩu hiện tại" autoComplete="current-password" required />
                    <button className="auth-pw-eye" type="button" onClick={() => toggleShow('old')} tabIndex={-1}>
                      {show.old
                        ? <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M1 8s2.5-5 7-5 7 5 7 5-2.5 5-7 5-7-5-7-5z" stroke="currentColor" strokeWidth="1.3"/><circle cx="8" cy="8" r="2" stroke="currentColor" strokeWidth="1.3"/><path d="M2 2l12 12" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/></svg>
                        : <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M1 8s2.5-5 7-5 7 5 7 5-2.5 5-7 5-7-5-7-5z" stroke="currentColor" strokeWidth="1.3"/><circle cx="8" cy="8" r="2" stroke="currentColor" strokeWidth="1.3"/></svg>}
                    </button>
                  </div>
                </div>

                <div className="auth-field">
                  <label htmlFor="cp-new">Mật khẩu mới</label>
                  <div className="auth-input-row">
                    <svg className="auth-field-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><rect x="3" y="7" width="10" height="7" rx="1.5" stroke="currentColor" strokeWidth="1.3"/><path d="M5 7V5a3 3 0 016 0v2" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/></svg>
                    <input id="cp-new" name="newPassword" type={show.new ? 'text' : 'password'} value={form.newPassword} onChange={handleChange} placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)" autoComplete="new-password" required />
                    <button className="auth-pw-eye" type="button" onClick={() => toggleShow('new')} tabIndex={-1}>
                      {show.new
                        ? <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M1 8s2.5-5 7-5 7 5 7 5-2.5 5-7 5-7-5-7-5z" stroke="currentColor" strokeWidth="1.3"/><circle cx="8" cy="8" r="2" stroke="currentColor" strokeWidth="1.3"/><path d="M2 2l12 12" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/></svg>
                        : <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M1 8s2.5-5 7-5 7 5 7 5-2.5 5-7 5-7-5-7-5z" stroke="currentColor" strokeWidth="1.3"/><circle cx="8" cy="8" r="2" stroke="currentColor" strokeWidth="1.3"/></svg>}
                    </button>
                  </div>
                  {form.newPassword && (
                    <div className="auth-strength">
                      <div className="auth-strength-bar" data-lv={STRENGTH_LV[strength]}>
                        <div className="auth-strength-fill" />
                      </div>
                      <span className="auth-strength-label">{STRENGTH_LABEL[strength]}</span>
                    </div>
                  )}
                </div>

                <div className="auth-field">
                  <label htmlFor="cp-confirm">Xác nhận mật khẩu mới</label>
                  <div className="auth-input-row">
                    <svg className="auth-field-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M2.5 8.5L6 12l7.5-8" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round" strokeLinejoin="round"/></svg>
                    <input id="cp-confirm" name="confirm" type={show.confirm ? 'text' : 'password'} value={form.confirm} onChange={handleChange} placeholder="Nhập lại mật khẩu mới" autoComplete="new-password" required />
                    <button className="auth-pw-eye" type="button" onClick={() => toggleShow('confirm')} tabIndex={-1}>
                      {show.confirm
                        ? <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M1 8s2.5-5 7-5 7 5 7 5-2.5 5-7 5-7-5-7-5z" stroke="currentColor" strokeWidth="1.3"/><circle cx="8" cy="8" r="2" stroke="currentColor" strokeWidth="1.3"/><path d="M2 2l12 12" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/></svg>
                        : <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M1 8s2.5-5 7-5 7 5 7 5-2.5 5-7 5-7-5-7-5z" stroke="currentColor" strokeWidth="1.3"/><circle cx="8" cy="8" r="2" stroke="currentColor" strokeWidth="1.3"/></svg>}
                    </button>
                  </div>
                </div>

                <button className="auth-cta" type="submit" disabled={loading}>
                  {loading
                    ? <><span className="auth-spin" />Đang xử lý...</>
                    : <>Đổi mật khẩu <span className="auth-cta-arrow">→</span></>}
                </button>
              </form>

              <p className="auth-switch-row">
                <Link to={ROUTES.PROFILE}>← Quay về hồ sơ</Link>
              </p>
            </>
          )}
        </div>
      </div>
    </div>
  )
}

export default ChangePasswordPage
