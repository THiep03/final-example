package com.datn.backend.dto;

import com.datn.backend.entity.Course;
import com.datn.backend.entity.LearningProgress;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDateTime;

public class LearningProgressResponse {

    private Long id;
    private Long userId;
    private Long lessonId;
    private Long courseId;
    private Float progressPercent;
    private Boolean completed;
    private LocalDateTime lastWatchedAt;
    private LocalDateTime completedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static LearningProgressResponse from(LearningProgress progress) {
        Course course = progress.getLesson().getCourse();

        LearningProgressResponse response = new LearningProgressResponse();
        response.setId(progress.getId());
        response.setUserId(progress.getUser().getId());
        response.setLessonId(progress.getLesson().getId());
        response.setCourseId(course == null ? null : course.getId());
        response.setProgressPercent(progress.getProgressPercent());
        response.setCompleted(progress.getCompleted());
        response.setLastWatchedAt(progress.getLastWatchedAt());
        response.setCompletedAt(progress.getCompletedAt());
        response.setCreatedAt(progress.getCreatedAt());
        response.setUpdatedAt(progress.getUpdatedAt());
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

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public Float getProgressPercent() {
        return progressPercent;
    }

    public void setProgressPercent(Float progressPercent) {
        this.progressPercent = progressPercent;
    }

    public Boolean getCompleted() {
        return completed;
    }

    @JsonProperty("isCompleted")
    public Boolean getIsCompleted() {
        return completed;
    }

    public void setCompleted(Boolean completed) {
        this.completed = completed;
    }

    public LocalDateTime getLastWatchedAt() {
        return lastWatchedAt;
    }

    public void setLastWatchedAt(LocalDateTime lastWatchedAt) {
        this.lastWatchedAt = lastWatchedAt;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
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
