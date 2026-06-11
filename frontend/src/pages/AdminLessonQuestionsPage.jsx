import { useEffect, useRef, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { getLessonById } from '../api/lessonApi.js'
import { createQuestion, deleteQuestion, getQuestionsByLessonId, updateQuestion } from '../api/questionApi.js'
import { DIFFICULTY, ROUTES } from '../constants/index.js'

const initialQuestionForm = {
  questionContent: '',
  optionA: '',
  optionB: '',
  optionC: '',
  optionD: '',
  correctAnswer: 'A',
  difficultyLevel: DIFFICULTY.BASIC,
}

function getDifficultyLabel(level) {
  if (level === DIFFICULTY.MEDIUM) return 'Trung bình'
  if (level === DIFFICULTY.HARD) return 'Khó'
  return 'Cơ bản'
}

function AdminLessonQuestionsPage() {
  const { lessonId } = useParams()
  const formRef = useRef(null)
  const [lesson, setLesson] = useState(null)
  const [questions, setQuestions] = useState([])
  const [form, setForm] = useState(initialQuestionForm)
  const [editingId, setEditingId] = useState(null)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  const loadQuestions = async () => {
    setLoading(true)
    try {
      const [lessonData, questionData] = await Promise.all([
        getLessonById(lessonId),
        getQuestionsByLessonId(lessonId),
      ])
      setLesson(lessonData)
      setQuestions(questionData)
      setError('')
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải câu hỏi của bài học.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    let isMounted = true

    const loadInitialQuestions = async () => {
      try {
        const [lessonData, questionData] = await Promise.all([
          getLessonById(lessonId),
          getQuestionsByLessonId(lessonId),
        ])
        if (isMounted) {
          setLesson(lessonData)
          setQuestions(questionData)
          setError('')
        }
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || 'Không thể tải câu hỏi của bài học.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadInitialQuestions()

    return () => {
      isMounted = false
    }
  }, [lessonId])

  const handleChange = (event) => {
    const { name, value } = event.target
    setForm((current) => ({ ...current, [name]: value }))
  }

  const resetForm = () => {
    setForm(initialQuestionForm)
    setEditingId(null)
  }

  const handleEdit = (question) => {
    setEditingId(question.id)
    setForm({
      questionContent: question.questionContent || '',
      optionA: question.optionA || '',
      optionB: question.optionB || '',
      optionC: question.optionC || '',
      optionD: question.optionD || '',
      correctAnswer: question.correctAnswer || 'A',
      difficultyLevel: question.difficultyLevel || 'basic',
    })
    setError('')
    setSuccess('')
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setError('')
    setSuccess('')

    if (!form.questionContent.trim()) {
      setError('Vui lòng nhập nội dung câu hỏi.')
      return
    }

    setSaving(true)
    try {
      const payload = {
        ...form,
        lessonId: Number(lessonId),
        correctAnswer: form.correctAnswer.toUpperCase(),
      }

      if (editingId) {
        await updateQuestion(editingId, payload)
        setSuccess('Đã cập nhật câu hỏi thành công.')
      } else {
        await createQuestion(payload)
        setSuccess('Đã thêm câu hỏi vào bài học.')
      }
      resetForm()
      await loadQuestions()
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
      if (editingId === id) {
        resetForm()
      }
      setSuccess('Đã xóa câu hỏi thành công.')
      await loadQuestions()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể xóa câu hỏi.')
    }
  }

  return (
    <section className="page-shell wide-shell admin-page">
      <Link className="text-link" to={lesson?.courseId ? ROUTES.adminCourseContent(lesson.courseId) : ROUTES.ADMIN_LESSONS}>
        Quay lại nội dung khóa học
      </Link>

      {loading ? (
        <p className="state-message">Đang tải câu hỏi...</p>
      ) : (
        <>
          <article className="content-hero">
            <div>
              <p className="eyebrow">Quản lý câu hỏi theo bài học</p>
              <h1>{lesson?.title || 'Bài học chưa đặt tên'}</h1>
              <p>{lesson?.description || 'Chưa có mô tả cho bài học này.'}</p>
            </div>
            <Link className="secondary-button" to={`/lessons/${lessonId}`}>
              Xem bài học
            </Link>
          </article>

          {error && <p className="alert">{error}</p>}
          {success && <p className="success-alert">{success}</p>}

          <form className="admin-form content-form" ref={formRef} onSubmit={handleSubmit}>
            <div className="full-field">
              <h2>{editingId ? 'Sửa câu hỏi' : 'Thêm câu hỏi'}</h2>
              <p className="muted">Bài học đã được chọn từ trang trước nên không cần chọn lại.</p>
            </div>

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
            <label>
              Đáp án đúng
              <select name="correctAnswer" value={form.correctAnswer} onChange={handleChange}>
                <option value="A">A</option>
                <option value="B">B</option>
                <option value="C">C</option>
                <option value="D">D</option>
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

            <button className="primary-button" type="submit" disabled={saving}>
              {saving ? 'Đang lưu...' : editingId ? 'Cập nhật câu hỏi' : 'Thêm câu hỏi'}
            </button>
            {editingId && (
              <button className="secondary-button" type="button" onClick={resetForm}>
                Hủy
              </button>
            )}
          </form>

          <section className="admin-table-panel">
            <h2>Câu hỏi của bài học</h2>
            {questions.length === 0 ? (
              <p className="state-message">Bài học này chưa có câu hỏi nào.</p>
            ) : (
              <div className="content-question-list">
                {questions.map((question, index) => (
                  <article className="question-management-card" key={question.id}>
                    <div>
                      <p className="eyebrow">Câu {index + 1} · {getDifficultyLabel(question.difficultyLevel)}</p>
                      <h3>{question.questionContent}</h3>
                    </div>
                    <div className="question-options-grid">
                      <span>A. {question.optionA || '-'}</span>
                      <span>B. {question.optionB || '-'}</span>
                      <span>C. {question.optionC || '-'}</span>
                      <span>D. {question.optionD || '-'}</span>
                    </div>
                    <div className="content-actions">
                      <span className="status-badge">Đáp án {question.correctAnswer}</span>
                      <button className="secondary-button compact-button" type="button" onClick={() => handleEdit(question)}>
                        Sửa
                      </button>
                      <button className="danger-button compact-button" type="button" onClick={() => handleDelete(question.id)}>
                        Xóa
                      </button>
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

export default AdminLessonQuestionsPage
