import { useEffect, useMemo, useRef, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { generateFeedback } from '../api/feedbackApi.js'
import { answerAdaptiveQuestion, startAdaptiveQuiz } from '../api/quizApi.js'
import { ANSWER_OPTIONS, DIFFICULTY, QUIZ_CONFIG, ROUTES, STORAGE_KEYS } from '../constants/index.js'

function getDifficultyLabel(level) {
  if (level === DIFFICULTY.MEDIUM) return 'Trung bình'
  if (level === DIFFICULTY.HARD) return 'Khó'
  return 'Cơ bản'
}

function getCurrentUser() {
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEYS.USER) || 'null')
  } catch {
    return null
  }
}

function formatElapsedTime(seconds) {
  const safeSeconds = Math.max(0, Number(seconds) || 0)
  const minutes = Math.floor(safeSeconds / 60)
  const remainingSeconds = safeSeconds % 60
  return `${minutes}:${String(remainingSeconds).padStart(2, '0')}`
}

function QuizPage() {
  const { lessonId } = useParams()
  const user = useMemo(() => getCurrentUser(), [])
  const isMountedRef = useRef(true)
  useEffect(() => {
    isMountedRef.current = true
    return () => { isMountedRef.current = false }
  }, [])
  const [attemptId, setAttemptId] = useState(null)
  const [currentQuestion, setCurrentQuestion] = useState(null)
  const [currentDifficulty, setCurrentDifficulty] = useState('basic')
  const [selectedAnswer, setSelectedAnswer] = useState('')
  const [answeredCount, setAnsweredCount] = useState(0)
  const [totalQuestions, setTotalQuestions] = useState(QUIZ_CONFIG.TOTAL_ADAPTIVE_QUESTIONS)
  const [questionStartedAt, setQuestionStartedAt] = useState(null)
  const [elapsedSeconds, setElapsedSeconds] = useState(0)
  const [result, setResult] = useState(null)
  const [generatedFeedback, setGeneratedFeedback] = useState(null)
  const [feedbackGenerating, setFeedbackGenerating] = useState(false)
  const [feedbackError, setFeedbackError] = useState('')
  const [loading, setLoading] = useState(true)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    let isMounted = true

    const loadQuiz = async () => {
      if (!user?.id) {
        setError('Vui lòng đăng nhập trước khi bắt đầu quiz.')
        setLoading(false)
        return
      }

      setLoading(true)
      try {
        const data = await startAdaptiveQuiz({
          userId: user.id,
          lessonId: Number(lessonId),
          totalQuestions: QUIZ_CONFIG.TOTAL_ADAPTIVE_QUESTIONS,
        })

        if (!isMounted) {
          return
        }

        if (!data?.attemptId || !data?.question) {
          throw new Error('Không thể tạo lượt làm quiz. Vui lòng thử lại.')
        }

        setAttemptId(data.attemptId)
        setCurrentQuestion(data.question)
        setCurrentDifficulty(data.currentDifficulty || 'basic')
        setAnsweredCount(data.answeredCount || 0)
        setTotalQuestions(data.totalQuestions || QUIZ_CONFIG.TOTAL_ADAPTIVE_QUESTIONS)
        setQuestionStartedAt(Date.now())
        setElapsedSeconds(0)
        setError('')
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || err.message || 'Không thể bắt đầu quiz.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadQuiz()

    return () => {
      isMounted = false
    }
  }, [lessonId, user])

  useEffect(() => {
    if (!questionStartedAt || result || !currentQuestion) {
      return undefined
    }

    const timerId = window.setInterval(() => {
      setElapsedSeconds(Math.floor((Date.now() - questionStartedAt) / 1000))
    }, 1000)

    return () => window.clearInterval(timerId)
  }, [questionStartedAt, result, currentQuestion])

  const handleSubmitAnswer = async (event) => {
    event.preventDefault()
    setError('')
    setFeedbackError('')

    if (!attemptId || !currentQuestion) {
      setError('Lượt làm quiz chưa sẵn sàng.')
      return
    }

    if (!selectedAnswer) {
      setError('Vui lòng chọn một đáp án trước khi tiếp tục.')
      return
    }

    setSubmitting(true)
    try {
      const responseTimeSeconds = questionStartedAt
        ? Math.max(0, Math.round((Date.now() - questionStartedAt) / 1000))
        : elapsedSeconds

      const data = await answerAdaptiveQuestion({
        attemptId,
        questionId: currentQuestion.id,
        selectedAnswer,
        responseTimeSeconds,
        currentDifficulty,
      })

      const finished = Boolean(data?.isFinished ?? data?.finished)
      const nextAnsweredCount = data?.answeredCount ?? answeredCount + 1

      if (finished) {
        setResult({
          id: attemptId,
          score: data.finalScore ?? data.currentScore ?? 0,
          correctAnswers: data.correctAnswers ?? 0,
          totalQuestions: nextAnsweredCount,
          resultStatus: data.resultStatus || 'fail',
        })
        setCurrentQuestion(null)

        setFeedbackGenerating(true)
        try {
          const feedbackData = await generateFeedback({
            userId: user.id,
            lessonId: Number(lessonId),
          })
          if (isMountedRef.current) {
            setGeneratedFeedback(feedbackData)
          }
        } catch (feedbackErr) {
          if (isMountedRef.current) {
            setFeedbackError(
              feedbackErr.response?.data?.message ||
                'Đã nộp bài, nhưng chưa thể tạo phản hồi học tập.',
            )
          }
        } finally {
          if (isMountedRef.current) {
            setFeedbackGenerating(false)
          }
        }
        return
      }

      if (!data?.nextQuestion) {
        throw new Error('Không tìm thấy câu hỏi tiếp theo.')
      }

      setCurrentQuestion(data.nextQuestion)
      setCurrentDifficulty(data.nextDifficulty || data.nextQuestion.difficultyLevel || currentDifficulty)
      setAnsweredCount(nextAnsweredCount)
      setTotalQuestions(data.totalQuestions || totalQuestions)
      setSelectedAnswer('')
      setQuestionStartedAt(Date.now())
      setElapsedSeconds(0)
    } catch (err) {
      setError(err.response?.data?.message || err.message || 'Không thể gửi câu trả lời.')
    } finally {
      setSubmitting(false)
    }
  }

  if (loading) {
    return (
      <section className="page-shell wide-shell">
        <p className="state-message">Đang tải quiz...</p>
      </section>
    )
  }

  if (!user?.id) {
    return (
      <section className="page-shell">
        <div className="panel home-panel">
          <p className="alert">{error}</p>
          <Link className="primary-button" to="/login">
            Đăng nhập
          </Link>
        </div>
      </section>
    )
  }

  return (
    <section className="page-shell wide-shell">
      <Link className="text-link" to={ROUTES.lessonDetail(lessonId)}>
        Quay lại bài học
      </Link>

      <div className="quiz-layout">
        <div className="quiz-header">
          <div>
            <p className="eyebrow">Quiz thích ứng</p>
            <h1>Làm quiz theo năng lực hiện tại</h1>
            <p className="muted-text">
              Hệ thống bắt đầu từ mức cơ bản và tự điều chỉnh độ khó sau từng câu trả lời.
            </p>
          </div>
          <div className="quiz-progress">
            Đã trả lời {answeredCount}/{totalQuestions}
          </div>
        </div>

        {error && <p className="alert">{error}</p>}

        {!result && !currentQuestion && !error && (
          <p className="state-message">Chưa có câu hỏi phù hợp cho bài học này.</p>
        )}

        {currentQuestion && !result && (
          <form className="quiz-form" onSubmit={handleSubmitAnswer}>
            <article className="question-card">
              <div className="question-heading">
                <span>Câu {answeredCount + 1}</span>
                <span>{getDifficultyLabel(currentDifficulty || currentQuestion.difficultyLevel)}</span>
              </div>

              <div className="question-heading">
                <span>Thời gian trả lời</span>
                <span>{formatElapsedTime(elapsedSeconds)}</span>
              </div>

              <h2>{currentQuestion.questionContent}</h2>

              <div className="answer-list">
                {ANSWER_OPTIONS.map((option) => (
                  <label
                    className={`answer-option ${selectedAnswer === option.value ? 'selected' : ''}`}
                    key={option.value}
                  >
                    <input
                      checked={selectedAnswer === option.value}
                      disabled={submitting}
                      name={`question-${currentQuestion.id}`}
                      type="radio"
                      value={option.value}
                      onChange={() => setSelectedAnswer(option.value)}
                    />
                    <span className="answer-letter">{option.value}</span>
                    <span>{currentQuestion[option.field] || 'Chưa có đáp án'}</span>
                  </label>
                ))}
              </div>
            </article>

            <button
              className="primary-button quiz-submit-button"
              type="submit"
              disabled={submitting || !selectedAnswer}
            >
              {submitting ? 'Đang gửi câu trả lời...' : 'Trả lời và tiếp tục'}
            </button>
          </form>
        )}

        {result && (
          <section className="quiz-result">
            <div>
              <p className="eyebrow">Kết quả</p>
              <h2>{result.resultStatus === 'pass' ? 'Đạt' : 'Chưa đạt'}</h2>
            </div>

            <dl className="result-grid">
              <div>
                <dt>Điểm</dt>
                <dd>{Math.round(result.score ?? 0)}%</dd>
              </div>
              <div>
                <dt>Số câu đúng</dt>
                <dd>{result.correctAnswers ?? 0}</dd>
              </div>
              <div>
                <dt>Tổng câu hỏi</dt>
                <dd>{result.totalQuestions ?? 0}</dd>
              </div>
              <div>
                <dt>Trạng thái</dt>
                <dd>{result.resultStatus === 'pass' ? 'Đạt' : 'Chưa đạt'}</dd>
              </div>
            </dl>

            {feedbackGenerating && <p className="state-message">Đang tạo phản hồi học tập...</p>}
            {feedbackError && <p className="alert">{feedbackError}</p>}

            <div className="actions">
              {feedbackGenerating ? (
                <button className="secondary-button" type="button" disabled>
                  Đang tạo phản hồi...
                </button>
              ) : !generatedFeedback ? (
                <button className="secondary-button" type="button" disabled>
                  Chưa có phản hồi
                </button>
              ) : (
                <Link
                  className="secondary-button"
                  state={{ feedback: generatedFeedback }}
                  to={ROUTES.feedbackPage(attemptId)}
                >
                  Xem phản hồi
                </Link>
              )}
              <Link className="primary-button" to={ROUTES.lessonDetail(lessonId)}>
                Quay lại bài học
              </Link>
            </div>
          </section>
        )}
      </div>
    </section>
  )
}

export default QuizPage
