# GIAI ĐOẠN 2 REPORT - Adaptive Quiz theo từng câu hỏi

Ngày thực hiện: 2026-06-09

## 1. File đã sửa/tạo

### Backend

| File | Nội dung |
|---|---|
| `backend/src/main/java/com/datn/backend/controller/QuizController.java` | Thêm API `POST /api/quiz/adaptive/start` và `POST /api/quiz/adaptive/answer`. |
| `backend/src/main/java/com/datn/backend/service/QuizService.java` | Bổ sung flow adaptive trong từng quiz attempt: bắt đầu từ `basic`, tính đúng/sai, thời gian trả lời, chuyển độ khó, tránh trùng câu hỏi và kết thúc attempt. |
| `backend/src/main/java/com/datn/backend/dto/AdaptiveStartQuizRequest.java` | DTO request bắt đầu quiz adaptive. |
| `backend/src/main/java/com/datn/backend/dto/AdaptiveStartQuizResponse.java` | DTO response trả câu hỏi đầu tiên, attemptId, difficulty hiện tại và tiến độ. |
| `backend/src/main/java/com/datn/backend/dto/AdaptiveAnswerRequest.java` | DTO request trả lời từng câu, gồm `responseTimeSeconds` và `currentDifficulty`. |
| `backend/src/main/java/com/datn/backend/dto/AdaptiveAnswerResponse.java` | DTO response sau từng câu, gồm câu tiếp theo hoặc kết quả cuối cùng. |
| `backend/src/main/java/com/datn/backend/dto/AdaptiveQuizQuestionResponse.java` | DTO câu hỏi adaptive không trả `correctAnswer` ra frontend. |
| `backend/src/main/java/com/datn/backend/entity/QuizAnswer.java` | Map thêm cột `response_time_seconds`. |
| `database.sql` | Bổ sung `response_time_seconds INT NULL` trong bảng `quiz_answers`. |
| `database_adaptive_quiz_update.sql` | Script migrate cho database đã tồn tại. |
| `backend/src/test/java/com/datn/backend/service/QuizServiceTest.java` | Thêm unit test cho thuật toán adaptive quiz. |
| `backend/src/test/java/com/datn/backend/service/LearningProgressServiceTest.java` | Cập nhật test để xác nhận learning progress không còn thay đổi `users.current_level`. |

### Frontend

| File | Nội dung |
|---|---|
| `frontend/src/api/quizApi.js` | Thêm client gọi `startAdaptiveQuiz` và `answerAdaptiveQuestion`. |
| `frontend/src/pages/QuizPage.jsx` | Chuyển sang flow từng câu hỏi: start quiz, hiển thị một câu, đo thời gian trả lời, gửi answer, nhận câu tiếp theo hoặc kết quả. |

## 2. Logic adaptive mới

Hệ thống không còn chọn câu hỏi dựa trên `users.current_level` và không cập nhật `users.current_level` sau quiz.

Luồng mới:

1. Tất cả quiz adaptive bắt đầu ở mức `basic`.
2. Sau mỗi câu trả lời, backend tính:
   - đúng hay sai
   - thời gian trả lời
   - độ khó tiếp theo
3. Backend chọn câu hỏi tiếp theo theo độ khó mới và không lặp lại câu đã trả lời.
4. Khi đủ `totalQuestions` hoặc hết câu hỏi phù hợp, backend tính điểm cuối, cập nhật `quiz_attempts`, lưu `quiz_answers`, cập nhật learning progress và trả kết quả.

Ngưỡng nhanh:

| Difficulty | Nhanh nếu |
|---|---|
| basic | `responseTimeSeconds <= 20` |
| medium | `responseTimeSeconds <= 30` |
| hard | `responseTimeSeconds <= 45` |

Chuyển độ khó:

| Điều kiện | basic | medium | hard |
|---|---|---|---|
| Đúng + nhanh | medium | hard | hard |
| Đúng + chậm | basic | medium | hard |
| Sai | basic | basic | medium |

Fallback khi thiếu câu hỏi:

| Cần độ khó | Thứ tự fallback |
|---|---|
| basic | basic -> medium -> hard |
| medium | medium -> basic -> hard |
| hard | hard -> medium -> basic |

## 3. API mới

### `POST /api/quiz/adaptive/start`

Request:

