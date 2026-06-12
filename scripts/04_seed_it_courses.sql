-- =============================================================
-- 04_seed_it_courses.sql
-- 6 khóa IT, 36 bài học, 360 câu hỏi quiz (adaptive)
-- Chạy sau 01_schema.sql
-- =============================================================
SET NAMES utf8mb4;
USE adaptive_learning_db;

START TRANSACTION;

-- ==================================================
-- IT COURSES SEED DATA FOR ADAPTIVE QUIZ TESTING
-- 6 courses, 36 lessons, 360 questions
-- Difficulty distribution per lesson: 4 basic, 3 medium, 3 hard
-- ==================================================

-- =========================
-- COURSES
-- =========================
INSERT INTO courses (title, description, thumbnail_url, status, created_at, updated_at)
SELECT 'Lập trình Java cơ bản', 'Khóa học nền tảng giúp người học nắm cú pháp Java, tư duy lập trình và các khái niệm hướng đối tượng để xây dựng chương trình Java cơ bản.', NULL, 'published', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE title = 'Lập trình Java cơ bản');

INSERT INTO courses (title, description, thumbnail_url, status, created_at, updated_at)
SELECT 'Cơ sở dữ liệu MySQL', 'Khóa học cung cấp kiến thức về cơ sở dữ liệu quan hệ, truy vấn SQL, thiết kế bảng và tối ưu truy vấn bằng MySQL.', NULL, 'published', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE title = 'Cơ sở dữ liệu MySQL');

INSERT INTO courses (title, description, thumbnail_url, status, created_at, updated_at)
SELECT 'Phát triển Web Frontend với React', 'Khóa học hướng dẫn xây dựng giao diện web hiện đại bằng React, component, state, router, axios và form.', NULL, 'published', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE title = 'Phát triển Web Frontend với React');

INSERT INTO courses (title, description, thumbnail_url, status, created_at, updated_at)
SELECT 'Lập trình Backend với Spring Boot', 'Khóa học giúp xây dựng REST API bằng Spring Boot, phân lớp controller service repository, JPA, DTO, validation và xử lý lỗi.', NULL, 'published', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE title = 'Lập trình Backend với Spring Boot');

INSERT INTO courses (title, description, thumbnail_url, status, created_at, updated_at)
SELECT 'Nhập môn Trí tuệ nhân tạo', 'Khóa học nhập môn AI, machine learning, dữ liệu huấn luyện, nhận diện khuôn mặt, đánh giá mô hình và đạo đức dữ liệu.', NULL, 'published', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE title = 'Nhập môn Trí tuệ nhân tạo');

INSERT INTO courses (title, description, thumbnail_url, status, created_at, updated_at)
SELECT 'Phân tích và Thiết kế Hệ thống Thông tin', 'Khóa học hướng dẫn khảo sát yêu cầu, use case, ERD, thiết kế UI/UX, kiểm thử và triển khai hệ thống thông tin.', NULL, 'published', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE title = 'Phân tích và Thiết kế Hệ thống Thông tin');

-- =========================
-- LESSONS
-- =========================
INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Giới thiệu Java và môi trường phát triển', 'Tìm hiểu vai trò của Java, JDK, IDE và cách chạy chương trình Java đầu tiên.', NULL, 35, 1, NOW(), NOW()
FROM courses c
WHERE c.title = 'Lập trình Java cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Giới thiệu Java và môi trường phát triển'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Biến, kiểu dữ liệu và toán tử', 'Học cách khai báo biến, chọn kiểu dữ liệu phù hợp và sử dụng toán tử trong biểu thức Java.', NULL, 40, 2, NOW(), NOW()
FROM courses c
WHERE c.title = 'Lập trình Java cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Biến, kiểu dữ liệu và toán tử'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Câu lệnh điều kiện và vòng lặp', 'Thực hành if, switch, for, while để điều khiển luồng chạy của chương trình.', NULL, 45, 3, NOW(), NOW()
FROM courses c
WHERE c.title = 'Lập trình Java cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Câu lệnh điều kiện và vòng lặp'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Mảng và String', 'Làm việc với mảng, chỉ số phần tử, duyệt dữ liệu và các thao tác thường gặp với String.', NULL, 45, 4, NOW(), NOW()
FROM courses c
WHERE c.title = 'Lập trình Java cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Mảng và String'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Lập trình hướng đối tượng', 'Nắm class, object, constructor, method, đóng gói và quan hệ giữa các đối tượng.', NULL, 50, 5, NOW(), NOW()
FROM courses c
WHERE c.title = 'Lập trình Java cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Lập trình hướng đối tượng'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Xử lý ngoại lệ và Collection', 'Tìm hiểu try-catch, exception, List, Set, Map và cách xử lý tập dữ liệu linh hoạt.', NULL, 50, 6, NOW(), NOW()
FROM courses c
WHERE c.title = 'Lập trình Java cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Xử lý ngoại lệ và Collection'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Tổng quan cơ sở dữ liệu quan hệ', 'Giới thiệu bảng, hàng, cột, khóa và cách dữ liệu quan hệ được tổ chức.', NULL, 35, 1, NOW(), NOW()
FROM courses c
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Tổng quan cơ sở dữ liệu quan hệ'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Tạo database, table và kiểu dữ liệu', 'Thực hành CREATE DATABASE, CREATE TABLE và lựa chọn kiểu dữ liệu phù hợp.', NULL, 40, 2, NOW(), NOW()
FROM courses c
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Tạo database, table và kiểu dữ liệu'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'SELECT, WHERE, ORDER BY', 'Học cách truy vấn dữ liệu, lọc bản ghi và sắp xếp kết quả.', NULL, 40, 3, NOW(), NOW()
FROM courses c
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'SELECT, WHERE, ORDER BY'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'JOIN và quan hệ bảng', 'Tìm hiểu khóa ngoại và cách JOIN dữ liệu từ nhiều bảng.', NULL, 45, 4, NOW(), NOW()
FROM courses c
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'JOIN và quan hệ bảng'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'GROUP BY, HAVING và Aggregate Functions', 'Thống kê dữ liệu với COUNT, AVG, SUM, GROUP BY và HAVING.', NULL, 45, 5, NOW(), NOW()
FROM courses c
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'GROUP BY, HAVING và Aggregate Functions'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Index, khóa chính, khóa ngoại và tối ưu truy vấn', 'Học vai trò của index, primary key, foreign key và cách đọc tư duy tối ưu truy vấn.', NULL, 50, 6, NOW(), NOW()
FROM courses c
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Index, khóa chính, khóa ngoại và tối ưu truy vấn'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'HTML, CSS, JavaScript trong ứng dụng web', 'Ôn lại vai trò của HTML, CSS, JavaScript trong cấu trúc, giao diện và hành vi của web app.', NULL, 35, 1, NOW(), NOW()
FROM courses c
WHERE c.title = 'Phát triển Web Frontend với React'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'HTML, CSS, JavaScript trong ứng dụng web'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Component và JSX', 'Tìm hiểu component, JSX và cách chia giao diện thành phần tái sử dụng.', NULL, 40, 2, NOW(), NOW()
FROM courses c
WHERE c.title = 'Phát triển Web Frontend với React'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Component và JSX'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Props, State và Event Handling', 'Học cách truyền dữ liệu bằng props, quản lý state và xử lý sự kiện người dùng.', NULL, 45, 3, NOW(), NOW()
FROM courses c
WHERE c.title = 'Phát triển Web Frontend với React'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Props, State và Event Handling'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'React Router và điều hướng', 'Thiết lập route, Link, useParams và điều hướng giữa các trang.', NULL, 40, 4, NOW(), NOW()
FROM courses c
WHERE c.title = 'Phát triển Web Frontend với React'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'React Router và điều hướng'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Gọi API bằng Axios', 'Thực hành axiosClient, gọi REST API, xử lý loading và error.', NULL, 45, 5, NOW(), NOW()
FROM courses c
WHERE c.title = 'Phát triển Web Frontend với React'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Gọi API bằng Axios'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Quản lý Form và hiển thị dữ liệu', 'Xây dựng form controlled component, validate cơ bản và hiển thị dữ liệu dạng list hoặc card.', NULL, 45, 6, NOW(), NOW()
FROM courses c
WHERE c.title = 'Phát triển Web Frontend với React'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Quản lý Form và hiển thị dữ liệu'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Tổng quan Spring Boot và REST API', 'Giới thiệu Spring Boot, cấu trúc ứng dụng và nguyên tắc thiết kế REST API.', NULL, 35, 1, NOW(), NOW()
FROM courses c
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Tổng quan Spring Boot và REST API'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Controller, Service, Repository', 'Tổ chức code theo layer controller, service, repository để tách trách nhiệm.', NULL, 40, 2, NOW(), NOW()
FROM courses c
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Controller, Service, Repository'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Entity và Spring Data JPA', 'Map bảng database sang entity và thao tác dữ liệu bằng Spring Data JPA.', NULL, 45, 3, NOW(), NOW()
FROM courses c
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Entity và Spring Data JPA'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'DTO và Validation', 'Tạo request/response DTO và kiểm tra dữ liệu đầu vào bằng validation.', NULL, 40, 4, NOW(), NOW()
FROM courses c
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'DTO và Validation'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Xử lý lỗi và Response chuẩn', 'Chuẩn hóa lỗi not found, bad request, validation và runtime exception.', NULL, 40, 5, NOW(), NOW()
FROM courses c
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Xử lý lỗi và Response chuẩn'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Kết nối MySQL và triển khai API', 'Cấu hình datasource MySQL, chạy backend và kiểm thử API bằng dữ liệu thật.', NULL, 50, 6, NOW(), NOW()
FROM courses c
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Kết nối MySQL và triển khai API'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'AI là gì và ứng dụng trong học tập', 'Tìm hiểu khái niệm AI và cách AI hỗ trợ cá nhân hóa quá trình học.', NULL, 35, 1, NOW(), NOW()
FROM courses c
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'AI là gì và ứng dụng trong học tập'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Machine Learning cơ bản', 'Giới thiệu dữ liệu, feature, label, training và prediction trong machine learning.', NULL, 40, 2, NOW(), NOW()
FROM courses c
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Machine Learning cơ bản'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Dữ liệu huấn luyện và mô hình', 'Tìm hiểu cách thu thập dữ liệu, làm sạch, chia tập và huấn luyện mô hình.', NULL, 45, 3, NOW(), NOW()
FROM courses c
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Dữ liệu huấn luyện và mô hình'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Nhận diện khuôn mặt với webcam', 'Tìm hiểu luồng bật webcam, lấy frame và phát hiện khuôn mặt trong trình duyệt.', NULL, 45, 4, NOW(), NOW()
FROM courses c
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Nhận diện khuôn mặt với webcam'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Đánh giá mô hình AI', 'Học accuracy, precision, recall, confusion matrix và cách đọc kết quả mô hình.', NULL, 40, 5, NOW(), NOW()
FROM courses c
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Đánh giá mô hình AI'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Đạo đức và bảo mật dữ liệu AI', 'Tìm hiểu quyền riêng tư, xin phép người dùng, lưu trữ dữ liệu và minh bạch khi dùng AI.', NULL, 40, 6, NOW(), NOW()
FROM courses c
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Đạo đức và bảo mật dữ liệu AI'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Tổng quan về phân tích và thiết kế hệ thống', 'Giới thiệu vai trò phân tích, thiết kế và vòng đời phát triển hệ thống thông tin.', NULL, 35, 1, NOW(), NOW()
FROM courses c
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Tổng quan về phân tích và thiết kế hệ thống'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Khảo sát và thu thập yêu cầu', 'Học phương pháp phỏng vấn, quan sát, khảo sát và tổng hợp yêu cầu người dùng.', NULL, 40, 2, NOW(), NOW()
FROM courses c
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Khảo sát và thu thập yêu cầu'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Use Case và đặc tả yêu cầu', 'Xây dựng use case, actor, luồng chính, luồng thay thế và đặc tả yêu cầu.', NULL, 45, 3, NOW(), NOW()
FROM courses c
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Use Case và đặc tả yêu cầu'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Thiết kế cơ sở dữ liệu và ERD', 'Thiết kế entity, relationship, khóa chính, khóa ngoại và sơ đồ ERD.', NULL, 45, 4, NOW(), NOW()
FROM courses c
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Thiết kế cơ sở dữ liệu và ERD'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Thiết kế giao diện người dùng (UI/UX)', 'Tìm hiểu wireframe, user flow, component UI và nguyên tắc trải nghiệm người dùng.', NULL, 40, 5, NOW(), NOW()
FROM courses c
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Thiết kế giao diện người dùng (UI/UX)'
  );

