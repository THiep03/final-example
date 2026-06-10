import { useState } from 'react'
import { Link, useLocation, useNavigate } from 'react-router-dom'
import axiosClient from '../api/axiosClient'

function Login() {
  const navigate = useNavigate()
  const location = useLocation()
  const [formData, setFormData] = useState({
    email: '',
    password: '',
  })
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleChange = (event) => {
    const { name, value } = event.target
    setFormData((current) => ({
      ...current,
      [name]: value,
    }))
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setError('')
    setLoading(true)

    try {
      const response = await axiosClient.post('/auth/login', formData)
      localStorage.setItem('user', JSON.stringify(response.data))
      if (response.data?.id) {
        localStorage.setItem('userId', String(response.data.id))
      }

      const isAdmin = response.data?.role === 'admin'
      const redirectTo = location.state?.from?.pathname
      const safeRedirect = redirectTo?.startsWith('/admin') && !isAdmin ? '/' : redirectTo

      navigate(safeRedirect || (isAdmin ? '/admin/dashboard' : '/courses'), { replace: true })
    } catch (err) {
      setError(err.response?.data?.message || 'Đăng nhập thất bại. Vui lòng thử lại.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <section className="page-shell">
      <form className="panel auth-form" onSubmit={handleSubmit}>
        <div>
          <p className="eyebrow">Chào mừng trở lại</p>
          <h1>Đăng nhập</h1>
        </div>

        {error && <p className="alert">{error}</p>}

        <label>
          Email
          <input
            name="email"
            type="email"
            value={formData.email}
            onChange={handleChange}
            placeholder="student@example.com"
            required
          />
        </label>

        <label>
          Mật khẩu
          <input
            name="password"
            type="password"
            value={formData.password}
            onChange={handleChange}
            placeholder="Nhập mật khẩu"
            required
          />
        </label>

        <button className="primary-button" type="submit" disabled={loading}>
          {loading ? 'Đang đăng nhập...' : 'Đăng nhập'}
        </button>

        <p className="form-footer">
          Chưa có tài khoản? <Link to="/register">Đăng ký ngay</Link>
        </p>
      </form>
    </section>
  )
}

export default Login
