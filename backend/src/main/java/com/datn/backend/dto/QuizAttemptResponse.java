package com.datn.backend.dto;

import com.datn.backend.entity.QuizAnswer;
import com.datn.backend.entity.QuizAttempt;

import java.time.LocalDateTime;
import java.util.List;

public class QuizAttemptResponse {

    private Long id;
    private Long userId;
    private Long lessonId;
    private Float score;
    private Integer totalQuestions;
    private Integer correctAnswers;
    private String resultStatus;
    private LocalDateTime startedAt;
    private LocalDateTime finishedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<QuizAnswerResponse> answers;

    public static QuizAttemptResponse from(QuizAttempt attempt, List<QuizAnswer> answers) {
        QuizAttemptResponse response = new QuizAttemptResponse();
        response.setId(attempt.getId());
        response.setUserId(attempt.getUser().getId());
        response.setLessonId(attempt.getLesson().getId());
        response.setScore(attempt.getScore());
        response.setTotalQuestions(attempt.getTotalQuestions());
        response.setCorrectAnswers(attempt.getCorrectAnswers());
        response.setResultStatus(attempt.getResultStatus());
        response.setStartedAt(attempt.getStartedAt());
        response.setFinishedAt(attempt.getFinishedAt());
        response.setCreatedAt(attempt.getCreatedAt());
        response.setUpdatedAt(attempt.getUpdatedAt());
        response.setAnswers(answers.stream().map(QuizAnswerResponse::from).toList());
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

    public Float getScore() {
        return score;
    }

    public void setScore(Float score) {
        this.score = score;
    }

    public Integer getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(Integer totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public Integer getCorrectAnswers() {
        return correctAnswers;
    }

    public void setCorrectAnswers(Integer correctAnswers) {
        this.correctAnswers = correctAnswers;
    }

    public String getResultStatus() {
        return resultStatus;
    }

    public void setResultStatus(String resultStatus) {
        this.resultStatus = resultStatus;
    }

    public LocalDateTime getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(LocalDateTime startedAt) {
        this.startedAt = startedAt;
    }

    public LocalDateTime getFinishedAt() {
        return finishedAt;
    }

    public void setFinishedAt(LocalDateTime finishedAt) {
        this.finishedAt = finishedAt;
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

    public List<QuizAnswerResponse> getAnswers() {
        return answers;
    }

    public void setAnswers(List<QuizAnswerResponse> answers) {
        this.answers = answers;
    }
}
