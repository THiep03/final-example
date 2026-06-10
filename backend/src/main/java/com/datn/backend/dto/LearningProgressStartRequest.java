package com.datn.backend.dto;

import jakarta.validation.constraints.NotNull;

public class LearningProgressStartRequest {

    @NotNull(message = "userId là bắt buộc")
    private Long userId;

    @NotNull(message = "lessonId là bắt buộc")
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
