-- =============================================================
-- UPDATE video_url cho 36 bài học
-- Chạy file này sau khi đã import sample_it_courses.sql
-- Lưu ý: kiểm tra lại các URL trước khi chạy vào production
-- =============================================================

USE adaptive_learning_db;

-- ========================
-- Java cơ bản (6 bài)
-- ========================
UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=DgIN8-vvvhY'
WHERE c.title = 'Lập trình Java cơ bản' AND l.title = 'Giới thiệu Java và môi trường phát triển';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=2b70hAXPSuc'
WHERE c.title = 'Lập trình Java cơ bản' AND l.title = 'Biến, kiểu dữ liệu và toán tử';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=pd5-FegSo3s'
WHERE c.title = 'Lập trình Java cơ bản' AND l.title = 'Câu lệnh điều kiện và vòng lặp';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=NpuR0244KfM'
WHERE c.title = 'Lập trình Java cơ bản' AND l.title = 'Mảng và String';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=wO4oDe-hEKo'
WHERE c.title = 'Lập trình Java cơ bản' AND l.title = 'Lập trình hướng đối tượng';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=EVoMK9Yo0fY'
WHERE c.title = 'Lập trình Java cơ bản' AND l.title = 'Xử lý ngoại lệ và Collection';

-- ========================
-- MySQL (6 bài)
-- ========================
UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=TslBGnENTFw'
WHERE c.title = 'Cơ sở dữ liệu MySQL' AND l.title = 'Tổng quan cơ sở dữ liệu quan hệ';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=aK8NJrpqcOI'
WHERE c.title = 'Cơ sở dữ liệu MySQL' AND l.title = 'Tạo database, table và kiểu dữ liệu';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=AIlpTG75leU'
WHERE c.title = 'Cơ sở dữ liệu MySQL' AND l.title = 'SELECT, WHERE, ORDER BY';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=0PwRrIqjfa8'
WHERE c.title = 'Cơ sở dữ liệu MySQL' AND l.title = 'INSERT, UPDATE, DELETE';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=1d_bVdkqvos'
WHERE c.title = 'Cơ sở dữ liệu MySQL' AND l.title = 'JOIN và quan hệ giữa các bảng';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=RKoP5L37ZIE'
WHERE c.title = 'Cơ sở dữ liệu MySQL' AND l.title = 'Index, transaction và tối ưu truy vấn';

-- ========================
-- React (6 bài)
-- ========================
UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=vok14zYNs7o'
WHERE c.title = 'Phát triển Web Frontend với React' AND l.title = 'Giới thiệu React và JSX';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=5TJ5RcPxPR8'
WHERE c.title = 'Phát triển Web Frontend với React' AND l.title = 'Component và Props';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=Wvc_5yV6-UY'
WHERE c.title = 'Phát triển Web Frontend với React' AND l.title = 'State và Event Handling';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=RhJjWetu__Q'
WHERE c.title = 'Phát triển Web Frontend với React' AND l.title = 'useEffect và gọi API';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=TkDW1V7o5Bk'
WHERE c.title = 'Phát triển Web Frontend với React' AND l.title = 'React Router và điều hướng';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=Wsxs9DoR3kM'
WHERE c.title = 'Phát triển Web Frontend với React' AND l.title = 'Form và Axios';

-- ========================
-- Spring Boot (6 bài)
-- ========================
UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=po5J1QRJQwk'
WHERE c.title = 'Lập trình Backend với Spring Boot' AND l.title = 'Giới thiệu Spring Boot và REST API';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=Nwyw5i71uik'
WHERE c.title = 'Lập trình Backend với Spring Boot' AND l.title = 'Controller, Service, Repository';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=XnedM4o4yDo'
WHERE c.title = 'Lập trình Backend với Spring Boot' AND l.title = 'JPA và kết nối database';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=GZAZgtWa96g'
WHERE c.title = 'Lập trình Backend với Spring Boot' AND l.title = 'DTO và Validation';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=AxUzQU22y10'
WHERE c.title = 'Lập trình Backend với Spring Boot' AND l.title = 'Xử lý lỗi và Exception Handler';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=TMUyJonQwXc'
WHERE c.title = 'Lập trình Backend với Spring Boot' AND l.title = 'Bảo mật cơ bản với Spring Security';

-- ========================
-- Nhập môn AI (6 bài)
-- ========================
UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=FCYx85pRonQ'
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo' AND l.title = 'Trí tuệ nhân tạo là gì?';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=_ZjIv2D6T40'
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo' AND l.title = 'Machine Learning cơ bản';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=VsXKtjddXWY'
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo' AND l.title = 'Dữ liệu và tiền xử lý';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=MTbMuJgScH0'
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo' AND l.title = 'Nhận diện khuôn mặt với OpenCV';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=yrQe6aFKMYg'
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo' AND l.title = 'Đánh giá mô hình AI';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=SBpObrCYsUs'
WHERE c.title = 'Nhập môn Trí tuệ nhân tạo' AND l.title = 'Đạo đức trong AI';

-- ========================
-- Phân tích & Thiết kế HTTT (6 bài)
-- ========================
UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=VLL77XefAHQ'
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin' AND l.title = 'Khảo sát và phân tích yêu cầu';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=95U5gmR935g'
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin' AND l.title = 'Use Case và sơ đồ Use Case';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=XkqciOtQUCI'
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin' AND l.title = 'ERD và thiết kế cơ sở dữ liệu';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=42oSbwMoAvM'
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin' AND l.title = 'Thiết kế giao diện UI/UX';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=WGJHpn2oUuY'
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin' AND l.title = 'Kiểm thử hệ thống';

UPDATE lessons l JOIN courses c ON l.course_id = c.id
SET l.video_url = 'https://www.youtube.com/watch?v=mrU5_ckq8NA'
WHERE c.title = 'Phân tích và Thiết kế Hệ thống Thông tin' AND l.title = 'Triển khai và bảo trì hệ thống';

-- Kiểm tra kết quả
SELECT c.title AS course, l.title AS lesson, l.video_url
FROM lessons l JOIN courses c ON l.course_id = c.id
ORDER BY c.id, l.order_number;
