package com.datn.backend.controller;

import com.datn.backend.dto.FeedbackResponse;
import com.datn.backend.dto.FocusLogRequest;
import com.datn.backend.dto.FocusLogResponse;
import com.datn.backend.service.FocusLogService;
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
@RequestMapping("/api/focus-logs")
public class FocusLogController {

    private final FocusLogService focusLogService;

    public FocusLogController(FocusLogService focusLogService) {
        this.focusLogService = focusLogService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public FocusLogResponse createFocusLog(@Valid @RequestBody FocusLogRequest request) {
        return focusLogService.createFocusLog(request);
    }

    @GetMapping("/user/{userId}")
    public List<FocusLogResponse> getFocusLogsByUserId(@PathVariable Long userId) {
        return focusLogService.getFocusLogsByUserId(userId);
    }

    @GetMapping("/lesson/{lessonId}")
    public List<FocusLogResponse> getFocusLogsByLessonId(@PathVariable Long lessonId) {
        return focusLogService.getFocusLogsByLessonId(lessonId);
    }

    @GetMapping("/user/{userId}/lesson/{lessonId}")
    public List<FocusLogResponse> getFocusLogsByUserIdAndLessonId(
            @PathVariable Long userId,
            @PathVariable Long lessonId
    ) {
        return focusLogService.getFocusLogsByUserIdAndLessonId(userId, lessonId);
    }

    @GetMapping("/attempt/{attemptId}")
    public FeedbackResponse getFeedbackByAttemptId(@PathVariable Long attemptId) {
        return focusLogService.getFeedbackByAttemptId(attemptId);
    }
}
