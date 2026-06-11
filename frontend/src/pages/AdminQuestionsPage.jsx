import { useEffect, useMemo, useRef, useState } from 'react'
import { getLessons } from '../api/lessonApi.js'
import {
  createQuestion,
  deleteQuestion,
  getQuestions,
  updateQuestion,
} from '../api/questionApi.js'

const initialForm = {
  lessonId: '',
  questionContent: '',
  optionA: '',
  optionB: '',
  optionC: '',
  optionD: '',
  correctAnswer: 'A',
  difficultyLevel: 'basic',
}

function getDifficultyLabel(level) {
  if (level === 'medium') {
    return 'Trung bình'
  }
  if (level === 'hard') {
    return 'Khó'
  }
  return 'Cơ bản'
}

function AdminQuestionsPage() {
  const [questions, setQuestions] = useState([])
  const [lessons, setLessons] = useState([])
  const [form, setForm] = useState(initialForm)
  const [editingId, setEditingId] = useState(null)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  const formRef = useRef(null)
  const lessonNameById = useMemo(
    () => new Map(lessons.map((lesson) => [Number(lesson.id), lesson.title || `Bài học #${lesson.id}`])),
    [lessons],
  )

  const loadData = async () => {
    setLoading(true)
    try {
      const [questionData, lessonData] = await Promise.all([getQuestions(), getLessons()])
      setQuestions(questionData)
      setLessons(lessonData)
      setError('')
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải danh sách câu hỏi.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    let isMounted = true

    const loadInitialData = async () => {
      try {
        const [questionData, lessonData] = await Promise.all([getQuestions(), getLessons()])
        if (isMounted) {
          setQuestions(questionData)
          setLessons(lessonData)
          setError('')
        }
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || 'Không thể tải danh sách câu hỏi.')
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

  const resetForm = () => {
    setForm(initialForm)
    setEditingId(null)
  }

  const handleEdit = (question) => {
    setEditingId(question.id)
    setForm({
      lessonId: question.lessonId || '',
      questionContent: question.questionContent || '',
      optionA: question.optionA || '',
      optionB: question.optionB || '',
      optionC: question.optionC || '',
      optionD: question.optionD || '',
      correctAnswer: question.correctAnswer || 'A',
      difficultyLevel: question.difficultyLevel || 'basic',
    })
    setSuccess('')
    setError('')
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setError('')
    setSuccess('')

    if (!form.lessonId) {
      setError('Vui lòng chọn bài học.')
      return
    }
    if (!form.questionContent.trim()) {
      setError('Vui lòng nhập nội dung câu hỏi.')
      return
    }

    const payload = {
      ...form,
      lessonId: Number(form.lessonId),
      correctAnswer: form.correctAnswer.toUpperCase(),
    }

    setSaving(true)
    try {
      if (editingId) {
        await updateQuestion(editingId, payload)
        setSuccess('Đã cập nhật câu hỏi thành công.')
      } else {
        await createQuestion(payload)
        setSuccess('Đã thêm câu hỏi thành công.')
      }
      resetForm()
      await loadData()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể lưu câu hỏi.')
    } finally {
      setSaving(false)
    }
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Bạn có chắc muốn xóa câu hỏi này?')) {
      return
    }

    setError('')
    setSuccess('')
    try {
      await deleteQuestion(id)
      setSuccess('Đã xóa câu hỏi thành công.')
      await loadData()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể xóa câu hỏi.')
    }
  }

  return (
    <section className="page-shell wide-shell admin-page">
      <div className="section-heading">
        <div>
          <p className="eyebrow">Quản trị nội dung</p>
          <h1>Quản lý câu hỏi</h1>
        </div>
        <p className="muted">Tạo, chỉnh sửa và xóa câu hỏi quiz cho từng bài học.</p>
      </div>

      {error && <p className="alert">{error}</p>}
      {success && <p className="success-alert">{success}</p>}

      <form className="admin-form" ref={formRef} onSubmit={handleSubmit}>
        <label>
          Bài học
          <select name="lessonId" value={form.lessonId} onChange={handleChange} required>
            <option value="">Chọn bài học</option>
            {lessons.map((lesson) => (
              <option key={lesson.id} value={lesson.id}>
                {lesson.title || `Bài học #${lesson.id}`}
              </option>
            ))}
          </select>
        </label>
        <label>
          Độ khó
          <select name="difficultyLevel" value={form.difficultyLevel} onChange={handleChange}>
            <option value="basic">Cơ bản</option>
            <option value="medium">Trung bình</option>
            <option value="hard">Khó</option>
          </select>
        </label>
        <label>
          Đáp án đúng
          <select name="correctAnswer" value={form.correctAnswer} onChange={handleChange}>
            <option value="A">A</option>
            <option value="B">B</option>
            <option value="C">C</option>
            <option value="D">D</option>
          </select>
        </label>
        <label className="full-field">
          Nội dung câu hỏi
          <textarea name="questionContent" value={form.questionContent} onChange={handleChange} rows="3" required />
        </label>
        <label>
          Phương án A
          <input name="optionA" value={form.optionA} onChange={handleChange} />
        </label>
        <label>
          Phương án B
          <input name="optionB" value={form.optionB} onChange={handleChange} />
        </label>
        <label>
          Phương án C
          <input name="optionC" value={form.optionC} onChange={handleChange} />
        </label>
        <label>
          Phương án D
          <input name="optionD" value={form.optionD} onChange={handleChange} />
        </label>
        <div className="admin-form-actions">
          <button className="primary-button" type="submit" disabled={saving}>
            {saving ? 'Đang lưu...' : editingId ? 'Cập nhật câu hỏi' : 'Thêm câu hỏi'}
          </button>
          {editingId && (
            <button className="secondary-button" type="button" onClick={resetForm}>
              Hủy
            </button>
          )}
        </div>
      </form>

      <section className="admin-table-panel">
        <h2>Danh sách câu hỏi</h2>
        {loading ? (
          <p className="state-message">Đang tải câu hỏi...</p>
        ) : questions.length === 0 ? (
          <p className="state-message">Chưa có dữ liệu câu hỏi.</p>
        ) : (
          <div className="table-scroll">
            <table className="admin-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Bài học</th>
                  <th>Câu hỏi</th>
                  <th>Độ khó</th>
                  <th>Đáp án</th>
                  <th>Thao tác</th>
                </tr>
              </thead>
              <tbody>
                {questions.map((question) => (
                  <tr key={question.id}>
                    <td>{question.id}</td>
                    <td>{lessonNameById.get(Number(question.lessonId)) || '-'}</td>
                    <td>{question.questionContent}</td>
                    <td>{getDifficultyLabel(question.difficultyLevel)}</td>
                    <td>{question.correctAnswer}</td>
                    <td>
                      <div className="table-actions">
                        <button className="secondary-button compact-button" type="button" onClick={() => handleEdit(question)}>
                          Sửa
                        </button>
                        <button className="danger-button compact-button" type="button" onClick={() => handleDelete(question.id)}>
                          Xóa
                        </button>
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

export default AdminQuestionsPage
