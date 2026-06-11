import { useEffect, useRef, useState } from 'react'
import { Link } from 'react-router-dom'
import { createCourse, deleteCourse, getCourses, updateCourse } from '../api/courseApi.js'
import { uploadFile } from '../api/fileApi.js'

const initialForm = {
  title: '',
  description: '',
  thumbnailUrl: '',
  status: 'draft',
}

function getStatusLabel(status) {
  return status === 'published' ? 'Đã xuất bản' : 'Bản nháp'
}

function AdminCoursesPage() {
  const [courses, setCourses] = useState([])
  const [form, setForm] = useState(initialForm)
  const formRef = useRef(null)
  const [editingId, setEditingId] = useState(null)
  const [selectedImage, setSelectedImage] = useState(null)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [uploadingImage, setUploadingImage] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

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
    let isMounted = true

    const loadInitialCourses = async () => {
      try {
        const data = await getCourses()
        if (isMounted) {
          setCourses(data)
          setError('')
        }
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || 'Không thể tải danh sách khóa học.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadInitialCourses()

    return () => {
      isMounted = false
    }
  }, [])

  const handleChange = (event) => {
    const { name, value } = event.target
    setForm((current) => ({ ...current, [name]: value }))
  }

  const handleThumbnailUpload = async (event) => {
    const file = event.target.files?.[0]
    setSelectedImage(file || null)
    setError('')
    setSuccess('')

    if (!file) {
      return
    }

    setUploadingImage(true)
    try {
      const uploadedFile = await uploadFile(file, 'image')
      setForm((current) => ({ ...current, thumbnailUrl: uploadedFile.fileUrl }))
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
    setError('')
    setSuccess('')
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setError('')
    setSuccess('')

    if (!form.title.trim()) {
      setError('Vui lòng nhập tên khóa học.')
      return
    }

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
    if (!window.confirm('Bạn có chắc muốn xóa khóa học này?')) {
      return
    }

    setError('')
    setSuccess('')
    try {
      await deleteCourse(id)
      if (editingId === id) {
        resetForm()
      }
      setSuccess('Đã xóa khóa học thành công.')
      await loadCourses()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể xóa khóa học.')
    }
  }

  return (
    <section className="page-shell wide-shell admin-page">
      <div className="section-heading">
        <div>
          <p className="eyebrow">Quản trị nội dung</p>
          <h1>Quản lý khóa học</h1>
        </div>
        <p className="muted">Tạo khóa học mới, sau đó mở luồng quản lý nội dung để thêm bài học và câu hỏi.</p>
      </div>

      {error && <p className="alert">{error}</p>}
      {success && <p className="success-alert">{success}</p>}

      <form className="admin-form" ref={formRef} onSubmit={handleSubmit}>
        <div className="full-field">
          <h2>{editingId ? 'Sửa khóa học' : 'Thêm khóa học'}</h2>
          <p className="muted">Ảnh đại diện chỉ được tải từ máy, hệ thống sẽ tự lưu file và gắn vào khóa học.</p>
        </div>
        <label>
          Tên khóa học
          <input name="title" value={form.title} onChange={handleChange} required />
        </label>
        <label className="file-picker">
          Tải ảnh đại diện
          <input accept="image/*" type="file" onChange={handleThumbnailUpload} />
          <span>
            {uploadingImage
              ? 'Đang tải ảnh lên...'
              : selectedImage
                ? selectedImage.name
                : form.thumbnailUrl
                  ? 'Đã có ảnh đại diện'
                  : 'Chưa chọn ảnh'}
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
          <textarea
            name="description"
            value={form.description}
            onChange={handleChange}
            rows="3"
            placeholder="Mô tả ngắn về nội dung khóa học"
          />
        </label>
        <button className="primary-button" type="submit" disabled={saving || uploadingImage}>
          {saving ? 'Đang lưu...' : editingId ? 'Cập nhật khóa học' : 'Thêm khóa học'}
        </button>
        {editingId && (
          <button className="secondary-button" type="button" onClick={resetForm}>
            Hủy
          </button>
        )}
      </form>

      <section className="admin-table-panel">
        <div>
          <h2>Danh sách khóa học</h2>
          <p className="muted">Tạo, chỉnh sửa, xóa khóa học và mở nhanh trang quản lý nội dung.</p>
        </div>
        {loading ? (
          <p className="state-message">Đang tải khóa học...</p>
        ) : courses.length === 0 ? (
          <p className="state-message">Chưa có dữ liệu khóa học.</p>
        ) : (
          <div className="table-scroll">
            <table className="admin-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Tên khóa học</th>
                  <th>Trạng thái</th>
                  <th>Mô tả</th>
                  <th>Thao tác</th>
                </tr>
              </thead>
              <tbody>
                {courses.map((course) => (
                  <tr key={course.id}>
                    <td>{course.id}</td>
                    <td>{course.title}</td>
                    <td>{getStatusLabel(course.status)}</td>
                    <td>{course.description || '-'}</td>
                    <td>
                      <div className="table-actions">
                        <button className="secondary-button small-action" type="button" onClick={() => handleEdit(course)}>
                          Sửa
                        </button>
                        <button className="danger-button small-action" type="button" onClick={() => handleDelete(course.id)}>
                          Xóa
                        </button>
                        <Link className="ghost-button small-action" to={`/admin/courses/${course.id}/content`}>
                          Quản lý nội dung
                        </Link>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </section>
  )
}

export default AdminCoursesPage
