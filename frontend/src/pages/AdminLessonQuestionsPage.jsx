import { useEffect, useMemo, useRef, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { getLessonById } from '../api/lessonApi.js'
import { createQuestion, deleteQuestion, getQuestionsByLessonId, updateQuestion } from '../api/questionApi.js'
import Pagination from '../components/Pagination.jsx'
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

const DIFFICULTY_OPTIONS = [
  { value: '',               label: 'Tất cả độ khó' },
  { value: DIFFICULTY.BASIC,  label: 'Cơ bản'    },
  { value: DIFFICULTY.MEDIUM, label: 'Trung bình' },
  { value: DIFFICULTY.HARD,   label: 'Khó'        },
]

function getDifficultyLabel(level) {
  if (level === DIFFICULTY.MEDIUM) return 'Trung bình'
  if (level === DIFFICULTY.HARD) return 'Khó'
  return 'Cơ bản'
}

function getDifficultyClass(level) {
  if (level === DIFFICULTY.HARD)   return 'diff-hard'
  if (level === DIFFICULTY.MEDIUM) return 'diff-medium'
  return 'diff-basic'
}

function AdminLessonQuestionsPage() {
  const { lessonId } = useParams()
  const formRef = useRef(null)
  const [lesson, setLesson]         = useState(null)
  const [questions, setQuestions]   = useState([])
  const [form, setForm]             = useState(initialQuestionForm)
  const [editingId, setEditingId]   = useState(null)
  const [loading, setLoading]       = useState(true)
  const [saving, setSaving]         = useState(false)
  const [error, setError]           = useState('')
  const [success, setSuccess]       = useState('')

  // search + filter + pagination
  const [search, setSearch]         = useState('')
  const [filterDiff, setFilterDiff] = useState('')
  const [page, setPage]             = useState(1)
  const [pageSize, setPageSize]     = useState(10)

  const loadQuestions = async () => {
    setLoading(true)
    try {
      const [lessonData, questionData] = await Promise.all([getLessonById(lessonId), getQuestionsByLessonId(lessonId)])
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
    let alive = true
    Promise.all([getLessonById(lessonId), getQuestionsByLessonId(lessonId)])
      .then(([lessonData, questionData]) => { if (alive) { setLesson(lessonData); setQuestions(questionData); setError('') } })
      .catch(err => { if (alive) setError(err.response?.data?.message || 'Không thể tải câu hỏi.') })
      .finally(() => { if (alive) setLoading(false) })
    return () => { alive = false }
  }, [lessonId])

  useEffect(() => { setPage(1) }, [search, filterDiff, pageSize])

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim()
    return questions.filter(item => {
      const matchSearch = !q || item.questionContent?.toLowerCase().includes(q)
      const matchDiff   = !filterDiff || item.difficultyLevel === filterDiff
      return matchSearch && matchDiff
    })
  }, [questions, search, filterDiff])

  const totalPages = Math.max(1, Math.ceil(filtered.length / pageSize))
  const safePage   = Math.min(page, totalPages)
  const pageItems  = filtered.slice((safePage - 1) * pageSize, safePage * pageSize)

  const handleChange = (e) => {
    const { name, value } = e.target
    setForm(cur => ({ ...cur, [name]: value }))
  }

  const resetForm = () => {
    setForm(initialQuestionForm)
    setEditingId(null)
    setError(''); setSuccess('')
  }

  const handleEdit = (q) => {
    setEditingId(q.id)
    setForm({
      questionContent: q.questionContent || '',
      optionA:         q.optionA         || '',
      optionB:         q.optionB         || '',
      optionC:         q.optionC         || '',
      optionD:         q.optionD         || '',
      correctAnswer:   q.correctAnswer   || 'A',
      difficultyLevel: q.difficultyLevel || 'basic',
    })
    setError(''); setSuccess('')
    formRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError(''); setSuccess('')
    if (!form.questionContent.trim()) { setError('Vui lòng nhập nội dung câu hỏi.'); return }
    setSaving(true)
    try {
      const payload = { ...form, lessonId: Number(lessonId), correctAnswer: form.correctAnswer.toUpperCase() }
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
    if (!window.confirm('Bạn có chắc muốn xóa câu hỏi này?')) return
    setError(''); setSuccess('')
    try {
      await deleteQuestion(id)
      if (editingId === id) resetForm()
      setSuccess('Đã xóa câu hỏi thành công.')
      await loadQuestions()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể xóa câu hỏi.')
    }
  }

  return (
    <section className="page-shell wide-shell admin-page">
      <Link className="text-link" to={lesson?.courseId ? ROUTES.adminCourseContent(lesson.courseId) : ROUTES.ADMIN_LESSONS}>
        ← Quay lại nội dung khóa học
      </Link>

      {loading ? (
        <p className="state-message">Đang tải câu hỏi...</p>
      ) : (
        <>
          {/* lesson hero */}
          <div className="adm-course-hero">
            <div className="adm-course-hero-left">
              <p className="eyebrow">Quản lý câu hỏi theo bài học</p>
              <h1>{lesson?.title || 'Bài học chưa đặt tên'}</h1>
              <p className="adm-course-hero-desc">{lesson?.description || 'Chưa có mô tả.'}</p>
              <div className="adm-course-hero-meta">
                {lesson?.duration && <span className="adm-course-hero-count">{lesson.duration} phút</span>}
                <span className="adm-course-hero-count">{questions.length} câu hỏi</span>
                <Link className="secondary-button compact-button" to={`/lessons/${lessonId}`}>Xem bài học</Link>
              </div>
            </div>
          </div>

          {error   && <p className="alert">{error}</p>}
          {success && <p className="success-alert">{success}</p>}

          {/* form */}
          <div className="adm-form-card" ref={formRef}>
            <div className="adm-form-card-head">
              <div>
                <p className="eyebrow">{editingId ? 'Chỉnh sửa' : 'Tạo mới'}</p>
                <h2>{editingId ? 'Sửa câu hỏi' : 'Thêm câu hỏi vào bài học'}</h2>
              </div>
              {editingId && <button className="ghost-button" type="button" onClick={resetForm}>✕ Hủy</button>}
            </div>
            <form className="adm-form-body admin-form content-form" onSubmit={handleSubmit}>
              <label className="full-field">
                Nội dung câu hỏi <span className="field-required">*</span>
                <textarea name="questionContent" value={form.questionContent} onChange={handleChange} rows="3" placeholder="Nhập nội dung câu hỏi..." required />
              </label>
              <label>
                Phương án A
                <input name="optionA" value={form.optionA} onChange={handleChange} placeholder="Nhập phương án A..." />
              </label>
              <label>
                Phương án B
                <input name="optionB" value={form.optionB} onChange={handleChange} placeholder="Nhập phương án B..." />
              </label>
              <label>
                Phương án C
                <input name="optionC" value={form.optionC} onChange={handleChange} placeholder="Nhập phương án C..." />
              </label>
              <label>
                Phương án D
                <input name="optionD" value={form.optionD} onChange={handleChange} placeholder="Nhập phương án D..." />
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
              <div className="admin-form-actions full-field">
                <button className="primary-button" type="submit" disabled={saving}>
                  {saving ? 'Đang lưu...' : editingId ? 'Cập nhật câu hỏi' : 'Thêm câu hỏi'}
                </button>
                {editingId && (
                  <button className="secondary-button" type="button" onClick={resetForm}>Hủy thay đổi</button>
                )}
              </div>
            </form>
          </div>

          {/* question list */}
          <section className="admin-table-panel">
            <div className="adm-table-header">
              <div>
                <h2>Câu hỏi của bài học</h2>
                <p className="muted">Tổng cộng <strong>{filtered.length}</strong> câu hỏi.</p>
              </div>
              <div className="adm-table-filters">
                <div className="adm-search-box">
                  <span className="adm-search-icon">🔍</span>
                  <input
                    className="adm-search-input"
                    placeholder="Tìm theo nội dung câu hỏi..."
                    value={search}
                    onChange={e => setSearch(e.target.value)}
                  />
                  {search && <button className="adm-search-clear" type="button" onClick={() => setSearch('')}>✕</button>}
                </div>
                <select className="adm-filter-select" value={filterDiff} onChange={e => setFilterDiff(e.target.value)}>
                  {DIFFICULTY_OPTIONS.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
                </select>
              </div>
            </div>

            {filtered.length === 0 ? (
              <p className="state-message">{search || filterDiff ? 'Không tìm thấy câu hỏi phù hợp.' : 'Bài học này chưa có câu hỏi nào.'}</p>
            ) : (
              <>
                <div className="adm-question-card-list">
                  {pageItems.map((q, idx) => (
                    <article className="adm-question-row" key={q.id}>
                      <div className="adm-question-row-head">
                        <div className="adm-question-meta-row">
                          <span className="adm-q-index">Câu {(safePage - 1) * pageSize + idx + 1}</span>
                          <span className={`adm-diff-badge ${getDifficultyClass(q.difficultyLevel)}`}>
                            {getDifficultyLabel(q.difficultyLevel)}
                          </span>
                          <span className="adm-answer-badge">Đáp án {q.correctAnswer}</span>
                        </div>
                        <div className="adm-question-row-actions">
                          <button className="secondary-button compact-button" type="button" onClick={() => handleEdit(q)}>
                            Sửa
                          </button>
                          <button className="danger-button compact-button" type="button" onClick={() => handleDelete(q.id)}>
                            Xóa
                          </button>
                        </div>
                      </div>
                      <h3 className="adm-question-content">{q.questionContent}</h3>
                      <div className="adm-options-grid">
                        {['A', 'B', 'C', 'D'].map(letter => {
                          const key = `option${letter}`
                          const isCorrect = q.correctAnswer?.toUpperCase() === letter
                          return (
                            <div className={`adm-option-item${isCorrect ? ' is-correct' : ''}`} key={letter}>
                              <span className="adm-option-letter">{letter}</span>
                              <span className="adm-option-text">{q[key] || '—'}</span>
                              {isCorrect && <span className="adm-option-check">✓</span>}
                            </div>
                          )
                        })}
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

export default AdminLessonQuestionsPage
