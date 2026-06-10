package com.datn.backend.dto;

public class DashboardSummaryResponse {

    private Long totalUsers;
    private Long totalCourses;
    private Long totalLessons;
    private Long totalQuestions;
    private Long totalQuizAttempts;
    private Double averageQuizScore;
    private Double averageFocusScore;
    private Long totalViews;
    private Long totalLikes;
    private Long totalDislikes;

    public Long getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(Long totalUsers) {
        this.totalUsers = totalUsers;
    }

    public Long getTotalCourses() {
        return totalCourses;
    }

    public void setTotalCourses(Long totalCourses) {
        this.totalCourses = totalCourses;
    }

    public Long getTotalLessons() {
        return totalLessons;
    }

    public void setTotalLessons(Long totalLessons) {
        this.totalLessons = totalLessons;
    }

    public Long getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(Long totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public Long getTotalQuizAttempts() {
        return totalQuizAttempts;
    }

    public void setTotalQuizAttempts(Long totalQuizAttempts) {
        this.totalQuizAttempts = totalQuizAttempts;
    }

    public Double getAverageQuizScore() {
        return averageQuizScore;
    }

    public void setAverageQuizScore(Double averageQuizScore) {
        this.averageQuizScore = averageQuizScore;
    }

    public Double getAverageFocusScore() {
        return averageFocusScore;
    }

    public void setAverageFocusScore(Double averageFocusScore) {
        this.averageFocusScore = averageFocusScore;
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
