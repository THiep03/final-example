package com.datn.backend.controller;

import com.datn.backend.dto.LessonInteractionRequest;
import com.datn.backend.dto.LessonInteractionReactionResponse;
import com.datn.backend.dto.LessonInteractionResponse;
import com.datn.backend.dto.LessonInteractionStatsResponse;
import com.datn.backend.service.LessonInteractionService;
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
@RequestMapping("/api/lesson-interactions")
public class LessonInteractionController {

    private final LessonInteractionService lessonInteractionService;

    public LessonInteractionController(LessonInteractionService lessonInteractionService) {
        this.lessonInteractionService = lessonInteractionService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public LessonInteractionResponse createLessonInteraction(
            @Valid @RequestBody LessonInteractionRequest request
    ) {
        return lessonInteractionService.createLessonInteraction(request);
    }

    @GetMapping("/user/{userId}")
    public List<LessonInteractionResponse> getLessonInteractionsByUserId(@PathVariable Long userId) {
        return lessonInteractionService.getLessonInteractionsByUserId(userId);
    }

    @GetMapping("/user/{userId}/lesson/{lessonId}/reaction")
    public LessonInteractionReactionResponse getCurrentReaction(
            @PathVariable Long userId,
            @PathVariable Long lessonId
    ) {
        return lessonInteractionService.getCurrentReaction(userId, lessonId);
    }

    @GetMapping("/lesson/{lessonId}")
    public List<LessonInteractionResponse> getLessonInteractionsByLessonId(@PathVariable Long lessonId) {
        return lessonInteractionService.getLessonInteractionsByLessonId(lessonId);
    }

    @GetMapping("/lesson/{lessonId}/stats")
    public LessonInteractionStatsResponse getLessonInteractionStats(@PathVariable Long lessonId) {
        return lessonInteractionService.getLessonInteractionStats(lessonId);
    }
}
