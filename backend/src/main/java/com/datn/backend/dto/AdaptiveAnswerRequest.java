package com.datn.backend.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

public class AdaptiveAnswerRequest {

    @NotNull(message = "Quiz attempt ID is required")
    private Long attemptId;

    @NotNull(message = "Question ID is required")
    private Long questionId;

    @NotBlank(message = "Selected answer is required")
    @Pattern(regexp = "[AaBbCcDd]", message = "Selected answer must be A, B, C, or D")
    private String selectedAnswer;

    @NotNull(message = "Response time is required")
    @Min(value = 0, message = "Response time must be zero or positive")
    private Integer responseTimeSeconds;

    @NotBlank(message = "Current difficulty is required")
    @Pattern(regexp = "basic|medium|hard", message = "Current difficulty must be basic, medium, or hard")
    private String currentDifficulty;

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

    public String getCurrentDifficulty() {
        return currentDifficulty;
    }

    public void setCurrentDifficulty(String currentDifficulty) {
        this.currentDifficulty = currentDifficulty;
    }
}
