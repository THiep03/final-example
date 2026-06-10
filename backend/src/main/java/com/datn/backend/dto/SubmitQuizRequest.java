package com.datn.backend.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.util.List;

public class SubmitQuizRequest {

    @NotNull(message = "Quiz attempt ID is required")
    private Long attemptId;

    @NotEmpty(message = "Answers are required")
    private List<@Valid SubmitAnswerRequest> answers;

    public Long getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(Long attemptId) {
        this.attemptId = attemptId;
    }

    public List<SubmitAnswerRequest> getAnswers() {
        return answers;
    }

    public void setAnswers(List<SubmitAnswerRequest> answers) {
        this.answers = answers;
    }
}
