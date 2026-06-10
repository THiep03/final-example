package com.datn.backend.dto;

import com.datn.backend.entity.LessonInteraction;

import java.time.LocalDateTime;

public class LessonInteractionResponse {

    private Long id;
    private Long userId;
    private Long lessonId;
    private String action;
    private String message;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static LessonInteractionResponse from(LessonInteraction interaction) {
        LessonInteractionResponse response = new LessonInteractionResponse();
        response.setId(interaction.getId());
        response.setUserId(interaction.getUser().getId());
        response.setLessonId(interaction.getLesson().getId());
        response.setAction(interaction.getAction());
        response.setCreatedAt(interaction.getCreatedAt());
        response.setUpdatedAt(interaction.getUpdatedAt());
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

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
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
