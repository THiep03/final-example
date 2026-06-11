import { Link, NavLink, useNavigate } from 'react-router-dom'
import { ROLES, ROUTES, STORAGE_KEYS } from '../constants/index.js'

function getStoredUser() {
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEYS.USER) || 'null')
  } catch {
    return null
  }
}

function Navbar() {
  const navigate = useNavigate()
  const user = getStoredUser()
  const isAdmin = user?.role === ROLES.ADMIN
  const displayName = user?.name || user?.email || 'Người dùng'

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
              <NavLink to={ROUTES.ADMIN_DASHBOARD}>Bảng điều khiển Admin</NavLink>
              <details className="admin-dropdown">
                <summary>Quản trị</summary>
                <div className="admin-dropdown-menu">
                  <NavLink to={ROUTES.ADMIN_COURSES}>Quản lý khóa học & nội dung</NavLink>
                  <NavLink to={ROUTES.ADMIN_LESSONS}>Quản lý bài học</NavLink>
                  <NavLink to={ROUTES.ADMIN_QUESTIONS}>Quản lý câu hỏi</NavLink>
                  <NavLink to={ROUTES.ADMIN_FILES}>Quản lý file</NavLink>
                </div>
              </details>
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
            <Link className="user-profile-link" title={displayName} to={ROUTES.PROFILE}>
              {displayName}
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
