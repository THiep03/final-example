package com.datn.backend.dto;

import com.datn.backend.entity.Feedback;

import java.time.LocalDateTime;

public class FeedbackResponse {

    private Long id;
    private Long userId;
    private Long lessonId;
    private Long quizAttemptId;
    private Float focusScore;
    private Float quizScore;
    private String recommendation;
    private String message;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static FeedbackResponse from(Feedback feedback) {
        FeedbackResponse response = new FeedbackResponse();
        response.setId(feedback.getId());
        response.setUserId(feedback.getUser().getId());
        response.setLessonId(feedback.getLesson().getId());
        response.setQuizAttemptId(feedback.getQuizAttempt() == null ? null : feedback.getQuizAttempt().getId());
        response.setFocusScore(feedback.getFocusScore());
        response.setQuizScore(feedback.getQuizScore());
        response.setRecommendation(feedback.getRecommendation());
        response.setMessage(feedback.getMessage());
        response.setCreatedAt(feedback.getCreatedAt());
        response.setUpdatedAt(feedback.getUpdatedAt());
        return response;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getLessonId() {
        return lessonId;
    }

    public void setLessonId(Long lessonId) {
        this.lessonId = lessonId;
    }

    public Long getQuizAttemptId() {
        return quizAttemptId;
    }

    public void setQuizAttemptId(Long quizAttemptId) {
        this.quizAttemptId = quizAttemptId;
    }

    public Float getFocusScore() {
        return focusScore;
    }

    public void setFocusScore(Float focusScore) {
        this.focusScore = focusScore;
    }

    public Float getQuizScore() {
        return quizScore;
    }

    public void setQuizScore(Float quizScore) {
        this.quizScore = quizScore;
    }

    public String getRecommendation() {
        return recommendation;
    }

    public void setRecommendation(String recommendation) {
        this.recommendation = recommendation;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
