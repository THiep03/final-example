package com.datn.backend.service;

import com.datn.backend.constants.AppConstants;
import com.datn.backend.dto.LessonInteractionRequest;
import com.datn.backend.dto.LessonInteractionReactionResponse;
import com.datn.backend.dto.LessonInteractionResponse;
import com.datn.backend.dto.LessonInteractionStatsResponse;
import com.datn.backend.entity.Lesson;
import com.datn.backend.entity.LessonInteraction;
import com.datn.backend.entity.User;
import com.datn.backend.repository.LessonInteractionRepository;
import com.datn.backend.repository.LessonRepository;
import com.datn.backend.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class LessonInteractionService {

    private static final List<String> REACTION_ACTIONS = List.of(AppConstants.LessonAction.LIKE, AppConstants.LessonAction.DISLIKE);

    private final LessonInteractionRepository lessonInteractionRepository;
    private final UserRepository userRepository;
    private final LessonRepository lessonRepository;

    public LessonInteractionService(
            LessonInteractionRepository lessonInteractionRepository,
            UserRepository userRepository,
            LessonRepository lessonRepository
    ) {
        this.lessonInteractionRepository = lessonInteractionRepository;
        this.userRepository = userRepository;
        this.lessonRepository = lessonRepository;
    }

    @Transactional
    public LessonInteractionResponse createLessonInteraction(LessonInteractionRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
        Lesson lesson = lessonRepository.findById(request.getLessonId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found"));

        if (REACTION_ACTIONS.contains(request.getAction())) {
            return saveReactionInteraction(user, lesson, request.getAction());
        }

        LessonInteraction interaction = new LessonInteraction();
        interaction.setUser(user);
        interaction.setLesson(lesson);
        interaction.setAction(request.getAction());

        return LessonInteractionResponse.from(lessonInteractionRepository.save(interaction));
    }

    private LessonInteractionResponse saveReactionInteraction(User user, Lesson lesson, String action) {
        List<LessonInteraction> existingReactions = lessonInteractionRepository
                .findByUserIdAndLessonIdAndActionInOrderByUpdatedAtDesc(
                        user.getId(),
                        lesson.getId(),
                        REACTION_ACTIONS
                );

        if (existingReactions.isEmpty()) {
            LessonInteraction interaction = new LessonInteraction();
            interaction.setUser(user);
            interaction.setLesson(lesson);
            interaction.setAction(action);

            LessonInteractionResponse response = LessonInteractionResponse.from(
                    lessonInteractionRepository.save(interaction)
            );
            response.setMessage("Đã ghi nhận phản ứng của bạn");
            return response;
        }

        LessonInteraction currentReaction = existingReactions.get(0);
        removeDuplicateReactions(existingReactions);

        if (currentReaction.getAction().equals(action)) {
            LessonInteractionResponse response = LessonInteractionResponse.from(currentReaction);
            response.setMessage("Bạn đã chọn phản ứng này rồi");
            return response;
        }

        currentReaction.setAction(action);
        LessonInteractionResponse response = LessonInteractionResponse.from(
                lessonInteractionRepository.save(currentReaction)
        );
        response.setMessage("Đã cập nhật phản ứng của bạn");
        return response;
    }

    private void removeDuplicateReactions(List<LessonInteraction> existingReactions) {
        if (existingReactions.size() <= 1) {
            return;
        }

        lessonInteractionRepository.deleteAll(existingReactions.subList(1, existingReactions.size()));
    }

    @Transactional(readOnly = true)
    public List<LessonInteractionResponse> getLessonInteractionsByUserId(Long userId) {
        if (!userRepository.existsById(userId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
        }

        return lessonInteractionRepository.findByUserId(userId)
                .stream()
                .map(LessonInteractionResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<LessonInteractionResponse> getLessonInteractionsByLessonId(Long lessonId) {
        if (!lessonRepository.existsById(lessonId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found");
        }

        return lessonInteractionRepository.findByLessonId(lessonId)
                .stream()
                .map(LessonInteractionResponse::from)
                .toList();
    }

    @Transactional
    public LessonInteractionStatsResponse getLessonInteractionStats(Long lessonId) {
        if (!lessonRepository.existsById(lessonId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found");
        }

        removeDuplicateReactionsForLesson(lessonId);

        return new LessonInteractionStatsResponse(
                lessonId,
                lessonInteractionRepository.countByLessonIdAndAction(lessonId, AppConstants.LessonAction.VIEW),
                lessonInteractionRepository.countByLessonIdAndAction(lessonId, AppConstants.LessonAction.LIKE),
                lessonInteractionRepository.countByLessonIdAndAction(lessonId, AppConstants.LessonAction.DISLIKE)
        );
    }

    private void removeDuplicateReactionsForLesson(Long lessonId) {
        List<LessonInteraction> reactions = lessonInteractionRepository
                .findByLessonIdAndActionInOrderByUserIdAscUpdatedAtDesc(lessonId, REACTION_ACTIONS);
        Set<Long> usersWithReaction = new HashSet<>();
        List<LessonInteraction> duplicates = new ArrayList<>();

        for (LessonInteraction reaction : reactions) {
            if (!usersWithReaction.add(reaction.getUser().getId())) {
                duplicates.add(reaction);
            }
        }

        if (!duplicates.isEmpty()) {
            lessonInteractionRepository.deleteAll(duplicates);
        }
    }

    @Transactional(readOnly = true)
    public LessonInteractionReactionResponse getCurrentReaction(Long userId, Long lessonId) {
        if (!userRepository.existsById(userId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
        }

        if (!lessonRepository.existsById(lessonId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found");
        }

        String action = lessonInteractionRepository
                .findByUserIdAndLessonIdAndActionInOrderByUpdatedAtDesc(userId, lessonId, REACTION_ACTIONS)
                .stream()
                .findFirst()
                .map(LessonInteraction::getAction)
                .orElse(null);

        return new LessonInteractionReactionResponse(action);
    }
}
