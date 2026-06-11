package com.datn.backend.service;

import com.datn.backend.constants.AppConstants;
import com.datn.backend.dto.DashboardSummaryResponse;
import com.datn.backend.dto.FeedbackResponse;
import com.datn.backend.dto.FocusLogResponse;
import com.datn.backend.dto.LearningProgressResponse;
import com.datn.backend.dto.LessonDashboardResponse;
import com.datn.backend.dto.LessonResponse;
import com.datn.backend.dto.QuizAttemptResponse;
import com.datn.backend.dto.UserDashboardResponse;
import com.datn.backend.dto.UserResponse;
import com.datn.backend.entity.Lesson;
import com.datn.backend.entity.QuizAttempt;
import com.datn.backend.entity.User;
import com.datn.backend.repository.CourseRepository;
import com.datn.backend.repository.FeedbackRepository;
import com.datn.backend.repository.FocusLogRepository;
import com.datn.backend.repository.LearningProgressRepository;
import com.datn.backend.repository.LessonInteractionRepository;
import com.datn.backend.repository.LessonRepository;
import com.datn.backend.repository.QuestionRepository;
import com.datn.backend.repository.QuizAnswerRepository;
import com.datn.backend.repository.QuizAttemptRepository;
import com.datn.backend.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class DashboardService {

    private final UserRepository userRepository;
    private final CourseRepository courseRepository;
    private final LessonRepository lessonRepository;
    private final QuestionRepository questionRepository;
    private final QuizAttemptRepository quizAttemptRepository;
    private final QuizAnswerRepository quizAnswerRepository;
    private final FocusLogRepository focusLogRepository;
    private final LessonInteractionRepository lessonInteractionRepository;
    private final LearningProgressRepository learningProgressRepository;
    private final FeedbackRepository feedbackRepository;

    public DashboardService(
            UserRepository userRepository,
            CourseRepository courseRepository,
            LessonRepository lessonRepository,
            QuestionRepository questionRepository,
            QuizAttemptRepository quizAttemptRepository,
            QuizAnswerRepository quizAnswerRepository,
            FocusLogRepository focusLogRepository,
            LessonInteractionRepository lessonInteractionRepository,
            LearningProgressRepository learningProgressRepository,
            FeedbackRepository feedbackRepository
    ) {
        this.userRepository = userRepository;
        this.courseRepository = courseRepository;
        this.lessonRepository = lessonRepository;
        this.questionRepository = questionRepository;
        this.quizAttemptRepository = quizAttemptRepository;
        this.quizAnswerRepository = quizAnswerRepository;
        this.focusLogRepository = focusLogRepository;
        this.lessonInteractionRepository = lessonInteractionRepository;
        this.learningProgressRepository = learningProgressRepository;
        this.feedbackRepository = feedbackRepository;
    }

    @Transactional(readOnly = true)
    public DashboardSummaryResponse getSummary() {
        DashboardSummaryResponse response = new DashboardSummaryResponse();
        response.setTotalUsers(userRepository.count());
        response.setTotalCourses(courseRepository.count());
        response.setTotalLessons(lessonRepository.count());
        response.setTotalQuestions(questionRepository.count());
        response.setTotalQuizAttempts(quizAttemptRepository.count());
        response.setAverageQuizScore(defaultDouble(quizAttemptRepository.averageQuizScore()));
        response.setAverageFocusScore(defaultDouble(focusLogRepository.averageFocusScore()));
        response.setTotalViews(lessonInteractionRepository.countByAction(AppConstants.LessonAction.VIEW));
        response.setTotalLikes(lessonInteractionRepository.countByAction(AppConstants.LessonAction.LIKE));
        response.setTotalDislikes(lessonInteractionRepository.countByAction(AppConstants.LessonAction.DISLIKE));
        return response;
    }

    @Transactional(readOnly = true)
    public UserDashboardResponse getUserDashboard(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        UserDashboardResponse response = new UserDashboardResponse();
        response.setUser(UserResponse.from(user));
        response.setLearningProgress(learningProgressRepository.findByUserId(userId)
                .stream()
                .map(LearningProgressResponse::from)
                .toList());
        response.setQuizAttempts(quizAttemptRepository.findByUserId(userId)
                .stream()
                .map(this::toQuizAttemptResponse)
                .toList());
        response.setFeedbacks(feedbackRepository.findByUserId(userId)
                .stream()
                .map(FeedbackResponse::from)
                .toList());
        response.setFocusLogs(focusLogRepository.findByUserId(userId)
                .stream()
                .map(FocusLogResponse::from)
                .toList());
        return response;
    }

    @Transactional(readOnly = true)
    public LessonDashboardResponse getLessonDashboard(Long lessonId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found"));

        LessonDashboardResponse response = new LessonDashboardResponse();
        response.setLesson(LessonResponse.from(lesson));
        response.setQuestionsCount(questionRepository.countByLessonId(lessonId));
        response.setQuizAttemptsCount(quizAttemptRepository.countByLessonId(lessonId));
        response.setAverageQuizScore(defaultDouble(quizAttemptRepository.averageQuizScoreByLessonId(lessonId)));
        response.setAverageFocusScore(defaultDouble(focusLogRepository.averageFocusScoreByLessonId(lessonId)));
        response.setTotalViews(lessonInteractionRepository.countByLessonIdAndAction(lessonId, AppConstants.LessonAction.VIEW));
        response.setTotalLikes(lessonInteractionRepository.countByLessonIdAndAction(lessonId, AppConstants.LessonAction.LIKE));
        response.setTotalDislikes(lessonInteractionRepository.countByLessonIdAndAction(lessonId, AppConstants.LessonAction.DISLIKE));
        return response;
    }

    private QuizAttemptResponse toQuizAttemptResponse(QuizAttempt attempt) {
        return QuizAttemptResponse.from(attempt, quizAnswerRepository.findByQuizAttemptId(attempt.getId()));
    }

    private Double defaultDouble(Double value) {
        return value == null ? 0.0 : value;
    }
}
