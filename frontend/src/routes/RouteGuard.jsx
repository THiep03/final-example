import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { ROLES, ROUTES } from '../constants/index.js'
import { getStoredUser } from '../utils/flowHelpers.js'

function isAdmin(user) {
  return String(user?.role || '').toLowerCase() === ROLES.ADMIN
}

export function ProtectedRoute({ requireAdmin = false }) {
  const location = useLocation()
  const user = getStoredUser()

  if (!user?.id) {
    return <Navigate replace to={ROUTES.LOGIN} state={{ from: location }} />
  }

  if (requireAdmin && !isAdmin(user)) {
    return <Navigate replace to={ROUTES.HOME} />
  }

  return <Outlet />
}

export function PublicOnlyRoute() {
  const user = getStoredUser()

  if (user?.id) {
    return <Navigate replace to={isAdmin(user) ? ROUTES.ADMIN_DASHBOARD : ROUTES.HOME} />
  }

  return <Outlet />
}
