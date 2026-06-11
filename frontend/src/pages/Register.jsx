import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import axiosClient from '../api/axiosClient'
import { ROUTES, STORAGE_KEYS } from '../constants/index.js'

function Register() {
  const navigate = useNavigate()
  const [formData, setFormData] = useState({
    name: '',
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
      const response = await axiosClient.post('/auth/register', formData)
      localStorage.setItem(STORAGE_KEYS.USER, JSON.stringify(response.data))
      if (response.data?.id) {
        localStorage.setItem(STORAGE_KEYS.USER_ID, String(response.data.id))
      }
      navigate(ROUTES.HOME, { replace: true })
    } catch (err) {
      setError(err.response?.data?.message || 'Đăng ký thất bại. Vui lòng thử lại.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <section className="page-shell">
      <form className="panel auth-form" onSubmit={handleSubmit}>
        <div>
          <p className="eyebrow">Tạo tài khoản</p>
          <h1>Đăng ký</h1>
        </div>

        {error && <p className="alert">{error}</p>}

        <label>
          Họ tên
          <input
            name="name"
            type="text"
            value={formData.name}
            onChange={handleChange}
            placeholder="Nguyễn Văn A"
            required
          />
        </label>

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
          {loading ? 'Đang tạo tài khoản...' : 'Đăng ký'}
        </button>

        <p className="form-footer">
          Đã có tài khoản? <Link to={ROUTES.LOGIN}>Đăng nhập</Link>
        </p>
      </form>
    </section>
  )
}

export default Register
