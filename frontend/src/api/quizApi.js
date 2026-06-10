import axiosClient from './axiosClient'

const startRequests = new Map()

export const startQuiz = async ({ userId, lessonId }) => {
  const key = `${userId}:${lessonId}`

  if (!startRequests.has(key)) {
    const request = axiosClient
      .post('/quiz/start', { userId, lessonId })
      .then((response) => response.data)
      .finally(() => {
        window.setTimeout(() => {
          startRequests.delete(key)
        }, 1000)
      })

    startRequests.set(key, request)
  }

  return startRequests.get(key)
}

export const submitQuiz = async ({ attemptId, answers }) => {
  const response = await axiosClient.post('/quiz/submit', { attemptId, answers })
  return response.data
}

export const startAdaptiveQuiz = async ({ userId, lessonId, totalQuestions = 10 }) => {
  const response = await axiosClient.post('/quiz/adaptive/start', {
    userId,
    lessonId,
    totalQuestions,
  })
  return response.data
}

export const answerAdaptiveQuestion = async ({
  attemptId,
  questionId,
  selectedAnswer,
  responseTimeSeconds,
  currentDifficulty,
}) => {
  const response = await axiosClient.post('/quiz/adaptive/answer', {
    attemptId,
    questionId,
    selectedAnswer,
    responseTimeSeconds,
    currentDifficulty,
  })
  return response.data
}
