# SEED IT COURSES REPORT

Ngày tạo: 2026-06-11

## 1. File SQL đã tạo/sửa

- Tạo mới: `sample_it_courses.sql`
- Không sửa `sample_data.sql`.
- Không sửa `database.sql` và không thay đổi schema database.

## 2. Danh sách khóa học đã thêm

1. Lập trình Java cơ bản
2. Cơ sở dữ liệu MySQL
3. Phát triển Web Frontend với React
4. Lập trình Backend với Spring Boot
5. Nhập môn Trí tuệ nhân tạo
6. Phân tích và Thiết kế Hệ thống Thông tin

## 3. Số bài giảng mỗi khóa học

Mỗi khóa học có đúng 6 bài giảng.

| Khóa học | Số bài giảng |
|---|---:|
| Lập trình Java cơ bản | 6 |
| Cơ sở dữ liệu MySQL | 6 |
| Phát triển Web Frontend với React | 6 |
| Lập trình Backend với Spring Boot | 6 |
| Nhập môn Trí tuệ nhân tạo | 6 |
| Phân tích và Thiết kế Hệ thống Thông tin | 6 |

## 4. Số câu hỏi mỗi bài giảng

Mỗi bài giảng có đúng 10 câu hỏi.

Tổng số bài giảng: 36

Tổng số câu hỏi: 360

## 5. Phân bố difficulty

Mỗi bài giảng có:

- 4 câu `basic`
- 3 câu `medium`
- 3 câu `hard`

Tổng toàn bộ seed:

| Difficulty | Số câu |
|---|---:|
| basic | 144 |
| medium | 108 |
| hard | 108 |

## 6. Cách import SQL

Sau khi đã tạo database bằng `database.sql`, import file seed:

```bash
mysql -u root -p adaptive_learning_db < sample_it_courses.sql
```

Hoặc trong MySQL client:

```sql
USE adaptive_learning_db;
SOURCE D:/DATN/sample_it_courses.sql;
```

## 7. Cách kiểm tra dữ liệu sau khi import

Đếm 6 khóa học seed:

```sql
SELECT COUNT(*) AS seeded_courses
FROM courses
WHERE title IN ('Lập trình Java cơ bản', 'Cơ sở dữ liệu MySQL', 'Phát triển Web Frontend với React', 'Lập trình Backend với Spring Boot', 'Nhập môn Trí tuệ nhân tạo', 'Phân tích và Thiết kế Hệ thống Thông tin');
```

Kiểm tra mỗi khóa học có 6 bài giảng:

```sql
SELECT c.title, COUNT(l.id) AS lessons_per_course
FROM courses c
LEFT JOIN lessons l ON l.course_id = c.id
WHERE c.title IN ('Lập trình Java cơ bản', 'Cơ sở dữ liệu MySQL', 'Phát triển Web Frontend với React', 'Lập trình Backend với Spring Boot', 'Nhập môn Trí tuệ nhân tạo', 'Phân tích và Thiết kế Hệ thống Thông tin')
GROUP BY c.id, c.title;
```

Kiểm tra mỗi bài giảng có 10 câu hỏi:

```sql
SELECT c.title AS course_title, l.title AS lesson_title, COUNT(q.id) AS questions_per_lesson
FROM courses c
JOIN lessons l ON l.course_id = c.id
LEFT JOIN questions q ON q.lesson_id = l.id
WHERE c.title IN ('Lập trình Java cơ bản', 'Cơ sở dữ liệu MySQL', 'Phát triển Web Frontend với React', 'Lập trình Backend với Spring Boot', 'Nhập môn Trí tuệ nhân tạo', 'Phân tích và Thiết kế Hệ thống Thông tin')
GROUP BY c.id, c.title, l.id, l.title
ORDER BY c.id, l.order_number;
```

Kiểm tra phân bố difficulty mỗi bài:

```sql
SELECT c.title AS course_title, l.title AS lesson_title, q.difficulty_level, COUNT(*) AS total
FROM courses c
JOIN lessons l ON l.course_id = c.id
JOIN questions q ON q.lesson_id = l.id
WHERE c.title IN ('Lập trình Java cơ bản', 'Cơ sở dữ liệu MySQL', 'Phát triển Web Frontend với React', 'Lập trình Backend với Spring Boot', 'Nhập môn Trí tuệ nhân tạo', 'Phân tích và Thiết kế Hệ thống Thông tin')
GROUP BY c.id, c.title, l.id, l.title, q.difficulty_level
ORDER BY c.id, l.order_number, FIELD(q.difficulty_level, 'basic', 'medium', 'hard');
```

Kỳ vọng:

- 6 khóa học
- 36 bài giảng
- 360 câu hỏi
- Mỗi bài: `basic = 4`, `medium = 3`, `hard = 3`

## 8. Có thay đổi schema hay không

Không thay đổi schema database.

File seed chỉ insert dữ liệu vào các bảng hiện có:

- `courses`
- `lessons`
- `questions`

Không dùng Google Drive, không tạo file upload thật, không sửa backend/frontend.
