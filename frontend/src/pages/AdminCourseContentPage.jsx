import { useEffect, useMemo, useRef, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { getCourseById } from '../api/courseApi.js'
import { uploadFile } from '../api/fileApi.js'
import { createLesson, deleteLesson, getLessons, updateLesson } from '../api/lessonApi.js'
import Pagination from '../components/Pagination.jsx'
import { ROUTES } from '../constants/index.js'

const initialLessonForm = {
  title: '',
  description: '',
  duration: '',
  orderNumber: '',
  videoFileId: '',
  videoUrl: '',
}

function AdminCourseContentPage() {
  const { courseId } = useParams()
  const formRef = useRef(null)
  const [course, setCourse]                 = useState(null)
  const [lessons, setLessons]               = useState([])
  const [form, setForm]                     = useState(initialLessonForm)
  const [editingLessonId, setEditingLessonId] = useState(null)
  const [selectedFile, setSelectedFile]     = useState(null)
  const [uploadedVideo, setUploadedVideo]   = useState(null)
  const [loading, setLoading]               = useState(true)
  const [saving, setSaving]                 = useState(false)
  const [uploadingVideo, setUploadingVideo] = useState(false)
  const [error, setError]                   = useState('')
  const [success, setSuccess]               = useState('')

  // search + pagination
  const [search, setSearch]     = useState('')
  const [page, setPage]         = useState(1)
  const [pageSize, setPageSize] = useState(10)

  const loadContent = async () => {
    setLoading(true)
    try {
      const [courseData, lessonData] = await Promise.all([getCourseById(courseId), getLessons()])
      const courseLessons = lessonData
        .filter(l => Number(l.courseId) === Number(courseId))
        .sort((a, b) => (a.orderNumber || 0) - (b.orderNumber || 0))
      setCourse(courseData)
      setLessons(courseLessons)
      setError('')
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải nội dung khóa học.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    let alive = true
    Promise.all([getCourseById(courseId), getLessons()])
      .then(([courseData, lessonData]) => {
        if (!alive) return
        const courseLessons = lessonData
          .filter(l => Number(l.courseId) === Number(courseId))
          .sort((a, b) => (a.orderNumber || 0) - (b.orderNumber || 0))
        setCourse(courseData)
        setLessons(courseLessons)
        setError('')
      })
      .catch(err => { if (alive) setError(err.response?.data?.message || 'Không thể tải nội dung khóa học.') })
      .finally(() => { if (alive) setLoading(false) })
    return () => { alive = false }
  }, [courseId])

  useEffect(() => { setPage(1) }, [search, pageSize])

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim()
    return !q ? lessons : lessons.filter(l => l.title?.toLowerCase().includes(q) || String(l.id).includes(q))
  }, [lessons, search])

  const totalPages = Math.max(1, Math.ceil(filtered.length / pageSize))
  const safePage   = Math.min(page, totalPages)
  const pageItems  = filtered.slice((safePage - 1) * pageSize, safePage * pageSize)

  const handleChange = (e) => {
    const { name, value } = e.target
    setForm(cur => ({ ...cur, [name]: value }))
  }

  const resetLessonForm = () => {
    setForm(initialLessonForm)
    setEditingLessonId(null)
    setSelectedFile(null)
    setUploadedVideo(null)
    setError(''); setSuccess('')
  }

  const handleFileChange = async (e) => {
    const file = e.target.files?.[0]
    setSelectedFile(file || null)
    setUploadedVideo(null)
    setError(''); setSuccess('')
    if (!file) return
    setUploadingVideo(true)
    try {
      const uploaded = await uploadFile(file, 'video')
      setUploadedVideo(uploaded)
      setSuccess('Đã tải video bài học lên hệ thống.')
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải video bài học.')
    } finally {
      setUploadingVideo(false)
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError(''); setSuccess('')
    if (!form.title.trim()) { setError('Vui lòng nhập tên bài học.'); return }
    if (!editingLessonId && !uploadedVideo?.fileUrl) { setError('Vui lòng tải video bài học.'); return }
    setSaving(true)
    try {
      const payload = {
        courseId:    Number(courseId),
        videoFileId: uploadedVideo?.id || (form.videoFileId ? Number(form.videoFileId) : null),
        title:       form.title,
        description: form.description,
        videoUrl:    uploadedVideo?.fileUrl || form.videoUrl,
        duration:    form.duration    ? Number(form.duration)    : null,
        orderNumber: form.orderNumber ? Number(form.orderNumber) : null,
      }
      if (editingLessonId) {
        await updateLesson(editingLessonId, payload)
        setSuccess('Đã cập nhật bài học thành công.')
      } else {
        await createLesson(payload)
        setSuccess('Đã thêm bài học vào khóa học.')
      }
      resetLessonForm()
      await loadContent()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể lưu bài học.')
    } finally {
      setSaving(false)
    }
  }

  const handleEditLesson = (lesson) => {
    setEditingLessonId(lesson.id)
    setSelectedFile(null)
    setUploadedVideo(null)
    setForm({
      title:       lesson.title       || '',
      description: lesson.description || '',
      duration:    lesson.duration    || '',
      orderNumber: lesson.orderNumber || '',
      videoFileId: lesson.videoFileId || '',
      videoUrl:    lesson.videoUrl    || '',
    })
    setError(''); setSuccess('')
    formRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }

  const handleDeleteLesson = async (lessonId) => {
    if (!window.confirm('Bạn có chắc muốn xóa bài học này?')) return
    setError(''); setSuccess('')
    try {
      await deleteLesson(lessonId)
      if (editingLessonId === lessonId) resetLessonForm()
      setSuccess('Đã xóa bài học thành công.')
      await loadContent()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể xóa bài học.')
    }
  }

  return (
    <section className="page-shell wide-shell admin-page">
      <Link className="text-link" to={ROUTES.ADMIN_COURSES}>← Quay lại quản lý khóa học</Link>

      {loading ? (
        <p className="state-message">Đang tải nội dung khóa học...</p>
      ) : (
        <>
          {/* course hero */}
          <div className="adm-course-hero">
            <div className="adm-course-hero-left">
              <p className="eyebrow">Quản lý nội dung khóa học</p>
              <h1>{course?.title || 'Khóa học chưa đặt tên'}</h1>
              <p className="adm-course-hero-desc">{course?.description || 'Chưa có mô tả.'}</p>
              <div className="adm-course-hero-meta">
                <span className={`adm-status-badge ${course?.status === 'published' ? 'badge-published' : 'badge-draft'}`}>
                  {course?.status === 'published' ? 'Đã xuất bản' : 'Bản nháp'}
                </span>
                <span className="adm-course-hero-count">{lessons.length} bài học</span>
              </div>
            </div>
          </div>

          {error   && <p className="alert">{error}</p>}
          {success && <p className="success-alert">{success}</p>}

          {/* form */}
          <div className="adm-form-card" ref={formRef}>
            <div className="adm-form-card-head">
              <div>
                <p className="eyebrow">{editingLessonId ? 'Chỉnh sửa' : 'Tạo mới'}</p>
                <h2>{editingLessonId ? 'Sửa bài học' : 'Thêm bài học vào khóa học'}</h2>
              </div>
              {editingLessonId && (
                <button className="ghost-button" type="button" onClick={resetLessonForm}>✕ Hủy</button>
              )}
            </div>
            <form className="adm-form-body admin-form content-form" onSubmit={handleSubmit}>
              <label>
                Tên bài học <span className="field-required">*</span>
                <input name="title" value={form.title} onChange={handleChange} placeholder="Nhập tên bài học..." required />
              </label>
              <label>
                Thời lượng (phút)
                <input min="0" name="duration" type="number" value={form.duration} onChange={handleChange} placeholder="0" />
              </label>
              <label>
                Thứ tự
                <input min="0" name="orderNumber" type="number" value={form.orderNumber} onChange={handleChange} placeholder="0" />
              </label>
              <label className="full-field">
                Mô tả
                <textarea name="description" value={form.description} onChange={handleChange} rows="3" placeholder="Mô tả nội dung bài học..." />
              </label>
              <label className="file-picker full-field">
                Tải video bài học <span className="field-required">*</span>
                <input accept="video/*" type="file" onChange={handleFileChange} />
                <span>
                  {uploadingVideo ? 'Đang tải video...' : selectedFile ? selectedFile.name : (uploadedVideo?.fileUrl || form.videoUrl) ? 'Đã có video – nhấn để đổi' : 'Chưa chọn video'}
                </span>
              </label>
              <div className="admin-form-actions full-field">
                <button className="primary-button" type="submit" disabled={saving || uploadingVideo}>
                  {saving ? 'Đang lưu...' : editingLessonId ? 'Cập nhật bài học' : 'Thêm bài học'}
                </button>
                {editingLessonId && (
                  <button className="secondary-button" type="button" onClick={resetLessonForm}>Hủy thay đổi</button>
                )}
              </div>
            </form>
          </div>

          {/* lesson list */}
          <section className="admin-table-panel">
            <div className="adm-table-header">
              <div>
                <h2>Bài học trong khóa học</h2>
                <p className="muted">Tổng cộng <strong>{filtered.length}</strong> bài học.</p>
              </div>
              <div className="adm-table-filters">
                <div className="adm-search-box">
                  <span className="adm-search-icon">🔍</span>
                  <input
                    className="adm-search-input"
                    placeholder="Tìm theo tên bài học..."
                    value={search}
                    onChange={e => setSearch(e.target.value)}
                  />
                  {search && <button className="adm-search-clear" type="button" onClick={() => setSearch('')}>✕</button>}
                </div>
              </div>
            </div>

            {filtered.length === 0 ? (
              <p className="state-message">{search ? 'Không tìm thấy bài học phù hợp.' : 'Khóa học này chưa có bài học nào.'}</p>
            ) : (
              <>
                <div className="adm-lesson-card-list">
                  {pageItems.map((lesson) => (
                    <article className="adm-lesson-row" key={lesson.id}>
                      <div className="adm-lesson-order">
                        <span>{lesson.orderNumber || '—'}</span>
                      </div>
                      <div className="adm-lesson-info">
                        <h3>{lesson.title || 'Bài học chưa đặt tên'}</h3>
                        <p className="adm-lesson-desc">{lesson.description || 'Chưa có mô tả.'}</p>
                        <div className="adm-lesson-chips">
                          <span>{lesson.duration ? `${lesson.duration} phút` : 'Chưa có thời lượng'}</span>
                          {lesson.videoFileId || lesson.videoUrl
                            ? <span className="chip-has-video adm-video-chip">Đã có video</span>
                            : <span className="chip-no-video adm-video-chip">Chưa có video</span>
                          }
                        </div>
                      </div>
                      <div className="adm-lesson-actions">
                        <Link className="primary-button compact-button" to={ROUTES.adminLessonQuestions(lesson.id)}>
                          Câu hỏi
                        </Link>
                        <button className="secondary-button compact-button" type="button" onClick={() => handleEditLesson(lesson)}>
                          Sửa
                        </button>
                        <button className="danger-button compact-button" type="button" onClick={() => handleDeleteLesson(lesson.id)}>
                          Xóa
                        </button>
                        <Link className="ghost-button compact-button" to={`/lessons/${lesson.id}`}>
                          Xem
                        </Link>
                      </div>
                    </article>
                  ))}
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
        </>
      )}
    </section>
  )
}

export default AdminCourseContentPage
