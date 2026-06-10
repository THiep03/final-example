import { Outlet } from 'react-router-dom'
import Navbar from './Navbar.jsx'

function AppLayout() {
  return (
    <div className="app-layout">
      <Navbar />
      <main className="app-main">
        <Outlet />
      </main>
    </div>
  )
}

export default AppLayout
