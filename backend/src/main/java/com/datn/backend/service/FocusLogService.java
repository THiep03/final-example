package com.datn.backend.service;

import com.datn.backend.dto.FeedbackResponse;
import com.datn.backend.dto.FocusLogRequest;
import com.datn.backend.dto.FocusLogResponse;
import com.datn.backend.entity.FocusLog;
import com.datn.backend.entity.Lesson;
import com.datn.backend.entity.QuizAttempt;
import com.datn.backend.entity.User;
import com.datn.backend.repository.FocusLogRepository;
import com.datn.backend.repository.LessonRepository;
import com.datn.backend.repository.QuizAttemptRepository;
import com.datn.backend.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class FocusLogService {

    private final FocusLogRepository focusLogRepository;
    private final UserRepository userRepository;
    private final LessonRepository lessonRepository;
    private final QuizAttemptRepository quizAttemptRepository;

    public FocusLogService(
            FocusLogRepository focusLogRepository,
            UserRepository userRepository,
            LessonRepository lessonRepository,
            QuizAttemptRepository quizAttemptRepository
    ) {
        this.focusLogRepository = focusLogRepository;
        this.userRepository = userRepository;
        this.lessonRepository = lessonRepository;
        this.quizAttemptRepository = quizAttemptRepository;
    }

    @Transactional
    public FocusLogResponse createFocusLog(FocusLogRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
        Lesson lesson = lessonRepository.findById(request.getLessonId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found"));

        FocusLog focusLog = new FocusLog();
        focusLog.setUser(user);
        focusLog.setLesson(lesson);
        focusLog.setStatus(request.getStatus());
        focusLog.setFocusScore(request.getFocusScore());
        focusLog.setRecordedAt(request.getRecordedAt() == null ? LocalDateTime.now() : request.getRecordedAt());

        return FocusLogResponse.from(focusLogRepository.save(focusLog));
    }

    @Transactional(readOnly = true)
    public List<FocusLogResponse> getFocusLogsByUserId(Long userId) {
        if (!userRepository.existsById(userId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
        }

        return focusLogRepository.findByUserId(userId)
                .stream()
                .map(FocusLogResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<FocusLogResponse> getFocusLogsByLessonId(Long lessonId) {
        if (!lessonRepository.existsById(lessonId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found");
        }

        return focusLogRepository.findByLessonId(lessonId)
                .stream()
                .map(FocusLogResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<FocusLogResponse> getFocusLogsByUserIdAndLessonId(Long userId, Long lessonId) {
        if (!userRepository.existsById(userId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
        }
        if (!lessonRepository.existsById(lessonId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found");
        }

        return focusLogRepository.findByUserIdAndLessonId(userId, lessonId)
                .stream()
                .map(FocusLogResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public FeedbackResponse getFeedbackByAttemptId(Long attemptId) {
        QuizAttempt attempt = quizAttemptRepository.findById(attemptId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Quiz attempt not found"));

        Long userId = attempt.getUser().getId();
        Long lessonId = attempt.getLesson().getId();
        Float quizScore = attempt.getScore() == null ? 0.0F : attempt.getScore();
        Float focusScore = calculateAverageFocusScore(userId, lessonId);
        String recommendation = buildRecommendation(quizScore, focusScore);

        FeedbackResponse response = new FeedbackResponse();
        response.setUserId(userId);
        response.setLessonId(lessonId);
        response.setQuizAttemptId(attempt.getId());
        response.setFocusScore(focusScore);
        response.setQuizScore(quizScore);
        response.setRecommendation(recommendation);
        response.setMessage(buildMessage(recommendation, quizScore, focusScore));
        return response;
    }

    private Float calculateAverageFocusScore(Long userId, Long lessonId) {
        double average = focusLogRepository.findByUserIdAndLessonId(userId, lessonId)
                .stream()
                .map(FocusLog::getFocusScore)
                .filter(score -> score != null)
                .mapToDouble(Float::doubleValue)
                .average()
                .orElse(0.0);
        return (float) average;
    }

    private String buildRecommendation(Float quizScore, Float focusScore) {
        if (quizScore >= 70.0F && focusScore >= 70.0F) {
            return "next_lesson";
        }
        if (quizScore < 70.0F) {
            return "review_lesson";
        }
        if (focusScore < 70.0F) {
            return "practice_more";
        }
        return "practice_more";
    }

    private String buildMessage(String recommendation, Float quizScore, Float focusScore) {
        if ("next_lesson".equals(recommendation)) {
            return String.format(
                    "Ban da hoan thanh tot bai hoc voi diem quiz %.1f va diem tap trung %.1f. Hay chuyen sang bai hoc tiep theo.",
                    quizScore,
                    focusScore
            );
        }
        if ("review_lesson".equals(recommendation)) {
            return String.format(
                    "Diem quiz cua ban la %.1f, chua dat muc yeu cau. Hay xem lai bai hoc va lam quiz lai de nam chac kien thuc.",
                    quizScore
            );
        }
        return String.format(
                "Diem tap trung trung binh cua ban la %.1f. Hay luyen tap them va giu moi truong hoc it xao nhang hon.",
                focusScore
        );
    }
}
