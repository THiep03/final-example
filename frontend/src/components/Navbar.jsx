import { Link, NavLink, useNavigate } from 'react-router-dom'

function getStoredUser() {
  try {
    return JSON.parse(localStorage.getItem('user') || 'null')
  } catch {
    return null
  }
}

function Navbar() {
  const navigate = useNavigate()
  const user = getStoredUser()
  const isAdmin = user?.role === 'admin'
  const displayName = user?.name || user?.email || 'Người dùng'

  const handleLogout = () => {
    localStorage.removeItem('user')
    localStorage.removeItem('userId')
    localStorage.removeItem('token')
    navigate('/login')
  }

  return (
    <header className="navbar">
      <div className="navbar-inner">
        <Link className="brand" to="/">
          <span>HT</span>
          <strong>Học thích ứng</strong>
        </Link>

        <nav className="nav-links" aria-label="Điều hướng chính">
          <NavLink to="/">Trang chủ</NavLink>
          <NavLink to="/courses">Khóa học</NavLink>

          {isAdmin ? (
            <>
              <NavLink to="/admin/dashboard">Bảng điều khiển Admin</NavLink>
              <details className="admin-dropdown">
                <summary>Quản trị</summary>
                <div className="admin-dropdown-menu">
                  <NavLink to="/admin/courses">Quản lý khóa học & nội dung</NavLink>
                  <NavLink to="/admin/lessons">Quản lý bài học</NavLink>
                  <NavLink to="/admin/questions">Quản lý câu hỏi</NavLink>
                  <NavLink to="/admin/files">Quản lý file</NavLink>
                </div>
              </details>
            </>
          ) : (
            user && <NavLink to="/dashboard">Bảng điều khiển</NavLink>
          )}

          {!user && (
            <>
              <NavLink to="/login">Đăng nhập</NavLink>
              <NavLink to="/register">Đăng ký</NavLink>
            </>
          )}
        </nav>

        {user && (
          <div className="user-menu">
            <Link className="user-profile-link" title={displayName} to="/profile">
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
