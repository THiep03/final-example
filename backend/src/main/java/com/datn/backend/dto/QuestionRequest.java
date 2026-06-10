package com.datn.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class QuestionRequest {

    @NotNull(message = "Lesson ID is required")
    private Long lessonId;

    @NotBlank(message = "Question content is required")
    private String questionContent;

    @Size(max = 255, message = "Option A must be at most 255 characters")
    private String optionA;

    @Size(max = 255, message = "Option B must be at most 255 characters")
    private String optionB;

    @Size(max = 255, message = "Option C must be at most 255 characters")
    private String optionC;

    @Size(max = 255, message = "Option D must be at most 255 characters")
    private String optionD;

    @NotBlank(message = "Correct answer is required")
    @Pattern(regexp = "[AaBbCcDd]", message = "Correct answer must be A, B, C, or D")
    private String correctAnswer;

    @NotBlank(message = "Difficulty level is required")
    @Pattern(regexp = "basic|medium|hard", message = "Difficulty level must be basic, medium, or hard")
    private String difficultyLevel;

    public Long getLessonId() {
        return lessonId;
    }

    public void setLessonId(Long lessonId) {
        this.lessonId = lessonId;
    }

    public String getQuestionContent() {
        return questionContent;
    }

    public void setQuestionContent(String questionContent) {
        this.questionContent = questionContent;
    }

    public String getOptionA() {
        return optionA;
    }

    public void setOptionA(String optionA) {
        this.optionA = optionA;
    }

    public String getOptionB() {
        return optionB;
    }

    public void setOptionB(String optionB) {
        this.optionB = optionB;
    }

    public String getOptionC() {
        return optionC;
    }

    public void setOptionC(String optionC) {
        this.optionC = optionC;
    }

    public String getOptionD() {
        return optionD;
    }

    public void setOptionD(String optionD) {
        this.optionD = optionD;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    public String getDifficultyLevel() {
        return difficultyLevel;
    }

    public void setDifficultyLevel(String difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
    }
}
