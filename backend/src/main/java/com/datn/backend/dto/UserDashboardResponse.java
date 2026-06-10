package com.datn.backend.dto;

import java.util.List;

public class UserDashboardResponse {

    private UserResponse user;
    private List<LearningProgressResponse> learningProgress;
    private List<QuizAttemptResponse> quizAttempts;
    private List<FeedbackResponse> feedbacks;
    private List<FocusLogResponse> focusLogs;

    public UserResponse getUser() {
        return user;
    }

    public void setUser(UserResponse user) {
        this.user = user;
    }

    public List<LearningProgressResponse> getLearningProgress() {
        return learningProgress;
    }

    public void setLearningProgress(List<LearningProgressResponse> learningProgress) {
        this.learningProgress = learningProgress;
    }

    public List<QuizAttemptResponse> getQuizAttempts() {
        return quizAttempts;
    }

    public void setQuizAttempts(List<QuizAttemptResponse> quizAttempts) {
        this.quizAttempts = quizAttempts;
    }

    public List<FeedbackResponse> getFeedbacks() {
        return feedbacks;
    }

    public void setFeedbacks(List<FeedbackResponse> feedbacks) {
        this.feedbacks = feedbacks;
    }

    public List<FocusLogResponse> getFocusLogs() {
        return focusLogs;
    }

    public void setFocusLogs(List<FocusLogResponse> focusLogs) {
        this.focusLogs = focusLogs;
    }
}
