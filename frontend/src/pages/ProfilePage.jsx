import { useEffect, useMemo, useRef, useState } from 'react'
import { Link } from 'react-router-dom'
import { getCurrentUserProfile, updateUser, uploadUserAvatar } from '../api/userApi.js'
import { DIFFICULTY, ROLES, ROUTES, STORAGE_KEYS } from '../constants/index.js'

function syncUserToStorage(updatedFields) {
  try {
    const stored = JSON.parse(localStorage.getItem(STORAGE_KEYS.USER) || 'null')
    if (stored) {
      localStorage.setItem(STORAGE_KEYS.USER, JSON.stringify({ ...stored, ...updatedFields }))
    }
  } catch { /* ignore */ }
  window.dispatchEvent(new CustomEvent('userUpdated'))
}

function getStoredSession() {
  const token = localStorage.getItem(STORAGE_KEYS.TOKEN)
  const storedUserId = localStorage.getItem(STORAGE_KEYS.USER_ID)
  if (storedUserId) return { token, userId: Number(storedUserId) }
  try {
    const storedUser = JSON.parse(localStorage.getItem(STORAGE_KEYS.USER) || 'null')
    return { token: token || storedUser?.token || '', userId: storedUser?.id ? Number(storedUser.id) : null }
  } catch {
    return { token, userId: null }
  }
}

function formatDate(value) {
  if (!value) return 'Chưa cập nhật'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return 'Chưa cập nhật'
  return new Intl.DateTimeFormat('vi-VN', { dateStyle: 'medium', timeStyle: 'short' }).format(date)
}

function formatDob(value) {
  if (!value) return 'Chưa cập nhật'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return 'Chưa cập nhật'
  return new Intl.DateTimeFormat('vi-VN', { dateStyle: 'long' }).format(date)
}

function formatRole(role) {
  return role === ROLES.ADMIN ? 'Quản trị viên' : 'Học viên'
}

function formatLevel(level) {
  const labels = { [DIFFICULTY.BASIC]: 'Cơ bản', [DIFFICULTY.MEDIUM]: 'Trung bình', [DIFFICULTY.HARD]: 'Nâng cao' }
  return labels[level] || level || 'Chưa cập nhật'
}

function formatGender(g) {
  if (g === 'male') return 'Nam'
  if (g === 'female') return 'Nữ'
  if (g === 'other') return 'Khác'
  return 'Chưa cập nhật'
}

function getInitial(name, email) {
  return (name || email || 'H').trim().charAt(0).toUpperCase()
}

const EMPTY_FORM = { name: '', phone: '', dateOfBirth: '', gender: '', school: '', bio: '' }

function profileToForm(p) {
  return {
    name: p.name || '',
    phone: p.phone || '',
    dateOfBirth: p.dateOfBirth || '',
    gender: p.gender || '',
    school: p.school || '',
    bio: p.bio || '',
  }
}

