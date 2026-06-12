import { useEffect, useMemo, useRef, useState } from 'react'
import { getLessons } from '../api/lessonApi.js'
import { createQuestion, deleteQuestion, getQuestions, updateQuestion } from '../api/questionApi.js'
import Pagination from '../components/Pagination.jsx'
import { DIFFICULTY } from '../constants/index.js'

const DEFAULT_PAGE_SIZE = 10

const initialForm = {
  lessonId: '',
  questionContent: '',
  optionA: '',
  optionB: '',
  optionC: '',
  optionD: '',
  correctAnswer: 'A',
  difficultyLevel: DIFFICULTY.BASIC,
}

const DIFFICULTY_OPTIONS = [
  { value: '', label: 'Tất cả độ khó' },
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

function AdminQuestionsPage() {
  const [questions, setQuestions] = useState([])
  const [lessons, setLessons]     = useState([])
  const [form, setForm]           = useState(initialForm)
  const [editingId, setEditingId] = useState(null)
  const [loading, setLoading]     = useState(true)
  const [saving, setSaving]       = useState(false)
  const [error, setError]         = useState('')
  const [success, setSuccess]     = useState('')

  const formRef = useRef(null)

  // search + filter
  const [search, setSearch]           = useState('')
  const [filterDiff, setFilterDiff]   = useState('')
  const [filterLesson, setFilterLesson] = useState('')
  const [page, setPage]               = useState(1)
  const [pageSize, setPageSize]       = useState(DEFAULT_PAGE_SIZE)

  const lessonNameById = useMemo(
    () => new Map(lessons.map(l => [Number(l.id), l.title || `Bài học #${l.id}`])),
    [lessons],
  )

  const loadData = async () => {
    setLoading(true)
    try {
      const [qData, lData] = await Promise.all([getQuestions(), getLessons()])
      setQuestions(qData)
      setLessons(lData)
      setError('')
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải danh sách câu hỏi.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    let alive = true
    Promise.all([getQuestions(), getLessons()])
      .then(([qData, lData]) => { if (alive) { setQuestions(qData); setLessons(lData); setError('') } })
      .catch(err => { if (alive) setError(err.response?.data?.message || 'Không thể tải dữ liệu.') })
      .finally(() => { if (alive) setLoading(false) })
    return () => { alive = false }
  }, [])

  useEffect(() => { setPage(1) }, [search, filterDiff, filterLesson, pageSize])

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim()
    return questions.filter(item => {
      const matchSearch = !q || item.questionContent?.toLowerCase().includes(q) || String(item.id).includes(q)
      const matchDiff   = !filterDiff   || item.difficultyLevel === filterDiff
      const matchLesson = !filterLesson || String(item.lessonId) === filterLesson
      return matchSearch && matchDiff && matchLesson
    })
  }, [questions, search, filterDiff, filterLesson])

  const totalPages = Math.max(1, Math.ceil(filtered.length / pageSize))
  const safePage   = Math.min(page, totalPages)
  const pageItems  = filtered.slice((safePage - 1) * pageSize, safePage * pageSize)

  const handleChange = (e) => {
    const { name, value } = e.target
    setForm(cur => ({ ...cur, [name]: value }))
  }

  const resetForm = () => {
    setForm(initialForm)
    setEditingId(null)
    setError(''); setSuccess('')
  }

  const handleEdit = (q) => {
    setEditingId(q.id)
    setForm({
      lessonId:        q.lessonId        || '',
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
    if (!form.lessonId) { setError('Vui lòng chọn bài học.'); return }
    if (!form.questionContent.trim()) { setError('Vui lòng nhập nội dung câu hỏi.'); return }

    const payload = { ...form, lessonId: Number(form.lessonId), correctAnswer: form.correctAnswer.toUpperCase() }

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
    if (!window.confirm('Bạn có chắc muốn xóa câu hỏi này?')) return
    setError(''); setSuccess('')
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

      <div className="adm-page-header">
        <div>
          <p className="eyebrow">Quản trị nội dung</p>
          <h1>Quản lý câu hỏi</h1>
          <p className="muted">Tạo, chỉnh sửa và xóa câu hỏi quiz cho từng bài học.</p>
        </div>
        <div className="adm-header-meta">
          <span className="adm-total-badge">{questions.length} câu hỏi</span>
        </div>
      </div>

      {error   && <p className="alert">{error}</p>}
      {success && <p className="success-alert">{success}</p>}

      {/* form */}
      <div className="adm-form-card" ref={formRef}>
        <div className="adm-form-card-head">
          <div>
            <p className="eyebrow">{editingId ? 'Chỉnh sửa' : 'Tạo mới'}</p>
            <h2>{editingId ? 'Sửa câu hỏi' : 'Thêm câu hỏi'}</h2>
          </div>
          {editingId && (
            <button className="ghost-button" type="button" onClick={resetForm}>✕ Hủy</button>
          )}
        </div>

        <form className="adm-form-body admin-form" onSubmit={handleSubmit}>
          <label>
            Bài học <span className="field-required">*</span>
            <select name="lessonId" value={form.lessonId} onChange={handleChange} required>
              <option value="">Chọn bài học</option>
              {lessons.map(l => (
                <option key={l.id} value={l.id}>{l.title || `Bài học #${l.id}`}</option>
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

      {/* table panel */}
      <section className="admin-table-panel">
        <div className="adm-table-header">
          <div>
            <h2>Danh sách câu hỏi</h2>
            <p className="muted">Tổng cộng <strong>{filtered.length}</strong> kết quả.</p>
          </div>
          <div className="adm-table-filters">
            <div className="adm-search-box">
              <span className="adm-search-icon">🔍</span>
              <input
                className="adm-search-input"
                placeholder="Tìm theo nội dung..."
                value={search}
                onChange={e => setSearch(e.target.value)}
              />
              {search && (
                <button className="adm-search-clear" onClick={() => setSearch('')} type="button">✕</button>
              )}
            </div>
            <select className="adm-filter-select" value={filterLesson} onChange={e => setFilterLesson(e.target.value)}>
              <option value="">Tất cả bài học</option>
              {lessons.map(l => (
                <option key={l.id} value={String(l.id)}>{l.title || `Bài #${l.id}`}</option>
              ))}
            </select>
            <select className="adm-filter-select" value={filterDiff} onChange={e => setFilterDiff(e.target.value)}>
              {DIFFICULTY_OPTIONS.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
          </div>
        </div>

        {loading ? (
          <p className="state-message">Đang tải câu hỏi...</p>
        ) : filtered.length === 0 ? (
          <p className="state-message">{search || filterDiff || filterLesson ? 'Không tìm thấy kết quả phù hợp.' : 'Chưa có dữ liệu câu hỏi.'}</p>
        ) : (
          <>
            <div className="table-scroll">
              <table className="admin-table">
                <thead>
                  <tr>
                    <th className="col-id">ID</th>
                    <th>Bài học</th>
                    <th>Nội dung câu hỏi</th>
                    <th>Độ khó</th>
                    <th>Đáp án</th>
                    <th>Thao tác</th>
                  </tr>
                </thead>
                <tbody>
                  {pageItems.map((q) => (
                    <tr key={q.id}>
                      <td className="col-id adm-id-cell">#{q.id}</td>
                      <td className="adm-muted-cell">{lessonNameById.get(Number(q.lessonId)) || '—'}</td>
                      <td className="adm-question-cell">{q.questionContent}</td>
                      <td>
                        <span className={`adm-diff-badge ${getDifficultyClass(q.difficultyLevel)}`}>
                          {getDifficultyLabel(q.difficultyLevel)}
                        </span>
                      </td>
                      <td>
                        <span className="adm-answer-badge">{q.correctAnswer}</span>
                      </td>
                      <td>
                        <div className="table-actions">
                          <button className="secondary-button small-action" type="button" onClick={() => handleEdit(q)}>
                            Sửa
                          </button>
                          <button className="danger-button small-action" type="button" onClick={() => handleDelete(q.id)}>
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

export default AdminQuestionsPage
