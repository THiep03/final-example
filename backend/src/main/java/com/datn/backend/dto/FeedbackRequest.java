package com.datn.backend.dto;

import jakarta.validation.constraints.NotNull;

public class FeedbackRequest {

    @NotNull(message = "User ID is required")
    private Long userId;

    @NotNull(message = "Lesson ID is required")
    private Long lessonId;

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
}
