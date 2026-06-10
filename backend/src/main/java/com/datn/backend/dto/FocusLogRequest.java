package com.datn.backend.dto;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

import java.time.LocalDateTime;

public class FocusLogRequest {

    @NotNull(message = "User ID is required")
    private Long userId;

    @NotNull(message = "Lesson ID is required")
    private Long lessonId;

    @NotBlank(message = "Status is required")
    @Pattern(regexp = "focused|distracted|no_face", message = "Status must be focused, distracted, or no_face")
    private String status;

    @NotNull(message = "Focus score is required")
    @DecimalMin(value = "0.0", message = "Focus score must be at least 0")
    @DecimalMax(value = "100.0", message = "Focus score must be at most 100")
    private Float focusScore;

    private LocalDateTime recordedAt;

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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Float getFocusScore() {
        return focusScore;
    }

    public void setFocusScore(Float focusScore) {
        this.focusScore = focusScore;
    }

    public LocalDateTime getRecordedAt() {
        return recordedAt;
    }

    public void setRecordedAt(LocalDateTime recordedAt) {
        this.recordedAt = recordedAt;
    }
}
