# GIAI ĐOẠN 1 REPORT - Ổn định Core Project

Ngày thực hiện: 2026-06-09

## 1. File đã sửa/tạo

### Frontend

| File | Loại | Nội dung |
|---|---|---|
| `frontend/src/routes/RouteGuard.jsx` | Tạo mới | Thêm `ProtectedRoute` và `PublicOnlyRoute`. |
| `frontend/src/routes/AppRoutes.jsx` | Sửa | Bọc route bằng guard: yêu cầu login, chặn non-admin vào `/admin/*`, chặn user đã login vào `/login` và `/register`. |
| `frontend/src/api/userApi.js` | Sửa | Bỏ gọi `/api/users/me`, chuyển sang gọi `/api/users/{id}` bằng `userId` hiện có. |
| `frontend/src/api/axiosClient.js` | Sửa | Thêm interceptor chuẩn hóa lỗi API/network về `response.data.message`. |
| `frontend/src/pages/Login.jsx` | Sửa | Sau login lưu `user`, `userId`; redirect theo route cũ hoặc role; tránh student quay lại admin path. |
| `frontend/src/pages/Register.jsx` | Sửa | Sau register lưu `user`, `userId`; redirect an toàn về trang chủ. |
| `frontend/src/pages/ProfilePage.jsx` | Sửa | Chỉ tải profile khi có `userId`, không phụ thuộc token/auth context chưa tồn tại. |
| `frontend/src/components/Navbar.jsx` | Sửa | Logout xóa `user`, `userId`, `token`. |

### Backend

| File | Loại | Nội dung |
|---|---|---|
| `backend/src/main/java/com/datn/backend/dto/ApiErrorResponse.java` | Tạo mới | DTO lỗi chuẩn gồm `timestamp`, `status`, `error`, `message`, `path`, `errors`. |
| `backend/src/main/java/com/datn/backend/exception/GlobalExceptionHandler.java` | Tạo mới | Xử lý validation, constraint violation, `ResponseStatusException`, bad request và runtime exception. |

### Documentation

| File | Loại | Nội dung |
|---|---|---|
| `README.md` | Tạo mới | Hướng dẫn đề tài, stack, database, import SQL, chạy backend/frontend, tài khoản demo, test/build. |
| `GIAI_DOAN_1_REPORT.md` | Tạo mới | Báo cáo giai đoạn 1. |

## 2. Chức năng đã hoàn thành

### Route guard frontend

Đã hoàn thành:

- Chưa đăng nhập truy cập route chính sẽ bị redirect về `/login`.
- User không phải admin không được vào `/admin/*`.
- User đã login không vào lại được `/login` hoặc `/register`.
- Sau login, nếu có route đích trước đó thì redirect về route đó.
- Nếu student cố vào admin route rồi login, hệ thống redirect an toàn về `/`.

### Xử lý `/api/users/me`

Đã hoàn thành:

- Frontend không còn gọi `/api/users/me`.
- Profile dùng `userId` từ localStorage/session hiện tại để gọi `/api/users/{id}`.
- Không thêm fake auth context, không thêm JWT/Spring Security.

### Global Exception Handler backend

Đã hoàn thành response lỗi chuẩn:

```json
{
  "timestamp": "...",
  "status": 400,
  "error": "Bad Request",
  "message": "...",
  "path": "/api/..."
}
```

Với validation field error, response có thêm:

```json
{
  "errors": {
    "fieldName": "message"
  }
}
```

Các nhóm lỗi đã xử lý:

- Validation error: `MethodArgumentNotValidException`
- Constraint validation: `ConstraintViolationException`
- Not found / bad request / conflict từ `ResponseStatusException`
- `IllegalArgumentException`
- Runtime exception bất ngờ

### Chuẩn hóa lỗi frontend

Đã hoàn thành:

- Axios interceptor chuẩn hóa lỗi backend/network.
- Các page hiện có đang đọc `err.response?.data?.message` sẽ nhận message rõ ràng hơn.
- Network error không còn rơi vào trạng thái không có `response`.

### README

Đã hoàn thành:

