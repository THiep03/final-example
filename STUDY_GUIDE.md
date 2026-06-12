# Tài liệu học tập — Hệ thống Học thích ứng (Adaptive Learning)

---

## MỤC LỤC

1. [Tổng quan dự án](#1-tổng-quan-dự-án)
2. [Công nghệ sử dụng](#2-công-nghệ-sử-dụng)
3. [Cấu trúc thư mục](#3-cấu-trúc-thư-mục)
4. [Database — Các bảng chính](#4-database--các-bảng-chính)
5. [Backend — Luồng xử lý](#5-backend--luồng-xử-lý)
6. [API Endpoints](#6-api-endpoints)
7. [Frontend — Các trang chính](#7-frontend--các-trang-chính)
8. [Tính năng đặc biệt](#8-tính-năng-đặc-biệt)
9. [Luồng hoạt động từ đầu đến cuối](#9-luồng-hoạt-động-từ-đầu-đến-cuối)
10. [Cấu hình & Chạy dự án](#10-cấu-hình--chạy-dự-án)

---

## 1. Tổng quan dự án

**Tên:** Hệ thống Học thích ứng (Adaptive Learning Platform)  
**Mục tiêu:** Nền tảng học online có khả năng theo dõi sự tập trung của người dùng qua camera và điều chỉnh độ khó bài kiểm tra tự động theo năng lực.

**Các tính năng cốt lõi:**
- Quản lý khóa học / bài học / câu hỏi
- Quiz thích ứng — độ khó tăng/giảm theo từng câu trả lời
- Theo dõi tập trung real-time qua camera (phát hiện buồn ngủ, mất tập trung)
- Dashboard thống kê cho học viên và admin
- Phân quyền: Student / Admin

---

## 2. Công nghệ sử dụng

| Thành phần | Công nghệ |
|---|---|
| Backend | Java 17 + Spring Boot 3.3.6 |
| ORM | Spring Data JPA + Hibernate |
| Database | MySQL |
| Bảo mật | Spring Security Crypto (BCrypt) |
| Frontend | React 19 + Vite 5 |
| Routing | React Router DOM 7 |
| HTTP Client | Axios |
| Face Detection | @vladmandic/face-api |
| File Upload | Spring Multipart (tối đa 500MB) |

---

## 3. Cấu trúc thư mục

```
final-example/
├── backend/
│   └── src/main/java/com/datn/backend/
│       ├── entity/          # JPA Entities (ánh xạ bảng DB)
│       ├── repository/      # Spring Data JPA Repositories
│       ├── service/         # Business logic
│       ├── controller/      # REST API Controllers
│       ├── dto/             # Request/Response objects
│       ├── config/          # CORS, file path config
│       └── exception/       # Exception handling
│
├── frontend/
│   └── src/
│       ├── pages/           # Các trang React
│       ├── components/      # Component dùng chung
│       ├── api/             # Hàm gọi API (axios)
│       ├── routes/          # Định nghĩa routes + guard
│       └── utils/           # Helper functions
│
└── uploads/                 # Thư mục lưu file video/ảnh
```

---

## 4. Database — Các bảng chính

### users
| Cột | Kiểu | Ghi chú |
|---|---|---|
| id | Long (PK) | Auto increment |
| name | String | Tối đa 100 ký tự |
| email | String | Unique, tối đa 150 |
| password | String | BCrypt hash |
| role | String | "student" / "admin" |
| currentLevel | String | "basic" / "medium" / "hard" |
| phone | String (20) | Số điện thoại (nullable) |
| dateOfBirth | Date | Ngày sinh (nullable) |
| gender | String (10) | "male" / "female" / "other" (nullable) |
| school | String (255) | Trường học / đơn vị (nullable) |
| bio | TEXT | Giới thiệu bản thân (nullable) |
| avatarUrl | String (500) | URL ảnh đại diện — lưu qua FileStorageService |
| createdAt / updatedAt | LocalDateTime | |

### courses
| Cột | Kiểu | Ghi chú |
|---|---|---|
| id | Long (PK) | |
| title | String | Bắt buộc |
| description | TEXT | |
| thumbnailUrl | String | URL ảnh đại diện |
| status | String | "draft" / "published" |

### lessons
| Cột | Kiểu | Ghi chú |
|---|---|---|
| id | Long (PK) | |
| courseId | FK → courses | |
| videoFileId | FK → file_storage | |
| title | String | |
| videoUrl | String | |
| duration | Integer | Tính bằng giây |
| orderNumber | Integer | Thứ tự bài học |

### questions
| Cột | Kiểu | Ghi chú |
|---|---|---|
| id | Long (PK) | |
| lessonId | FK → lessons | |
| questionContent | TEXT | |
| optionA/B/C/D | String | 4 đáp án |
| correctAnswer | String | "A" / "B" / "C" / "D" |
| difficultyLevel | String | "basic" / "medium" / "hard" |

### quiz_attempts
| Cột | Kiểu | Ghi chú |
|---|---|---|
| id | Long (PK) | |
| userId | FK → users | |
| lessonId | FK → lessons | |
| score | Float | Phần trăm 0–100 |
| totalQuestions | Integer | |
| correctAnswers | Integer | |
| resultStatus | String | "pass" (≥70) / "fail" |
| startedAt / finishedAt | LocalDateTime | |

### quiz_answers
| Cột | Kiểu | Ghi chú |
|---|---|---|
| quizAttemptId | FK → quiz_attempts | |
| questionId | FK → questions | |
| selectedAnswer | String | Đáp án người dùng chọn |
| responseTimeSeconds | Integer | Thời gian trả lời |
| isCorrect | Boolean | |
| difficultyLevel | String | Độ khó lúc trả lời |

### focus_logs
| Cột | Kiểu | Ghi chú |
|---|---|---|
| userId | FK → users | |
| lessonId | FK → lessons | |
| status | String | "focused" / "distracted" / "drowsy" / "no_face" |
| focusScore | Float | Điểm tập trung 0–100 |
| recordedAt | LocalDateTime | |

### learning_progress
| Cột | Kiểu | Ghi chú |
|---|---|---|
| userId | FK → users | |
| lessonId | FK → lessons | |
| progressPercent | Float | % video đã xem |
| isCompleted | Boolean | |
| completedAt | LocalDateTime | |

### feedbacks
| Cột | Kiểu | Ghi chú |
|---|---|---|
| userId / lessonId | FK | |
| focusScore | Float | Điểm tập trung bài học |
| quizScore | Float | Điểm quiz |
| recommendation | String | Khuyến nghị học tập |
| message | TEXT | Nội dung phản hồi |

---

## 5. Backend — Luồng xử lý

### Kiến trúc tầng (Layered Architecture)

```
Request → Controller → Service → Repository → Database
                              ↓
                           Entity/DTO
```

### Các Service quan trọng

**AuthService**
- `register()` → kiểm tra email trùng → hash password BCrypt → lưu user
- `login()` → tìm email → so sánh password BCrypt → trả UserResponse

**QuizService — Quiz thích ứng**
```
startAdaptiveQuiz()
  → tạo QuizAttempt
  → lấy câu hỏi đầu tiên độ khó "basic"

answerAdaptiveQuestion()
  → lưu QuizAnswer
  → tính nextDifficulty:
      Đúng + nhanh  → tăng độ khó
      Đúng + chậm   → giữ nguyên
      Sai  + nhanh  → giảm độ khó
      Sai  + chậm   → giảm độ khó
  → lấy câu hỏi tiếp theo theo độ khó mới
  → nếu đủ số câu → tính điểm, đánh dấu hoàn thành
```

**Quy tắc Pass/Fail:**
```java
float PASS_SCORE = 70.0F;
score = (correctAnswers / totalQuestions) * 100
resultStatus = score >= 70 ? "pass" : "fail"
```

**FocusLogService**
- Nhận log từ frontend mỗi 15 giây
- Tính focusScore trung bình theo session
- Kết hợp với quizScore để sinh feedback

**DashboardService**
- Tổng hợp toàn bộ thống kê hệ thống (admin)
- Dashboard cá nhân (user): progress, quiz, focus

---

## 6. API Endpoints

### Auth
```
POST /api/auth/register    Đăng ký
POST /api/auth/login       Đăng nhập
```

### Courses
```
GET    /api/courses                  Danh sách khóa học
GET    /api/courses/trending         Top khóa học xu hướng
GET    /api/courses/{id}             Chi tiết khóa học
POST   /api/courses                  Tạo khóa học
PUT    /api/courses/{id}             Cập nhật
DELETE /api/courses/{id}             Xóa
```

### Lessons
```
GET    /api/lessons                  Danh sách bài học
GET    /api/lessons/{id}             Chi tiết + câu hỏi
POST   /api/lessons                  Tạo bài học
PUT    /api/lessons/{id}             Cập nhật
DELETE /api/lessons/{id}             Xóa
```

### Quiz
```
POST /api/quiz/start                 Bắt đầu quiz thường
POST /api/quiz/submit                Nộp bài quiz thường
POST /api/quiz/adaptive/start        Bắt đầu quiz thích ứng
POST /api/quiz/adaptive/answer       Trả lời từng câu (adaptive)
GET  /api/quiz/attempts/{id}         Kết quả một lần thi
GET  /api/quiz/user/{userId}         Lịch sử thi của user
```

### Progress & Interaction
```
POST /api/progress/start                            Bắt đầu học bài
PUT  /api/progress/complete                         Hoàn thành bài
GET  /api/progress/user/{userId}                    Progress của user
POST /api/lesson-interactions                       Like/dislike/view
GET  /api/lesson-interactions/lesson/{id}/stats     Thống kê tương tác
```

### Focus & Feedback
```
POST /api/focus-logs                                Lưu log tập trung
GET  /api/focus-logs/user/{userId}                  Log của user
POST /api/feedbacks/generate                        Tạo feedback
GET  /api/feedbacks/user/{userId}                   Feedback của user
```

### Users (hồ sơ & mật khẩu)
```
GET    /api/users/{id}               Lấy thông tin người dùng
PUT    /api/users/{id}               Cập nhật hồ sơ (name, phone, dateOfBirth, gender, school, bio)
POST   /api/users/{id}/avatar        Upload ảnh đại diện (multipart/form-data, field: file)
POST   /api/users/{id}/change-password  Đổi mật khẩu (oldPassword, newPassword)
GET    /api/users                    Danh sách tất cả users (admin)
```

### Admin
```
GET /api/admin/dashboard/summary                    Thống kê tổng quan
GET /api/dashboard/users/{userId}                   Dashboard học viên
```

---

## 7. Frontend — Các trang chính

### Phân quyền Routes

```
Public (chưa đăng nhập):
  /login          Đăng nhập
  /register       Đăng ký

Student (đã đăng nhập):
  /               Trang chủ
  /courses        Danh sách khóa học
  /courses/:id    Chi tiết khóa học
  /lessons/:id    Xem bài học + camera
  /quiz/:lessonId Làm quiz thích ứng
  /dashboard      Dashboard cá nhân
  /profile        Hồ sơ + chỉnh sửa + upload avatar
  /change-password  Đổi mật khẩu

Admin:
  /admin/dashboard              Thống kê hệ thống
  /admin/users                  Quản lý người dùng (xem, sửa, upload avatar)
  /admin/courses                Quản lý khóa học
  /admin/courses/:id/content    Nội dung khóa học
  /admin/lessons                Quản lý bài học
  /admin/lessons/:id/questions  Quản lý câu hỏi
  /admin/questions              Pool câu hỏi
  /admin/files                  Quản lý file
```

### Trang quan trọng

**ProfilePage.jsx** — Hồ sơ người dùng
- Hiển thị + chỉnh sửa 6 trường: name, phone, dateOfBirth, gender, school, bio
- Avatar: click vào vòng tròn → chọn ảnh → upload ngay `POST /api/users/{id}/avatar`
- Preview ảnh tức thì; nếu chưa có avatar hiển thị chữ cái đầu của tên
- Sau khi upload → gọi `syncUserToStorage({ avatarUrl })` → dispatch custom event `userUpdated`
- Navbar lắng nghe sự kiện `userUpdated` và re-render avatar

**ChangePasswordPage.jsx** — Đổi mật khẩu
- Layout giống Login (auth-scene, cinematic dark)
- 3 trường: mật khẩu cũ, mật khẩu mới, xác nhận
- Thanh strength bar cho mật khẩu mới
- Validate confirm client-side trước khi gọi API
- Thành công → tự động redirect về /profile sau 2 giây

**Navbar.jsx** — Đồng bộ avatar
- `const [user, setUser] = useState(getStoredUser)` — state thay vì const
- `useEffect` lắng nghe `window.addEventListener('userUpdated', refresh)`
- Hiển thị `<img>` nếu có avatarUrl, hoặc chữ cái đầu (initials)

**AdminUsersPage.jsx** — Quản lý người dùng (Admin)
- Bảng danh sách: cột avatar (ảnh hoặc initials), tên, email + phone, school, role
- Click "Sửa" → form 9 trường (name, email, phone, dateOfBirth, gender, role, school, currentLevel, bio)
- Khu vực avatar: preview 88px + nút chọn file + tên file
- Submit: upload avatar trước (nếu chọn file mới) → gọi `updateUser()`

**LessonDetailPage.jsx** — Phức tạp nhất
- Phát video bài học
- Chạy face-api.js qua webcam, detect mỗi 2 giây
- Lưu focus log mỗi 15 giây
- Cập nhật learning progress theo % video đã xem
- Cho like / dislike bài học

**QuizPage.jsx** — Quiz thích ứng
- Gọi `startAdaptiveQuiz` → nhận câu đầu tiên
- Mỗi câu trả lời → gọi `answerAdaptiveQuestion` → nhận câu tiếp theo
- Theo dõi thời gian trả lời từng câu
- Khi `isFinished = true` → hiện kết quả + link feedback

**AdminCoursesPage.jsx / AdminLessonsPage.jsx / AdminQuestionsPage.jsx**
- Form thêm ở trên, bảng danh sách ở dưới
- Click "Sửa" → cuộn về đầu trang + điền dữ liệu vào form
- Click "Hủy" → reset form

### Session / Auth
```javascript
// Đăng nhập → lưu vào localStorage
localStorage.setItem('user', JSON.stringify(userResponse))
localStorage.setItem('userId', userResponse.id)

// Đọc lại ở các trang
const user = JSON.parse(localStorage.getItem('user'))
const userId = localStorage.getItem('userId')

// Đăng xuất
localStorage.removeItem('user')
localStorage.removeItem('userId')

// Cập nhật localStorage + đồng bộ Navbar (syncUserToStorage)
function syncUserToStorage(updatedFields) {
  const current = JSON.parse(localStorage.getItem('user') || '{}')
  const merged = { ...current, ...updatedFields }
  localStorage.setItem('user', JSON.stringify(merged))
  window.dispatchEvent(new CustomEvent('userUpdated'))
}
```

---

## 8. Tính năng đặc biệt

### 8.1 Quiz thích ứng (Adaptive Quiz)

```
Bắt đầu: độ khó = "basic"

Sau mỗi câu:
┌─────────────────────────────────────────────┐
│  Đúng + thời gian ngắn  → tăng lên "medium" │
│  Đúng + thời gian dài   → giữ nguyên        │
│  Sai  + bất kỳ          → giảm xuống        │
└─────────────────────────────────────────────┘

Thang độ khó: basic → medium → hard
Kết thúc khi đủ số câu (mặc định totalQuestions)
```

### 8.2 Phát hiện tập trung (Focus Detection)

Dùng thư viện `@vladmandic/face-api` với các mô hình ML lưu tại `public/models/`.

```
Mỗi 2 giây:
  1. Chụp frame từ webcam
  2. Phát hiện khuôn mặt
     → Không có mặt → status = "no_face"
  3. Tính EAR (Eye Aspect Ratio)
     → EAR < 0.22 → mắt nhắm → đếm frame
     → Đủ 4 frame nhắm mắt → status = "drowsy"
  4. Ước tính hướng đầu (head pose)
     → Quay ngoài → status = "distracted"
  5. Bình thường → status = "focused"

Mỗi 15 giây:
  → Tính focusScore trung bình
  → Gọi POST /api/focus-logs
```

Hằng số:
```javascript
DETECTION_INTERVAL_MS   = 2000   // Phát hiện mỗi 2s
LOG_INTERVAL_MS         = 15000  // Lưu log mỗi 15s
EAR_THRESHOLD           = 0.22   // Ngưỡng mắt nhắm
DISTRACT_ALERT_THRESHOLD = 3     // Số frame mất tập trung
DROWSY_ALERT_THRESHOLD   = 4     // Số frame buồn ngủ
```

### 8.3 Trending Courses

Điểm trending tính từ:
```
trendScore = (tổng views × 1) + (tổng likes × 3) - (tổng dislikes × 1)
```

### 8.4 Feedback tự động

Sau khi hoàn thành bài học + quiz:
```
focusScore   = trung bình tất cả focus_logs của session
quizScore    = điểm quiz vừa làm
recommendation = dựa trên tổ hợp hai điểm trên
```

### 8.5 Hồ sơ người dùng mở rộng

Bảng `users` có thêm 6 trường mở rộng ngoài thông tin đăng nhập cơ bản:

```
phone, dateOfBirth, gender, school, bio, avatarUrl
```

Tất cả là nullable — người dùng điền dần, không bắt buộc khi đăng ký.

API cập nhật hồ sơ: `PUT /api/users/{id}` nhận `UserUpdateRequest` (DTO với 6 trường trên).

### 8.6 Upload ảnh đại diện (Avatar)

**Endpoint:** `POST /api/users/{id}/avatar` — `multipart/form-data`, field tên `file`

**Backend:**
```java
// AuthService.updateAvatar()
String url = fileStorageService.uploadFile(file, "image")  // reuse FileStorageService
user.setAvatarUrl(url)
userRepository.save(user)
```

**Frontend — cross-component sync:**
```
ProfilePage upload avatar
  → uploadUserAvatar(userId, file)         [API call]
  → syncUserToStorage({ avatarUrl })       [patch localStorage]
  → dispatch CustomEvent('userUpdated')    [broadcast]
  ← Navbar nhận event → setUser(getStoredUser()) [re-render avatar]
```

Lý do dùng custom event thay localStorage event: `storage` event chỉ fire ở tab khác, không fire trong cùng tab.

---

## 9. Luồng hoạt động từ đầu đến cuối

### Luồng học viên học một bài:

```
1. Đăng nhập
   POST /api/auth/login → lưu userId vào localStorage

2. Vào trang khóa học → chọn bài học
   GET /api/courses, /api/lessons

3. Xem bài học (LessonDetailPage)
   POST /api/progress/start         ← đánh dấu bắt đầu học
   POST /api/lesson-interactions    ← ghi nhận "view"
   [Camera bật] → detect mỗi 2s → log mỗi 15s
   POST /api/focus-logs             ← lưu trạng thái tập trung

4. Xong video
   PUT /api/progress/complete       ← đánh dấu hoàn thành

5. Làm quiz (QuizPage)
   POST /api/quiz/adaptive/start    ← lấy câu hỏi đầu tiên
   POST /api/quiz/adaptive/answer   ← trả lời từng câu (lặp)
   [isFinished = true]
   POST /api/feedbacks/generate     ← tạo feedback

6. Xem kết quả + feedback
   GET /api/quiz/attempts/{id}
   GET /api/feedbacks/...
```

### Luồng admin quản lý nội dung:

```
1. Vào /admin/courses → thêm khóa học
   POST /api/courses

2. Vào "Quản lý nội dung" khóa học → thêm bài học
   POST /api/lessons (upload video)
   POST /api/files   (lưu file)

3. Vào bài học → thêm câu hỏi
   POST /api/questions

4. Xuất bản khóa học
   PUT /api/courses/{id} → status = "published"
```

---

## 10. Cấu hình & Chạy dự án

### Database — Dùng scripts/ (khuyến nghị)

```
scripts/
├── 01_schema.sql         Tạo database + toàn bộ bảng (chạy đầu tiên)
├── 02_migrations.sql     ALTER TABLE cho DB đã tồn tại trước (bỏ qua nếu tạo mới)
├── 03_seed_sample.sql    Dữ liệu mẫu cơ bản (3 user, 2 khóa học)
├── 04_seed_it_courses.sql  6 khóa IT, 36 bài học, 360 câu hỏi
├── 05_seed_videos.sql    36 video YouTube cho 36 bài học
├── run_all.bat           Chạy toàn bộ (Windows)
└── run_all.sh            Chạy toàn bộ (Linux/Mac)
```

```bash
# Windows — chạy một lệnh
scripts\run_all.bat localhost root matkhau

# Linux/Mac
chmod +x scripts/run_all.sh
./scripts/run_all.sh localhost root matkhau

# Hoặc thủ công từng file
mysql -u root -p adaptive_learning_db < scripts/01_schema.sql
mysql -u root -p adaptive_learning_db < scripts/03_seed_sample.sql
```

**Nếu DB đã tồn tại** (upgrade thêm cột mới):
```bash
mysql -u root -p < scripts/02_migrations.sql
```

### Backend
```bash
cd backend
# Tạo database trước
mysql -u root -p
CREATE DATABASE adaptive_learning_db;

# Chạy ứng dụng
mvn spring-boot:run
# → http://localhost:8080
```

**application.properties:**
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/adaptive_learning_db
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD
spring.jpa.hibernate.ddl-auto=none
server.port=8080
spring.servlet.multipart.max-file-size=500MB
```

### Frontend
```bash
cd frontend
npm install
npm run dev
# → http://localhost:5173 (cố định, strictPort=true)
```

**vite.config.js:**
```javascript
server: {
  port: 5173,
  strictPort: true   // Báo lỗi nếu cổng bị chiếm, không tự nhảy cổng khác
}
```

**CORS (CorsConfig.java):** chỉ cho phép `http://localhost:5173`

### Nếu lỗi "Port 5173 is already in use":
```powershell
# Tìm process đang dùng cổng 5173
Get-NetTCPConnection -LocalPort 5173 | Select OwningProcess
# Tắt process đó
Stop-Process -Id <PID> -Force
# Chạy lại npm run dev
```

---

## Tóm tắt nhanh để ôn thi

| Câu hỏi | Trả lời |
|---|---|
| Backend dùng gì? | Spring Boot 3, Java 17, JPA, MySQL |
| Frontend dùng gì? | React 19, Vite 5, Axios, React Router 7 |
| Auth hoạt động thế nào? | BCrypt hash, lưu session bằng localStorage |
| Quiz thích ứng là gì? | Độ khó câu hỏi tăng/giảm theo đúng/sai + thời gian |
| Pass quiz khi nào? | Score ≥ 70% |
| Focus detection dùng gì? | face-api.js, phát hiện mắt nhắm + hướng đầu |
| Log focus lưu bao lâu 1 lần? | 15 giây |
| Detect focus bao lâu 1 lần? | 2 giây |
| File upload tối đa? | 500MB |
| Port frontend? | 5173 (cố định) |
| Port backend? | 8080 |
| Avatar upload endpoint? | POST /api/users/{id}/avatar (multipart/form-data) |
| Đổi mật khẩu endpoint? | POST /api/users/{id}/change-password |
| Navbar re-render avatar thế nào? | Lắng nghe custom event `userUpdated` dispatch từ ProfilePage |
| Bảng users có những trường profile nào? | phone, dateOfBirth, gender, school, bio, avatarUrl |
| Chạy DB nhanh? | scripts\run_all.bat (Windows) / run_all.sh (Linux/Mac) |
| DB có mấy bảng? | 11 bảng (users, courses, lessons, questions, quiz_attempts, quiz_answers, focus_logs, feedbacks, learning_progress, lesson_interactions, file_storage) |
