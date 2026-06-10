import axiosClient from './axiosClient'

export const getLessons = async () => {
  const response = await axiosClient.get('/lessons')
  return response.data
}

export const getLessonById = async (id) => {
  const response = await axiosClient.get(`/lessons/${id}`)
  return response.data
}

export const createLesson = async (lesson) => {
  const response = await axiosClient.post('/lessons', lesson)
  return response.data
}

export const updateLesson = async (id, lesson) => {
  const response = await axiosClient.put(`/lessons/${id}`, lesson)
  return response.data
}

export const deleteLesson = async (id) => {
  await axiosClient.delete(`/lessons/${id}`)
}
