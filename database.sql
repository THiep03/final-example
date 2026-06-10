CREATE DATABASE IF NOT EXISTS adaptive_learning_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE adaptive_learning_db;

-- =========================
-- USERS
-- =========================
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    password VARCHAR(255),

    role ENUM('student', 'admin')
    DEFAULT 'student',

    current_level ENUM('basic', 'medium', 'hard')
    DEFAULT 'basic',

    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- =========================
-- COURSES
-- =========================
CREATE TABLE courses (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    thumbnail_url VARCHAR(500),

    status ENUM('draft', 'published')
    DEFAULT 'draft',

    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- =========================
-- FILE STORAGE
-- =========================
CREATE TABLE file_storage (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    file_name VARCHAR(255) NOT NULL,

    file_type ENUM('video', 'image', 'document')
    DEFAULT 'video',

    storage_provider ENUM('google_drive', 'local')
    DEFAULT 'google_drive',

    file_url VARCHAR(500),
    drive_file_id VARCHAR(255),
    mime_type VARCHAR(100),
    file_size BIGINT,

    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- =========================
-- LESSONS
-- =========================
CREATE TABLE lessons (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    course_id BIGINT NULL,
    video_file_id BIGINT NULL,

    title VARCHAR(255),
    description TEXT,
    video_url VARCHAR(500),

    duration INT,
    order_number INT,

    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,

    CONSTRAINT fk_lessons_course
        FOREIGN KEY (course_id)
        REFERENCES courses(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_lessons_file
        FOREIGN KEY (video_file_id)
        REFERENCES file_storage(id)
        ON DELETE SET NULL
);

-- =========================
-- QUESTIONS
-- =========================
CREATE TABLE questions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    lesson_id BIGINT NOT NULL,

    question_content TEXT,

    option_a VARCHAR(255),
    option_b VARCHAR(255),
    option_c VARCHAR(255),
    option_d VARCHAR(255),

    correct_answer VARCHAR(10),

    difficulty_level ENUM('basic', 'medium', 'hard'),

    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,

    CONSTRAINT fk_questions_lesson
        FOREIGN KEY (lesson_id)
        REFERENCES lessons(id)
        ON DELETE CASCADE
);

-- =========================
-- QUIZ ATTEMPTS
-- =========================
CREATE TABLE quiz_attempts (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    user_id BIGINT NOT NULL,
    lesson_id BIGINT NOT NULL,

    score FLOAT,
    total_questions INT,
    correct_answers INT,

    result_status ENUM('pass', 'fail'),

    started_at TIMESTAMP NULL,
    finished_at TIMESTAMP NULL,

    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,

    CONSTRAINT fk_quiz_attempts_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_quiz_attempts_lesson
        FOREIGN KEY (lesson_id)
        REFERENCES lessons(id)
        ON DELETE CASCADE
);

-- =========================
-- QUIZ ANSWERS
-- =========================
CREATE TABLE quiz_answers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    quiz_attempt_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,

    selected_answer VARCHAR(10),

    response_time_seconds INT NULL,

    is_correct BOOLEAN,

    difficulty_level ENUM('basic', 'medium', 'hard'),

    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,

    CONSTRAINT fk_quiz_answers_attempt
        FOREIGN KEY (quiz_attempt_id)
        REFERENCES quiz_attempts(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_quiz_answers_question
        FOREIGN KEY (question_id)
        REFERENCES questions(id)
        ON DELETE CASCADE
);

-- =========================
-- FOCUS LOGS
-- =========================
CREATE TABLE focus_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    user_id BIGINT NOT NULL,
    lesson_id BIGINT NOT NULL,

    status ENUM('focused', 'distracted', 'no_face'),

    focus_score FLOAT,

    recorded_at TIMESTAMP NULL,

    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,

    CONSTRAINT fk_focus_logs_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_focus_logs_lesson
        FOREIGN KEY (lesson_id)
        REFERENCES lessons(id)
        ON DELETE CASCADE
);

-- =========================
-- FEEDBACKS
-- =========================
CREATE TABLE feedbacks (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    user_id BIGINT NOT NULL,
    lesson_id BIGINT NOT NULL,

    quiz_attempt_id BIGINT NULL,

    focus_score FLOAT,
    quiz_score FLOAT,

    recommendation ENUM(
        'review_lesson',
        'next_lesson',
        'practice_more'
    ),

    message TEXT,

    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,

    CONSTRAINT fk_feedbacks_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_feedbacks_lesson
        FOREIGN KEY (lesson_id)
        REFERENCES lessons(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_feedbacks_quiz_attempt
        FOREIGN KEY (quiz_attempt_id)
        REFERENCES quiz_attempts(id)
        ON DELETE SET NULL
);

-- =========================
-- LESSON INTERACTIONS
-- =========================
CREATE TABLE lesson_interactions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    user_id BIGINT NOT NULL,
    lesson_id BIGINT NOT NULL,

    action ENUM('view', 'like', 'dislike')
    NOT NULL,

    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,

    CONSTRAINT fk_lesson_interactions_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_lesson_interactions_lesson
        FOREIGN KEY (lesson_id)
        REFERENCES lessons(id)
        ON DELETE CASCADE
);

-- =========================
-- LEARNING PROGRESS
-- =========================
CREATE TABLE learning_progress (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    user_id BIGINT NOT NULL,
    lesson_id BIGINT NOT NULL,

    progress_percent FLOAT
    DEFAULT 0,

    is_completed BOOLEAN
    DEFAULT FALSE,

    last_watched_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,

    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,

    CONSTRAINT fk_learning_progress_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_learning_progress_lesson
        FOREIGN KEY (lesson_id)
        REFERENCES lessons(id)
        ON DELETE CASCADE
);