```json
{
  "userId": 1,
  "lessonId": 1,
  "totalQuestions": 10
}
```

Response:

```json
{
  "attemptId": 1,
  "question": {
    "id": 1,
    "questionContent": "...",
    "optionA": "...",
    "optionB": "...",
    "optionC": "...",
    "optionD": "...",
    "difficultyLevel": "basic"
  },
  "currentDifficulty": "basic",
  "answeredCount": 0,
  "totalQuestions": 10
}
```

### `POST /api/quiz/adaptive/answer`

Request:

```json
{
  "attemptId": 1,
  "questionId": 1,
  "selectedAnswer": "A",
  "responseTimeSeconds": 12,
  "currentDifficulty": "basic"
}
```

Response khi còn câu tiếp theo:

```json
{
  "isFinished": false,
  "isCorrect": true,
  "currentDifficulty": "basic",
  "nextDifficulty": "medium",
  "nextQuestion": {
    "id": 2,
    "questionContent": "...",
    "optionA": "...",
    "optionB": "...",
    "optionC": "...",
    "optionD": "...",
    "difficultyLevel": "medium"
  },
  "currentScore": 100.0,
  "answeredCount": 1,
  "totalQuestions": 10
}
```

Response khi kết thúc:

```json
{
  "isFinished": true,
  "isCorrect": true,
  "currentDifficulty": "hard",
  "nextDifficulty": "hard",
  "currentScore": 80.0,
  "finalScore": 80.0,
  "resultStatus": "pass",
  "correctAnswers": 8,
  "answeredCount": 10,
  "totalQuestions": 10
}
```

## 4. Test đã thêm

File: `backend/src/test/java/com/datn/backend/service/QuizServiceTest.java`

Các case:

1. Start adaptive quiz trả câu hỏi `basic`.
2. Đúng + nhanh ở `basic` chuyển lên `medium`.
3. Đúng + nhanh ở `medium` chuyển lên `hard`.
4. Đúng + chậm giữ nguyên difficulty.
5. Sai ở `medium` giảm về `basic`.
6. Sai ở `hard` giảm về `medium`.
7. Không trả lại câu hỏi đã trả lời.
8. Kết thúc khi đủ `totalQuestions`.
9. Không cập nhật `users.current_level`.
10. Không cho trả lời trùng câu hỏi trong cùng attempt.

## 5. Lưu ý database

Database schema có thêm cột:

```sql
response_time_seconds INT NULL
```

Nếu database đã được tạo trước đó, chạy thêm:

```sql
SOURCE database_adaptive_quiz_update.sql;
```

Hoặc import trực tiếp nội dung file `database_adaptive_quiz_update.sql`.

## 6. Cách test thủ công

1. Đăng nhập student.
2. Mở bài học có câu hỏi ở `/lessons/{lessonId}`.
3. Bấm `Bắt đầu quiz`.
4. Kiểm tra `/quiz/{lessonId}`:
   - câu đầu tiên là mức `Cơ bản`
   - chỉ hiển thị một câu tại một thời điểm
   - có thời gian trả lời
   - chọn đáp án rồi bấm `Trả lời và tiếp tục`
5. Trả lời đúng nhanh để thấy câu tiếp theo tăng difficulty.
6. Trả lời sai để thấy difficulty giảm theo rule.
7. Làm đến khi kết thúc:
   - hiển thị điểm
   - số câu đúng
   - trạng thái đạt/chưa đạt
   - nút xem phản hồi
8. Kiểm tra bảng `users.current_level` không thay đổi sau quiz.

## 7. Giới hạn còn tồn tại

1. Frontend đang đặt `totalQuestions = 10` cố định.
2. Câu hỏi được chọn theo thứ tự ID, chưa random.
3. Nếu một lesson có ít câu hỏi, quiz có thể kết thúc sớm khi hết câu chưa trả lời.
4. Cần chạy script migrate cho database cũ để lưu được `response_time_seconds`.

## 8. Giai đoạn tiếp theo

1. Cho admin cấu hình số câu hỏi mỗi quiz theo lesson.
2. Random câu hỏi trong cùng difficulty để giảm lặp trải nghiệm.
3. Bổ sung integration test HTTP cho API adaptive.
4. Sau khi core quiz ổn định, chuyển sang Face-A focus tracking và gửi focus logs tự động.
