import { useEffect, useMemo, useRef, useState } from 'react'
import { deleteUser, getUsers, updateUser } from '../api/userApi.js'
import Pagination from '../components/Pagination.jsx'
import { DIFFICULTY, ROLES } from '../constants/index.js'

const DEFAULT_PAGE_SIZE = 10

const ROLE_OPTIONS = [
  { value: '',           label: 'Tất cả vai trò' },
  { value: ROLES.ADMIN,   label: 'Admin'           },
  { value: ROLES.STUDENT, label: 'Học viên'        },
]

const LEVEL_OPTIONS = [
  { value: '',                label: 'Tất cả cấp độ' },
  { value: DIFFICULTY.BASIC,  label: 'Cơ bản'        },
  { value: DIFFICULTY.MEDIUM, label: 'Trung bình'    },
  { value: DIFFICULTY.HARD,   label: 'Nâng cao'      },
]

const initialForm = { name: '', email: '', role: ROLES.STUDENT, currentLevel: DIFFICULTY.BASIC }

function getRoleClass(role) {
  return role === ROLES.ADMIN ? 'role-admin' : 'role-student'
}

function getRoleLabel(role) {
  return role === ROLES.ADMIN ? 'Admin' : 'Học viên'
}

function getLevelLabel(level) {
  if (level === DIFFICULTY.MEDIUM) return 'Trung bình'
  if (level === DIFFICULTY.HARD)   return 'Nâng cao'
  return 'Cơ bản'
}

function getLevelClass(level) {
  if (level === DIFFICULTY.HARD)   return 'diff-hard'
  if (level === DIFFICULTY.MEDIUM) return 'diff-medium'
  return 'diff-basic'
}

function initials(name) {
  if (!name) return '?'
  return name.trim().split(/\s+/).map(w => w[0]).slice(0, 2).join('').toUpperCase()
}

function fmtDt(iso) {
  if (!iso) return '—'
  try { return new Date(iso).toLocaleDateString('vi-VN') } catch { return iso }
}

