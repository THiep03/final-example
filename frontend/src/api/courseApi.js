import axiosClient from './axiosClient'

export const getCourses = async () => {
  const response = await axiosClient.get('/courses')
  return response.data
}

export const getTrendingCourses = async () => {
  const response = await axiosClient.get('/courses/trending')
  return response.data
}

export const getCourseById = async (id) => {
  const response = await axiosClient.get(`/courses/${id}`)
  return response.data
}

export const createCourse = async (course) => {
  const response = await axiosClient.post('/courses', course)
  return response.data
}

export const updateCourse = async (id, course) => {
  const response = await axiosClient.put(`/courses/${id}`, course)
  return response.data
}

export const deleteCourse = async (id) => {
  await axiosClient.delete(`/courses/${id}`)
}
