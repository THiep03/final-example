import axiosClient from './axiosClient'

export const getCurrentUserProfile = async ({ userId }) => {
  if (!userId) {
    throw new Error('Không tìm thấy thông tin người dùng đăng nhập.')
  }

  const response = await axiosClient.get(`/users/${userId}`)
  return response.data
}
