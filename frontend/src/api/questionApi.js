import axiosClient from './axiosClient'

export const getQuestions = async () => {
  const response = await axiosClient.get('/questions')
  return response.data
}

export const getQuestionsByLessonId = async (lessonId) => {
  const response = await axiosClient.get(`/questions/lesson/${lessonId}`)
  return response.data
}

export const createQuestion = async (question) => {
  const response = await axiosClient.post('/questions', question)
  return response.data
}

export const updateQuestion = async (id, question) => {
  const response = await axiosClient.put(`/questions/${id}`, question)
  return response.data
}

export const deleteQuestion = async (id) => {
  await axiosClient.delete(`/questions/${id}`)
}
