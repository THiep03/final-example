import { useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { getCourseById } from '../api/courseApi.js'
import { uploadFile } from '../api/fileApi.js'
import { createLesson, deleteLesson, getLessons, updateLesson } from '../api/lessonApi.js'

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
  const [course, setCourse] = useState(null)
  const [lessons, setLessons] = useState([])
  const [form, setForm] = useState(initialLessonForm)
  const [editingLessonId, setEditingLessonId] = useState(null)
  const [selectedFile, setSelectedFile] = useState(null)
  const [uploadedVideo, setUploadedVideo] = useState(null)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [uploadingVideo, setUploadingVideo] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  const loadContent = async () => {
    setLoading(true)
    try {
      const [courseData, lessonData] = await Promise.all([getCourseById(courseId), getLessons()])
      const courseLessons = lessonData
        .filter((lesson) => Number(lesson.courseId) === Number(courseId))
        .sort((first, second) => (first.orderNumber || 0) - (second.orderNumber || 0))

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
    let isMounted = true

    const loadInitialContent = async () => {
      try {
        const [courseData, lessonData] = await Promise.all([getCourseById(courseId), getLessons()])
        const courseLessons = lessonData
          .filter((lesson) => Number(lesson.courseId) === Number(courseId))
          .sort((first, second) => (first.orderNumber || 0) - (second.orderNumber || 0))

        if (isMounted) {
          setCourse(courseData)
          setLessons(courseLessons)
          setError('')
        }
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || 'Không thể tải nội dung khóa học.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadInitialContent()

    return () => {
      isMounted = false
    }
  }, [courseId])

  const handleChange = (event) => {
    const { name, value } = event.target
    setForm((current) => ({ ...current, [name]: value }))
  }

  const resetLessonForm = () => {
    setForm(initialLessonForm)
    setEditingLessonId(null)
    setSelectedFile(null)
    setUploadedVideo(null)
  }

  const handleFileChange = async (event) => {
    const file = event.target.files?.[0]
    setSelectedFile(file || null)
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
      setSuccess('Đã tải video bài học lên hệ thống.')
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải video bài học.')
    } finally {
      setUploadingVideo(false)
    }
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setError('')
    setSuccess('')

    if (!form.title.trim()) {
      setError('Vui lòng nhập tên bài học.')
      return
    }
    if (!editingLessonId && !uploadedVideo?.fileUrl) {
      setError('Vui lòng tải video bài học.')
      return
    }

    setSaving(true)
    try {
      const payload = {
        courseId: Number(courseId),
        videoFileId: uploadedVideo?.id || (form.videoFileId ? Number(form.videoFileId) : null),
        title: form.title,
        description: form.description,
        videoUrl: uploadedVideo?.fileUrl || form.videoUrl,
        duration: form.duration ? Number(form.duration) : null,
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
      title: lesson.title || '',
      description: lesson.description || '',
      duration: lesson.duration || '',
      orderNumber: lesson.orderNumber || '',
      videoFileId: lesson.videoFileId || '',
      videoUrl: lesson.videoUrl || '',
    })
    setError('')
    setSuccess('')
  }

  const handleDeleteLesson = async (lessonId) => {
    if (!window.confirm('Bạn có chắc muốn xóa bài học này?')) {
      return
    }

    setError('')
    setSuccess('')
    try {
      await deleteLesson(lessonId)
      if (editingLessonId === lessonId) {
        resetLessonForm()
      }
      setSuccess('Đã xóa bài học thành công.')
      await loadContent()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể xóa bài học.')
    }
  }

  return (
    <section className="page-shell wide-shell admin-page">
      <Link className="text-link" to="/admin/courses">
        Quay lại quản lý khóa học
      </Link>

      {loading ? (
        <p className="state-message">Đang tải nội dung khóa học...</p>
      ) : (
        <>
          <article className="content-hero">
            <div>
              <p className="eyebrow">Quản lý nội dung khóa học</p>
              <h1>{course?.title || 'Khóa học chưa đặt tên'}</h1>
              <p>{course?.description || 'Chưa có mô tả cho khóa học này.'}</p>
            </div>
            <span className="status-badge">
              {course?.status === 'published' ? 'Đã xuất bản' : 'Bản nháp'}
            </span>
          </article>

          {error && <p className="alert">{error}</p>}
          {success && <p className="success-alert">{success}</p>}

          <form className="admin-form content-form" onSubmit={handleSubmit}>
            <div className="full-field">
              <h2>{editingLessonId ? 'Sửa bài học trong khóa học' : 'Thêm bài học trong khóa học'}</h2>
              <p className="muted">Tải video từ máy, hệ thống sẽ tự lưu file và gắn video vào bài học.</p>
            </div>

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
            <label className="file-picker full-field">
              Tải video bài học
              <input accept="video/*" type="file" onChange={handleFileChange} />
              <span>
                {uploadingVideo
                  ? 'Đang tải video lên...'
                  : selectedFile
                    ? selectedFile.name
                    : uploadedVideo?.fileUrl || form.videoUrl
                      ? 'Đã có video bài học'
                      : 'Chưa chọn video'}
              </span>
            </label>

            <button className="primary-button" type="submit" disabled={saving || uploadingVideo}>
              {saving ? 'Đang lưu...' : editingLessonId ? 'Cập nhật bài học' : 'Thêm bài học'}
            </button>
            {editingLessonId && (
              <button className="secondary-button" type="button" onClick={resetLessonForm}>
                Hủy
              </button>
            )}
          </form>

          <section className="admin-table-panel">
            <div>
              <h2>Bài học trong khóa học</h2>
              <p className="muted">Quản lý câu hỏi ngay theo từng bài học để thao tác nhanh hơn.</p>
            </div>

            {lessons.length === 0 ? (
              <p className="state-message">Khóa học này chưa có bài học nào.</p>
            ) : (
              <div className="content-lesson-list">
                {lessons.map((lesson) => (
                  <article className="content-lesson-card" key={lesson.id}>
                    <div className="lesson-order">{lesson.orderNumber || '-'}</div>
                    <div>
                      <h3>{lesson.title || 'Bài học chưa đặt tên'}</h3>
                      <p>{lesson.description || 'Chưa có mô tả.'}</p>
                      <div className="lesson-meta">
                        <span>{lesson.duration ? `${lesson.duration} phút` : 'Chưa có thời lượng'}</span>
                        <span>{lesson.videoFileId || lesson.videoUrl ? 'Đã có video' : 'Chưa có video'}</span>
                      </div>
                    </div>
                    <div className="content-actions">
                      <Link className="primary-button compact-button" to={`/admin/lessons/${lesson.id}/questions`}>
                        Quản lý câu hỏi
                      </Link>
                      <button className="secondary-button compact-button" type="button" onClick={() => handleEditLesson(lesson)}>
                        Sửa
                      </button>
                      <button className="danger-button compact-button" type="button" onClick={() => handleDeleteLesson(lesson.id)}>
                        Xóa
                      </button>
                      <Link className="secondary-button compact-button" to={`/lessons/${lesson.id}`}>
                        Xem bài học
                      </Link>
                    </div>
                  </article>
                ))}
              </div>
            )}
          </section>
        </>
      )}
    </section>
  )
}

export default AdminCourseContentPage
