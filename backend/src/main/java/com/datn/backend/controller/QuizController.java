package com.datn.backend.controller;

import com.datn.backend.dto.AdaptiveAnswerRequest;
import com.datn.backend.dto.AdaptiveAnswerResponse;
import com.datn.backend.dto.AdaptiveStartQuizRequest;
import com.datn.backend.dto.AdaptiveStartQuizResponse;
import com.datn.backend.dto.QuizAttemptResponse;
import com.datn.backend.dto.StartQuizRequest;
import com.datn.backend.dto.SubmitQuizRequest;
import com.datn.backend.service.QuizService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/quiz")
public class QuizController {

    private final QuizService quizService;

    public QuizController(QuizService quizService) {
        this.quizService = quizService;
    }

    @PostMapping("/start")
    @ResponseStatus(HttpStatus.CREATED)
    public QuizAttemptResponse startQuiz(@Valid @RequestBody StartQuizRequest request) {
        return quizService.startQuiz(request);
    }

    @PostMapping("/submit")
    public QuizAttemptResponse submitQuiz(@Valid @RequestBody SubmitQuizRequest request) {
        return quizService.submitQuiz(request);
    }

    @PostMapping("/adaptive/start")
    @ResponseStatus(HttpStatus.CREATED)
    public AdaptiveStartQuizResponse startAdaptiveQuiz(@Valid @RequestBody AdaptiveStartQuizRequest request) {
        return quizService.startAdaptiveQuiz(request);
    }

    @PostMapping("/adaptive/answer")
    public AdaptiveAnswerResponse answerAdaptiveQuestion(@Valid @RequestBody AdaptiveAnswerRequest request) {
        return quizService.answerAdaptiveQuestion(request);
    }

    @GetMapping("/attempts/{id}")
    public QuizAttemptResponse getAttemptById(@PathVariable Long id) {
        return quizService.getAttemptById(id);
    }

    @GetMapping("/user/{userId}")
    public List<QuizAttemptResponse> getAttemptsByUserId(@PathVariable Long userId) {
        return quizService.getAttemptsByUserId(userId);
    }

    @GetMapping("/lesson/{lessonId}")
    public List<QuizAttemptResponse> getAttemptsByLessonId(@PathVariable Long lessonId) {
        return quizService.getAttemptsByLessonId(lessonId);
    }
}
