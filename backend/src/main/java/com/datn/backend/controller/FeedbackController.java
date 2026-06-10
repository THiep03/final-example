package com.datn.backend.controller;

import com.datn.backend.dto.FeedbackRequest;
import com.datn.backend.dto.FeedbackResponse;
import com.datn.backend.service.FeedbackService;
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
@RequestMapping("/api/feedbacks")
public class FeedbackController {

    private final FeedbackService feedbackService;

    public FeedbackController(FeedbackService feedbackService) {
        this.feedbackService = feedbackService;
    }

    @PostMapping("/generate")
    @ResponseStatus(HttpStatus.CREATED)
    public FeedbackResponse generateFeedback(@Valid @RequestBody FeedbackRequest request) {
        return feedbackService.generateFeedback(request);
    }

    @GetMapping("/user/{userId}")
    public List<FeedbackResponse> getFeedbacksByUserId(@PathVariable Long userId) {
        return feedbackService.getFeedbacksByUserId(userId);
    }

    @GetMapping("/lesson/{lessonId}")
    public List<FeedbackResponse> getFeedbacksByLessonId(@PathVariable Long lessonId) {
        return feedbackService.getFeedbacksByLessonId(lessonId);
    }

    @GetMapping("/user/{userId}/lesson/{lessonId}")
    public List<FeedbackResponse> getFeedbacksByUserIdAndLessonId(
            @PathVariable Long userId,
            @PathVariable Long lessonId
    ) {
        return feedbackService.getFeedbacksByUserIdAndLessonId(userId, lessonId);
    }
}
