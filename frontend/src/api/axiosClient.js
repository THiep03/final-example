import axios from "axios";
import { API_BASE_URL, ROUTES, STORAGE_KEYS } from '../constants/index.js'

const axiosClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    "Content-Type": "application/json",
  },
});

function normalizeErrorMessage(error) {
  if (!error.response) {
    return 'Không thể kết nối tới máy chủ. Vui lòng kiểm tra backend và thử lại.'
  }

  const data = error.response.data

  if (data?.message) {
    return data.message
  }

  if (data?.errors && typeof data.errors === 'object') {
    return Object.values(data.errors).filter(Boolean).join(' ')
  }

  if (typeof data === 'string' && data.trim()) {
    return data
  }

  return 'Đã xảy ra lỗi khi xử lý yêu cầu. Vui lòng thử lại.'
}

axiosClient.interceptors.response.use(
  (response) => response,
  (error) => {
    const message = normalizeErrorMessage(error)

    if (!error.response) {
      error.response = {
        data: { message },
      }
    } else {
      error.response.data = {
        ...(typeof error.response.data === 'object' && error.response.data !== null ? error.response.data : {}),
        message,
      }

      if (error.response.status === 401) {
        localStorage.removeItem(STORAGE_KEYS.USER)
        localStorage.removeItem(STORAGE_KEYS.USER_ID)
        if (!window.location.pathname.startsWith(ROUTES.LOGIN)) {
          window.location.href = ROUTES.LOGIN
        }
      }
    }

    return Promise.reject(error)
  },
)

export default axiosClient;
