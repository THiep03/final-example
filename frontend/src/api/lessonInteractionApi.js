import axiosClient from './axiosClient'

export const createLessonInteraction = async (interaction) => {
  const response = await axiosClient.post('/lesson-interactions', interaction)
  return response.data
}

export const getLessonInteractionStats = async (lessonId) => {
  const response = await axiosClient.get(`/lesson-interactions/lesson/${lessonId}/stats`)
  return response.data
}

export const getLessonReaction = async (userId, lessonId) => {
  const response = await axiosClient.get(`/lesson-interactions/user/${userId}/lesson/${lessonId}/reaction`)
  return response.data
}
