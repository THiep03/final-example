import { useEffect, useMemo, useRef, useState } from 'react'
import { Link } from 'react-router-dom'
import { createCourse, deleteCourse, getCourses, updateCourse } from '../api/courseApi.js'
import { uploadFile } from '../api/fileApi.js'
import Pagination from '../components/Pagination.jsx'
import { CONTENT_STATUS, ROUTES } from '../constants/index.js'

const DEFAULT_PAGE_SIZE = 10

const initialForm = {
  title: '',
  description: '',
  thumbnailUrl: '',
  status: CONTENT_STATUS.DRAFT,
}

const STATUS_OPTIONS = [
  { value: '', label: 'Tất cả trạng thái' },
  { value: CONTENT_STATUS.PUBLISHED, label: 'Đã xuất bản' },
  { value: CONTENT_STATUS.DRAFT, label: 'Bản nháp' },
]

function getStatusLabel(status) {
  return status === CONTENT_STATUS.PUBLISHED ? 'Đã xuất bản' : 'Bản nháp'
}

function getStatusClass(status) {
  return status === CONTENT_STATUS.PUBLISHED ? 'badge-published' : 'badge-draft'
}

function AdminCoursesPage() {
  const [courses, setCourses]         = useState([])
  const [form, setForm]               = useState(initialForm)
  const formRef                        = useRef(null)
  const [editingId, setEditingId]     = useState(null)
  const [selectedImage, setSelectedImage] = useState(null)
  const [loading, setLoading]         = useState(true)
  const [saving, setSaving]           = useState(false)
  const [uploadingImage, setUploadingImage] = useState(false)
  const [error, setError]             = useState('')
  const [success, setSuccess]         = useState('')

  // search + filter
  const [search, setSearch]           = useState('')
  const [filterStatus, setFilterStatus] = useState('')
  const [page, setPage]               = useState(1)
  const [pageSize, setPageSize]       = useState(DEFAULT_PAGE_SIZE)

  const loadCourses = async () => {
    setLoading(true)
    try {
      const data = await getCourses()
      setCourses(data)
      setError('')
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải danh sách khóa học.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    let alive = true
    getCourses()
      .then(data => { if (alive) { setCourses(data); setError('') } })
      .catch(err => { if (alive) setError(err.response?.data?.message || 'Không thể tải danh sách khóa học.') })
      .finally(() => { if (alive) setLoading(false) })
    return () => { alive = false }
  }, [])

  // reset page when filters change
  useEffect(() => { setPage(1) }, [search, filterStatus, pageSize])

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim()
    return courses.filter(c => {
      const matchSearch = !q || c.title?.toLowerCase().includes(q) || String(c.id).includes(q)
      const matchStatus = !filterStatus || c.status === filterStatus
      return matchSearch && matchStatus
    })
  }, [courses, search, filterStatus])

  const totalPages = Math.max(1, Math.ceil(filtered.length / pageSize))
  const safePage   = Math.min(page, totalPages)
  const pageItems  = filtered.slice((safePage - 1) * pageSize, safePage * pageSize)

  const handleChange = (e) => {
    const { name, value } = e.target
    setForm(cur => ({ ...cur, [name]: value }))
  }

  const handleThumbnailUpload = async (e) => {
    const file = e.target.files?.[0]
    setSelectedImage(file || null)
    setError(''); setSuccess('')
    if (!file) return
    setUploadingImage(true)
    try {
      const uploaded = await uploadFile(file, 'image')
      setForm(cur => ({ ...cur, thumbnailUrl: uploaded.fileUrl }))
      setSuccess('Đã tải ảnh đại diện lên hệ thống.')
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải ảnh đại diện.')
    } finally {
      setUploadingImage(false)
    }
  }

  const resetForm = () => {
    setForm(initialForm)
    setEditingId(null)
    setSelectedImage(null)
    setError(''); setSuccess('')
  }

  const handleEdit = (course) => {
    setEditingId(course.id)
    setSelectedImage(null)
    setForm({
      title: course.title || '',
      description: course.description || '',
      thumbnailUrl: course.thumbnailUrl || '',
      status: course.status || 'draft',
    })
    setError(''); setSuccess('')
    formRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError(''); setSuccess('')
    if (!form.title.trim()) { setError('Vui lòng nhập tên khóa học.'); return }
    setSaving(true)
    try {
      if (editingId) {
        await updateCourse(editingId, form)
        setSuccess('Đã cập nhật khóa học thành công.')
      } else {
        await createCourse(form)
        setSuccess('Đã thêm khóa học thành công.')
      }
      resetForm()
      await loadCourses()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể lưu khóa học.')
    } finally {
      setSaving(false)
    }
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Bạn có chắc muốn xóa khóa học này?')) return
    setError(''); setSuccess('')
    try {
      await deleteCourse(id)
      if (editingId === id) resetForm()
      setSuccess('Đã xóa khóa học thành công.')
      await loadCourses()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể xóa khóa học.')
    }
  }

  return (
    <section className="page-shell wide-shell admin-page">

      {/* header */}
      <div className="adm-page-header">
        <div>
          <p className="eyebrow">Quản trị nội dung</p>
          <h1>Quản lý khóa học</h1>
          <p className="muted">Tạo khóa học, quản lý nội dung và xuất bản cho người học.</p>
        </div>
        <div className="adm-header-meta">
          <span className="adm-total-badge">{courses.length} khóa học</span>
        </div>
      </div>

      {error   && <p className="alert">{error}</p>}
      {success && <p className="success-alert">{success}</p>}

      {/* form */}
      <div className="adm-form-card" ref={formRef}>
        <div className="adm-form-card-head">
          <div>
            <p className="eyebrow">{editingId ? 'Chỉnh sửa' : 'Tạo mới'}</p>
            <h2>{editingId ? 'Sửa khóa học' : 'Thêm khóa học'}</h2>
          </div>
          {editingId && (
            <button className="ghost-button" type="button" onClick={resetForm}>✕ Hủy</button>
          )}
        </div>

        <form className="adm-form-body admin-form" onSubmit={handleSubmit}>
          <label>
            Tên khóa học <span className="field-required">*</span>
            <input name="title" value={form.title} onChange={handleChange} placeholder="Nhập tên khóa học..." required />
          </label>
          <label className="file-picker">
            Ảnh đại diện
            <input accept="image/*" type="file" onChange={handleThumbnailUpload} />
            <span>
              {uploadingImage ? 'Đang tải ảnh...' : selectedImage ? selectedImage.name : form.thumbnailUrl ? 'Đã có ảnh – nhấn để đổi' : 'Chưa chọn ảnh'}
            </span>
          </label>
          <label>
            Trạng thái
            <select name="status" value={form.status} onChange={handleChange}>
              <option value="draft">Bản nháp</option>
              <option value="published">Đã xuất bản</option>
            </select>
          </label>
          <label className="full-field">
            Mô tả
            <textarea name="description" value={form.description} onChange={handleChange} rows="3" placeholder="Mô tả ngắn về nội dung khóa học..." />
          </label>
          <div className="admin-form-actions full-field">
            <button className="primary-button" type="submit" disabled={saving || uploadingImage}>
              {saving ? 'Đang lưu...' : editingId ? 'Cập nhật khóa học' : 'Thêm khóa học'}
            </button>
            {editingId && (
              <button className="secondary-button" type="button" onClick={resetForm}>Hủy thay đổi</button>
            )}
          </div>
        </form>
      </div>

      {/* table panel */}
      <section className="admin-table-panel">
        <div className="adm-table-header">
          <div>
            <h2>Danh sách khóa học</h2>
            <p className="muted">Tổng cộng <strong>{filtered.length}</strong> kết quả.</p>
          </div>
          <div className="adm-table-filters">
            <div className="adm-search-box">
              <span className="adm-search-icon">🔍</span>
              <input
                className="adm-search-input"
                placeholder="Tìm theo tên hoặc ID..."
                value={search}
                onChange={e => setSearch(e.target.value)}
              />
              {search && (
                <button className="adm-search-clear" onClick={() => setSearch('')} type="button">✕</button>
              )}
            </div>
            <select className="adm-filter-select" value={filterStatus} onChange={e => setFilterStatus(e.target.value)}>
              {STATUS_OPTIONS.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
          </div>
        </div>

        {loading ? (
          <p className="state-message">Đang tải khóa học...</p>
        ) : filtered.length === 0 ? (
          <p className="state-message">{search || filterStatus ? 'Không tìm thấy kết quả phù hợp.' : 'Chưa có dữ liệu khóa học.'}</p>
        ) : (
          <>
            <div className="table-scroll">
              <table className="admin-table">
                <thead>
                  <tr>
                    <th className="col-id">ID</th>
                    <th>Tên khóa học</th>
                    <th>Trạng thái</th>
                    <th>Mô tả</th>
                    <th>Thao tác</th>
                  </tr>
                </thead>
                <tbody>
                  {pageItems.map((course) => (
                    <tr key={course.id}>
                      <td className="col-id adm-id-cell">#{course.id}</td>
                      <td className="adm-name-cell">{course.title}</td>
                      <td>
                        <span className={`adm-status-badge ${getStatusClass(course.status)}`}>
                          {getStatusLabel(course.status)}
                        </span>
                      </td>
                      <td className="adm-desc-cell">{course.description || '—'}</td>
                      <td>
                        <div className="table-actions">
                          <button className="secondary-button small-action" type="button" onClick={() => handleEdit(course)}>
                            Sửa
                          </button>
                          <button className="danger-button small-action" type="button" onClick={() => handleDelete(course.id)}>
                            Xóa
                          </button>
                          <Link className="ghost-button small-action" to={ROUTES.adminCourseContent(course.id)}>
                            Nội dung
                          </Link>
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

export default AdminCoursesPage
