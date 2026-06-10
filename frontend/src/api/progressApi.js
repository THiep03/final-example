import axiosClient from './axiosClient'

export const startProgress = async (progress) => {
  const response = await axiosClient.post('/progress/start', progress)
  return response.data
}

export const completeProgress = async (progress) => {
  const response = await axiosClient.put('/progress/complete', progress)
  return response.data
}

export const getProgressByUserId = async (userId) => {
  const response = await axiosClient.get(`/progress/user/${userId}`)
  return response.data
}
