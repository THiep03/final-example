package com.datn.backend.controller;

import com.datn.backend.dto.LearningProgressResponse;
import com.datn.backend.dto.LearningProgressStartRequest;
import com.datn.backend.service.LearningProgressService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/progress")
public class LearningProgressController {

    private final LearningProgressService learningProgressService;

    public LearningProgressController(LearningProgressService learningProgressService) {
        this.learningProgressService = learningProgressService;
    }

    @PostMapping("/start")
    public LearningProgressResponse startProgress(@Valid @RequestBody LearningProgressStartRequest request) {
        return learningProgressService.startProgress(request.getUserId(), request.getLessonId());
    }

    @PutMapping("/complete")
    public LearningProgressResponse completeProgress(@Valid @RequestBody LearningProgressStartRequest request) {
        return learningProgressService.completeProgress(request.getUserId(), request.getLessonId());
    }

    @GetMapping("/user/{userId}")
    public List<LearningProgressResponse> getProgressByUserId(@PathVariable Long userId) {
        return learningProgressService.getProgressByUserId(userId);
    }

    @GetMapping("/user/{userId}/course/{courseId}")
    public List<LearningProgressResponse> getProgressByUserIdAndCourseId(
            @PathVariable Long userId,
            @PathVariable Long courseId
    ) {
        return learningProgressService.getProgressByUserIdAndCourseId(userId, courseId);
    }
}
