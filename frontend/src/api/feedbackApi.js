import axiosClient from './axiosClient'
import { normalizeList, sameId } from '../utils/flowHelpers.js'

export const generateFeedback = async (payload) => {
  const response = await axiosClient.post('/feedbacks/generate', payload)
  return response.data
}

export const getFeedbacksByUserId = async (userId) => {
  const response = await axiosClient.get(`/feedbacks/user/${userId}`)
  return response.data
}

export const getFeedbackByAttemptId = async (attemptId, userId) => {
  const feedbacks = await getFeedbacksByUserId(userId)
  return normalizeList(feedbacks).find((feedback) => sameId(feedback.quizAttemptId, attemptId)) || null
}
