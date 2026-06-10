package com.datn.backend.dto;

public class LessonInteractionStatsResponse {

    private Long lessonId;
    private Long totalViews;
    private Long totalLikes;
    private Long totalDislikes;

    public LessonInteractionStatsResponse(Long lessonId, Long totalViews, Long totalLikes, Long totalDislikes) {
        this.lessonId = lessonId;
        this.totalViews = totalViews;
        this.totalLikes = totalLikes;
        this.totalDislikes = totalDislikes;
    }

    public Long getLessonId() {
        return lessonId;
    }

    public void setLessonId(Long lessonId) {
        this.lessonId = lessonId;
    }

    public Long getTotalViews() {
        return totalViews;
    }

    public void setTotalViews(Long totalViews) {
        this.totalViews = totalViews;
    }

    public Long getTotalLikes() {
        return totalLikes;
    }

    public void setTotalLikes(Long totalLikes) {
        this.totalLikes = totalLikes;
    }

    public Long getTotalDislikes() {
        return totalDislikes;
    }

    public void setTotalDislikes(Long totalDislikes) {
        this.totalDislikes = totalDislikes;
    }
}
