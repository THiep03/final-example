import axiosClient from './axiosClient'

export const createFocusLog = async (log) => {
  const response = await axiosClient.post('/focus-logs', log)
  return response.data
}

export const getFocusLogsByUserId = async (userId) => {
  const response = await axiosClient.get(`/focus-logs/user/${userId}`)
  return response.data
}

export const getFocusLogsByUserIdAndLessonId = async (userId, lessonId) => {
  const response = await axiosClient.get(`/focus-logs/user/${userId}/lesson/${lessonId}`)
  return response.data
}
