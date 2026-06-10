package com.datn.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

public class LessonInteractionRequest {

    @NotNull(message = "User ID is required")
    private Long userId;

    @NotNull(message = "Lesson ID is required")
    private Long lessonId;

    @NotBlank(message = "Action is required")
    @Pattern(regexp = "view|like|dislike", message = "Action must be view, like, or dislike")
    private String action;

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

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }
}
