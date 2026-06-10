package com.datn.backend.service;

import com.datn.backend.dto.FeedbackRequest;
import com.datn.backend.dto.FeedbackResponse;
import com.datn.backend.entity.Feedback;
import com.datn.backend.entity.FocusLog;
import com.datn.backend.entity.Lesson;
import com.datn.backend.entity.QuizAttempt;
import com.datn.backend.entity.User;
import com.datn.backend.repository.FeedbackRepository;
import com.datn.backend.repository.FocusLogRepository;
import com.datn.backend.repository.LessonRepository;
import com.datn.backend.repository.QuizAttemptRepository;
import com.datn.backend.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class FeedbackService {

    private final FeedbackRepository feedbackRepository;
    private final UserRepository userRepository;
    private final LessonRepository lessonRepository;
    private final QuizAttemptRepository quizAttemptRepository;
    private final FocusLogRepository focusLogRepository;

    public FeedbackService(
            FeedbackRepository feedbackRepository,
            UserRepository userRepository,
            LessonRepository lessonRepository,
            QuizAttemptRepository quizAttemptRepository,
            FocusLogRepository focusLogRepository
    ) {
        this.feedbackRepository = feedbackRepository;
        this.userRepository = userRepository;
        this.lessonRepository = lessonRepository;
        this.quizAttemptRepository = quizAttemptRepository;
        this.focusLogRepository = focusLogRepository;
    }

    @Transactional
    public FeedbackResponse generateFeedback(FeedbackRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
        Lesson lesson = lessonRepository.findById(request.getLessonId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found"));
        QuizAttempt quizAttempt = quizAttemptRepository
                .findTopByUserIdAndLessonIdOrderByIdDesc(user.getId(), lesson.getId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Quiz attempt not found"));

        Float quizScore = quizAttempt.getScore() == null ? 0.0F : quizAttempt.getScore();
        Float focusScore = calculateAverageFocusScore(user.getId(), lesson.getId());
        String recommendation = buildRecommendation(quizScore, focusScore);

        Feedback feedback = new Feedback();
        feedback.setUser(user);
        feedback.setLesson(lesson);
        feedback.setQuizAttempt(quizAttempt);
        feedback.setQuizScore(quizScore);
        feedback.setFocusScore(focusScore);
        feedback.setRecommendation(recommendation);
        feedback.setMessage(buildMessage(recommendation, quizScore, focusScore));

        return FeedbackResponse.from(feedbackRepository.save(feedback));
    }

    @Transactional(readOnly = true)
    public List<FeedbackResponse> getFeedbacksByUserId(Long userId) {
        if (!userRepository.existsById(userId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
        }

        return feedbackRepository.findByUserId(userId)
                .stream()
                .map(FeedbackResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<FeedbackResponse> getFeedbacksByLessonId(Long lessonId) {
        if (!lessonRepository.existsById(lessonId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found");
        }

        return feedbackRepository.findByLessonId(lessonId)
                .stream()
                .map(FeedbackResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<FeedbackResponse> getFeedbacksByUserIdAndLessonId(Long userId, Long lessonId) {
        if (!userRepository.existsById(userId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
        }
        if (!lessonRepository.existsById(lessonId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found");
        }

        return feedbackRepository.findByUserIdAndLessonId(userId, lessonId)
                .stream()
                .map(FeedbackResponse::from)
                .toList();
    }

    private Float calculateAverageFocusScore(Long userId, Long lessonId) {
        List<FocusLog> focusLogs = focusLogRepository.findByUserIdAndLessonId(userId, lessonId);
        double average = focusLogs.stream()
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
                    "Bạn đã hoàn thành tốt bài học với điểm quiz %.1f và mức độ tập trung trung bình %.1f. Hãy chuyển sang bài học tiếp theo.",
                    quizScore,
                    focusScore
            );
        }
        if ("review_lesson".equals(recommendation)) {
            return String.format(
                    "Điểm quiz của bạn là %.1f, chưa đạt mức yêu cầu. Bạn nên học lại bài này và làm lại quiz để nắm chắc kiến thức hơn.",
                    quizScore
            );
        }
        return String.format(
                "Mức độ tập trung trung bình của bạn là %.1f, còn thấp so với mục tiêu. Bạn nên luyện tập thêm và giữ môi trường học ít xao nhãng hơn.",
                focusScore
        );
    }
}
