import { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { getCurrentUserProfile } from '../api/userApi.js'
import { DIFFICULTY, ROLES, ROUTES, STORAGE_KEYS } from '../constants/index.js'

function getStoredSession() {
  const token = localStorage.getItem(STORAGE_KEYS.TOKEN)
  const storedUserId = localStorage.getItem(STORAGE_KEYS.USER_ID)

  if (storedUserId) {
    return {
      token,
      userId: Number(storedUserId),
    }
  }

  try {
    const storedUser = JSON.parse(localStorage.getItem(STORAGE_KEYS.USER) || 'null')

    return {
      token: token || storedUser?.token || storedUser?.accessToken || '',
      userId: storedUser?.id ? Number(storedUser.id) : null,
    }
  } catch {
    return {
      token,
      userId: null,
    }
  }
}

function formatDate(value) {
  if (!value) {
    return 'Chưa cập nhật'
  }

  const date = new Date(value)

  if (Number.isNaN(date.getTime())) {
    return 'Chưa cập nhật'
  }

  return new Intl.DateTimeFormat('vi-VN', {
    dateStyle: 'medium',
    timeStyle: 'short',
  }).format(date)
}

function formatRole(role) {
  if (role === ROLES.ADMIN) return 'Quản trị viên'
  return 'Học viên'
}

function formatLevel(level) {
  const labels = {
    [DIFFICULTY.BASIC]: 'Cơ bản',
    [DIFFICULTY.MEDIUM]: 'Trung bình',
    [DIFFICULTY.HARD]: 'Nâng cao',
  }

  return labels[level] || level || 'Chưa cập nhật'
}

function getInitial(name, email) {
  return (name || email || 'H').trim().charAt(0).toUpperCase()
}

function ProfilePage() {
  const session = useMemo(() => getStoredSession(), [])
  const [profile, setProfile] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    let isMounted = true

    const loadProfile = async () => {
      if (!session.userId) {
        setError('Bạn cần đăng nhập để xem hồ sơ cá nhân.')
        setLoading(false)
        return
      }

      try {
        const profileData = await getCurrentUserProfile(session)

        if (isMounted) {
          setProfile(profileData)
          setError('')
        }
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || 'Không thể tải thông tin hồ sơ.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadProfile()

    return () => {
      isMounted = false
    }
  }, [session])

  return (
    <section className="page-shell wide-shell profile-page">
      <div className="section-heading compact-heading">
        <div>
          <p className="eyebrow">Hồ sơ cá nhân</p>
          <h1>Thông tin tài khoản</h1>
          <p className="muted">Dữ liệu hồ sơ được lấy trực tiếp từ backend, không dùng localStorage làm nguồn hiển thị chính.</p>
        </div>
      </div>

      {loading && <p className="state-message">Đang tải hồ sơ...</p>}
      {error && <p className="alert">{error}</p>}

      {!loading && !error && profile && (
        <article className="profile-card">
          <div className="profile-hero">
            <div className="profile-avatar" aria-hidden="true">
              {getInitial(profile.name, profile.email)}
            </div>
            <div>
              <p className="eyebrow">{formatRole(profile.role)}</p>
              <h2>{profile.name || 'Người dùng chưa cập nhật tên'}</h2>
              <p>{profile.email || 'Chưa cập nhật email'}</p>
            </div>
          </div>

          <dl className="profile-info-grid">
            <div>
              <dt>Họ tên</dt>
              <dd>{profile.name || 'Chưa cập nhật'}</dd>
            </div>
            <div>
              <dt>Email</dt>
              <dd>{profile.email || 'Chưa cập nhật'}</dd>
            </div>
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
          </dl>

          <div className="profile-actions">
            <Link className="primary-button" to={profile.role === ROLES.ADMIN ? ROUTES.ADMIN_DASHBOARD : ROUTES.DASHBOARD}>
              Mở bảng điều khiển
            </Link>
            <Link className="secondary-button" to={ROUTES.COURSES}>
              Xem khóa học
            </Link>
          </div>
        </article>
      )}
    </section>
  )
}

export default ProfilePage
