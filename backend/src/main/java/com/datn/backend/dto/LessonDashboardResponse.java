package com.datn.backend.dto;

public class LessonDashboardResponse {

    private LessonResponse lesson;
    private Long questionsCount;
    private Long quizAttemptsCount;
    private Double averageQuizScore;
    private Double averageFocusScore;
    private Long totalViews;
    private Long totalLikes;
    private Long totalDislikes;

    public LessonResponse getLesson() {
        return lesson;
    }

    public void setLesson(LessonResponse lesson) {
        this.lesson = lesson;
    }

    public Long getQuestionsCount() {
        return questionsCount;
    }

    public void setQuestionsCount(Long questionsCount) {
        this.questionsCount = questionsCount;
    }

    public Long getQuizAttemptsCount() {
        return quizAttemptsCount;
    }

    public void setQuizAttemptsCount(Long quizAttemptsCount) {
        this.quizAttemptsCount = quizAttemptsCount;
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