INSERT INTO lessons (course_id, video_file_id, title, description, video_url, duration, order_number, created_at, updated_at)
SELECT c.id, NULL, 'Kiểm thử và triển khai hệ thống', 'Học test case, kiểm thử chức năng, build, triển khai và kiểm tra sau khi release.', NULL, 45, 6, NOW(), NOW()
FROM courses c
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND NOT EXISTS (
      SELECT 1 FROM lessons l
      WHERE l.course_id = c.id AND l.title = 'Kiểm thử và triển khai hệ thống'
  );

-- =========================
-- QUESTIONS
-- =========================
-- Lập trình Java cơ bản / Giới thiệu Java và môi trường phát triển
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Giới thiệu Java và môi trường phát triển", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'môi trường phát triển Java', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Giới thiệu Java và môi trường phát triển'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Giới thiệu Java và môi trường phát triển", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Giới thiệu Java và môi trường phát triển" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'chương trình Hello World', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Giới thiệu Java và môi trường phát triển'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Giới thiệu Java và môi trường phát triển" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Giới thiệu Java và môi trường phát triển"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'cài đặt JDK và IDE', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Giới thiệu Java và môi trường phát triển'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Giới thiệu Java và môi trường phát triển"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Giới thiệu Java và môi trường phát triển"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'JDK và IntelliJ IDEA', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Giới thiệu Java và môi trường phát triển'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Giới thiệu Java và môi trường phát triển"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Giới thiệu Java và môi trường phát triển", lựa chọn nào là cách làm hợp lý?', 'kiểm tra phiên bản JDK trước khi chạy chương trình', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Giới thiệu Java và môi trường phát triển'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Giới thiệu Java và môi trường phát triển", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "môi trường phát triển Java" quan trọng trong bài "Giới thiệu Java và môi trường phát triển"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'JDK cung cấp trình biên dịch và môi trường chạy', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Giới thiệu Java và môi trường phát triển'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "môi trường phát triển Java" quan trọng trong bài "Giới thiệu Java và môi trường phát triển"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Giới thiệu Java và môi trường phát triển"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'tạo được chương trình Java đầu tiên', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Giới thiệu Java và môi trường phát triển'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Giới thiệu Java và môi trường phát triển"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "cài đặt JDK và IDE" trong bài "Giới thiệu Java và môi trường phát triển"?', 'chạy Java khi chưa cấu hình JDK', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Giới thiệu Java và môi trường phát triển'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "cài đặt JDK và IDE" trong bài "Giới thiệu Java và môi trường phát triển"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Giới thiệu Java và môi trường phát triển", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'đường dẫn Java runtime và cấu hình project', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Giới thiệu Java và môi trường phát triển'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Giới thiệu Java và môi trường phát triển", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Giới thiệu Java và môi trường phát triển" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'biên dịch và chạy thành công file Java', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Giới thiệu Java và môi trường phát triển'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Giới thiệu Java và môi trường phát triển" tốt nhất là gì?'
  );

-- Lập trình Java cơ bản / Biến, kiểu dữ liệu và toán tử
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Biến, kiểu dữ liệu và toán tử", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'biến và kiểu dữ liệu Java', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Biến, kiểu dữ liệu và toán tử'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Biến, kiểu dữ liệu và toán tử", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Biến, kiểu dữ liệu và toán tử" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'biểu thức tính toán bằng toán tử', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Biến, kiểu dữ liệu và toán tử'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Biến, kiểu dữ liệu và toán tử" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Biến, kiểu dữ liệu và toán tử"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'khai báo biến đúng kiểu', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Biến, kiểu dữ liệu và toán tử'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Biến, kiểu dữ liệu và toán tử"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Biến, kiểu dữ liệu và toán tử"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'int, double, boolean và String', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Biến, kiểu dữ liệu và toán tử'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Biến, kiểu dữ liệu và toán tử"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Biến, kiểu dữ liệu và toán tử", lựa chọn nào là cách làm hợp lý?', 'chọn kiểu dữ liệu theo miền giá trị', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Biến, kiểu dữ liệu và toán tử'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Biến, kiểu dữ liệu và toán tử", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "biến và kiểu dữ liệu Java" quan trọng trong bài "Biến, kiểu dữ liệu và toán tử"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'kiểu dữ liệu quyết định cách bộ nhớ lưu giá trị', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Biến, kiểu dữ liệu và toán tử'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "biến và kiểu dữ liệu Java" quan trọng trong bài "Biến, kiểu dữ liệu và toán tử"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Biến, kiểu dữ liệu và toán tử"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'viết được biểu thức có biến và toán tử', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Biến, kiểu dữ liệu và toán tử'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Biến, kiểu dữ liệu và toán tử"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "khai báo biến đúng kiểu" trong bài "Biến, kiểu dữ liệu và toán tử"?', 'gán dữ liệu sai kiểu cho biến', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Biến, kiểu dữ liệu và toán tử'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "khai báo biến đúng kiểu" trong bài "Biến, kiểu dữ liệu và toán tử"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Biến, kiểu dữ liệu và toán tử", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'ép kiểu và thứ tự ưu tiên toán tử', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Biến, kiểu dữ liệu và toán tử'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Biến, kiểu dữ liệu và toán tử", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Biến, kiểu dữ liệu và toán tử" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'in ra giá trị biểu thức đúng như mong đợi', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Biến, kiểu dữ liệu và toán tử'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Biến, kiểu dữ liệu và toán tử" tốt nhất là gì?'
  );

-- Lập trình Java cơ bản / Câu lệnh điều kiện và vòng lặp
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Câu lệnh điều kiện và vòng lặp", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'điều khiển luồng trong Java', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Câu lệnh điều kiện và vòng lặp'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Câu lệnh điều kiện và vòng lặp", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Câu lệnh điều kiện và vòng lặp" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'chương trình rẽ nhánh và lặp', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Câu lệnh điều kiện và vòng lặp'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Câu lệnh điều kiện và vòng lặp" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Câu lệnh điều kiện và vòng lặp"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'viết điều kiện và vòng lặp', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Câu lệnh điều kiện và vòng lặp'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Câu lệnh điều kiện và vòng lặp"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Câu lệnh điều kiện và vòng lặp"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'if, switch, for và while', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Câu lệnh điều kiện và vòng lặp'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Câu lệnh điều kiện và vòng lặp"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Câu lệnh điều kiện và vòng lặp", lựa chọn nào là cách làm hợp lý?', 'xác định rõ điều kiện dừng vòng lặp', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Câu lệnh điều kiện và vòng lặp'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Câu lệnh điều kiện và vòng lặp", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "điều khiển luồng trong Java" quan trọng trong bài "Câu lệnh điều kiện và vòng lặp"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'điều kiện quyết định nhánh xử lý của chương trình', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Câu lệnh điều kiện và vòng lặp'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "điều khiển luồng trong Java" quan trọng trong bài "Câu lệnh điều kiện và vòng lặp"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Câu lệnh điều kiện và vòng lặp"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'giải được bài toán cần rẽ nhánh hoặc lặp', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Câu lệnh điều kiện và vòng lặp'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Câu lệnh điều kiện và vòng lặp"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "viết điều kiện và vòng lặp" trong bài "Câu lệnh điều kiện và vòng lặp"?', 'tạo vòng lặp không có điểm dừng', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Câu lệnh điều kiện và vòng lặp'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "viết điều kiện và vòng lặp" trong bài "Câu lệnh điều kiện và vòng lặp"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Câu lệnh điều kiện và vòng lặp", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'lồng điều kiện và tối ưu nhánh xử lý', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Câu lệnh điều kiện và vòng lặp'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Câu lệnh điều kiện và vòng lặp", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Câu lệnh điều kiện và vòng lặp" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'kiểm thử với nhiều bộ dữ liệu đầu vào', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Câu lệnh điều kiện và vòng lặp'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Câu lệnh điều kiện và vòng lặp" tốt nhất là gì?'
  );

-- Lập trình Java cơ bản / Mảng và String
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Mảng và String", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'mảng và chuỗi trong Java', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Mảng và String'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Mảng và String", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Mảng và String" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'danh sách điểm hoặc danh sách tên', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Mảng và String'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Mảng và String" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Mảng và String"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'duyệt mảng và xử lý String', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Mảng và String'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Mảng và String"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Mảng và String"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'array, index, length và String method', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Mảng và String'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Mảng và String"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Mảng và String", lựa chọn nào là cách làm hợp lý?', 'kiểm tra giới hạn chỉ số trước khi truy cập mảng', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Mảng và String'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Mảng và String", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "mảng và chuỗi trong Java" quan trọng trong bài "Mảng và String"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'mảng lưu nhiều giá trị cùng kiểu theo thứ tự', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Mảng và String'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "mảng và chuỗi trong Java" quan trọng trong bài "Mảng và String"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Mảng và String"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'xử lý được danh sách dữ liệu đơn giản', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Mảng và String'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Mảng và String"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "duyệt mảng và xử lý String" trong bài "Mảng và String"?', 'truy cập phần tử ngoài phạm vi mảng', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Mảng và String'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "duyệt mảng và xử lý String" trong bài "Mảng và String"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Mảng và String", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'so sánh String và quản lý bộ nhớ chuỗi', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Mảng và String'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Mảng và String", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Mảng và String" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'duyệt hết phần tử và xử lý chuỗi chính xác', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Mảng và String'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Mảng và String" tốt nhất là gì?'
  );

-- Lập trình Java cơ bản / Lập trình hướng đối tượng
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Lập trình hướng đối tượng", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'lập trình hướng đối tượng trong Java', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Lập trình hướng đối tượng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Lập trình hướng đối tượng", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Lập trình hướng đối tượng" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'mô hình Student hoặc Course', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Lập trình hướng đối tượng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Lập trình hướng đối tượng" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Lập trình hướng đối tượng"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'thiết kế class và object', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Lập trình hướng đối tượng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Lập trình hướng đối tượng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Lập trình hướng đối tượng"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'class, object, constructor và method', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Lập trình hướng đối tượng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Lập trình hướng đối tượng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Lập trình hướng đối tượng", lựa chọn nào là cách làm hợp lý?', 'đóng gói thuộc tính và cung cấp method phù hợp', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Lập trình hướng đối tượng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Lập trình hướng đối tượng", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "lập trình hướng đối tượng trong Java" quan trọng trong bài "Lập trình hướng đối tượng"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'OOP giúp mô hình hóa đối tượng thực tế trong code', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Lập trình hướng đối tượng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "lập trình hướng đối tượng trong Java" quan trọng trong bài "Lập trình hướng đối tượng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Lập trình hướng đối tượng"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'thiết kế được class có thuộc tính và hành vi', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Lập trình hướng đối tượng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Lập trình hướng đối tượng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "thiết kế class và object" trong bài "Lập trình hướng đối tượng"?', 'để toàn bộ thuộc tính public và xử lý rời rạc', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Lập trình hướng đối tượng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "thiết kế class và object" trong bài "Lập trình hướng đối tượng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Lập trình hướng đối tượng", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'phân chia trách nhiệm giữa các class', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Lập trình hướng đối tượng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Lập trình hướng đối tượng", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Lập trình hướng đối tượng" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'tạo object và gọi method đúng hành vi', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Lập trình hướng đối tượng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Lập trình hướng đối tượng" tốt nhất là gì?'
  );

