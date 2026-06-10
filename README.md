# Hệ thống học tập thích ứng

Đây là đồ án xây dựng nền tảng học tập trực tuyến có quiz thích ứng, theo dõi tiến trình học, dashboard cho học viên/quản trị viên và nền tảng backend cho việc tích hợp Webcam Focus/Face-A ở giai đoạn sau.

## Công nghệ sử dụng

### Backend

- Java 17
- Spring Boot 3.3.6
- Spring Web
- Spring Data JPA
- Jakarta Validation
- MySQL
- Maven

### Frontend

- React 19
- Vite
- React Router
- Axios
- CSS thuần

### Database

- MySQL
- Schema chính: `database.sql`
- Dữ liệu mẫu: `sample_data.sql`

## Cấu trúc chính

```text
D:\DATN
├── backend
├── frontend
├── database.sql
├── sample_data.sql
├── PROJECT_REQUIREMENTS.md
└── PROJECT_AUDIT.md
```

## Tạo database MySQL

Đăng nhập MySQL:

```bash
mysql -u root -p
```

Import schema:

```bash
mysql -u root -p < database.sql
```

Import dữ liệu mẫu:

```bash
mysql -u root -p adaptive_learning_db < sample_data.sql
```

Database mặc định trong backend:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/adaptive_learning_db
spring.datasource.username=root
spring.datasource.password=123456
```

Nếu máy dùng mật khẩu khác, sửa file:

```text
backend/src/main/resources/application.properties
```

## Chạy backend

```bash
cd backend
mvn spring-boot:run
```

Backend chạy tại:

```text
http://localhost:8080
```

API base URL:

```text
http://localhost:8080/api
```

File upload local được phục vụ qua:

```text
http://localhost:8080/uploads/...
```

## Chạy frontend

Cài dependency:

```bash
cd frontend
npm install
```

Chạy dev server:

```bash
npm run dev
```

Frontend chạy tại:

```text
http://localhost:5173
```

## Tài khoản demo

Dữ liệu mẫu trong `sample_data.sql` có các tài khoản:

| Vai trò | Email | Password |
|---|---|---|
| Học viên | `an.student@example.com` | `123456` |
| Học viên | `binh.student@example.com` | `123456` |
| Admin | `admin@example.com` | `admin123` |

## Lệnh kiểm tra

Frontend lint:

```bash
cd frontend
npm run lint
```

Frontend build:

```bash
cd frontend
npm run build
```

Backend test:

```bash
cd backend
mvn test
```

## Flow demo chính

### Học viên

1. Đăng nhập.
2. Xem danh sách khóa học.
3. Mở chi tiết khóa học.
4. Xem bài học/video.
5. Bật/tắt webcam focus UI.
6. Đánh dấu hoàn thành bài học.
7. Làm quiz.
8. Xem feedback.
9. Xem dashboard học tập.

### Admin

1. Đăng nhập bằng tài khoản admin.
2. Mở dashboard admin.
3. Tạo/sửa/xóa khóa học.
4. Upload ảnh đại diện khóa học.
5. Tạo/sửa/xóa bài học.
6. Upload video bài học.
7. Tạo/sửa/xóa câu hỏi quiz.
8. Quản lý file upload local.

## Ghi chú hiện tại

- Hệ thống chưa dùng Spring Security/JWT.
- Password đang để plain text để dễ test theo yêu cầu giai đoạn đầu.
- Route guard frontend dựa trên `localStorage.user`.
- Webcam hiện mới là UI bật/tắt camera, chưa tích hợp `face-api.js`.
- Focus logs backend đã có API, nhưng frontend chưa tự gửi log từ AI.
