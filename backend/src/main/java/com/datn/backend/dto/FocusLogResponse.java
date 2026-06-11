package com.datn.backend.dto;

import com.datn.backend.entity.FocusLog;

import java.time.LocalDateTime;

public class FocusLogResponse {

    private Long id;
    private Long userId;
    private String userName;
    private Long lessonId;
    private String lessonTitle;
    private String status;
    private Float focusScore;
    private LocalDateTime recordedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static FocusLogResponse from(FocusLog focusLog) {
        FocusLogResponse response = new FocusLogResponse();
        response.setId(focusLog.getId());
        response.setUserId(focusLog.getUser().getId());
        response.setUserName(focusLog.getUser().getName());
        response.setLessonId(focusLog.getLesson().getId());
        response.setLessonTitle(focusLog.getLesson().getTitle());
        response.setStatus(focusLog.getStatus());
        response.setFocusScore(focusLog.getFocusScore());
        response.setRecordedAt(focusLog.getRecordedAt());
        response.setCreatedAt(focusLog.getCreatedAt());
        response.setUpdatedAt(focusLog.getUpdatedAt());
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

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Long getLessonId() {
        return lessonId;
    }

    public void setLessonId(Long lessonId) {
        this.lessonId = lessonId;
    }

    public String getLessonTitle() {
        return lessonTitle;
    }

    public void setLessonTitle(String lessonTitle) {
        this.lessonTitle = lessonTitle;
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
