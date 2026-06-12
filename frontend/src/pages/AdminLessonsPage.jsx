import { useEffect, useMemo, useRef, useState } from 'react'
import { Link } from 'react-router-dom'
import { getCourses } from '../api/courseApi.js'
import { uploadFile } from '../api/fileApi.js'
import { createLesson, deleteLesson, getLessons, updateLesson } from '../api/lessonApi.js'
import Pagination from '../components/Pagination.jsx'
import { ROUTES } from '../constants/index.js'

const DEFAULT_PAGE_SIZE = 10

const initialForm = {
  courseId: '',
  videoFileId: '',
  title: '',
  description: '',
  videoUrl: '',
  duration: '',
  orderNumber: '',
}

function AdminLessonsPage() {
  const [lessons, setLessons]   = useState([])
  const [courses, setCourses]   = useState([])
  const [form, setForm]         = useState(initialForm)
  const [editingId, setEditingId] = useState(null)
  const [videoMode, setVideoMode] = useState('youtube')
  const [selectedVideo, setSelectedVideo] = useState(null)
  const [uploadedVideo, setUploadedVideo] = useState(null)
  const [loading, setLoading]   = useState(true)
  const [saving, setSaving]     = useState(false)
  const [uploadingVideo, setUploadingVideo] = useState(false)
  const [error, setError]       = useState('')
  const [success, setSuccess]   = useState('')

  const formRef = useRef(null)

  // search + filter
  const [search, setSearch]           = useState('')
  const [filterCourse, setFilterCourse] = useState('')
  const [page, setPage]               = useState(1)
  const [pageSize, setPageSize]       = useState(DEFAULT_PAGE_SIZE)

  const courseNameById = useMemo(
    () => new Map(courses.map(c => [Number(c.id), c.title])),
    [courses],
  )

  const loadData = async () => {
    setLoading(true)
    try {
      const [lData, cData] = await Promise.all([getLessons(), getCourses()])
      setLessons(lData)
      setCourses(cData)
      setError('')
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải danh sách bài học.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    let alive = true
    Promise.all([getLessons(), getCourses()])
      .then(([lData, cData]) => { if (alive) { setLessons(lData); setCourses(cData); setError('') } })
      .catch(err => { if (alive) setError(err.response?.data?.message || 'Không thể tải dữ liệu.') })
      .finally(() => { if (alive) setLoading(false) })
    return () => { alive = false }
  }, [])

  useEffect(() => { setPage(1) }, [search, filterCourse, pageSize])

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim()
    return lessons.filter(l => {
      const matchSearch  = !q || l.title?.toLowerCase().includes(q) || String(l.id).includes(q)
      const matchCourse  = !filterCourse || String(l.courseId) === filterCourse
      return matchSearch && matchCourse
    })
  }, [lessons, search, filterCourse])

  const totalPages = Math.max(1, Math.ceil(filtered.length / pageSize))
  const safePage   = Math.min(page, totalPages)
  const pageItems  = filtered.slice((safePage - 1) * pageSize, safePage * pageSize)

  const handleChange = (e) => {
    const { name, value } = e.target
    setForm(cur => ({ ...cur, [name]: value }))
  }

  const handleVideoUpload = async (e) => {
    const file = e.target.files?.[0]
    setSelectedVideo(file || null)
    setUploadedVideo(null)
    setError(''); setSuccess('')
    if (!file) return
    setUploadingVideo(true)
    try {
      const uploaded = await uploadFile(file, 'video')
      setUploadedVideo(uploaded)
      setForm(cur => ({ ...cur, videoFileId: uploaded.id || '', videoUrl: uploaded.fileUrl || '' }))
      setSuccess('Đã tải video lên hệ thống.')
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải video.')
    } finally {
      setUploadingVideo(false)
    }
  }

  const resetForm = () => {
    setForm(initialForm)
    setEditingId(null)
    setSelectedVideo(null)
    setUploadedVideo(null)
    setVideoMode('youtube')
    setError(''); setSuccess('')
  }

  const handleEdit = (lesson) => {
    setEditingId(lesson.id)
    setSelectedVideo(null)
    setUploadedVideo(null)
    const isYoutube = lesson.videoUrl && (lesson.videoUrl.includes('youtube.com') || lesson.videoUrl.includes('youtu.be'))
    setVideoMode(lesson.videoFileId ? 'upload' : isYoutube ? 'youtube' : 'youtube')
    setForm({
      courseId:    lesson.courseId    || '',
      videoFileId: lesson.videoFileId || '',
      title:       lesson.title       || '',
      description: lesson.description || '',
      videoUrl:    lesson.videoUrl    || '',
      duration:    lesson.duration    || '',
      orderNumber: lesson.orderNumber || '',
    })
    setError(''); setSuccess('')
    formRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError(''); setSuccess('')
    if (!form.title.trim()) { setError('Vui lòng nhập tên bài học.'); return }
    if (!editingId) {
      if (videoMode === 'youtube' && !form.videoUrl.trim()) { setError('Vui lòng nhập link YouTube.'); return }
      if (videoMode === 'upload' && !uploadedVideo?.fileUrl) { setError('Vui lòng tải video bài học.'); return }
    }

    setSaving(true)
    try {
      const videoFileId = videoMode === 'upload' ? (uploadedVideo?.id || (form.videoFileId ? Number(form.videoFileId) : null)) : null
      const videoUrl    = videoMode === 'youtube' ? form.videoUrl.trim() : (uploadedVideo?.fileUrl || form.videoUrl)
      const payload = {
        ...form,
        courseId:    form.courseId    ? Number(form.courseId)    : null,
        videoFileId,
        videoUrl,
        duration:    form.duration    ? Number(form.duration)    : null,
        orderNumber: form.orderNumber ? Number(form.orderNumber) : null,
      }
      if (editingId) {
        await updateLesson(editingId, payload)
        setSuccess('Đã cập nhật bài học thành công.')
      } else {
        await createLesson(payload)
        setSuccess('Đã thêm bài học thành công.')
      }
      resetForm()
      await loadData()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể lưu bài học.')
    } finally {
      setSaving(false)
    }
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Bạn có chắc muốn xóa bài học này?')) return
    setError(''); setSuccess('')
    try {
      await deleteLesson(id)
      if (editingId === id) resetForm()
      setSuccess('Đã xóa bài học thành công.')
      await loadData()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể xóa bài học.')
    }
  }

  return (
    <section className="page-shell wide-shell admin-page">

      <div className="adm-page-header">
        <div>
          <p className="eyebrow">Quản trị nội dung</p>
          <h1>Quản lý bài học</h1>
          <p className="muted">Xem toàn bộ bài học và mở nhanh trang quản lý câu hỏi theo từng bài.</p>
        </div>
        <div className="adm-header-meta">
          <span className="adm-total-badge">{lessons.length} bài học</span>
        </div>
      </div>

      {error   && <p className="alert">{error}</p>}
      {success && <p className="success-alert">{success}</p>}

      {/* form */}
      <div className="adm-form-card" ref={formRef}>
        <form className="lesson-admin-form" onSubmit={handleSubmit} style={{ border: 'none', boxShadow: 'none' }}>
          <div className="lesson-form-header">
            <div>
              <p className="eyebrow">{editingId ? 'Chỉnh sửa' : 'Tạo mới'}</p>
              <h2>{editingId ? 'Sửa bài học' : 'Thêm bài học'}</h2>
            </div>
            {editingId && (
              <button className="ghost-button" type="button" onClick={resetForm}>✕ Hủy</button>
            )}
          </div>

          <div className="lesson-form-body">
            <div className="lesson-form-section">
              <p className="lesson-form-section-label">Thông tin chung</p>
              <div className="lesson-form-row">
                <label className="lesson-form-field span-2">
                  Tên bài học <span className="field-required">*</span>
                  <input name="title" value={form.title} onChange={handleChange} placeholder="Nhập tên bài học..." required />
                </label>
                <label className="lesson-form-field">
                  Khóa học
                  <select name="courseId" value={form.courseId} onChange={handleChange}>
                    <option value="">Chưa chọn</option>
                    {courses.map(c => <option key={c.id} value={c.id}>{c.title}</option>)}
                  </select>
                </label>
              </div>
              <div className="lesson-form-row">
                <label className="lesson-form-field">
                  Thời lượng (phút)
                  <input min="0" name="duration" type="number" value={form.duration} onChange={handleChange} placeholder="0" />
                </label>
                <label className="lesson-form-field">
                  Thứ tự bài
                  <input min="0" name="orderNumber" type="number" value={form.orderNumber} onChange={handleChange} placeholder="0" />
                </label>
                <label className="lesson-form-field span-1" />
              </div>
              <label className="lesson-form-field">
                Mô tả
                <textarea name="description" value={form.description} onChange={handleChange} rows="3" placeholder="Mô tả nội dung bài học..." />
              </label>
            </div>

            <div className="lesson-form-section">
              <p className="lesson-form-section-label">Nguồn video</p>
              <div className="video-source-tabs">
                <button className={`video-source-tab${videoMode === 'youtube' ? ' active' : ''}`} type="button" onClick={() => setVideoMode('youtube')}>
                  <span className="tab-icon">▶</span> YouTube
                </button>
                <button className={`video-source-tab${videoMode === 'upload' ? ' active' : ''}`} type="button" onClick={() => setVideoMode('upload')}>
                  <span className="tab-icon">↑</span> Tải file lên
                </button>
              </div>
              {videoMode === 'youtube' ? (
                <div className="youtube-input-wrap">
                  <span className="youtube-icon">▶</span>
                  <input className="youtube-url-input" name="videoUrl" type="url" placeholder="https://www.youtube.com/watch?v=..." value={form.videoUrl} onChange={handleChange} />
                </div>
              ) : (
                <label className="upload-drop-zone">
                  <input accept="video/*" type="file" onChange={handleVideoUpload} />
                  <span className="upload-drop-icon">↑</span>
                  <span className="upload-drop-text">
                    {uploadingVideo ? 'Đang tải lên...' : selectedVideo ? selectedVideo.name : form.videoUrl ? 'Đã có video – nhấn để đổi' : 'Kéo thả hoặc nhấn để chọn file video'}
                  </span>
                  <span className="upload-drop-hint">MP4, MOV, AVI · tối đa 500 MB</span>
                </label>
              )}
            </div>
          </div>

          <div className="lesson-form-footer">
            <button className="primary-button" type="submit" disabled={saving || uploadingVideo}>
              {saving ? 'Đang lưu...' : editingId ? 'Cập nhật bài học' : 'Thêm bài học'}
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
            <h2>Danh sách bài học</h2>
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
            <select className="adm-filter-select" value={filterCourse} onChange={e => setFilterCourse(e.target.value)}>
              <option value="">Tất cả khóa học</option>
              {courses.map(c => <option key={c.id} value={String(c.id)}>{c.title}</option>)}
            </select>
          </div>
        </div>

        {loading ? (
          <p className="state-message">Đang tải bài học...</p>
        ) : filtered.length === 0 ? (
          <p className="state-message">{search || filterCourse ? 'Không tìm thấy kết quả phù hợp.' : 'Chưa có dữ liệu bài học.'}</p>
        ) : (
          <>
            <div className="table-scroll">
              <table className="admin-table">
                <thead>
                  <tr>
                    <th className="col-id">ID</th>
                    <th>Khóa học</th>
                    <th>Tên bài học</th>
                    <th>Video</th>
                    <th>Thời lượng</th>
                    <th>Thứ tự</th>
                    <th>Thao tác</th>
                  </tr>
                </thead>
                <tbody>
                  {pageItems.map((lesson) => (
                    <tr key={lesson.id}>
                      <td className="col-id adm-id-cell">#{lesson.id}</td>
                      <td className="adm-muted-cell">{courseNameById.get(Number(lesson.courseId)) || '—'}</td>
                      <td className="adm-name-cell">{lesson.title || '—'}</td>
                      <td>
                        {lesson.videoFileId || lesson.videoUrl ? (
                          <span className="adm-video-chip chip-has-video">Đã có video</span>
                        ) : (
                          <span className="adm-video-chip chip-no-video">Chưa có video</span>
                        )}
                      </td>
                      <td className="adm-muted-cell">{lesson.duration ? `${lesson.duration} phút` : '—'}</td>
                      <td className="adm-muted-cell">{lesson.orderNumber || '—'}</td>
                      <td>
                        <div className="table-actions">
                          <button className="secondary-button small-action" type="button" onClick={() => handleEdit(lesson)}>
                            Sửa
                          </button>
                          <button className="danger-button small-action" type="button" onClick={() => handleDelete(lesson.id)}>
                            Xóa
                          </button>
                          <Link className="ghost-button small-action" to={ROUTES.adminLessonQuestions(lesson.id)}>
                            Câu hỏi
                          </Link>
                          <Link className="ghost-button small-action" to={`/lessons/${lesson.id}`}>
                            Xem
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

export default AdminLessonsPage
