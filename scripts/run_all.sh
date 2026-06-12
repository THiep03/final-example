#!/bin/bash
# =============================================================
# run_all.sh — Chạy toàn bộ script database theo thứ tự
# Dùng: ./run_all.sh [host] [user] [password]
# Mặc định: localhost / root / (không có mật khẩu)
# =============================================================

DB_HOST="${1:-localhost}"
DB_USER="${2:-root}"
DB_PASS="${3:-}"

if [ -n "$DB_PASS" ]; then
  MYSQL_CMD="mysql -h$DB_HOST -u$DB_USER -p$DB_PASS"
else
  MYSQL_CMD="mysql -h$DB_HOST -u$DB_USER"
fi

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "============================================"
echo " Adaptive Learning DB — Setup"
echo " Host: $DB_HOST   User: $DB_USER"
echo "============================================"

run_script() {
  local step="$1"
  local file="$2"
  echo "[$step] Running $file..."
  $MYSQL_CMD < "$SCRIPTS_DIR/$file"
  if [ $? -ne 0 ]; then
    echo "[FAILED] $file"
    exit 1
  fi
  echo "     OK"
}

run_script "1/5" "01_schema.sql"
echo "[2/5] Migration đã tích hợp vào schema — SKIP"
run_script "3/5" "03_seed_sample.sql"
run_script "4/5" "04_seed_it_courses.sql"
run_script "5/5" "05_seed_videos.sql"

echo "============================================"
echo " Hoàn thành! Database sẵn sàng sử dụng."
echo "============================================"
