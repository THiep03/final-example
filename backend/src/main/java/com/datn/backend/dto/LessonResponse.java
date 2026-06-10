package com.datn.backend.dto;

import com.datn.backend.entity.Lesson;

import java.time.LocalDateTime;

public class LessonResponse {

    private Long id;
    private Long courseId;
    private Long videoFileId;
    private String title;
    private String description;
    private String videoUrl;
    private Integer duration;
    private Integer orderNumber;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static LessonResponse from(Lesson lesson) {
        LessonResponse response = new LessonResponse();
        response.setId(lesson.getId());
        response.setCourseId(lesson.getCourse() == null ? null : lesson.getCourse().getId());
        response.setVideoFileId(lesson.getVideoFile() == null ? null : lesson.getVideoFile().getId());
        response.setTitle(lesson.getTitle());
        response.setDescription(lesson.getDescription());
        response.setVideoUrl(lesson.getVideoUrl());
        response.setDuration(lesson.getDuration());
        response.setOrderNumber(lesson.getOrderNumber());
        response.setCreatedAt(lesson.getCreatedAt());
        response.setUpdatedAt(lesson.getUpdatedAt());
        return response;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public Long getVideoFileId() {
        return videoFileId;
    }

    public void setVideoFileId(Long videoFileId) {
        this.videoFileId = videoFileId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public Integer getDuration() {
        return duration;
    }

    public void setDuration(Integer duration) {
        this.duration = duration;
    }

    public Integer getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(Integer orderNumber) {
        this.orderNumber = orderNumber;
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
