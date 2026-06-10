package com.datn.backend.dto;

public class AdaptiveStartQuizResponse {

    private Long attemptId;
    private AdaptiveQuizQuestionResponse question;
    private String currentDifficulty;
    private Integer answeredCount;
    private Integer totalQuestions;

    public Long getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(Long attemptId) {
        this.attemptId = attemptId;
    }

    public AdaptiveQuizQuestionResponse getQuestion() {
        return question;
    }

    public void setQuestion(AdaptiveQuizQuestionResponse question) {
        this.question = question;
    }

    public String getCurrentDifficulty() {
        return currentDifficulty;
    }

    public void setCurrentDifficulty(String currentDifficulty) {
        this.currentDifficulty = currentDifficulty;
    }

    public Integer getAnsweredCount() {
        return answeredCount;
    }

    public void setAnsweredCount(Integer answeredCount) {
        this.answeredCount = answeredCount;
    }

    public Integer getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(Integer totalQuestions) {
        this.totalQuestions = totalQuestions;
    }
}
