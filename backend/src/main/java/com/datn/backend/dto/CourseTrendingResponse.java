package com.datn.backend.dto;

import com.datn.backend.entity.Course;

public class CourseTrendingResponse {

    private Long id;
    private String title;
    private String description;
    private String thumbnailUrl;
    private Long totalViews;
    private Long totalLikes;
    private Long totalDislikes;
    private Long trendScore;

    public CourseTrendingResponse() {
    }

    public CourseTrendingResponse(
            Long id,
            String title,
            String description,
            String thumbnailUrl,
            Long totalViews,
            Long totalLikes,
            Long totalDislikes,
            Long trendScore
    ) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.thumbnailUrl = thumbnailUrl;
        this.totalViews = totalViews;
        this.totalLikes = totalLikes;
        this.totalDislikes = totalDislikes;
        this.trendScore = trendScore;
    }

    public static CourseTrendingResponse from(
            Course course,
            Long totalViews,
            Long totalLikes,
            Long totalDislikes
    ) {
        CourseTrendingResponse response = new CourseTrendingResponse();
        response.setId(course.getId());
        response.setTitle(course.getTitle());
        response.setDescription(course.getDescription());
        response.setThumbnailUrl(course.getThumbnailUrl());
        response.setTotalViews(totalViews);
        response.setTotalLikes(totalLikes);
        response.setTotalDislikes(totalDislikes);
        response.setTrendScore(totalViews + (totalLikes * 3) - (totalDislikes * 2));
        return response;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
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

    public Long getTrendScore() {
        return trendScore;
    }

    public void setTrendScore(Long trendScore) {
        this.trendScore = trendScore;
    }
}
