package com.datn.backend.dto;

import com.datn.backend.entity.QuizAnswer;

import java.time.LocalDateTime;

public class QuizAnswerResponse {

    private Long id;
    private Long attemptId;
    private Long questionId;
    private String selectedAnswer;
    private Integer responseTimeSeconds;
    private Boolean correct;
    private String difficultyLevel;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static QuizAnswerResponse from(QuizAnswer answer) {
        QuizAnswerResponse response = new QuizAnswerResponse();
        response.setId(answer.getId());
        response.setAttemptId(answer.getQuizAttempt().getId());
        response.setQuestionId(answer.getQuestion().getId());
        response.setSelectedAnswer(answer.getSelectedAnswer());
        response.setResponseTimeSeconds(answer.getResponseTimeSeconds());
        response.setCorrect(answer.getCorrect());
        response.setDifficultyLevel(answer.getDifficultyLevel());
        response.setCreatedAt(answer.getCreatedAt());
        response.setUpdatedAt(answer.getUpdatedAt());
        return response;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(Long attemptId) {
        this.attemptId = attemptId;
    }

    public Long getQuestionId() {
        return questionId;
    }

    public void setQuestionId(Long questionId) {
        this.questionId = questionId;
    }

    public String getSelectedAnswer() {
        return selectedAnswer;
    }

    public void setSelectedAnswer(String selectedAnswer) {
        this.selectedAnswer = selectedAnswer;
    }

    public Integer getResponseTimeSeconds() {
        return responseTimeSeconds;
    }

    public void setResponseTimeSeconds(Integer responseTimeSeconds) {
        this.responseTimeSeconds = responseTimeSeconds;
    }

    public Boolean getCorrect() {
        return correct;
    }

    public void setCorrect(Boolean correct) {
        this.correct = correct;
    }

    public String getDifficultyLevel() {
        return difficultyLevel;
    }

    public void setDifficultyLevel(String difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
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
