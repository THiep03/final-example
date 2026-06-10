import axiosClient from './axiosClient'

export const getDashboardSummary = async () => {
  const response = await axiosClient.get('/admin/dashboard/summary')
  return response.data
}

export const getUserDashboard = async (userId) => {
  const response = await axiosClient.get(`/dashboard/users/${userId}`)
  return response.data
}