-- Lập trình Java cơ bản / Xử lý ngoại lệ và Collection
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Xử lý ngoại lệ và Collection", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'exception và collection trong Java', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Xử lý ngoại lệ và Collection'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Xử lý ngoại lệ và Collection", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Xử lý ngoại lệ và Collection" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'danh sách sinh viên bằng ArrayList', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Xử lý ngoại lệ và Collection'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Xử lý ngoại lệ và Collection" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Xử lý ngoại lệ và Collection"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'xử lý lỗi và lưu tập dữ liệu', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Xử lý ngoại lệ và Collection'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Xử lý ngoại lệ và Collection"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Xử lý ngoại lệ và Collection"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'try-catch, List, Set và Map', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Xử lý ngoại lệ và Collection'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Xử lý ngoại lệ và Collection"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Xử lý ngoại lệ và Collection", lựa chọn nào là cách làm hợp lý?', 'bắt ngoại lệ ở điểm có thể phục hồi lỗi', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Xử lý ngoại lệ và Collection'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Xử lý ngoại lệ và Collection", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "exception và collection trong Java" quan trọng trong bài "Xử lý ngoại lệ và Collection"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'exception giúp chương trình xử lý tình huống lỗi có kiểm soát', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Xử lý ngoại lệ và Collection'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "exception và collection trong Java" quan trọng trong bài "Xử lý ngoại lệ và Collection"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Xử lý ngoại lệ và Collection"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'biết dùng collection thay cho mảng cố định', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Xử lý ngoại lệ và Collection'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Xử lý ngoại lệ và Collection"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xử lý lỗi và lưu tập dữ liệu" trong bài "Xử lý ngoại lệ và Collection"?', 'nuốt lỗi bằng catch rỗng', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Xử lý ngoại lệ và Collection'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xử lý lỗi và lưu tập dữ liệu" trong bài "Xử lý ngoại lệ và Collection"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Xử lý ngoại lệ và Collection", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'chọn collection theo đặc điểm truy cập dữ liệu', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Xử lý ngoại lệ và Collection'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Xử lý ngoại lệ và Collection", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Xử lý ngoại lệ và Collection" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'chạy chương trình ổn định khi có dữ liệu bất thường', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Java cơ bản'
  AND l.title = 'Xử lý ngoại lệ và Collection'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Xử lý ngoại lệ và Collection" tốt nhất là gì?'
  );

-- Cơ sở dữ liệu MySQL / Tổng quan cơ sở dữ liệu quan hệ
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Tổng quan cơ sở dữ liệu quan hệ", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'mô hình cơ sở dữ liệu quan hệ', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tổng quan cơ sở dữ liệu quan hệ'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Tổng quan cơ sở dữ liệu quan hệ", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Tổng quan cơ sở dữ liệu quan hệ" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'mô hình dữ liệu sinh viên và lớp học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tổng quan cơ sở dữ liệu quan hệ'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Tổng quan cơ sở dữ liệu quan hệ" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Tổng quan cơ sở dữ liệu quan hệ"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'phân biệt bảng, hàng và cột', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tổng quan cơ sở dữ liệu quan hệ'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Tổng quan cơ sở dữ liệu quan hệ"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Tổng quan cơ sở dữ liệu quan hệ"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'table, row, column và relationship', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tổng quan cơ sở dữ liệu quan hệ'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Tổng quan cơ sở dữ liệu quan hệ"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Tổng quan cơ sở dữ liệu quan hệ", lựa chọn nào là cách làm hợp lý?', 'xác định entity trước khi tạo bảng', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tổng quan cơ sở dữ liệu quan hệ'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Tổng quan cơ sở dữ liệu quan hệ", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "mô hình cơ sở dữ liệu quan hệ" quan trọng trong bài "Tổng quan cơ sở dữ liệu quan hệ"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'database quan hệ giúp dữ liệu có cấu trúc và dễ truy vấn', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tổng quan cơ sở dữ liệu quan hệ'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "mô hình cơ sở dữ liệu quan hệ" quan trọng trong bài "Tổng quan cơ sở dữ liệu quan hệ"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Tổng quan cơ sở dữ liệu quan hệ"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'hiểu được cách tổ chức dữ liệu dạng bảng', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tổng quan cơ sở dữ liệu quan hệ'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Tổng quan cơ sở dữ liệu quan hệ"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "phân biệt bảng, hàng và cột" trong bài "Tổng quan cơ sở dữ liệu quan hệ"?', 'lưu mọi dữ liệu vào một bảng duy nhất', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tổng quan cơ sở dữ liệu quan hệ'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "phân biệt bảng, hàng và cột" trong bài "Tổng quan cơ sở dữ liệu quan hệ"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Tổng quan cơ sở dữ liệu quan hệ", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'chuẩn hóa dữ liệu và giảm trùng lặp', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tổng quan cơ sở dữ liệu quan hệ'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Tổng quan cơ sở dữ liệu quan hệ", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Tổng quan cơ sở dữ liệu quan hệ" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'mô tả được quan hệ giữa các bảng', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tổng quan cơ sở dữ liệu quan hệ'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Tổng quan cơ sở dữ liệu quan hệ" tốt nhất là gì?'
  );

-- Cơ sở dữ liệu MySQL / Tạo database, table và kiểu dữ liệu
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Tạo database, table và kiểu dữ liệu", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'tạo schema và bảng MySQL', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tạo database, table và kiểu dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Tạo database, table và kiểu dữ liệu", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Tạo database, table và kiểu dữ liệu" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'bảng users hoặc courses', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tạo database, table và kiểu dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Tạo database, table và kiểu dữ liệu" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Tạo database, table và kiểu dữ liệu"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'định nghĩa table với kiểu dữ liệu', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tạo database, table và kiểu dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Tạo database, table và kiểu dữ liệu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Tạo database, table và kiểu dữ liệu"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'CREATE DATABASE và CREATE TABLE', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tạo database, table và kiểu dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Tạo database, table và kiểu dữ liệu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Tạo database, table và kiểu dữ liệu", lựa chọn nào là cách làm hợp lý?', 'chọn kiểu dữ liệu theo ý nghĩa cột', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tạo database, table và kiểu dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Tạo database, table và kiểu dữ liệu", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "tạo schema và bảng MySQL" quan trọng trong bài "Tạo database, table và kiểu dữ liệu"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'kiểu dữ liệu giúp MySQL lưu và kiểm tra dữ liệu chính xác', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tạo database, table và kiểu dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "tạo schema và bảng MySQL" quan trọng trong bài "Tạo database, table và kiểu dữ liệu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Tạo database, table và kiểu dữ liệu"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'tạo được database và table cơ bản', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tạo database, table và kiểu dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Tạo database, table và kiểu dữ liệu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "định nghĩa table với kiểu dữ liệu" trong bài "Tạo database, table và kiểu dữ liệu"?', 'dùng VARCHAR cho mọi loại dữ liệu', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tạo database, table và kiểu dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "định nghĩa table với kiểu dữ liệu" trong bài "Tạo database, table và kiểu dữ liệu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Tạo database, table và kiểu dữ liệu", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'ràng buộc NOT NULL và kích thước cột', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tạo database, table và kiểu dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Tạo database, table và kiểu dữ liệu", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Tạo database, table và kiểu dữ liệu" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'tạo bảng đúng cấu trúc và insert được dữ liệu', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Tạo database, table và kiểu dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Tạo database, table và kiểu dữ liệu" tốt nhất là gì?'
  );

-- Cơ sở dữ liệu MySQL / SELECT, WHERE, ORDER BY
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "SELECT, WHERE, ORDER BY", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'truy vấn dữ liệu bằng SELECT', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'SELECT, WHERE, ORDER BY'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "SELECT, WHERE, ORDER BY", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "SELECT, WHERE, ORDER BY" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'danh sách khóa học đã published', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'SELECT, WHERE, ORDER BY'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "SELECT, WHERE, ORDER BY" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "SELECT, WHERE, ORDER BY"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'lọc và sắp xếp bản ghi', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'SELECT, WHERE, ORDER BY'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "SELECT, WHERE, ORDER BY"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "SELECT, WHERE, ORDER BY"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'SELECT, WHERE và ORDER BY', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'SELECT, WHERE, ORDER BY'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "SELECT, WHERE, ORDER BY"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "SELECT, WHERE, ORDER BY", lựa chọn nào là cách làm hợp lý?', 'chỉ chọn cột cần dùng thay vì SELECT tất cả', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'SELECT, WHERE, ORDER BY'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "SELECT, WHERE, ORDER BY", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "truy vấn dữ liệu bằng SELECT" quan trọng trong bài "SELECT, WHERE, ORDER BY"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'WHERE giúp lấy dữ liệu theo điều kiện nghiệp vụ', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'SELECT, WHERE, ORDER BY'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "truy vấn dữ liệu bằng SELECT" quan trọng trong bài "SELECT, WHERE, ORDER BY"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "SELECT, WHERE, ORDER BY"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'viết được truy vấn đọc dữ liệu cơ bản', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'SELECT, WHERE, ORDER BY'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "SELECT, WHERE, ORDER BY"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "lọc và sắp xếp bản ghi" trong bài "SELECT, WHERE, ORDER BY"?', 'lọc sai điều kiện làm mất dữ liệu cần xem', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'SELECT, WHERE, ORDER BY'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "lọc và sắp xếp bản ghi" trong bài "SELECT, WHERE, ORDER BY"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "SELECT, WHERE, ORDER BY", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'kết hợp nhiều điều kiện trong WHERE', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'SELECT, WHERE, ORDER BY'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "SELECT, WHERE, ORDER BY", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "SELECT, WHERE, ORDER BY" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'trả về đúng tập bản ghi và đúng thứ tự', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'SELECT, WHERE, ORDER BY'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "SELECT, WHERE, ORDER BY" tốt nhất là gì?'
  );

-- Cơ sở dữ liệu MySQL / JOIN và quan hệ bảng
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "JOIN và quan hệ bảng", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'kết nối dữ liệu giữa nhiều bảng', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'JOIN và quan hệ bảng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "JOIN và quan hệ bảng", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "JOIN và quan hệ bảng" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'danh sách bài học kèm tên khóa học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'JOIN và quan hệ bảng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "JOIN và quan hệ bảng" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "JOIN và quan hệ bảng"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'sử dụng JOIN theo khóa ngoại', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'JOIN và quan hệ bảng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "JOIN và quan hệ bảng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "JOIN và quan hệ bảng"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'INNER JOIN và LEFT JOIN', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'JOIN và quan hệ bảng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "JOIN và quan hệ bảng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "JOIN và quan hệ bảng", lựa chọn nào là cách làm hợp lý?', 'JOIN dựa trên cặp khóa chính khóa ngoại đúng', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'JOIN và quan hệ bảng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "JOIN và quan hệ bảng", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "kết nối dữ liệu giữa nhiều bảng" quan trọng trong bài "JOIN và quan hệ bảng"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'JOIN giúp kết hợp dữ liệu phân tán ở nhiều bảng', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'JOIN và quan hệ bảng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "kết nối dữ liệu giữa nhiều bảng" quan trọng trong bài "JOIN và quan hệ bảng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "JOIN và quan hệ bảng"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'hiểu được quan hệ course và lesson', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'JOIN và quan hệ bảng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "JOIN và quan hệ bảng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "sử dụng JOIN theo khóa ngoại" trong bài "JOIN và quan hệ bảng"?', 'JOIN thiếu điều kiện gây nhân bản dữ liệu', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'JOIN và quan hệ bảng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "sử dụng JOIN theo khóa ngoại" trong bài "JOIN và quan hệ bảng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "JOIN và quan hệ bảng", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'chọn loại JOIN theo yêu cầu thiếu hoặc đủ dữ liệu', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'JOIN và quan hệ bảng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "JOIN và quan hệ bảng", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "JOIN và quan hệ bảng" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'truy vấn được dữ liệu từ hai bảng liên quan', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'JOIN và quan hệ bảng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "JOIN và quan hệ bảng" tốt nhất là gì?'
  );