function AdminUsersPage() {
  const [users, setUsers]       = useState([])
  const [loading, setLoading]   = useState(true)
  const [saving, setSaving]     = useState(false)
  const [error, setError]       = useState('')
  const [success, setSuccess]   = useState('')
  const [editingId, setEditingId] = useState(null)
  const [form, setForm]         = useState(initialForm)
  const formRef                 = useRef(null)

  // search + filter + pagination
  const [search, setSearch]       = useState('')
  const [filterRole, setFilterRole] = useState('')
  const [filterLevel, setFilterLevel] = useState('')
  const [page, setPage]           = useState(1)
  const [pageSize, setPageSize]   = useState(DEFAULT_PAGE_SIZE)

  const loadUsers = async () => {
    setLoading(true)
    try {
      const data = await getUsers()
      setUsers(Array.isArray(data) ? data : [])
      setError('')
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải danh sách người dùng.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    let alive = true
    getUsers()
      .then(data => { if (alive) { setUsers(Array.isArray(data) ? data : []); setError('') } })
      .catch(err => { if (alive) setError(err.response?.data?.message || 'Không thể tải người dùng.') })
      .finally(() => { if (alive) setLoading(false) })
    return () => { alive = false }
  }, [])

  useEffect(() => { setPage(1) }, [search, filterRole, filterLevel, pageSize])

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim()
    return users.filter(u => {
      const matchSearch = !q || u.name?.toLowerCase().includes(q) || u.email?.toLowerCase().includes(q) || String(u.id).includes(q)
      const matchRole   = !filterRole  || u.role === filterRole
      const matchLevel  = !filterLevel || u.currentLevel === filterLevel
      return matchSearch && matchRole && matchLevel
    })
  }, [users, search, filterRole, filterLevel])

  const totalPages = Math.max(1, Math.ceil(filtered.length / pageSize))
  const safePage   = Math.min(page, totalPages)
  const pageItems  = filtered.slice((safePage - 1) * pageSize, safePage * pageSize)

  // stats
  const adminCount   = users.filter(u => u.role === ROLES.ADMIN).length
  const studentCount = users.filter(u => u.role === ROLES.STUDENT).length

  const handleChange = (e) => {
    const { name, value } = e.target
    setForm(cur => ({ ...cur, [name]: value }))
  }

  const handleEdit = (user) => {
    setEditingId(user.id)
    setForm({
      name:         user.name         || '',
      email:        user.email        || '',
      role:         user.role         || ROLES.STUDENT,
      currentLevel: user.currentLevel || DIFFICULTY.BASIC,
    })
    setError(''); setSuccess('')
    formRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }

  const resetForm = () => {
    setForm(initialForm)
    setEditingId(null)
    setError(''); setSuccess('')
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError(''); setSuccess('')
    if (!form.name.trim())  { setError('Vui lòng nhập tên người dùng.'); return }
    if (!form.email.trim()) { setError('Vui lòng nhập email.'); return }
    if (!editingId) return
    setSaving(true)
    try {
      await updateUser(editingId, form)
      setSuccess('Đã cập nhật người dùng thành công.')
      resetForm()
      await loadUsers()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể cập nhật người dùng.')
    } finally {
      setSaving(false)
    }
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Bạn có chắc muốn xóa người dùng này? Hành động không thể hoàn tác.')) return
    setError(''); setSuccess('')
    try {
      await deleteUser(id)
      if (editingId === id) resetForm()
      setSuccess('Đã xóa người dùng thành công.')
      await loadUsers()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể xóa người dùng.')
    }
  }

  return (
    <section className="page-shell wide-shell admin-page">

      {/* page header */}
      <div className="adm-page-header">
        <div>
          <p className="eyebrow">Quản trị hệ thống</p>
          <h1>Quản lý người dùng</h1>
          <p className="muted">Xem, chỉnh sửa vai trò và cấp độ học tập của người dùng trong hệ thống.</p>
        </div>
        <div className="adm-header-meta">
          <span className="adm-total-badge">{users.length} người dùng</span>
        </div>
      </div>

      {/* stat strip */}
      {!loading && users.length > 0 && (
        <div className="adm-user-stats">
          <div className="adm-user-stat-card kpi-blue">
            <span className="adm-user-stat-icon">👥</span>
            <div>
              <strong>{users.length}</strong>
              <span>Tổng người dùng</span>
            </div>
          </div>
          <div className="adm-user-stat-card kpi-indigo">
            <span className="adm-user-stat-icon">🛡️</span>
            <div>
              <strong>{adminCount}</strong>
              <span>Quản trị viên</span>
            </div>
          </div>
          <div className="adm-user-stat-card kpi-teal">
            <span className="adm-user-stat-icon">🎓</span>
            <div>
              <strong>{studentCount}</strong>
              <span>Học viên</span>
            </div>
          </div>
        </div>
      )}

      {error   && <p className="alert">{error}</p>}
      {success && <p className="success-alert">{success}</p>}

      {/* edit form — only shows when editing */}
      {editingId && (
        <div className="adm-form-card" ref={formRef}>
          <div className="adm-form-card-head">
            <div>
              <p className="eyebrow">Chỉnh sửa</p>
              <h2>Sửa thông tin người dùng</h2>
            </div>
            <button className="ghost-button" type="button" onClick={resetForm}>✕ Hủy</button>
          </div>
          <form className="adm-form-body admin-form" onSubmit={handleSubmit}>
            <label>
              Họ tên <span className="field-required">*</span>
              <input name="name" value={form.name} onChange={handleChange} placeholder="Nhập họ tên..." required />
            </label>
            <label>
              Email <span className="field-required">*</span>
              <input name="email" type="email" value={form.email} onChange={handleChange} placeholder="email@example.com" required />
            </label>
            <label>
              Vai trò
              <select name="role" value={form.role} onChange={handleChange}>
                <option value={ROLES.STUDENT}>Học viên</option>
                <option value={ROLES.ADMIN}>Admin</option>
              </select>
            </label>
            <label>
              Cấp độ học tập
              <select name="currentLevel" value={form.currentLevel} onChange={handleChange}>
                <option value={DIFFICULTY.BASIC}>Cơ bản</option>
                <option value={DIFFICULTY.MEDIUM}>Trung bình</option>
                <option value={DIFFICULTY.HARD}>Nâng cao</option>
              </select>
            </label>
            <div className="admin-form-actions full-field">
              <button className="primary-button" type="submit" disabled={saving}>
                {saving ? 'Đang lưu...' : 'Cập nhật người dùng'}
              </button>
              <button className="secondary-button" type="button" onClick={resetForm}>
                Hủy thay đổi
              </button>
            </div>
          </form>
        </div>
      )}

      {/* table */}
      <section className="admin-table-panel">
        <div className="adm-table-header">
          <div>
            <h2>Danh sách người dùng</h2>
            <p className="muted">Tổng cộng <strong>{filtered.length}</strong> kết quả.</p>
          </div>
          <div className="adm-table-filters">
            <div className="adm-search-box">
              <span className="adm-search-icon">🔍</span>
              <input
                className="adm-search-input"
                placeholder="Tìm theo tên, email hoặc ID..."
                value={search}
                onChange={e => setSearch(e.target.value)}
              />
              {search && (
                <button className="adm-search-clear" type="button" onClick={() => setSearch('')}>✕</button>
              )}
            </div>
            <select className="adm-filter-select" value={filterRole} onChange={e => setFilterRole(e.target.value)}>
              {ROLE_OPTIONS.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
            <select className="adm-filter-select" value={filterLevel} onChange={e => setFilterLevel(e.target.value)}>
              {LEVEL_OPTIONS.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
          </div>
        </div>

        {loading ? (
          <p className="state-message">Đang tải danh sách người dùng...</p>
        ) : filtered.length === 0 ? (
          <p className="state-message">{search || filterRole || filterLevel ? 'Không tìm thấy người dùng phù hợp.' : 'Chưa có người dùng nào.'}</p>
        ) : (
          <>
            <div className="table-scroll">
              <table className="admin-table">
                <thead>
                  <tr>
                    <th className="col-id">ID</th>
                    <th>Người dùng</th>
                    <th>Email</th>
                    <th>Vai trò</th>
                    <th>Cấp độ</th>
                    <th>Ngày tạo</th>
                    <th>Thao tác</th>
                  </tr>
                </thead>
                <tbody>
                  {pageItems.map(user => (
                    <tr key={user.id}>
                      <td className="col-id adm-id-cell">#{user.id}</td>
                      <td>
                        <div className="adm-user-cell">
                          <span className="adm-user-avatar">{initials(user.name)}</span>
                          <span className="adm-user-name">{user.name || '—'}</span>
                        </div>
                      </td>
                      <td className="adm-email-cell">{user.email || '—'}</td>
                      <td>
                        <span className={`adm-role-badge ${getRoleClass(user.role)}`}>
                          {getRoleLabel(user.role)}
                        </span>
                      </td>
                      <td>
                        <span className={`adm-diff-badge ${getLevelClass(user.currentLevel)}`}>
                          {getLevelLabel(user.currentLevel)}
                        </span>
                      </td>
                      <td className="adm-muted-cell">{fmtDt(user.createdAt)}</td>
                      <td>
                        <div className="table-actions">
                          <button className="secondary-button small-action" type="button" onClick={() => handleEdit(user)}>
                            Sửa
                          </button>
                          <button className="danger-button small-action" type="button" onClick={() => handleDelete(user.id)}>
                            Xóa
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <Pagination
              page={safePage}
              totalPages={totalPages}
              totalItems={filtered.length}
              pageSize={pageSize}
              onPageChange={setPage}
              onPageSizeChange={setPageSize}
            />
          </>
        )}
      </section>
    </section>
  )
}

export default AdminUsersPage
