-- =============================================================
-- 02_migrations.sql
-- Các câu ALTER TABLE — chỉ chạy nếu DB đã tồn tại từ trước
-- Nếu tạo mới từ 01_schema.sql thì BỎ QUA file này
-- =============================================================

USE adaptive_learning_db;

-- -------------------------------------------------------
-- Migration 1: Thêm response_time_seconds vào quiz_answers
-- -------------------------------------------------------
ALTER TABLE quiz_answers
    ADD COLUMN IF NOT EXISTS response_time_seconds INT NULL AFTER selected_answer;

-- -------------------------------------------------------
-- Migration 2: Thêm thông tin cá nhân và avatar vào users
-- -------------------------------------------------------
ALTER TABLE users
    ADD COLUMN IF NOT EXISTS phone         VARCHAR(20)  NULL AFTER current_level,
    ADD COLUMN IF NOT EXISTS date_of_birth DATE         NULL AFTER phone,
    ADD COLUMN IF NOT EXISTS gender        VARCHAR(10)  NULL AFTER date_of_birth,
    ADD COLUMN IF NOT EXISTS school        VARCHAR(255) NULL AFTER gender,
    ADD COLUMN IF NOT EXISTS bio           TEXT         NULL AFTER school,
    ADD COLUMN IF NOT EXISTS avatar_url    VARCHAR(500) NULL AFTER bio;

SELECT 'Migrations applied successfully.' AS status;