-- Cơ sở dữ liệu MySQL / GROUP BY, HAVING và Aggregate Functions
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "GROUP BY, HAVING và Aggregate Functions", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'thống kê dữ liệu bằng aggregate', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'GROUP BY, HAVING và Aggregate Functions'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "GROUP BY, HAVING và Aggregate Functions", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "GROUP BY, HAVING và Aggregate Functions" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'đếm số bài học theo khóa học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'GROUP BY, HAVING và Aggregate Functions'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "GROUP BY, HAVING và Aggregate Functions" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "GROUP BY, HAVING và Aggregate Functions"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'gom nhóm và lọc nhóm dữ liệu', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'GROUP BY, HAVING và Aggregate Functions'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "GROUP BY, HAVING và Aggregate Functions"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "GROUP BY, HAVING và Aggregate Functions"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'COUNT, AVG, SUM, GROUP BY và HAVING', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'GROUP BY, HAVING và Aggregate Functions'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "GROUP BY, HAVING và Aggregate Functions"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "GROUP BY, HAVING và Aggregate Functions", lựa chọn nào là cách làm hợp lý?', 'GROUP BY theo đúng khóa đại diện nhóm', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'GROUP BY, HAVING và Aggregate Functions'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "GROUP BY, HAVING và Aggregate Functions", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "thống kê dữ liệu bằng aggregate" quan trọng trong bài "GROUP BY, HAVING và Aggregate Functions"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'aggregate giúp tạo báo cáo thống kê từ dữ liệu', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'GROUP BY, HAVING và Aggregate Functions'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "thống kê dữ liệu bằng aggregate" quan trọng trong bài "GROUP BY, HAVING và Aggregate Functions"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "GROUP BY, HAVING và Aggregate Functions"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'viết được truy vấn tổng hợp dữ liệu', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'GROUP BY, HAVING và Aggregate Functions'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "GROUP BY, HAVING và Aggregate Functions"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "gom nhóm và lọc nhóm dữ liệu" trong bài "GROUP BY, HAVING và Aggregate Functions"?', 'dùng WHERE thay cho HAVING khi lọc kết quả aggregate', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'GROUP BY, HAVING và Aggregate Functions'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "gom nhóm và lọc nhóm dữ liệu" trong bài "GROUP BY, HAVING và Aggregate Functions"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "GROUP BY, HAVING và Aggregate Functions", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'phân biệt lọc dòng và lọc nhóm', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'GROUP BY, HAVING và Aggregate Functions'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "GROUP BY, HAVING và Aggregate Functions", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "GROUP BY, HAVING và Aggregate Functions" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'tính đúng số lượng hoặc trung bình theo nhóm', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'GROUP BY, HAVING và Aggregate Functions'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "GROUP BY, HAVING và Aggregate Functions" tốt nhất là gì?'
  );

-- Cơ sở dữ liệu MySQL / Index, khóa chính, khóa ngoại và tối ưu truy vấn
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'ràng buộc và tối ưu truy vấn MySQL', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Index, khóa chính, khóa ngoại và tối ưu truy vấn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'index cho cột thường dùng trong WHERE', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Index, khóa chính, khóa ngoại và tối ưu truy vấn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'thiết kế khóa và index phù hợp', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Index, khóa chính, khóa ngoại và tối ưu truy vấn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'PRIMARY KEY, FOREIGN KEY và INDEX', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Index, khóa chính, khóa ngoại và tối ưu truy vấn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn", lựa chọn nào là cách làm hợp lý?', 'đặt index cho cột lọc hoặc join thường xuyên', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Index, khóa chính, khóa ngoại và tối ưu truy vấn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "ràng buộc và tối ưu truy vấn MySQL" quan trọng trong bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'index giúp MySQL tìm dữ liệu nhanh hơn', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Index, khóa chính, khóa ngoại và tối ưu truy vấn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "ràng buộc và tối ưu truy vấn MySQL" quan trọng trong bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'hiểu được vai trò khóa và index', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Index, khóa chính, khóa ngoại và tối ưu truy vấn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "thiết kế khóa và index phù hợp" trong bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn"?', 'tạo quá nhiều index không cần thiết', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Index, khóa chính, khóa ngoại và tối ưu truy vấn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "thiết kế khóa và index phù hợp" trong bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'cân bằng tốc độ đọc và chi phí ghi dữ liệu', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Index, khóa chính, khóa ngoại và tối ưu truy vấn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'truy vấn join hoặc lọc chạy hợp lý hơn', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Cơ sở dữ liệu MySQL'
  AND l.title = 'Index, khóa chính, khóa ngoại và tối ưu truy vấn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Index, khóa chính, khóa ngoại và tối ưu truy vấn" tốt nhất là gì?'
  );

-- Phát triển Web Frontend với React / HTML, CSS, JavaScript trong ứng dụng web
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "HTML, CSS, JavaScript trong ứng dụng web", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'nền tảng HTML CSS JavaScript', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'HTML, CSS, JavaScript trong ứng dụng web'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "HTML, CSS, JavaScript trong ứng dụng web", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "HTML, CSS, JavaScript trong ứng dụng web" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'trang web có nội dung, style và tương tác', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'HTML, CSS, JavaScript trong ứng dụng web'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "HTML, CSS, JavaScript trong ứng dụng web" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "HTML, CSS, JavaScript trong ứng dụng web"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'tách cấu trúc giao diện và hành vi', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'HTML, CSS, JavaScript trong ứng dụng web'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "HTML, CSS, JavaScript trong ứng dụng web"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "HTML, CSS, JavaScript trong ứng dụng web"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'HTML, CSS và JavaScript', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'HTML, CSS, JavaScript trong ứng dụng web'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "HTML, CSS, JavaScript trong ứng dụng web"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "HTML, CSS, JavaScript trong ứng dụng web", lựa chọn nào là cách làm hợp lý?', 'viết HTML có ngữ nghĩa và CSS dễ bảo trì', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'HTML, CSS, JavaScript trong ứng dụng web'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "HTML, CSS, JavaScript trong ứng dụng web", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "nền tảng HTML CSS JavaScript" quan trọng trong bài "HTML, CSS, JavaScript trong ứng dụng web"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'ba công nghệ này tạo nền cho mọi frontend web', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'HTML, CSS, JavaScript trong ứng dụng web'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "nền tảng HTML CSS JavaScript" quan trọng trong bài "HTML, CSS, JavaScript trong ứng dụng web"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "HTML, CSS, JavaScript trong ứng dụng web"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'phân biệt được vai trò của HTML CSS JS', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'HTML, CSS, JavaScript trong ứng dụng web'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "HTML, CSS, JavaScript trong ứng dụng web"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "tách cấu trúc giao diện và hành vi" trong bài "HTML, CSS, JavaScript trong ứng dụng web"?', 'trộn toàn bộ logic vào inline HTML', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'HTML, CSS, JavaScript trong ứng dụng web'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "tách cấu trúc giao diện và hành vi" trong bài "HTML, CSS, JavaScript trong ứng dụng web"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "HTML, CSS, JavaScript trong ứng dụng web", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'tổ chức asset và script trong ứng dụng web', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'HTML, CSS, JavaScript trong ứng dụng web'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "HTML, CSS, JavaScript trong ứng dụng web", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "HTML, CSS, JavaScript trong ứng dụng web" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'trang hiển thị đúng và có tương tác cơ bản', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'HTML, CSS, JavaScript trong ứng dụng web'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "HTML, CSS, JavaScript trong ứng dụng web" tốt nhất là gì?'
  );

-- Phát triển Web Frontend với React / Component và JSX
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Component và JSX", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'component và JSX trong React', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Component và JSX'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Component và JSX", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Component và JSX" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'CourseCard hoặc Navbar component', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Component và JSX'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Component và JSX" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Component và JSX"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'xây dựng component tái sử dụng', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Component và JSX'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Component và JSX"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Component và JSX"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'React component và JSX syntax', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Component và JSX'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Component và JSX"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Component và JSX", lựa chọn nào là cách làm hợp lý?', 'chia UI theo trách nhiệm nhỏ rõ ràng', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Component và JSX'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Component và JSX", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "component và JSX trong React" quan trọng trong bài "Component và JSX"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'component giúp UI dễ tái sử dụng và bảo trì', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Component và JSX'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "component và JSX trong React" quan trọng trong bài "Component và JSX"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Component và JSX"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'tạo được component React đơn giản', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Component và JSX'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Component và JSX"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xây dựng component tái sử dụng" trong bài "Component và JSX"?', 'viết toàn bộ giao diện trong một file lớn', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Component và JSX'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xây dựng component tái sử dụng" trong bài "Component và JSX"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Component và JSX", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'truyền dữ liệu và render điều kiện trong JSX', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Component và JSX'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Component và JSX", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Component và JSX" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'component render đúng dữ liệu được truyền vào', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Component và JSX'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Component và JSX" tốt nhất là gì?'
  );

-- Phát triển Web Frontend với React / Props, State và Event Handling
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Props, State và Event Handling", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'props state và event trong React', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Props, State và Event Handling'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Props, State và Event Handling", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Props, State và Event Handling" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'form chọn đáp án quiz', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Props, State và Event Handling'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Props, State và Event Handling" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Props, State và Event Handling"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'quản lý dữ liệu thay đổi trên UI', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Props, State và Event Handling'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Props, State và Event Handling"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Props, State và Event Handling"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'useState, props và onClick', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Props, State và Event Handling'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Props, State và Event Handling"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Props, State và Event Handling", lựa chọn nào là cách làm hợp lý?', 'chỉ lưu state cần thiết cho tương tác', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Props, State và Event Handling'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Props, State và Event Handling", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "props state và event trong React" quan trọng trong bài "Props, State và Event Handling"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'state giúp React biết khi nào cần render lại', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Props, State và Event Handling'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "props state và event trong React" quan trọng trong bài "Props, State và Event Handling"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Props, State và Event Handling"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'xử lý được input và button trong React', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Props, State và Event Handling'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Props, State và Event Handling"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "quản lý dữ liệu thay đổi trên UI" trong bài "Props, State và Event Handling"?', 'thay đổi trực tiếp state object', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Props, State và Event Handling'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "quản lý dữ liệu thay đổi trên UI" trong bài "Props, State và Event Handling"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Props, State và Event Handling", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'đồng bộ dữ liệu state với hành động người dùng', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Props, State và Event Handling'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Props, State và Event Handling", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Props, State và Event Handling" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'UI cập nhật đúng sau khi người dùng thao tác', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Props, State và Event Handling'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Props, State và Event Handling" tốt nhất là gì?'
  );

-- Phát triển Web Frontend với React / React Router và điều hướng
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "React Router và điều hướng", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'định tuyến trong React Router', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'React Router và điều hướng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "React Router và điều hướng", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "React Router và điều hướng" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'trang courses và lessons', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'React Router và điều hướng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "React Router và điều hướng" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "React Router và điều hướng"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'xây dựng route và trang chi tiết', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'React Router và điều hướng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "React Router và điều hướng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "React Router và điều hướng"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'BrowserRouter, Routes, Route và Link', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'React Router và điều hướng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "React Router và điều hướng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "React Router và điều hướng", lựa chọn nào là cách làm hợp lý?', 'đặt route rõ nghĩa theo tài nguyên', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'React Router và điều hướng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "React Router và điều hướng", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "định tuyến trong React Router" quan trọng trong bài "React Router và điều hướng"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'router giúp SPA chuyển trang không tải lại toàn bộ', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'React Router và điều hướng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "định tuyến trong React Router" quan trọng trong bài "React Router và điều hướng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "React Router và điều hướng"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'tạo được route danh sách và chi tiết', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'React Router và điều hướng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "React Router và điều hướng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xây dựng route và trang chi tiết" trong bài "React Router và điều hướng"?', 'dùng thẻ a làm reload toàn trang không cần thiết', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'React Router và điều hướng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xây dựng route và trang chi tiết" trong bài "React Router và điều hướng"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "React Router và điều hướng", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'xử lý tham số URL và route guard', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'React Router và điều hướng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "React Router và điều hướng", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "React Router và điều hướng" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'truy cập đúng trang theo URL', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'React Router và điều hướng'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "React Router và điều hướng" tốt nhất là gì?'
  );