function ProfilePage() {
  const session = useMemo(() => getStoredSession(), [])
  const [profile, setProfile] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const [editing, setEditing] = useState(false)
  const [form, setForm] = useState(EMPTY_FORM)
  const [saving, setSaving] = useState(false)
  const [saveError, setSaveError] = useState('')
  const [saveOk, setSaveOk] = useState(false)

  const [avatarUploading, setAvatarUploading] = useState(false)
  const [avatarPreview, setAvatarPreview] = useState(null)
  const avatarInputRef = useRef(null)

  useEffect(() => {
    let isMounted = true
    const load = async () => {
      if (!session.userId) { setError('Bạn cần đăng nhập để xem hồ sơ cá nhân.'); setLoading(false); return }
      try {
        const data = await getCurrentUserProfile(session)
        if (isMounted) { setProfile(data); setError('') }
      } catch (err) {
        if (isMounted) setError(err.response?.data?.message || 'Không thể tải thông tin hồ sơ.')
      } finally {
        if (isMounted) setLoading(false)
      }
    }
    load()
    return () => { isMounted = false }
  }, [session])

  const handleEdit = () => {
    setForm(profileToForm(profile))
    setSaveError('')
    setSaveOk(false)
    setEditing(true)
  }

  const handleCancel = () => {
    setEditing(false)
    setSaveError('')
  }

  const handleAvatarClick = () => {
    if (!avatarUploading) avatarInputRef.current?.click()
  }

  const handleAvatarChange = async (e) => {
    const file = e.target.files?.[0]
    if (!file || !session.userId) return
    const preview = URL.createObjectURL(file)
    setAvatarPreview(preview)
    setAvatarUploading(true)
    try {
      const updated = await uploadUserAvatar(session.userId, file)
      setProfile(updated)
      syncUserToStorage({ avatarUrl: updated.avatarUrl })
      setSaveOk(false)
    } catch {
      setAvatarPreview(null)
    } finally {
      setAvatarUploading(false)
      e.target.value = ''
    }
  }

  const handleChange = (e) => {
    const { name, value } = e.target
    setForm(cur => ({ ...cur, [name]: value }))
    setSaveError('')
    setSaveOk(false)
  }

  const handleSave = async (e) => {
    e.preventDefault()
    setSaving(true)
    setSaveError('')
    setSaveOk(false)
    try {
      const payload = {
        name: form.name || undefined,
        phone: form.phone || undefined,
        dateOfBirth: form.dateOfBirth || undefined,
        gender: form.gender || undefined,
        school: form.school || undefined,
        bio: form.bio || undefined,
      }
      const updated = await updateUser(session.userId, payload)
      setProfile(updated)
      setSaveOk(true)
      setEditing(false)
    } catch (err) {
      setSaveError(err.response?.data?.message || 'Lưu thất bại. Vui lòng thử lại.')
    } finally {
      setSaving(false)
    }
  }

  return (
    <section className="page-shell wide-shell profile-page">
      <div className="section-heading compact-heading">
        <div>
          <p className="eyebrow">Hồ sơ cá nhân</p>
          <h1>Thông tin tài khoản</h1>
        </div>
      </div>

      {loading && (
        <div className="profile-skeleton">
          <div className="ui-skeleton" style={{ width: 80, height: 80, borderRadius: '50%' }} />
          <div style={{ flex: 1 }}>
            <div className="ui-skeleton" style={{ width: '40%', height: 20, marginBottom: 8 }} />
            <div className="ui-skeleton" style={{ width: '60%', height: 14 }} />
          </div>
        </div>
      )}
      {error && <p className="alert">{error}</p>}

      {!loading && !error && profile && (
        <article className="profile-card">
          {/* ── hero ── */}
          <div className="profile-hero">
            <div
              className={`profile-avatar-wrap${avatarUploading ? ' profile-avatar-wrap--uploading' : ''}`}
              onClick={handleAvatarClick}
              title="Nhấn để đổi ảnh đại diện"
            >
              {(avatarPreview || profile.avatarUrl)
                ? <img src={avatarPreview || profile.avatarUrl} alt="avatar" className="profile-avatar-img" />
                : <div className="profile-avatar">{getInitial(profile.name, profile.email)}</div>}
              <div className="profile-avatar-overlay">
                {avatarUploading
                  ? <span className="profile-avatar-spinner" />
                  : <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M23 19a2 2 0 01-2 2H3a2 2 0 01-2-2V8a2 2 0 012-2h4l2-3h6l2 3h4a2 2 0 012 2z"/><circle cx="12" cy="13" r="4"/></svg>}
              </div>
              <input
                ref={avatarInputRef}
                type="file"
                accept="image/jpeg,image/png,image/webp"
                style={{ display: 'none' }}
                onChange={handleAvatarChange}
              />
            </div>

            <div className="profile-hero-info">
              <p className="eyebrow">{formatRole(profile.role)}</p>
              <h2>{profile.name || 'Chưa cập nhật tên'}</h2>
              <p className="profile-hero-email">{profile.email}</p>
              {profile.bio && <p className="profile-bio-preview">{profile.bio}</p>}
              <p className="profile-avatar-hint">Nhấn vào ảnh để thay đổi</p>
            </div>
            {!editing && (
              <button className="profile-edit-btn" onClick={handleEdit}>
                ✏️ Chỉnh sửa
              </button>
            )}
          </div>

          {saveOk && (
            <div className="profile-save-ok">✓ Cập nhật hồ sơ thành công!</div>
          )}

          {/* ── edit form ── */}
          {editing ? (
            <form className="profile-edit-form" onSubmit={handleSave} noValidate>
              <h3 className="profile-edit-title">Chỉnh sửa thông tin</h3>

              {saveError && <div className="auth-error-box" style={{ marginBottom: '1rem' }}><span>{saveError}</span></div>}

              <div className="profile-edit-grid">
                <div className="profile-edit-field">
                  <label>Họ tên</label>
                  <input name="name" value={form.name} onChange={handleChange} placeholder="Nguyễn Văn A" />
                </div>
                <div className="profile-edit-field">
                  <label>Số điện thoại</label>
                  <input name="phone" value={form.phone} onChange={handleChange} placeholder="0901 234 567" />
                </div>
                <div className="profile-edit-field">
                  <label>Ngày sinh</label>
                  <input name="dateOfBirth" type="date" value={form.dateOfBirth} onChange={handleChange} />
                </div>
                <div className="profile-edit-field">
                  <label>Giới tính</label>
                  <select name="gender" value={form.gender} onChange={handleChange}>
                    <option value="">-- Chọn --</option>
                    <option value="male">Nam</option>
                    <option value="female">Nữ</option>
                    <option value="other">Khác</option>
                  </select>
                </div>
                <div className="profile-edit-field profile-edit-field--full">
                  <label>Trường / Cơ quan</label>
                  <input name="school" value={form.school} onChange={handleChange} placeholder="Đại học Bách Khoa Hà Nội" />
                </div>
                <div className="profile-edit-field profile-edit-field--full">
                  <label>Giới thiệu bản thân</label>
                  <textarea name="bio" value={form.bio} onChange={handleChange} placeholder="Viết vài dòng về bản thân..." rows={3} />
                </div>
              </div>

              <div className="profile-edit-actions">
                <button type="submit" className="primary-button" disabled={saving}>
                  {saving ? 'Đang lưu...' : 'Lưu thay đổi'}
                </button>
                <button type="button" className="secondary-button" onClick={handleCancel} disabled={saving}>
                  Hủy
                </button>
              </div>
            </form>
          ) : (
            /* ── info grid ── */
            <>
              <div className="profile-section-title">Thông tin cá nhân</div>
              <dl className="profile-info-grid">
                <div>
                  <dt>Họ tên</dt>
                  <dd>{profile.name || 'Chưa cập nhật'}</dd>
                </div>
                <div>
                  <dt>Email</dt>
                  <dd>{profile.email}</dd>
                </div>
                <div>
                  <dt>Số điện thoại</dt>
                  <dd>{profile.phone || 'Chưa cập nhật'}</dd>
                </div>
                <div>
                  <dt>Ngày sinh</dt>
                  <dd>{formatDob(profile.dateOfBirth)}</dd>
                </div>
                <div>
                  <dt>Giới tính</dt>
                  <dd>{formatGender(profile.gender)}</dd>
                </div>
                <div>
                  <dt>Trường / Cơ quan</dt>
                  <dd>{profile.school || 'Chưa cập nhật'}</dd>
                </div>
              </dl>

              <div className="profile-section-title" style={{ marginTop: '1.5rem' }}>Tài khoản học tập</div>
              <dl className="profile-info-grid">
                <div>
                  <dt>Vai trò</dt>
                  <dd>{formatRole(profile.role)}</dd>
                </div>
                <div>
                  <dt>Trình độ hiện tại</dt>
                  <dd>{formatLevel(profile.currentLevel)}</dd>
                </div>
                <div>
                  <dt>Ngày tạo tài khoản</dt>
                  <dd>{formatDate(profile.createdAt)}</dd>
                </div>
                <div>
                  <dt>Cập nhật lần cuối</dt>
                  <dd>{formatDate(profile.updatedAt)}</dd>
                </div>
              </dl>

              {profile.bio && (
                <>
                  <div className="profile-section-title" style={{ marginTop: '1.5rem' }}>Giới thiệu</div>
                  <p className="profile-bio-full">{profile.bio}</p>
                </>
              )}
            </>
          )}

          {!editing && (
            <div className="profile-actions">
              <Link className="primary-button" to={profile.role === ROLES.ADMIN ? ROUTES.ADMIN_DASHBOARD : ROUTES.DASHBOARD}>
                Mở bảng điều khiển
              </Link>
              <Link className="secondary-button" to={ROUTES.COURSES}>
                Xem khóa học
              </Link>
              <Link className="profile-change-pw-btn" to={ROUTES.CHANGE_PASSWORD}>
                🔑 Đổi mật khẩu
              </Link>
            </div>
          )}
        </article>
      )}
    </section>
  )
}

export default ProfilePage
