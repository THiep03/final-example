import { BrowserRouter, Route, Routes } from 'react-router-dom'
import { ROUTES } from '../constants/index.js'
import AdminCourseContentPage from '../pages/AdminCourseContentPage.jsx'
import AdminCoursesPage from '../pages/AdminCoursesPage.jsx'
import AdminDashboardPage from '../pages/AdminDashboardPage.jsx'
import AdminFilesPage from '../pages/AdminFilesPage.jsx'
import AdminLessonQuestionsPage from '../pages/AdminLessonQuestionsPage.jsx'
import AdminLessonsPage from '../pages/AdminLessonsPage.jsx'
import AdminQuestionsPage from '../pages/AdminQuestionsPage.jsx'
import AdminUsersPage from '../pages/AdminUsersPage.jsx'
import AppLayout from '../components/AppLayout.jsx'
import CourseDetailPage from '../pages/CourseDetailPage.jsx'
import CourseProgressDetailPage from '../pages/CourseProgressDetailPage.jsx'
import CoursesPage from '../pages/CoursesPage.jsx'
import FeedbackPage from '../pages/FeedbackPage.jsx'
import Home from '../pages/Home.jsx'
import LessonDetailPage from '../pages/LessonDetailPage.jsx'
import ChangePasswordPage from '../pages/ChangePasswordPage.jsx'
import Login from '../pages/Login.jsx'
import ProfilePage from '../pages/ProfilePage.jsx'
import QuizPage from '../pages/QuizPage.jsx'
import Register from '../pages/Register.jsx'
import StudentDashboardPage from '../pages/StudentDashboardPage.jsx'
import { ProtectedRoute, PublicOnlyRoute } from './RouteGuard.jsx'

function AppRoutes() {
  return (
    <BrowserRouter>
      <Routes>
        {/* auth pages — no navbar */}
        <Route element={<PublicOnlyRoute />}>
          <Route path={ROUTES.LOGIN} element={<Login />} />
          <Route path={ROUTES.REGISTER} element={<Register />} />
        </Route>

        <Route element={<AppLayout />}>
          <Route element={<ProtectedRoute />}>
            <Route path={ROUTES.HOME} element={<Home />} />
            <Route path={ROUTES.DASHBOARD} element={<StudentDashboardPage />} />
            <Route path="/dashboard/courses/:courseId/progress" element={<CourseProgressDetailPage />} />
            <Route path={ROUTES.COURSES} element={<CoursesPage />} />
            <Route path="/courses/:id" element={<CourseDetailPage />} />
            <Route path="/lessons/:id" element={<LessonDetailPage />} />
            <Route path="/quiz/:lessonId" element={<QuizPage />} />
            <Route path="/feedback/:attemptId" element={<FeedbackPage />} />
            <Route path={ROUTES.PROFILE} element={<ProfilePage />} />
            <Route path={ROUTES.CHANGE_PASSWORD} element={<ChangePasswordPage />} />
          </Route>

          <Route element={<ProtectedRoute requireAdmin />}>
            <Route path={ROUTES.ADMIN_DASHBOARD} element={<AdminDashboardPage />} />
            <Route path={ROUTES.ADMIN_COURSES} element={<AdminCoursesPage />} />
            <Route path="/admin/courses/:courseId/content" element={<AdminCourseContentPage />} />
            <Route path={ROUTES.ADMIN_LESSONS} element={<AdminLessonsPage />} />
            <Route path="/admin/lessons/:lessonId/questions" element={<AdminLessonQuestionsPage />} />
            <Route path={ROUTES.ADMIN_QUESTIONS} element={<AdminQuestionsPage />} />
            <Route path={ROUTES.ADMIN_FILES} element={<AdminFilesPage />} />
            <Route path={ROUTES.ADMIN_USERS} element={<AdminUsersPage />} />
          </Route>
        </Route>
      </Routes>
    </BrowserRouter>
  )
}

export default AppRoutes