-- Phát triển Web Frontend với React / Gọi API bằng Axios
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Gọi API bằng Axios", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'gọi API REST bằng Axios', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Gọi API bằng Axios'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Gọi API bằng Axios", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Gọi API bằng Axios" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'danh sách khóa học từ API', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Gọi API bằng Axios'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Gọi API bằng Axios" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Gọi API bằng Axios"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'lấy dữ liệu backend và render UI', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Gọi API bằng Axios'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Gọi API bằng Axios"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Gọi API bằng Axios"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'axiosClient và useEffect', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Gọi API bằng Axios'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Gọi API bằng Axios"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Gọi API bằng Axios", lựa chọn nào là cách làm hợp lý?', 'gom cấu hình baseURL vào axios client', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Gọi API bằng Axios'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Gọi API bằng Axios", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "gọi API REST bằng Axios" quan trọng trong bài "Gọi API bằng Axios"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Axios giúp frontend giao tiếp với backend REST', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Gọi API bằng Axios'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "gọi API REST bằng Axios" quan trọng trong bài "Gọi API bằng Axios"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Gọi API bằng Axios"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'gọi được API và xử lý response', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Gọi API bằng Axios'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Gọi API bằng Axios"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "lấy dữ liệu backend và render UI" trong bài "Gọi API bằng Axios"?', 'lặp lại baseURL ở mọi component', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Gọi API bằng Axios'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "lấy dữ liệu backend và render UI" trong bài "Gọi API bằng Axios"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Gọi API bằng Axios", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'xử lý lỗi HTTP và trạng thái loading', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Gọi API bằng Axios'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Gọi API bằng Axios", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Gọi API bằng Axios" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'dữ liệu API hiển thị đúng trên giao diện', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Gọi API bằng Axios'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Gọi API bằng Axios" tốt nhất là gì?'
  );

-- Phát triển Web Frontend với React / Quản lý Form và hiển thị dữ liệu
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Quản lý Form và hiển thị dữ liệu", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'form controlled component trong React', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Quản lý Form và hiển thị dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Quản lý Form và hiển thị dữ liệu", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Quản lý Form và hiển thị dữ liệu" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'form đăng nhập hoặc thêm khóa học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Quản lý Form và hiển thị dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Quản lý Form và hiển thị dữ liệu" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Quản lý Form và hiển thị dữ liệu"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'quản lý input và submit form', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Quản lý Form và hiển thị dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Quản lý Form và hiển thị dữ liệu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Quản lý Form và hiển thị dữ liệu"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'input value và onChange', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Quản lý Form và hiển thị dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Quản lý Form và hiển thị dữ liệu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Quản lý Form và hiển thị dữ liệu", lựa chọn nào là cách làm hợp lý?', 'validate dữ liệu trước khi gửi API', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Quản lý Form và hiển thị dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Quản lý Form và hiển thị dữ liệu", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "form controlled component trong React" quan trọng trong bài "Quản lý Form và hiển thị dữ liệu"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'controlled form giúp dữ liệu UI nhất quán với state', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Quản lý Form và hiển thị dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "form controlled component trong React" quan trọng trong bài "Quản lý Form và hiển thị dữ liệu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Quản lý Form và hiển thị dữ liệu"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'tạo được form nhập liệu hoàn chỉnh', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Quản lý Form và hiển thị dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Quản lý Form và hiển thị dữ liệu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "quản lý input và submit form" trong bài "Quản lý Form và hiển thị dữ liệu"?', 'để input không kiểm soát gây khó đồng bộ', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Quản lý Form và hiển thị dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "quản lý input và submit form" trong bài "Quản lý Form và hiển thị dữ liệu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Quản lý Form và hiển thị dữ liệu", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'reset form và hiển thị thông báo sau submit', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Quản lý Form và hiển thị dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Quản lý Form và hiển thị dữ liệu", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Quản lý Form và hiển thị dữ liệu" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'form gửi đúng payload và cập nhật danh sách', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phát triển Web Frontend với React'
  AND l.title = 'Quản lý Form và hiển thị dữ liệu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Quản lý Form và hiển thị dữ liệu" tốt nhất là gì?'
  );

-- Lập trình Backend với Spring Boot / Tổng quan Spring Boot và REST API
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Tổng quan Spring Boot và REST API", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'Spring Boot và REST API', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Tổng quan Spring Boot và REST API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Tổng quan Spring Boot và REST API", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Tổng quan Spring Boot và REST API" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'endpoint trả JSON cho khóa học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Tổng quan Spring Boot và REST API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Tổng quan Spring Boot và REST API" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Tổng quan Spring Boot và REST API"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'tạo ứng dụng backend REST', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Tổng quan Spring Boot và REST API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Tổng quan Spring Boot và REST API"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Tổng quan Spring Boot và REST API"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Spring Boot Starter Web', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Tổng quan Spring Boot và REST API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Tổng quan Spring Boot và REST API"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Tổng quan Spring Boot và REST API", lựa chọn nào là cách làm hợp lý?', 'thiết kế URL theo tài nguyên', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Tổng quan Spring Boot và REST API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Tổng quan Spring Boot và REST API", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "Spring Boot và REST API" quan trọng trong bài "Tổng quan Spring Boot và REST API"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Spring Boot giúp khởi tạo backend nhanh và nhất quán', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Tổng quan Spring Boot và REST API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "Spring Boot và REST API" quan trọng trong bài "Tổng quan Spring Boot và REST API"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Tổng quan Spring Boot và REST API"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'hiểu được luồng request response', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Tổng quan Spring Boot và REST API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Tổng quan Spring Boot và REST API"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "tạo ứng dụng backend REST" trong bài "Tổng quan Spring Boot và REST API"?', 'đặt toàn bộ logic trong controller', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Tổng quan Spring Boot và REST API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "tạo ứng dụng backend REST" trong bài "Tổng quan Spring Boot và REST API"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Tổng quan Spring Boot và REST API", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'phân biệt HTTP method và status code', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Tổng quan Spring Boot và REST API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Tổng quan Spring Boot và REST API", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Tổng quan Spring Boot và REST API" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'API trả response JSON đúng nghiệp vụ', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Tổng quan Spring Boot và REST API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Tổng quan Spring Boot và REST API" tốt nhất là gì?'
  );

-- Lập trình Backend với Spring Boot / Controller, Service, Repository
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Controller, Service, Repository", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'kiến trúc layer trong Spring Boot', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Controller, Service, Repository'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Controller, Service, Repository", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Controller, Service, Repository" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'module quản lý khóa học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Controller, Service, Repository'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Controller, Service, Repository" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Controller, Service, Repository"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'tách controller service repository', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Controller, Service, Repository'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Controller, Service, Repository"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Controller, Service, Repository"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'RestController, Service và Repository', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Controller, Service, Repository'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Controller, Service, Repository"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Controller, Service, Repository", lựa chọn nào là cách làm hợp lý?', 'đặt nghiệp vụ trong service', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Controller, Service, Repository'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Controller, Service, Repository", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "kiến trúc layer trong Spring Boot" quan trọng trong bài "Controller, Service, Repository"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'phân lớp giúp code dễ test và bảo trì', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Controller, Service, Repository'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "kiến trúc layer trong Spring Boot" quan trọng trong bài "Controller, Service, Repository"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Controller, Service, Repository"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'xây dựng được flow API có service', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Controller, Service, Repository'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Controller, Service, Repository"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "tách controller service repository" trong bài "Controller, Service, Repository"?', 'truy vấn database trực tiếp ở controller', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Controller, Service, Repository'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "tách controller service repository" trong bài "Controller, Service, Repository"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Controller, Service, Repository", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'quản lý transaction ở tầng service', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Controller, Service, Repository'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Controller, Service, Repository", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Controller, Service, Repository" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'request đi qua đúng các tầng xử lý', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Controller, Service, Repository'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Controller, Service, Repository" tốt nhất là gì?'
  );

-- Lập trình Backend với Spring Boot / Entity và Spring Data JPA
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Entity và Spring Data JPA", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'entity và Spring Data JPA', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Entity và Spring Data JPA'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Entity và Spring Data JPA", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Entity và Spring Data JPA" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Course entity và CourseRepository', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Entity và Spring Data JPA'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Entity và Spring Data JPA" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Entity và Spring Data JPA"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'map bảng thành Java entity', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Entity và Spring Data JPA'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Entity và Spring Data JPA"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Entity và Spring Data JPA"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Entity, Id, ManyToOne và JpaRepository', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Entity và Spring Data JPA'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Entity và Spring Data JPA"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Entity và Spring Data JPA", lựa chọn nào là cách làm hợp lý?', 'đặt annotation theo đúng schema database', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Entity và Spring Data JPA'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Entity và Spring Data JPA", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "entity và Spring Data JPA" quan trọng trong bài "Entity và Spring Data JPA"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'JPA giảm code SQL lặp lại cho CRUD', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Entity và Spring Data JPA'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "entity và Spring Data JPA" quan trọng trong bài "Entity và Spring Data JPA"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Entity và Spring Data JPA"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'tạo được entity và repository', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Entity và Spring Data JPA'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Entity và Spring Data JPA"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "map bảng thành Java entity" trong bài "Entity và Spring Data JPA"?', 'đổi tên cột tùy ý không theo schema', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Entity và Spring Data JPA'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "map bảng thành Java entity" trong bài "Entity và Spring Data JPA"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Entity và Spring Data JPA", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'xử lý quan hệ lazy loading và khóa ngoại', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Entity và Spring Data JPA'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Entity và Spring Data JPA", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Entity và Spring Data JPA" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'repository đọc ghi đúng bảng dữ liệu', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Entity và Spring Data JPA'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Entity và Spring Data JPA" tốt nhất là gì?'
  );

-- Lập trình Backend với Spring Boot / DTO và Validation
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "DTO và Validation", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'DTO và validation trong API', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'DTO và Validation'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "DTO và Validation", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "DTO và Validation" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'RegisterRequest hoặc QuestionRequest', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'DTO và Validation'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "DTO và Validation" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "DTO và Validation"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'tách dữ liệu request response khỏi entity', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'DTO và Validation'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "DTO và Validation"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "DTO và Validation"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'DTO, Valid và constraint annotation', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'DTO và Validation'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "DTO và Validation"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "DTO và Validation", lựa chọn nào là cách làm hợp lý?', 'validate dữ liệu trước khi vào service', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'DTO và Validation'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "DTO và Validation", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "DTO và validation trong API" quan trọng trong bài "DTO và Validation"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'DTO giúp kiểm soát contract giữa frontend và backend', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'DTO và Validation'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "DTO và validation trong API" quan trọng trong bài "DTO và Validation"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "DTO và Validation"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'viết được DTO request response', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'DTO và Validation'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "DTO và Validation"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "tách dữ liệu request response khỏi entity" trong bài "DTO và Validation"?', 'trả entity đầy đủ ra ngoài API', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'DTO và Validation'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "tách dữ liệu request response khỏi entity" trong bài "DTO và Validation"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "DTO và Validation", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'thiết kế message lỗi dễ hiểu cho frontend', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'DTO và Validation'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "DTO và Validation", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "DTO và Validation" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'API từ chối payload sai định dạng', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'DTO và Validation'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "DTO và Validation" tốt nhất là gì?'
  );

-- Lập trình Backend với Spring Boot / Xử lý lỗi và Response chuẩn
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Xử lý lỗi và Response chuẩn", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'global exception handling', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Xử lý lỗi và Response chuẩn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Xử lý lỗi và Response chuẩn", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Xử lý lỗi và Response chuẩn" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'response lỗi có timestamp status message', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Xử lý lỗi và Response chuẩn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Xử lý lỗi và Response chuẩn" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Xử lý lỗi và Response chuẩn"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'trả lỗi API thống nhất', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Xử lý lỗi và Response chuẩn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Xử lý lỗi và Response chuẩn"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Xử lý lỗi và Response chuẩn"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'ControllerAdvice và ResponseStatusException', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Xử lý lỗi và Response chuẩn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Xử lý lỗi và Response chuẩn"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Xử lý lỗi và Response chuẩn", lựa chọn nào là cách làm hợp lý?', 'ẩn lỗi kỹ thuật không cần thiết khỏi người dùng', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Xử lý lỗi và Response chuẩn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Xử lý lỗi và Response chuẩn", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "global exception handling" quan trọng trong bài "Xử lý lỗi và Response chuẩn"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'response chuẩn giúp debug và UX tốt hơn', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Xử lý lỗi và Response chuẩn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "global exception handling" quan trọng trong bài "Xử lý lỗi và Response chuẩn"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Xử lý lỗi và Response chuẩn"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'xử lý được lỗi tập trung', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Xử lý lỗi và Response chuẩn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Xử lý lỗi và Response chuẩn"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "trả lỗi API thống nhất" trong bài "Xử lý lỗi và Response chuẩn"?', 'để stack trace thô trả về frontend', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Xử lý lỗi và Response chuẩn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "trả lỗi API thống nhất" trong bài "Xử lý lỗi và Response chuẩn"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Xử lý lỗi và Response chuẩn", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'phân loại lỗi nghiệp vụ và lỗi hệ thống', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Xử lý lỗi và Response chuẩn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Xử lý lỗi và Response chuẩn", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Xử lý lỗi và Response chuẩn" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'frontend nhận message lỗi rõ ràng', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Xử lý lỗi và Response chuẩn'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Xử lý lỗi và Response chuẩn" tốt nhất là gì?'
  );