- Giới thiệu đề tài.
- Công nghệ sử dụng.
- Cách tạo/import database.
- Cách chạy backend/frontend.
- Tài khoản demo.
- Lệnh lint/build/test.
- Ghi chú trạng thái hiện tại: chưa JWT/Spring Security, chưa Face-A.

## 3. Cách test từng chức năng

### Test route guard chưa đăng nhập

1. Mở DevTools/Application/Local Storage.
2. Xóa key `user`, `userId`, `token`.
3. Truy cập:

```text
http://localhost:5173/dashboard
http://localhost:5173/admin/dashboard
http://localhost:5173/courses
```

Kết quả mong đợi:

- Tự redirect về `/login`.

### Test route guard đã login

1. Login bằng student:

```text
an.student@example.com / 123456
```

2. Truy cập:

```text
http://localhost:5173/login
http://localhost:5173/register
```

Kết quả mong đợi:

- Không vào lại login/register.
- Redirect về trang học tập.

### Test admin guard

1. Login bằng student.
2. Truy cập:

```text
http://localhost:5173/admin/dashboard
```

Kết quả mong đợi:

- Không vào được admin, redirect về `/`.

3. Login bằng admin:

```text
admin@example.com / admin123
```

4. Truy cập `/admin/dashboard`.

Kết quả mong đợi:

- Vào được dashboard admin.

### Test Profile không dùng `/api/users/me`

1. Login bằng user bất kỳ.
2. Mở:

```text
http://localhost:5173/profile
```

Kết quả mong đợi:

- Profile gọi `/api/users/{id}`.
- Không còn request `/api/users/me`.
- Hiển thị tên, email, role, current level, ngày tạo.

### Test Global Exception Handler

Gửi request validation lỗi, ví dụ thiếu title:

```bash
curl -X POST http://localhost:8080/api/courses ^
  -H "Content-Type: application/json" ^
  -d "{\"title\":\"\",\"status\":\"invalid\"}"
```

Kết quả mong đợi:

- HTTP 400.
- Response JSON có `timestamp`, `status`, `error`, `message`, `path`, `errors`.

Test not found:

```bash
curl http://localhost:8080/api/courses/999999
```

Kết quả mong đợi:

- HTTP 404.
- Response JSON có message `Course not found`.

### Test build/lint/test

Frontend:

```bash
cd frontend
npm run lint
npm run build
```

Backend:

```bash
cd backend
mvn test
```

Kết quả đã chạy:

- `npm run lint`: PASS.
- `npm run build`: PASS.
- `mvn test`: PASS, 6 tests, 0 failures.

## 4. Lỗi hoặc giới hạn còn tồn tại

### Còn tồn tại

1. Route guard hiện tại chỉ là frontend guard dựa trên `localStorage.user`.
   - API backend admin vẫn chưa được bảo vệ thật.
   - Đây là giới hạn có chủ ý vì giai đoạn này không thêm Spring Security/JWT.

2. Password vẫn plain text.
   - Giữ nguyên theo yêu cầu giai đoạn hiện tại.

3. Chưa có `/api/users/me`.
   - Đã xử lý bằng cách bỏ gọi route này ở frontend.
   - Khi có auth thật, có thể bổ sung lại `/api/users/me`.

4. Face-A chưa tích hợp.
   - Webcam UI vẫn chỉ bật/tắt camera.
   - Chưa có `face-api.js`, detection loop, focus log tự động.

5. Global exception handler chưa log stack trace ra file/log system.
   - Hiện ưu tiên response JSON sạch cho frontend.

## 5. Giai đoạn tiếp theo nên làm gì

Theo roadmap audit, giai đoạn tiếp theo nên là **Giai đoạn 2 - Hoàn thiện Adaptive Quiz thật**:

1. Thêm API lấy câu hỏi quiz theo `users.current_level`.
2. QuizPage gọi API adaptive thay vì luôn lấy toàn bộ câu hỏi của lesson.
3. Bổ sung rule số câu hỏi mỗi lượt quiz.
4. Test tăng/giảm/giữ level:
   - score >= 80: tăng level
   - score < 50: giảm level
   - 50-79: giữ nguyên
5. Sau đó mới sang **Giai đoạn 3 - Face-A realtime focus detection**.
