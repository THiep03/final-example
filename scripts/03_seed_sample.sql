-- =============================================================
-- 03_seed_sample.sql
-- Dữ liệu mẫu cơ bản: 3 users, 2 courses, lessons, questions
-- =============================================================
USE adaptive_learning_db;

START TRANSACTION;

-- =========================
-- USERS
-- =========================
INSERT INTO users (name, email, password, role, current_level, created_at, updated_at)
SELECT 'Nguyen Van An', 'an.student@example.com', '123456', 'student', 'basic', NOW(), NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM users WHERE email = 'an.student@example.com'
);

INSERT INTO users (name, email, password, role, current_level, created_at, updated_at)
SELECT 'Tran Thi Binh', 'binh.student@example.com', '123456', 'student', 'medium', NOW(), NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM users WHERE email = 'binh.student@example.com'
);

INSERT INTO users (name, email, password, role, current_level, created_at, updated_at)
SELECT 'Admin DATN', 'admin@example.com', 'admin123', 'admin', 'hard', NOW(), NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM users WHERE email = 'admin@example.com'
);

-- =========================
-- COURSES
-- =========================
INSERT INTO courses (title, description, thumbnail_url, status, created_at, updated_at)
SELECT
    'Java co ban',
    'Khoa hoc nhap mon Java danh cho nguoi moi bat dau, bao gom cu phap, bien, kieu du lieu va lap trinh huong doi tuong.',
    'http://localhost:5173/images/java-basic-thumbnail.jpg',
    'published',
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM courses WHERE title = 'Java co ban'
);

INSERT INTO courses (title, description, thumbnail_url, status, created_at, updated_at)
SELECT
    'Nhap mon Web Frontend',
    'Khoa hoc gioi thieu HTML, CSS va JavaScript de xay dung giao dien web don gian.',
    'http://localhost:5173/images/frontend-basic-thumbnail.jpg',
    'published',
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM courses WHERE title = 'Nhap mon Web Frontend'
);

-- =========================
-- FILE STORAGE
-- =========================
INSERT INTO file_storage (
    file_name,
    file_type,
    storage_provider,
    file_url,
    drive_file_id,
    mime_type,
    file_size,
    created_at,
    updated_at
)
SELECT
    'java-introduction.mp4',
    'video',
    'local',
    'http://localhost:8080/files/videos/java-introduction.mp4',
    NULL,
    'video/mp4',
    52428800,
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM file_storage WHERE file_name = 'java-introduction.mp4'
);

INSERT INTO file_storage (
    file_name,
    file_type,
    storage_provider,
    file_url,
    drive_file_id,
    mime_type,
    file_size,
    created_at,
    updated_at
)
SELECT
    'java-oop-basics.mp4',
    'video',
    'local',
    'http://localhost:8080/files/videos/java-oop-basics.mp4',
    NULL,
    'video/mp4',
    68157440,
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM file_storage WHERE file_name = 'java-oop-basics.mp4'
);

INSERT INTO file_storage (
    file_name,
    file_type,
    storage_provider,
    file_url,
    drive_file_id,
    mime_type,
    file_size,
    created_at,
    updated_at
)
SELECT
    'java-basic-slide.pdf',
    'document',
    'local',
    'http://localhost:8080/files/documents/java-basic-slide.pdf',
    NULL,
    'application/pdf',
    3145728,
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM file_storage WHERE file_name = 'java-basic-slide.pdf'
);

SET @java_course_id := (
    SELECT id FROM courses WHERE title = 'Java co ban' ORDER BY id LIMIT 1
);

SET @java_intro_video_id := (
    SELECT id FROM file_storage WHERE file_name = 'java-introduction.mp4' ORDER BY id LIMIT 1
);

SET @java_oop_video_id := (
    SELECT id FROM file_storage WHERE file_name = 'java-oop-basics.mp4' ORDER BY id LIMIT 1
);

-- =========================
-- LESSONS
-- =========================
INSERT INTO lessons (
    course_id,
    video_file_id,
    title,
    description,
    video_url,
    duration,
    order_number,
    created_at,
    updated_at
)
SELECT
    @java_course_id,
    @java_intro_video_id,
    'Bai 1: Gioi thieu Java va cu phap co ban',
    'Tim hieu Java la gi, cach viet chuong trinh dau tien, khai bao bien va su dung cac kieu du lieu co ban.',
    'http://localhost:8080/files/videos/java-introduction.mp4',
    25,
    1,
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1
    FROM lessons
    WHERE course_id = @java_course_id
      AND title = 'Bai 1: Gioi thieu Java va cu phap co ban'
);