-- Lập trình Backend với Spring Boot / Kết nối MySQL và triển khai API
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Kết nối MySQL và triển khai API", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'kết nối Spring Boot với MySQL', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Kết nối MySQL và triển khai API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Kết nối MySQL và triển khai API", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Kết nối MySQL và triển khai API" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'API courses dùng database MySQL', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Kết nối MySQL và triển khai API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Kết nối MySQL và triển khai API" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Kết nối MySQL và triển khai API"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'cấu hình datasource và chạy CRUD API', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Kết nối MySQL và triển khai API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Kết nối MySQL và triển khai API"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Kết nối MySQL và triển khai API"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'application.properties và MySQL driver', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Kết nối MySQL và triển khai API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Kết nối MySQL và triển khai API"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Kết nối MySQL và triển khai API", lựa chọn nào là cách làm hợp lý?', 'kiểm tra connection string và quyền user DB', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Kết nối MySQL và triển khai API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Kết nối MySQL và triển khai API", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "kết nối Spring Boot với MySQL" quan trọng trong bài "Kết nối MySQL và triển khai API"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'database thật giúp kiểm thử luồng sản phẩm đầy đủ', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Kết nối MySQL và triển khai API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "kết nối Spring Boot với MySQL" quan trọng trong bài "Kết nối MySQL và triển khai API"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Kết nối MySQL và triển khai API"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'triển khai được API CRUD với MySQL', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Kết nối MySQL và triển khai API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Kết nối MySQL và triển khai API"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "cấu hình datasource và chạy CRUD API" trong bài "Kết nối MySQL và triển khai API"?', 'chạy API khi database chưa sẵn sàng', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Kết nối MySQL và triển khai API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "cấu hình datasource và chạy CRUD API" trong bài "Kết nối MySQL và triển khai API"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Kết nối MySQL và triển khai API", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'quản lý schema và dữ liệu seed khi triển khai', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Kết nối MySQL và triển khai API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Kết nối MySQL và triển khai API", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Kết nối MySQL và triển khai API" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'API đọc ghi thành công trên MySQL', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Lập trình Backend với Spring Boot'
  AND l.title = 'Kết nối MySQL và triển khai API'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Kết nối MySQL và triển khai API" tốt nhất là gì?'
  );

-- Nhập môn Trí tuệ nhân tạo / AI là gì và ứng dụng trong học tập
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "AI là gì và ứng dụng trong học tập", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'AI trong hệ thống học tập', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'AI là gì và ứng dụng trong học tập'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "AI là gì và ứng dụng trong học tập", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "AI là gì và ứng dụng trong học tập" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'gợi ý bài học theo năng lực', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'AI là gì và ứng dụng trong học tập'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "AI là gì và ứng dụng trong học tập" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "AI là gì và ứng dụng trong học tập"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'nhận diện ứng dụng AI giáo dục', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'AI là gì và ứng dụng trong học tập'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "AI là gì và ứng dụng trong học tập"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "AI là gì và ứng dụng trong học tập"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'AI, adaptive learning và recommendation', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'AI là gì và ứng dụng trong học tập'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "AI là gì và ứng dụng trong học tập"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "AI là gì và ứng dụng trong học tập", lựa chọn nào là cách làm hợp lý?', 'xác định bài toán phù hợp để dùng AI', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'AI là gì và ứng dụng trong học tập'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "AI là gì và ứng dụng trong học tập", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "AI trong hệ thống học tập" quan trọng trong bài "AI là gì và ứng dụng trong học tập"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'AI giúp hệ thống đưa ra quyết định dựa trên dữ liệu', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'AI là gì và ứng dụng trong học tập'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "AI trong hệ thống học tập" quan trọng trong bài "AI là gì và ứng dụng trong học tập"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "AI là gì và ứng dụng trong học tập"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'hiểu được vai trò AI trong đồ án', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'AI là gì và ứng dụng trong học tập'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "AI là gì và ứng dụng trong học tập"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "nhận diện ứng dụng AI giáo dục" trong bài "AI là gì và ứng dụng trong học tập"?', 'gắn nhãn AI cho mọi chức năng thông thường', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'AI là gì và ứng dụng trong học tập'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "nhận diện ứng dụng AI giáo dục" trong bài "AI là gì và ứng dụng trong học tập"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "AI là gì và ứng dụng trong học tập", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'đánh giá tác động AI đến trải nghiệm học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'AI là gì và ứng dụng trong học tập'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "AI là gì và ứng dụng trong học tập", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "AI là gì và ứng dụng trong học tập" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'mô tả được lợi ích AI trong học tập', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'AI là gì và ứng dụng trong học tập'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "AI là gì và ứng dụng trong học tập" tốt nhất là gì?'
  );

-- Nhập môn Trí tuệ nhân tạo / Machine Learning cơ bản
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Machine Learning cơ bản", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'machine learning cơ bản', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Machine Learning cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Machine Learning cơ bản", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Machine Learning cơ bản" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'mô hình dự đoán mức độ tập trung', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Machine Learning cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Machine Learning cơ bản" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Machine Learning cơ bản"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'phân biệt training và prediction', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Machine Learning cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Machine Learning cơ bản"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Machine Learning cơ bản"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'feature, label, model và training', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Machine Learning cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Machine Learning cơ bản"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Machine Learning cơ bản", lựa chọn nào là cách làm hợp lý?', 'chuẩn bị dữ liệu đại diện trước khi huấn luyện', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Machine Learning cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Machine Learning cơ bản", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "machine learning cơ bản" quan trọng trong bài "Machine Learning cơ bản"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'machine learning học quy luật từ dữ liệu', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Machine Learning cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "machine learning cơ bản" quan trọng trong bài "Machine Learning cơ bản"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Machine Learning cơ bản"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'nắm được vòng đời mô hình ML', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Machine Learning cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Machine Learning cơ bản"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "phân biệt training và prediction" trong bài "Machine Learning cơ bản"?', 'huấn luyện mô hình với dữ liệu thiếu nhãn', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Machine Learning cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "phân biệt training và prediction" trong bài "Machine Learning cơ bản"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Machine Learning cơ bản", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'tránh overfitting và kiểm tra generalization', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Machine Learning cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Machine Learning cơ bản", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Machine Learning cơ bản" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'mô hình dự đoán hợp lý trên dữ liệu mới', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Machine Learning cơ bản'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Machine Learning cơ bản" tốt nhất là gì?'
  );

-- Nhập môn Trí tuệ nhân tạo / Dữ liệu huấn luyện và mô hình
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Dữ liệu huấn luyện và mô hình", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'dữ liệu huấn luyện cho mô hình AI', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Dữ liệu huấn luyện và mô hình'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Dữ liệu huấn luyện và mô hình", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Dữ liệu huấn luyện và mô hình" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'ảnh webcam có nhãn focused distracted no_face', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Dữ liệu huấn luyện và mô hình'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Dữ liệu huấn luyện và mô hình" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Dữ liệu huấn luyện và mô hình"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'chuẩn bị dataset sạch và cân bằng', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Dữ liệu huấn luyện và mô hình'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Dữ liệu huấn luyện và mô hình"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Dữ liệu huấn luyện và mô hình"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'dataset, preprocessing và train test split', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Dữ liệu huấn luyện và mô hình'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Dữ liệu huấn luyện và mô hình"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Dữ liệu huấn luyện và mô hình", lựa chọn nào là cách làm hợp lý?', 'tách tập train và test trước khi đánh giá', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Dữ liệu huấn luyện và mô hình'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Dữ liệu huấn luyện và mô hình", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "dữ liệu huấn luyện cho mô hình AI" quan trọng trong bài "Dữ liệu huấn luyện và mô hình"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'chất lượng dữ liệu quyết định chất lượng mô hình', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Dữ liệu huấn luyện và mô hình'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "dữ liệu huấn luyện cho mô hình AI" quan trọng trong bài "Dữ liệu huấn luyện và mô hình"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Dữ liệu huấn luyện và mô hình"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'biết chuẩn bị dữ liệu cho AI', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Dữ liệu huấn luyện và mô hình'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Dữ liệu huấn luyện và mô hình"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "chuẩn bị dataset sạch và cân bằng" trong bài "Dữ liệu huấn luyện và mô hình"?', 'đánh giá trên chính dữ liệu đã huấn luyện', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Dữ liệu huấn luyện và mô hình'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "chuẩn bị dataset sạch và cân bằng" trong bài "Dữ liệu huấn luyện và mô hình"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Dữ liệu huấn luyện và mô hình", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'kiểm soát bias và chất lượng nhãn dữ liệu', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Dữ liệu huấn luyện và mô hình'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Dữ liệu huấn luyện và mô hình", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Dữ liệu huấn luyện và mô hình" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'mô hình học từ dữ liệu có cấu trúc rõ', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Dữ liệu huấn luyện và mô hình'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Dữ liệu huấn luyện và mô hình" tốt nhất là gì?'
  );

-- Nhập môn Trí tuệ nhân tạo / Nhận diện khuôn mặt với webcam
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Nhận diện khuôn mặt với webcam", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'nhận diện khuôn mặt bằng webcam', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Nhận diện khuôn mặt với webcam'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Nhận diện khuôn mặt với webcam", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Nhận diện khuôn mặt với webcam" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'preview webcam trong trang bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Nhận diện khuôn mặt với webcam'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Nhận diện khuôn mặt với webcam" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Nhận diện khuôn mặt với webcam"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'xử lý video frame từ camera', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Nhận diện khuôn mặt với webcam'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Nhận diện khuôn mặt với webcam"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Nhận diện khuôn mặt với webcam"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'getUserMedia và face detection', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Nhận diện khuôn mặt với webcam'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Nhận diện khuôn mặt với webcam"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Nhận diện khuôn mặt với webcam", lựa chọn nào là cách làm hợp lý?', 'xin quyền camera rõ ràng và xử lý khi bị từ chối', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Nhận diện khuôn mặt với webcam'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Nhận diện khuôn mặt với webcam", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "nhận diện khuôn mặt bằng webcam" quan trọng trong bài "Nhận diện khuôn mặt với webcam"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'webcam cung cấp dữ liệu thị giác cho phân tích tập trung', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Nhận diện khuôn mặt với webcam'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "nhận diện khuôn mặt bằng webcam" quan trọng trong bài "Nhận diện khuôn mặt với webcam"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Nhận diện khuôn mặt với webcam"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'hiểu luồng camera phục vụ Focus Logs', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Nhận diện khuôn mặt với webcam'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Nhận diện khuôn mặt với webcam"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xử lý video frame từ camera" trong bài "Nhận diện khuôn mặt với webcam"?', 'tự động bật camera không xin phép', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Nhận diện khuôn mặt với webcam'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xử lý video frame từ camera" trong bài "Nhận diện khuôn mặt với webcam"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Nhận diện khuôn mặt với webcam", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'tối ưu hiệu năng khi xử lý frame liên tục', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Nhận diện khuôn mặt với webcam'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Nhận diện khuôn mặt với webcam", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Nhận diện khuôn mặt với webcam" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'phát hiện được trạng thái có hoặc không có khuôn mặt', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Nhận diện khuôn mặt với webcam'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Nhận diện khuôn mặt với webcam" tốt nhất là gì?'
  );

