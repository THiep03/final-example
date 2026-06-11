import { useEffect, useMemo, useRef, useState } from 'react'
import { Link } from 'react-router-dom'
import { getCourses } from '../api/courseApi.js'
import { uploadFile } from '../api/fileApi.js'
import { createLesson, deleteLesson, getLessons, updateLesson } from '../api/lessonApi.js'
import { ROUTES } from '../constants/index.js'

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
  const [lessons, setLessons] = useState([])
  const [courses, setCourses] = useState([])
  const [form, setForm] = useState(initialForm)
  const [editingId, setEditingId] = useState(null)
  const [selectedVideo, setSelectedVideo] = useState(null)
  const [uploadedVideo, setUploadedVideo] = useState(null)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [uploadingVideo, setUploadingVideo] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  const formRef = useRef(null)
  const courseNameById = useMemo(
    () => new Map(courses.map((course) => [Number(course.id), course.title])),
    [courses],
  )
  const loadData = async () => {
    setLoading(true)
    try {
      const [lessonData, courseData] = await Promise.all([
        getLessons(),
        getCourses(),
      ])
      setLessons(lessonData)
      setCourses(courseData)
      setError('')
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải danh sách bài học.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    let isMounted = true

    const loadInitialData = async () => {
      try {
        const [lessonData, courseData] = await Promise.all([
          getLessons(),
          getCourses(),
        ])
        if (isMounted) {
          setLessons(lessonData)
          setCourses(courseData)
          setError('')
        }
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || 'Không thể tải danh sách bài học.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadInitialData()

    return () => {
      isMounted = false
    }
  }, [])

  const handleChange = (event) => {
    const { name, value } = event.target
    setForm((current) => ({ ...current, [name]: value }))
  }

  const handleVideoUpload = async (event) => {
    const file = event.target.files?.[0]
    setSelectedVideo(file || null)
    setUploadedVideo(null)
    setError('')
    setSuccess('')

    if (!file) {
      return
    }

    setUploadingVideo(true)
    try {
      const uploadedFile = await uploadFile(file, 'video')
      setUploadedVideo(uploadedFile)
      setForm((current) => ({
        ...current,
        videoFileId: uploadedFile.id || '',
        videoUrl: uploadedFile.fileUrl || '',
      }))
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
  }

  const handleEdit = (lesson) => {
    setEditingId(lesson.id)
    setSelectedVideo(null)
    setUploadedVideo(null)
    setForm({
      courseId: lesson.courseId || '',
      videoFileId: lesson.videoFileId || '',
      title: lesson.title || '',
      description: lesson.description || '',
      videoUrl: lesson.videoUrl || '',
      duration: lesson.duration || '',
      orderNumber: lesson.orderNumber || '',
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
      setError('Vui lòng nhập tên bài học.')
      return
    }

    if (!editingId && !form.videoUrl && !uploadedVideo?.fileUrl) {
      setError('Vui lòng tải video bài học.')
      return
    }

    setSaving(true)
    try {
      const videoFileId = uploadedVideo?.id || (form.videoFileId ? Number(form.videoFileId) : null)
      const videoUrl = uploadedVideo?.fileUrl || form.videoUrl

      const payload = {
        ...form,
        courseId: form.courseId ? Number(form.courseId) : null,
        videoFileId,
        videoUrl,
        duration: form.duration ? Number(form.duration) : null,
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
    if (!window.confirm('Bạn có chắc muốn xóa bài học này?')) {
      return
    }

    setError('')
    setSuccess('')
    try {
      await deleteLesson(id)
      if (editingId === id) {
        resetForm()
      }
      setSuccess('Đã xóa bài học thành công.')
      await loadData()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể xóa bài học.')
    }
  }

  return (
    <section className="page-shell wide-shell admin-page">
      <div className="section-heading">
        <div>
          <p className="eyebrow">Quản trị nội dung</p>
          <h1>Quản lý bài học</h1>
        </div>
        <p className="muted">Xem toàn bộ bài học và mở nhanh trang quản lý câu hỏi theo từng bài.</p>
      </div>

      {error && <p className="alert">{error}</p>}
      {success && <p className="success-alert">{success}</p>}

      <form className="admin-form" ref={formRef} onSubmit={handleSubmit}>
        <div className="full-field">
          <h2>{editingId ? 'Sửa bài học' : 'Thêm bài học'}</h2>
          <p className="muted">Video bài học chỉ được tải từ máy, hệ thống sẽ tự lưu file và gắn vào bài học.</p>
        </div>
        <label>
          Khóa học
          <select name="courseId" value={form.courseId} onChange={handleChange}>
            <option value="">Chưa chọn khóa học</option>
            {courses.map((course) => (
              <option key={course.id} value={course.id}>
                {course.title}
              </option>
            ))}
          </select>
        </label>
        <label className="file-picker">
          Tải video bài học
          <input accept="video/*" type="file" onChange={handleVideoUpload} />
          <span>
            {uploadingVideo
              ? 'Đang tải video lên...'
              : selectedVideo
                ? selectedVideo.name
                : form.videoUrl
                  ? 'Đã có video bài học'
                  : 'Chưa chọn video'}
          </span>
        </label>
        <label>
          Tên bài học
          <input name="title" value={form.title} onChange={handleChange} required />
        </label>
        <label>
          Thời lượng phút
          <input min="0" name="duration" type="number" value={form.duration} onChange={handleChange} />
        </label>
        <label>
          Thứ tự
          <input min="0" name="orderNumber" type="number" value={form.orderNumber} onChange={handleChange} />
        </label>
        <label className="full-field">
          Mô tả
          <textarea name="description" value={form.description} onChange={handleChange} rows="3" />
        </label>
        <button className="primary-button" type="submit" disabled={saving || uploadingVideo}>
          {saving ? 'Đang lưu...' : editingId ? 'Cập nhật bài học' : 'Thêm bài học'}
        </button>
        {editingId && (
          <button className="secondary-button" type="button" onClick={resetForm}>
            Hủy
          </button>
        )}
      </form>

      <section className="admin-table-panel">
        <div>
          <h2>Danh sách bài học</h2>
          <p className="muted">Tạo, chỉnh sửa, xóa bài học và mở nhanh trang quản lý câu hỏi.</p>
        </div>
        {loading ? (
          <p className="state-message">Đang tải bài học...</p>
        ) : lessons.length === 0 ? (
          <p className="state-message">Chưa có dữ liệu bài học.</p>
        ) : (
          <div className="table-scroll">
            <table className="admin-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Khóa học</th>
                  <th>Tên bài học</th>
                  <th>Video</th>
                  <th>Thời lượng</th>
                  <th>Thứ tự</th>
                  <th>Thao tác</th>
                </tr>
              </thead>
              <tbody>
                {lessons.map((lesson) => (
                  <tr key={lesson.id}>
                    <td>{lesson.id}</td>
                    <td>{courseNameById.get(Number(lesson.courseId)) || '-'}</td>
                    <td>{lesson.title || '-'}</td>
                    <td>{lesson.videoFileId || lesson.videoUrl ? 'Đã có video' : 'Chưa có video'}</td>
                    <td>{lesson.duration ? `${lesson.duration} phút` : '-'}</td>
                    <td>{lesson.orderNumber || '-'}</td>
                    <td>
                      <div className="table-actions">
                        <button className="secondary-button small-action" type="button" onClick={() => handleEdit(lesson)}>
                          Sửa
                        </button>
                        <button className="danger-button small-action" type="button" onClick={() => handleDelete(lesson.id)}>
                          Xóa
                        </button>
                        <Link className="ghost-button small-action" to={ROUTES.adminLessonQuestions(lesson.id)}>
                          Quản lý câu hỏi
                        </Link>
                        <Link className="ghost-button small-action" to={`/lessons/${lesson.id}`}>
                          Xem bài học
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

export default AdminLessonsPage