INSERT INTO lessons (
    course_id,
    video_file_id,
    title,
    description,
    video_url,
    duration,
    order_number,
    created_at,
    updated_at
)
SELECT
    @java_course_id,
    @java_oop_video_id,
    'Bai 2: Lap trinh huong doi tuong trong Java',
    'Lam quen voi class, object, constructor, method va cac nguyen ly co ban cua lap trinh huong doi tuong.',
    'http://localhost:8080/files/videos/java-oop-basics.mp4',
    35,
    2,
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1
    FROM lessons
    WHERE course_id = @java_course_id
      AND title = 'Bai 2: Lap trinh huong doi tuong trong Java'
);

SET @lesson_intro_id := (
    SELECT id
    FROM lessons
    WHERE course_id = @java_course_id
      AND title = 'Bai 1: Gioi thieu Java va cu phap co ban'
    ORDER BY id
    LIMIT 1
);

SET @lesson_oop_id := (
    SELECT id
    FROM lessons
    WHERE course_id = @java_course_id
      AND title = 'Bai 2: Lap trinh huong doi tuong trong Java'
    ORDER BY id
    LIMIT 1
);

-- =========================
-- QUESTIONS - LESSON 1
-- =========================
INSERT INTO questions (
    lesson_id,
    question_content,
    option_a,
    option_b,
    option_c,
    option_d,
    correct_answer,
    difficulty_level,
    created_at,
    updated_at
)
SELECT
    @lesson_intro_id,
    'Tu khoa nao dung de khai bao lop trong Java?',
    'class',
    'function',
    'define',
    'module',
    'A',
    'basic',
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE lesson_id = @lesson_intro_id
      AND question_content = 'Tu khoa nao dung de khai bao lop trong Java?'
);

INSERT INTO questions (
    lesson_id,
    question_content,
    option_a,
    option_b,
    option_c,
    option_d,
    correct_answer,
    difficulty_level,
    created_at,
    updated_at
)
SELECT
    @lesson_intro_id,
    'Kieu du lieu nao trong Java dung de luu so nguyen?',
    'String',
    'boolean',
    'int',
    'double',
    'C',
    'medium',
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE lesson_id = @lesson_intro_id
      AND question_content = 'Kieu du lieu nao trong Java dung de luu so nguyen?'
);

INSERT INTO questions (
    lesson_id,
    question_content,
    option_a,
    option_b,
    option_c,
    option_d,
    correct_answer,
    difficulty_level,
    created_at,
    updated_at
)
SELECT
    @lesson_intro_id,
    'Phuong thuc main dung trong Java console application co dang nao?',
    'public void main(String args)',
    'public static void main(String[] args)',
    'static main(String[] args)',
    'public int main(String[] args)',
    'B',
    'hard',
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE lesson_id = @lesson_intro_id
      AND question_content = 'Phuong thuc main dung trong Java console application co dang nao?'
);

-- =========================
-- QUESTIONS - LESSON 2
-- =========================
INSERT INTO questions (
    lesson_id,
    question_content,
    option_a,
    option_b,
    option_c,
    option_d,
    correct_answer,
    difficulty_level,
    created_at,
    updated_at
)
SELECT
    @lesson_oop_id,
    'Object trong Java duoc tao tu dau?',
    'Package',
    'Interface',
    'Class',
    'Database',
    'C',
    'basic',
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE lesson_id = @lesson_oop_id
      AND question_content = 'Object trong Java duoc tao tu dau?'
);

INSERT INTO questions (
    lesson_id,
    question_content,
    option_a,
    option_b,
    option_c,
    option_d,
    correct_answer,
    difficulty_level,
    created_at,
    updated_at
)
SELECT
    @lesson_oop_id,
    'Constructor trong Java thuong duoc dung de lam gi?',
    'Khoi tao doi tuong',
    'Xoa doi tuong',
    'Bien dich chuong trinh',
    'Tao database',
    'A',
    'medium',
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE lesson_id = @lesson_oop_id
      AND question_content = 'Constructor trong Java thuong duoc dung de lam gi?'
);

INSERT INTO questions (
    lesson_id,
    question_content,
    option_a,
    option_b,
    option_c,
    option_d,
    correct_answer,
    difficulty_level,
    created_at,
    updated_at
)
SELECT
    @lesson_oop_id,
    'Tinh dong goi trong OOP khuyen khich dieu gi?',
    'Dat tat ca thuoc tinh la public',
    'An du lieu ben trong object va truy cap qua method phu hop',
    'Khong su dung class',
    'Chi viet code trong main method',
    'B',
    'hard',
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE lesson_id = @lesson_oop_id
      AND question_content = 'Tinh dong goi trong OOP khuyen khich dieu gi?'
);

COMMIT;

