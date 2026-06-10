package com.datn.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class AdaptiveAnswerResponse {

    private Boolean finished;
    private Boolean correct;
    private String currentDifficulty;
    private String nextDifficulty;
    private AdaptiveQuizQuestionResponse nextQuestion;
    private Float currentScore;
    private Float finalScore;
    private String resultStatus;
    private Integer correctAnswers;
    private Integer answeredCount;
    private Integer totalQuestions;

    @JsonProperty("isFinished")
    public Boolean getFinished() {
        return finished;
    }

    public void setFinished(Boolean finished) {
        this.finished = finished;
    }

    @JsonProperty("isCorrect")
    public Boolean getCorrect() {
        return correct;
    }

    public void setCorrect(Boolean correct) {
        this.correct = correct;
    }

    public String getCurrentDifficulty() {
        return currentDifficulty;
    }

    public void setCurrentDifficulty(String currentDifficulty) {
        this.currentDifficulty = currentDifficulty;
    }

    public String getNextDifficulty() {
        return nextDifficulty;
    }

    public void setNextDifficulty(String nextDifficulty) {
        this.nextDifficulty = nextDifficulty;
    }

    public AdaptiveQuizQuestionResponse getNextQuestion() {
        return nextQuestion;
    }

    public void setNextQuestion(AdaptiveQuizQuestionResponse nextQuestion) {
        this.nextQuestion = nextQuestion;
    }

    public Float getCurrentScore() {
        return currentScore;
    }

    public void setCurrentScore(Float currentScore) {
        this.currentScore = currentScore;
    }

    public Float getFinalScore() {
        return finalScore;
    }

    public void setFinalScore(Float finalScore) {
        this.finalScore = finalScore;
    }

    public String getResultStatus() {
        return resultStatus;
    }

    public void setResultStatus(String resultStatus) {
        this.resultStatus = resultStatus;
    }

    public Integer getCorrectAnswers() {
        return correctAnswers;
    }

    public void setCorrectAnswers(Integer correctAnswers) {
        this.correctAnswers = correctAnswers;
    }

    public Integer getAnsweredCount() {
        return answeredCount;
    }

    public void setAnsweredCount(Integer answeredCount) {
        this.answeredCount = answeredCount;
    }

    public Integer getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(Integer totalQuestions) {
        this.totalQuestions = totalQuestions;
    }
}
