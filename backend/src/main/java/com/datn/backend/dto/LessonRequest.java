package com.datn.backend.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;

public class LessonRequest {

    private Long courseId;

    private Long videoFileId;

    @Size(max = 255, message = "Title must be at most 255 characters")
    private String title;

    private String description;

    @Size(max = 500, message = "Video URL must be at most 500 characters")
    private String videoUrl;

    @Min(value = 0, message = "Duration must be zero or positive")
    private Integer duration;

    @Min(value = 0, message = "Order number must be zero or positive")
    private Integer orderNumber;

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
}
