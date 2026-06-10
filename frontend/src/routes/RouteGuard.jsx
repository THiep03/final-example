import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { getStoredUser } from '../utils/flowHelpers.js'

function isAdmin(user) {
  return String(user?.role || '').toLowerCase() === 'admin'
}

export function ProtectedRoute({ requireAdmin = false }) {
  const location = useLocation()
  const user = getStoredUser()

  if (!user?.id) {
    return <Navigate replace to="/login" state={{ from: location }} />
  }

  if (requireAdmin && !isAdmin(user)) {
    return <Navigate replace to="/" />
  }

  return <Outlet />
}

export function PublicOnlyRoute() {
  const user = getStoredUser()

  if (user?.id) {
    return <Navigate replace to={isAdmin(user) ? '/admin/dashboard' : '/'} />
  }

  return <Outlet />
}
