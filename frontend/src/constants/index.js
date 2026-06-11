export const STORAGE_KEYS = {
  USER: 'user',
  USER_ID: 'userId',
  TOKEN: 'token',
}

export const getLessonNoteKey = (userId, lessonId) => `lesson_note_${userId}_${lessonId}`

export const ROUTES = {
  HOME: '/',
  LOGIN: '/login',
  REGISTER: '/register',
  DASHBOARD: '/dashboard',
  COURSES: '/courses',
  PROFILE: '/profile',
  courseDetail: (id) => `/courses/${id}`,
  lessonDetail: (id) => `/lessons/${id}`,
  quizPage: (lessonId) => `/quiz/${lessonId}`,
  feedbackPage: (attemptId) => `/feedback/${attemptId}`,
  courseProgress: (courseId) => `/dashboard/courses/${courseId}/progress`,
  ADMIN_DASHBOARD: '/admin/dashboard',
  ADMIN_COURSES: '/admin/courses',
  ADMIN_LESSONS: '/admin/lessons',
  ADMIN_QUESTIONS: '/admin/questions',
  ADMIN_FILES: '/admin/files',
  adminCourseContent: (courseId) => `/admin/courses/${courseId}/content`,
  adminLessonQuestions: (lessonId) => `/admin/lessons/${lessonId}/questions`,
}

export const ROLES = {
  ADMIN: 'admin',
  STUDENT: 'student',
}

export const FOCUS_STATUS = {
  IDLE: 'idle',
  FOCUSED: 'focused',
  DISTRACTED: 'distracted',
  NO_FACE: 'no_face',
  DROWSY: 'drowsy',
}

export const FOCUS_SCORE = {
  GOOD: 70,
  MID: 40,
}

export const AI_CONFIG = {
  MODELS_URL: '/models',
  DETECTION_INTERVAL_MS: 2000,
  LOG_INTERVAL_MS: 15000,
  DISTRACT_ALERT_THRESHOLD: 3,
  EAR_THRESHOLD: 0.22,
  DROWSY_ALERT_THRESHOLD: 4,
}

export const DIFFICULTY = {
  BASIC: 'basic',
  MEDIUM: 'medium',
  HARD: 'hard',
}

export const QUIZ_CONFIG = {
  TOTAL_ADAPTIVE_QUESTIONS: 10,
  PASS_SCORE: 70,
}

export const ANSWER_OPTIONS = [
  { value: 'A', field: 'optionA' },
  { value: 'B', field: 'optionB' },
  { value: 'C', field: 'optionC' },
  { value: 'D', field: 'optionD' },
]

export const RECOMMENDATION = {
  NEXT_LESSON: 'next_lesson',
  REVIEW_LESSON: 'review_lesson',
  PRACTICE_MORE: 'practice_more',
}

export const CONTENT_STATUS = {
  DRAFT: 'draft',
  PUBLISHED: 'published',
}

export const API_BASE_URL = 'http://localhost:8080/api'