-- Nhập môn Trí tuệ nhân tạo / Đánh giá mô hình AI
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Đánh giá mô hình AI", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'đánh giá mô hình AI', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đánh giá mô hình AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Đánh giá mô hình AI", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Đánh giá mô hình AI" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'bảng confusion matrix cho trạng thái tập trung', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đánh giá mô hình AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Đánh giá mô hình AI" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Đánh giá mô hình AI"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'đo hiệu quả dự đoán của mô hình', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đánh giá mô hình AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Đánh giá mô hình AI"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Đánh giá mô hình AI"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'accuracy, precision, recall và F1-score', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đánh giá mô hình AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Đánh giá mô hình AI"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Đánh giá mô hình AI", lựa chọn nào là cách làm hợp lý?', 'chọn metric phù hợp với mục tiêu hệ thống', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đánh giá mô hình AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Đánh giá mô hình AI", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "đánh giá mô hình AI" quan trọng trong bài "Đánh giá mô hình AI"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'metric giúp quyết định mô hình có đủ tin cậy không', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đánh giá mô hình AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "đánh giá mô hình AI" quan trọng trong bài "Đánh giá mô hình AI"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Đánh giá mô hình AI"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'đọc được báo cáo đánh giá mô hình', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đánh giá mô hình AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Đánh giá mô hình AI"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "đo hiệu quả dự đoán của mô hình" trong bài "Đánh giá mô hình AI"?', 'chỉ nhìn accuracy khi dữ liệu lệch lớp', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đánh giá mô hình AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "đo hiệu quả dự đoán của mô hình" trong bài "Đánh giá mô hình AI"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Đánh giá mô hình AI", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'phân tích lỗi false positive và false negative', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đánh giá mô hình AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Đánh giá mô hình AI", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Đánh giá mô hình AI" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'biết mô hình mạnh yếu ở lớp nào', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đánh giá mô hình AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Đánh giá mô hình AI" tốt nhất là gì?'
  );

-- Nhập môn Trí tuệ nhân tạo / Đạo đức và bảo mật dữ liệu AI
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Đạo đức và bảo mật dữ liệu AI", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'đạo đức và bảo mật dữ liệu AI', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đạo đức và bảo mật dữ liệu AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Đạo đức và bảo mật dữ liệu AI", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Đạo đức và bảo mật dữ liệu AI" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'thông báo mục đích dùng webcam', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đạo đức và bảo mật dữ liệu AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Đạo đức và bảo mật dữ liệu AI" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Đạo đức và bảo mật dữ liệu AI"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'bảo vệ dữ liệu camera và thông tin học tập', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đạo đức và bảo mật dữ liệu AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Đạo đức và bảo mật dữ liệu AI"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Đạo đức và bảo mật dữ liệu AI"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'privacy, consent và data minimization', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đạo đức và bảo mật dữ liệu AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Đạo đức và bảo mật dữ liệu AI"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Đạo đức và bảo mật dữ liệu AI", lựa chọn nào là cách làm hợp lý?', 'chỉ thu thập dữ liệu cần thiết cho mục tiêu học tập', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đạo đức và bảo mật dữ liệu AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Đạo đức và bảo mật dữ liệu AI", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "đạo đức và bảo mật dữ liệu AI" quan trọng trong bài "Đạo đức và bảo mật dữ liệu AI"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'AI trong giáo dục phải minh bạch và tôn trọng riêng tư', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đạo đức và bảo mật dữ liệu AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "đạo đức và bảo mật dữ liệu AI" quan trọng trong bài "Đạo đức và bảo mật dữ liệu AI"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Đạo đức và bảo mật dữ liệu AI"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'nhận diện được rủi ro đạo đức AI', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đạo đức và bảo mật dữ liệu AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Đạo đức và bảo mật dữ liệu AI"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "bảo vệ dữ liệu camera và thông tin học tập" trong bài "Đạo đức và bảo mật dữ liệu AI"?', 'lưu dữ liệu nhạy cảm không có lý do', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đạo đức và bảo mật dữ liệu AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "bảo vệ dữ liệu camera và thông tin học tập" trong bài "Đạo đức và bảo mật dữ liệu AI"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Đạo đức và bảo mật dữ liệu AI", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'ẩn danh hóa và kiểm soát quyền truy cập dữ liệu', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đạo đức và bảo mật dữ liệu AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Đạo đức và bảo mật dữ liệu AI", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Đạo đức và bảo mật dữ liệu AI" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'người dùng hiểu dữ liệu được dùng thế nào', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo'
  AND l.title = 'Đạo đức và bảo mật dữ liệu AI'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Đạo đức và bảo mật dữ liệu AI" tốt nhất là gì?'
  );

-- Phân tích và Thiết kế Hệ thống Thông tin / Tổng quan về phân tích và thiết kế hệ thống
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Tổng quan về phân tích và thiết kế hệ thống", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'phân tích và thiết kế hệ thống', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Tổng quan về phân tích và thiết kế hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Tổng quan về phân tích và thiết kế hệ thống", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Tổng quan về phân tích và thiết kế hệ thống" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'mô hình hệ thống học tập trực tuyến', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Tổng quan về phân tích và thiết kế hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Tổng quan về phân tích và thiết kế hệ thống" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Tổng quan về phân tích và thiết kế hệ thống"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'xác định phạm vi và mục tiêu hệ thống', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Tổng quan về phân tích và thiết kế hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Tổng quan về phân tích và thiết kế hệ thống"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Tổng quan về phân tích và thiết kế hệ thống"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'SDLC, stakeholder và requirement', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Tổng quan về phân tích và thiết kế hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Tổng quan về phân tích và thiết kế hệ thống"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Tổng quan về phân tích và thiết kế hệ thống", lựa chọn nào là cách làm hợp lý?', 'làm rõ vấn đề nghiệp vụ trước khi thiết kế', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Tổng quan về phân tích và thiết kế hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Tổng quan về phân tích và thiết kế hệ thống", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "phân tích và thiết kế hệ thống" quan trọng trong bài "Tổng quan về phân tích và thiết kế hệ thống"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'phân tích thiết kế giúp giảm sai lệch khi triển khai', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Tổng quan về phân tích và thiết kế hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "phân tích và thiết kế hệ thống" quan trọng trong bài "Tổng quan về phân tích và thiết kế hệ thống"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Tổng quan về phân tích và thiết kế hệ thống"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'hiểu vai trò của giai đoạn phân tích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Tổng quan về phân tích và thiết kế hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Tổng quan về phân tích và thiết kế hệ thống"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xác định phạm vi và mục tiêu hệ thống" trong bài "Tổng quan về phân tích và thiết kế hệ thống"?', 'bắt đầu code khi chưa hiểu yêu cầu', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Tổng quan về phân tích và thiết kế hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xác định phạm vi và mục tiêu hệ thống" trong bài "Tổng quan về phân tích và thiết kế hệ thống"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Tổng quan về phân tích và thiết kế hệ thống", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'liên kết mục tiêu kinh doanh với chức năng phần mềm', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Tổng quan về phân tích và thiết kế hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Tổng quan về phân tích và thiết kế hệ thống", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Tổng quan về phân tích và thiết kế hệ thống" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'mô tả được phạm vi hệ thống', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Tổng quan về phân tích và thiết kế hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Tổng quan về phân tích và thiết kế hệ thống" tốt nhất là gì?'
  );

-- Phân tích và Thiết kế Hệ thống Thông tin / Khảo sát và thu thập yêu cầu
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Khảo sát và thu thập yêu cầu", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'thu thập yêu cầu hệ thống', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Khảo sát và thu thập yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Khảo sát và thu thập yêu cầu", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Khảo sát và thu thập yêu cầu" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'bảng câu hỏi cho sinh viên và giảng viên', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Khảo sát và thu thập yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Khảo sát và thu thập yêu cầu" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Khảo sát và thu thập yêu cầu"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'khảo sát người dùng và stakeholder', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Khảo sát và thu thập yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Khảo sát và thu thập yêu cầu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Khảo sát và thu thập yêu cầu"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'interview, survey và observation', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Khảo sát và thu thập yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Khảo sát và thu thập yêu cầu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Khảo sát và thu thập yêu cầu", lựa chọn nào là cách làm hợp lý?', 'ghi nhận yêu cầu bằng ngôn ngữ rõ ràng đo được', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Khảo sát và thu thập yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Khảo sát và thu thập yêu cầu", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "thu thập yêu cầu hệ thống" quan trọng trong bài "Khảo sát và thu thập yêu cầu"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'thu thập yêu cầu tốt giúp hệ thống giải đúng bài toán', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Khảo sát và thu thập yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "thu thập yêu cầu hệ thống" quan trọng trong bài "Khảo sát và thu thập yêu cầu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Khảo sát và thu thập yêu cầu"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'lập được danh sách yêu cầu ban đầu', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Khảo sát và thu thập yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Khảo sát và thu thập yêu cầu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "khảo sát người dùng và stakeholder" trong bài "Khảo sát và thu thập yêu cầu"?', 'chỉ hỏi một người rồi kết luận cho toàn hệ thống', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Khảo sát và thu thập yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "khảo sát người dùng và stakeholder" trong bài "Khảo sát và thu thập yêu cầu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Khảo sát và thu thập yêu cầu", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'phân loại yêu cầu chức năng và phi chức năng', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Khảo sát và thu thập yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Khảo sát và thu thập yêu cầu", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Khảo sát và thu thập yêu cầu" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'danh sách yêu cầu phản ánh đúng nhu cầu thực tế', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Khảo sát và thu thập yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Khảo sát và thu thập yêu cầu" tốt nhất là gì?'
  );

-- Phân tích và Thiết kế Hệ thống Thông tin / Use Case và đặc tả yêu cầu
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Use Case và đặc tả yêu cầu", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'use case và đặc tả yêu cầu', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Use Case và đặc tả yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Use Case và đặc tả yêu cầu", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Use Case và đặc tả yêu cầu" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'use case làm quiz adaptive', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Use Case và đặc tả yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Use Case và đặc tả yêu cầu" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Use Case và đặc tả yêu cầu"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'mô tả tương tác giữa actor và hệ thống', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Use Case và đặc tả yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Use Case và đặc tả yêu cầu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Use Case và đặc tả yêu cầu"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'actor, use case, main flow và alternative flow', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Use Case và đặc tả yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Use Case và đặc tả yêu cầu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Use Case và đặc tả yêu cầu", lựa chọn nào là cách làm hợp lý?', 'viết use case theo mục tiêu người dùng', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Use Case và đặc tả yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Use Case và đặc tả yêu cầu", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "use case và đặc tả yêu cầu" quan trọng trong bài "Use Case và đặc tả yêu cầu"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'use case giúp chuyển yêu cầu thành chức năng rõ ràng', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Use Case và đặc tả yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "use case và đặc tả yêu cầu" quan trọng trong bài "Use Case và đặc tả yêu cầu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Use Case và đặc tả yêu cầu"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'viết được đặc tả use case cơ bản', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Use Case và đặc tả yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Use Case và đặc tả yêu cầu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "mô tả tương tác giữa actor và hệ thống" trong bài "Use Case và đặc tả yêu cầu"?', 'mô tả use case bằng câu quá mơ hồ', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Use Case và đặc tả yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "mô tả tương tác giữa actor và hệ thống" trong bài "Use Case và đặc tả yêu cầu"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Use Case và đặc tả yêu cầu", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'xử lý ngoại lệ và tiền điều kiện hậu điều kiện', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Use Case và đặc tả yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Use Case và đặc tả yêu cầu", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Use Case và đặc tả yêu cầu" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'người đọc hiểu được hệ thống phản hồi ra sao', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Use Case và đặc tả yêu cầu'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Use Case và đặc tả yêu cầu" tốt nhất là gì?'
  );

