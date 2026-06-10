import { BrowserRouter, Route, Routes } from 'react-router-dom'
import AdminDashboardPage from '../pages/AdminDashboardPage.jsx'
import AdminCourseContentPage from '../pages/AdminCourseContentPage.jsx'
import AdminCoursesPage from '../pages/AdminCoursesPage.jsx'
import AdminFilesPage from '../pages/AdminFilesPage.jsx'
import AdminLessonQuestionsPage from '../pages/AdminLessonQuestionsPage.jsx'
import AdminLessonsPage from '../pages/AdminLessonsPage.jsx'
import AdminQuestionsPage from '../pages/AdminQuestionsPage.jsx'
import AppLayout from '../components/AppLayout.jsx'
import CourseDetailPage from '../pages/CourseDetailPage.jsx'
import CourseProgressDetailPage from '../pages/CourseProgressDetailPage.jsx'
import CoursesPage from '../pages/CoursesPage.jsx'
import FeedbackPage from '../pages/FeedbackPage.jsx'
import Home from '../pages/Home.jsx'
import LessonDetailPage from '../pages/LessonDetailPage.jsx'
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
        <Route element={<AppLayout />}>
          <Route element={<ProtectedRoute />}>
            <Route path="/" element={<Home />} />
            <Route path="/dashboard" element={<StudentDashboardPage />} />
            <Route path="/dashboard/courses/:courseId/progress" element={<CourseProgressDetailPage />} />
            <Route path="/courses" element={<CoursesPage />} />
            <Route path="/courses/:id" element={<CourseDetailPage />} />
            <Route path="/lessons/:id" element={<LessonDetailPage />} />
            <Route path="/quiz/:lessonId" element={<QuizPage />} />
            <Route path="/feedback/:attemptId" element={<FeedbackPage />} />
            <Route path="/profile" element={<ProfilePage />} />
          </Route>

          <Route element={<ProtectedRoute requireAdmin />}>
            <Route path="/admin/dashboard" element={<AdminDashboardPage />} />
            <Route path="/admin/courses" element={<AdminCoursesPage />} />
            <Route path="/admin/courses/:courseId/content" element={<AdminCourseContentPage />} />
            <Route path="/admin/lessons" element={<AdminLessonsPage />} />
            <Route path="/admin/lessons/:lessonId/questions" element={<AdminLessonQuestionsPage />} />
            <Route path="/admin/questions" element={<AdminQuestionsPage />} />
            <Route path="/admin/files" element={<AdminFilesPage />} />
          </Route>

          <Route element={<PublicOnlyRoute />}>
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />
          </Route>
        </Route>
      </Routes>
    </BrowserRouter>
  )
}

export default AppRoutes
