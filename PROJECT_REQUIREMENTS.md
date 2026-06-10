# PROJECT REQUIREMENTS

## Tên đề tài
Hệ thống học tập trực tuyến với kiểm tra tập trung bằng webcam và quiz thích ứng.

---

# 1. Công nghệ sử dụng

## Frontend
- React.js
- Axios
- React Router
- TensorFlow.js
- face-api.js

## Backend
- Java Spring Boot
- Spring Data JPA
- REST API

## Database
- MySQL

## AI Webcam
- TensorFlow.js
- face-api.js

---

# 2. Mục tiêu hệ thống

Hệ thống học tập trực tuyến cho phép:
- Học viên xem video bài giảng
- Theo dõi mức độ tập trung bằng webcam
- Làm adaptive quiz sau bài học
- Tự động tăng/giảm level người học
- Sinh feedback học tập
- Admin quản lý khóa học, bài giảng và quiz

---

# 3. Chức năng chính

## 3.1 Người học (Student)

### Authentication
- Đăng ký
- Đăng nhập
- Đăng xuất

### Học tập
- Xem danh sách khóa học
- Xem video bài giảng
- Theo dõi tiến trình học
- Xem feedback sau bài học

### AI Webcam Focus Detection
- Mở webcam khi học
- Detect face realtime bằng face-api.js
- Detect:
  - focused
  - distracted
  - no_face
- Tính focus_score
- Gửi focus_logs về backend
- Không gửi ảnh/video webcam lên server

### Adaptive Quiz
- Làm quiz sau bài học
- Hệ thống chọn câu hỏi theo level:
  - basic
  - medium
  - hard
- Nếu trả lời đúng nhiều:
  - tăng current_level
- Nếu trả lời sai nhiều:
  - giảm current_level
  - yêu cầu học lại

---

## 3.2 Quản trị viên (Admin)

### Course Management
- CRUD khóa học
- CRUD bài giảng
- Upload video bài giảng

### Quiz Management
- CRUD câu hỏi
- Phân loại độ khó câu hỏi

### Dashboard
- Xem thống kê:
  - số học viên
  - tiến trình học
  - focus score
  - kết quả quiz
  - lượt xem bài học

---

# 4. Database Tables

## Core Tables
- users
- lessons
- questions
- quiz_attempts
- quiz_answers
- focus_logs

## Additional Tables
- courses
- file_storage
- feedbacks
- lesson_interactions
- learning_progress

---

# 5. AI Webcam Logic

## Frontend xử lý AI
React + face-api.js sẽ:
- mở webcam
- detect face realtime
- detect eye/head pose
- xác định trạng thái:
  - focused
  - distracted
  - no_face

## Backend xử lý dữ liệu
Spring Boot sẽ:
- nhận focus_logs
- lưu database
- phân tích dữ liệu
- sinh feedback

---

# 6. API Requirements

## Backend cần:
- REST API
- JSON response
- DTO pattern
- Service layer
- Repository layer
- Entity mapping đúng khóa ngoại

---

# 7. Coding Requirements

## Backend
- Spring Boot
- Spring Data JPA
- Không thay đổi database schema nếu chưa hỏi
- Tách module rõ ràng

## Frontend
- React component-based
- Axios gọi API
- Tách pages/components

---

# 8. Triển khai theo module

## Module 1
- Users/Auth

## Module 2
- Courses

## Module 3
- Lessons + FileStorage

## Module 4
- Questions

## Module 5
- QuizAttempts + QuizAnswers

## Module 6
- FocusLogs

## Module 7
- LearningProgress

## Module 8
- Feedbacks

## Module 9
- LessonInteractions

## Module 10
- Admin Dashboard

---

# 9. Workflow hệ thống

User học bài:
1. Login
2. Chọn khóa học
3. Xem video
4. Webcam detect focus
5. Làm adaptive quiz
6. Hệ thống cập nhật current_level
7. Sinh feedback
8. Lưu tiến trình học

---

# 10. Mục tiêu triển khai Codex

Codex cần:
- Triển khai theo từng module
- Không code toàn bộ cùng lúc
- Không tự ý sửa schema
- Giải thích file đã tạo
- Hướng dẫn cách chạy project