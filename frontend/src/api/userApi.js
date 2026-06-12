import axiosClient from './axiosClient'

export const getUsers = async () => {
  const response = await axiosClient.get('/users')
  return response.data
}

export const getCurrentUserProfile = async ({ userId }) => {
  if (!userId) throw new Error('Không tìm thấy thông tin người dùng đăng nhập.')
  const response = await axiosClient.get(`/users/${userId}`)
  return response.data
}

export const updateUser = async (id, data) => {
  const response = await axiosClient.put(`/users/${id}`, data)
  return response.data
}

export const deleteUser = async (id) => {
  await axiosClient.delete(`/users/${id}`)
}

export const uploadUserAvatar = async (userId, file) => {
  const formData = new FormData()
  formData.append('file', file)
  const response = await axiosClient.post(`/users/${userId}/avatar`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })
  return response.data
}

export const changePassword = async (userId, data) => {
  await axiosClient.post(`/users/${userId}/change-password`, data)
}
