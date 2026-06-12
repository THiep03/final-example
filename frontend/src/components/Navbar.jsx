import { useEffect, useRef, useState } from 'react'
import { Link, NavLink, useLocation, useNavigate } from 'react-router-dom'
import { ROLES, ROUTES, STORAGE_KEYS } from '../constants/index.js'

function getStoredUser() {
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEYS.USER) || 'null')
  } catch {
    return null
  }
}

const ADMIN_MENU = [
  {
    group: 'Nội dung học tập',
    items: [
      { label: 'Khóa học & nội dung', icon: '📚', to: ROUTES.ADMIN_COURSES,   desc: 'Tạo và quản lý khóa học' },
      { label: 'Bài học',             icon: '📖', to: ROUTES.ADMIN_LESSONS,   desc: 'Quản lý bài học & video' },
      { label: 'Câu hỏi quiz',        icon: '❓', to: ROUTES.ADMIN_QUESTIONS, desc: 'Ngân hàng câu hỏi' },
    ],
  },
  {
    group: 'Hệ thống',
    items: [
      { label: 'Người dùng', icon: '👥', to: ROUTES.ADMIN_USERS, desc: 'Vai trò và cấp độ' },
      { label: 'File media',  icon: '🗂️', to: ROUTES.ADMIN_FILES, desc: 'Ảnh, video, tài liệu' },
    ],
  },
]

function AdminDropdown() {
  const [open, setOpen] = useState(false)
  const ref = useRef(null)
  const location = useLocation()

  // close on outside click
  useEffect(() => {
    const handler = (e) => { if (ref.current && !ref.current.contains(e.target)) setOpen(false) }
    document.addEventListener('mousedown', handler)
    return () => document.removeEventListener('mousedown', handler)
  }, [])

  // close on route change
  useEffect(() => { setOpen(false) }, [location.pathname])

  const isActive = ADMIN_MENU.flatMap(g => g.items).some(item => location.pathname.startsWith(item.to))

  return (
    <div className="adm-nav-dropdown" ref={ref}>
      <button
        className={`adm-nav-trigger${open ? ' is-open' : ''}${isActive ? ' is-active' : ''}`}
        type="button"
        onClick={() => setOpen(v => !v)}
        aria-haspopup="true"
        aria-expanded={open}
      >
        <span>Quản trị</span>
        <svg className="adm-nav-chevron" width="12" height="12" viewBox="0 0 12 12" fill="none">
          <path d="M2 4l4 4 4-4" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/>
        </svg>
      </button>

      {open && (
        <div className="adm-nav-menu" role="menu">
          <div className="adm-nav-menu-header">
            <span>⚙️</span>
            <span>Bảng điều khiển quản trị</span>
          </div>
          {ADMIN_MENU.map((group) => (
            <div className="adm-nav-group" key={group.group}>
              <p className="adm-nav-group-label">{group.group}</p>
              {group.items.map((item) => (
                <NavLink
                  className={({ isActive }) => `adm-nav-item${isActive ? ' is-active' : ''}`}
                  key={item.to}
                  to={item.to}
                  role="menuitem"
                >
                  <span className="adm-nav-item-icon">{item.icon}</span>
                  <span className="adm-nav-item-body">
                    <span className="adm-nav-item-label">{item.label}</span>
                    <span className="adm-nav-item-desc">{item.desc}</span>
                  </span>
                </NavLink>
              ))}
            </div>
          ))}
          <div className="adm-nav-menu-footer">
            <NavLink className="adm-nav-dashboard-link" to={ROUTES.ADMIN_DASHBOARD}>
              <span>📊</span>
              <span>Xem bảng điều khiển</span>
              <span className="adm-nav-arrow">→</span>
            </NavLink>
          </div>
        </div>
      )}
    </div>
  )
}

function getInitial(name, email) {
  return (name || email || '?').trim().charAt(0).toUpperCase()
}

function Navbar() {
  const navigate = useNavigate()
  const [user, setUser] = useState(getStoredUser)
  const isAdmin = user?.role === ROLES.ADMIN
  const displayName = user?.name || user?.email || 'Người dùng'

  useEffect(() => {
    const refresh = () => setUser(getStoredUser())
    window.addEventListener('userUpdated', refresh)
    return () => window.removeEventListener('userUpdated', refresh)
  }, [])

  const handleLogout = () => {
    localStorage.removeItem(STORAGE_KEYS.USER)
    localStorage.removeItem(STORAGE_KEYS.USER_ID)
    localStorage.removeItem(STORAGE_KEYS.TOKEN)
    navigate(ROUTES.LOGIN)
  }

  return (
    <header className="navbar">
      <div className="navbar-inner">
        <Link className="brand" to={ROUTES.HOME}>
          <span>HT</span>
          <strong>Học thích ứng</strong>
        </Link>

        <nav className="nav-links" aria-label="Điều hướng chính">
          <NavLink to={ROUTES.HOME}>Trang chủ</NavLink>
          <NavLink to={ROUTES.COURSES}>Khóa học</NavLink>

          {isAdmin ? (
            <>
              <NavLink to={ROUTES.ADMIN_DASHBOARD}>Dashboard</NavLink>
              <AdminDropdown />
            </>
          ) : (
            user && <NavLink to={ROUTES.DASHBOARD}>Bảng điều khiển</NavLink>
          )}

          {!user && (
            <>
              <NavLink to={ROUTES.LOGIN}>Đăng nhập</NavLink>
              <NavLink to={ROUTES.REGISTER}>Đăng ký</NavLink>
            </>
          )}
        </nav>

        {user && (
          <div className="user-menu">
            <Link className="navbar-user-profile" title={`Hồ sơ: ${displayName}`} to={ROUTES.PROFILE}>
              <div className="navbar-avatar">
                {user.avatarUrl
                  ? <img src={user.avatarUrl} alt={displayName} className="navbar-avatar-img" />
                  : <span className="navbar-avatar-initial">{getInitial(user.name, user.email)}</span>}
              </div>
              <span className="navbar-display-name">{displayName}</span>
            </Link>
            <button className="link-button" type="button" onClick={handleLogout}>
              Đăng xuất
            </button>
          </div>
        )}
      </div>
    </header>
  )
}

export default Navbar