-- Phân tích và Thiết kế Hệ thống Thông tin / Thiết kế cơ sở dữ liệu và ERD
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Thiết kế cơ sở dữ liệu và ERD", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'thiết kế database và ERD', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế cơ sở dữ liệu và ERD'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Thiết kế cơ sở dữ liệu và ERD", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Thiết kế cơ sở dữ liệu và ERD" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'ERD cho courses lessons questions', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế cơ sở dữ liệu và ERD'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Thiết kế cơ sở dữ liệu và ERD" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Thiết kế cơ sở dữ liệu và ERD"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'xác định bảng và quan hệ dữ liệu', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế cơ sở dữ liệu và ERD'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Thiết kế cơ sở dữ liệu và ERD"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Thiết kế cơ sở dữ liệu và ERD"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'entity, relationship, primary key và foreign key', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế cơ sở dữ liệu và ERD'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Thiết kế cơ sở dữ liệu và ERD"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Thiết kế cơ sở dữ liệu và ERD", lựa chọn nào là cách làm hợp lý?', 'đặt khóa ngoại đúng theo quan hệ nghiệp vụ', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế cơ sở dữ liệu và ERD'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Thiết kế cơ sở dữ liệu và ERD", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "thiết kế database và ERD" quan trọng trong bài "Thiết kế cơ sở dữ liệu và ERD"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'ERD giúp backend map entity và query chính xác', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế cơ sở dữ liệu và ERD'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "thiết kế database và ERD" quan trọng trong bài "Thiết kế cơ sở dữ liệu và ERD"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Thiết kế cơ sở dữ liệu và ERD"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'thiết kế được sơ đồ database cơ bản', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế cơ sở dữ liệu và ERD'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Thiết kế cơ sở dữ liệu và ERD"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xác định bảng và quan hệ dữ liệu" trong bài "Thiết kế cơ sở dữ liệu và ERD"?', 'lưu dữ liệu lặp lại thay vì tạo quan hệ', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế cơ sở dữ liệu và ERD'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xác định bảng và quan hệ dữ liệu" trong bài "Thiết kế cơ sở dữ liệu và ERD"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Thiết kế cơ sở dữ liệu và ERD", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'chuẩn hóa và ràng buộc toàn vẹn dữ liệu', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế cơ sở dữ liệu và ERD'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Thiết kế cơ sở dữ liệu và ERD", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Thiết kế cơ sở dữ liệu và ERD" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'ERD thể hiện đúng liên kết giữa các bảng', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế cơ sở dữ liệu và ERD'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Thiết kế cơ sở dữ liệu và ERD" tốt nhất là gì?'
  );

-- Phân tích và Thiết kế Hệ thống Thông tin / Thiết kế giao diện người dùng (UI/UX)
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Thiết kế giao diện người dùng (UI/UX)", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'thiết kế UI UX cho hệ thống', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế giao diện người dùng (UI/UX)'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Thiết kế giao diện người dùng (UI/UX)", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Thiết kế giao diện người dùng (UI/UX)" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'flow học course lesson quiz feedback', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế giao diện người dùng (UI/UX)'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Thiết kế giao diện người dùng (UI/UX)" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Thiết kế giao diện người dùng (UI/UX)"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'xây dựng flow màn hình dễ dùng', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế giao diện người dùng (UI/UX)'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Thiết kế giao diện người dùng (UI/UX)"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Thiết kế giao diện người dùng (UI/UX)"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'wireframe, user flow và usability', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế giao diện người dùng (UI/UX)'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Thiết kế giao diện người dùng (UI/UX)"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Thiết kế giao diện người dùng (UI/UX)", lựa chọn nào là cách làm hợp lý?', 'ưu tiên tác vụ chính của người dùng trên giao diện', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế giao diện người dùng (UI/UX)'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Thiết kế giao diện người dùng (UI/UX)", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "thiết kế UI UX cho hệ thống" quan trọng trong bài "Thiết kế giao diện người dùng (UI/UX)"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'UI UX tốt làm hệ thống dễ demo và dễ dùng', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế giao diện người dùng (UI/UX)'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "thiết kế UI UX cho hệ thống" quan trọng trong bài "Thiết kế giao diện người dùng (UI/UX)"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Thiết kế giao diện người dùng (UI/UX)"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'phác thảo được màn hình theo flow', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế giao diện người dùng (UI/UX)'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Thiết kế giao diện người dùng (UI/UX)"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xây dựng flow màn hình dễ dùng" trong bài "Thiết kế giao diện người dùng (UI/UX)"?', 'đưa quá nhiều thông tin kỹ thuật ra màn hình', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế giao diện người dùng (UI/UX)'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xây dựng flow màn hình dễ dùng" trong bài "Thiết kế giao diện người dùng (UI/UX)"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Thiết kế giao diện người dùng (UI/UX)", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'kiểm tra responsive và trạng thái rỗng lỗi loading', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế giao diện người dùng (UI/UX)'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Thiết kế giao diện người dùng (UI/UX)", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Thiết kế giao diện người dùng (UI/UX)" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'người dùng hoàn thành tác vụ ít nhầm lẫn hơn', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Thiết kế giao diện người dùng (UI/UX)'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Thiết kế giao diện người dùng (UI/UX)" tốt nhất là gì?'
  );

-- Phân tích và Thiết kế Hệ thống Thông tin / Kiểm thử và triển khai hệ thống
INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong bài "Kiểm thử và triển khai hệ thống", nội dung nào là trọng tâm đầu tiên người học cần nắm?', 'kiểm thử và triển khai hệ thống', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Kiểm thử và triển khai hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong bài "Kiểm thử và triển khai hệ thống", nội dung nào là trọng tâm đầu tiên người học cần nắm?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kết quả thực hành cơ bản của bài "Kiểm thử và triển khai hệ thống" là gì?', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'test flow đăng nhập học quiz dashboard', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Kiểm thử và triển khai hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kết quả thực hành cơ bản của bài "Kiểm thử và triển khai hệ thống" là gì?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Kiểm thử và triển khai hệ thống"?', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'xác nhận hệ thống chạy đúng trước khi bàn giao', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Kiểm thử và triển khai hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Kỹ năng nào liên quan trực tiếp nhất đến bài "Kiểm thử và triển khai hệ thống"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Kiểm thử và triển khai hệ thống"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'test case, build và deployment checklist', 'D', 'basic', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Kiểm thử và triển khai hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Công cụ hoặc khái niệm nào thường được dùng trong bài "Kiểm thử và triển khai hệ thống"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Khi áp dụng nội dung bài "Kiểm thử và triển khai hệ thống", lựa chọn nào là cách làm hợp lý?', 'kiểm thử theo luồng người dùng quan trọng', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'A', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Kiểm thử và triển khai hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Khi áp dụng nội dung bài "Kiểm thử và triển khai hệ thống", lựa chọn nào là cách làm hợp lý?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Vì sao nội dung "kiểm thử và triển khai hệ thống" quan trọng trong bài "Kiểm thử và triển khai hệ thống"?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'kiểm thử giúp giảm lỗi khi người dùng thật sử dụng', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Kiểm thử và triển khai hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Vì sao nội dung "kiểm thử và triển khai hệ thống" quan trọng trong bài "Kiểm thử và triển khai hệ thống"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Dấu hiệu nào cho thấy người học đã hiểu bài "Kiểm thử và triển khai hệ thống"?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'lập được checklist test và triển khai', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'C', 'medium', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Kiểm thử và triển khai hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Dấu hiệu nào cho thấy người học đã hiểu bài "Kiểm thử và triển khai hệ thống"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xác nhận hệ thống chạy đúng trước khi bàn giao" trong bài "Kiểm thử và triển khai hệ thống"?', 'chỉ kiểm tra một màn hình rồi kết luận hệ thống ổn', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'Bỏ qua kiểm tra kết quả sau khi thực hành', 'A', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Kiểm thử và triển khai hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Rủi ro nào dễ xảy ra nếu triển khai sai kỹ năng "xác nhận hệ thống chạy đúng trước khi bàn giao" trong bài "Kiểm thử và triển khai hệ thống"?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Trong tình huống phức tạp của bài "Kiểm thử và triển khai hệ thống", yếu tố nào cần ưu tiên phân tích?', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'quản lý lỗi phát sinh sau triển khai', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Tập trung vào thao tác ngoài phạm vi bài học', 'B', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Kiểm thử và triển khai hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Trong tình huống phức tạp của bài "Kiểm thử và triển khai hệ thống", yếu tố nào cần ưu tiên phân tích?'
  );

INSERT INTO questions (lesson_id, question_content, option_a, option_b, option_c, option_d, correct_answer, difficulty_level, created_at, updated_at)
SELECT l.id, 'Cách kiểm chứng kết quả học tập của bài "Kiểm thử và triển khai hệ thống" tốt nhất là gì?', 'Chỉ thay đổi màu giao diện mà không liên quan nội dung bài', 'Sao chép mã hoặc câu lệnh mà không hiểu mục đích', 'Tập trung vào thao tác ngoài phạm vi bài học', 'hệ thống chạy ổn định trên môi trường demo', 'D', 'hard', NOW(), NOW()
FROM lessons l
JOIN courses c ON c.id = l.course_id
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin'
  AND l.title = 'Kiểm thử và triển khai hệ thống'
  AND NOT EXISTS (
      SELECT 1 FROM questions q
      WHERE q.lesson_id = l.id AND q.question_content = 'Cách kiểm chứng kết quả học tập của bài "Kiểm thử và triển khai hệ thống" tốt nhất là gì?'
  );

COMMIT;

-- =========================
-- VERIFICATION QUERIES
-- =========================
-- 1. Count seeded courses
-- SELECT COUNT(*) AS seeded_courses FROM courses WHERE title IN (
--   'Lập trình Java cơ bản',
--   'Cơ sở dữ liệu MySQL',
--   'Phát triển Web Frontend với React',
--   'Lập trình Backend với Spring Boot',
--   'Nhập môn Trí tuệ nhân tạo',
--   'Phân tích và Thiết kế Hệ thống Thông tin'
-- );

-- 2. Lessons per seeded course, expected lessons_per_course = 6
-- SELECT c.title, COUNT(l.id) AS lessons_per_course
-- FROM courses c
-- LEFT JOIN lessons l ON l.course_id = c.id
-- WHERE c.title IN (
--   'Lập trình Java cơ bản',
--   'Cơ sở dữ liệu MySQL',
--   'Phát triển Web Frontend với React',
--   'Lập trình Backend với Spring Boot',
--   'Nhập môn Trí tuệ nhân tạo',
--   'Phân tích và Thiết kế Hệ thống Thông tin'
-- )
-- GROUP BY c.id, c.title;

-- 3. Questions per seeded lesson, expected questions_per_lesson = 10
-- SELECT c.title AS course_title, l.title AS lesson_title, COUNT(q.id) AS questions_per_lesson
-- FROM courses c
-- JOIN lessons l ON l.course_id = c.id
-- LEFT JOIN questions q ON q.lesson_id = l.id
-- WHERE c.title IN (
--   'Lập trình Java cơ bản',
--   'Cơ sở dữ liệu MySQL',
--   'Phát triển Web Frontend với React',
--   'Lập trình Backend với Spring Boot',
--   'Nhập môn Trí tuệ nhân tạo',
--   'Phân tích và Thiết kế Hệ thống Thông tin'
-- )
-- GROUP BY c.id, c.title, l.id, l.title
-- ORDER BY c.id, l.order_number;

-- 4. Difficulty distribution per lesson, expected basic=4, medium=3, hard=3
-- SELECT c.title AS course_title, l.title AS lesson_title, q.difficulty_level, COUNT(*) AS total
-- FROM courses c
-- JOIN lessons l ON l.course_id = c.id
-- JOIN questions q ON q.lesson_id = l.id
-- WHERE c.title IN (
--   'Lập trình Java cơ bản',
--   'Cơ sở dữ liệu MySQL',
--   'Phát triển Web Frontend với React',
--   'Lập trình Backend với Spring Boot',
--   'Nhập môn Trí tuệ nhân tạo',
--   'Phân tích và Thiết kế Hệ thống Thông tin'
-- )
-- GROUP BY c.id, c.title, l.id, l.title, q.difficulty_level
-- ORDER BY c.id, l.order_number, FIELD(q.difficulty_level, 'basic', 'medium', 'hard');
