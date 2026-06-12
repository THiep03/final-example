@echo off
:: =============================================================
:: run_all.bat — Chạy toàn bộ script database theo thứ tự
:: Dùng: run_all.bat [host] [user] [password]
:: Mặc định: localhost / root / (không có mật khẩu)
:: =============================================================

SET DB_HOST=%1
SET DB_USER=%2
SET DB_PASS=%3

IF "%DB_HOST%"=="" SET DB_HOST=localhost
IF "%DB_USER%"=="" SET DB_USER=root

SET MYSQL_CMD=mysql -h%DB_HOST% -u%DB_USER%
IF NOT "%DB_PASS%"=="" SET MYSQL_CMD=%MYSQL_CMD% -p%DB_PASS%

SET SCRIPTS_DIR=%~dp0

echo ============================================
echo  Adaptive Learning DB — Setup
echo  Host: %DB_HOST%   User: %DB_USER%
echo ============================================

echo [1/5] Tao schema (database + tables)...
%MYSQL_CMD% < "%SCRIPTS_DIR%01_schema.sql"
IF ERRORLEVEL 1 ( echo [FAILED] 01_schema.sql & pause & exit /b 1 )
echo      OK

echo [2/5] Bo qua migration (da tich hop vao schema)...
echo      SKIP

echo [3/5] Seed du lieu mau co ban...
%MYSQL_CMD% < "%SCRIPTS_DIR%03_seed_sample.sql"
IF ERRORLEVEL 1 ( echo [FAILED] 03_seed_sample.sql & pause & exit /b 1 )
echo      OK

echo [4/5] Seed 6 khoa IT, 36 bai hoc, 360 cau hoi...
%MYSQL_CMD% < "%SCRIPTS_DIR%04_seed_it_courses.sql"
IF ERRORLEVEL 1 ( echo [FAILED] 04_seed_it_courses.sql & pause & exit /b 1 )
echo      OK

echo [5/5] Cap nhat video YouTube cho 36 bai hoc...
%MYSQL_CMD% < "%SCRIPTS_DIR%05_seed_videos.sql"
IF ERRORLEVEL 1 ( echo [FAILED] 05_seed_videos.sql & pause & exit /b 1 )
echo      OK

echo ============================================
echo  Hoan thanh! Database san sang su dung.
echo ============================================
pause
