package com.datn.backend.repository;

import com.datn.backend.entity.LessonInteraction;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;
import java.util.List;

public interface LessonInteractionRepository extends JpaRepository<LessonInteraction, Long> {

    List<LessonInteraction> findByUserId(Long userId);

    List<LessonInteraction> findByLessonId(Long lessonId);

    List<LessonInteraction> findByUserIdAndLessonIdAndActionInOrderByUpdatedAtDesc(
            Long userId,
            Long lessonId,
            Collection<String> actions
    );

    List<LessonInteraction> findByLessonIdAndActionInOrderByUserIdAscUpdatedAtDesc(
            Long lessonId,
            Collection<String> actions
    );

    long countByLessonIdAndAction(Long lessonId, String action);

    long countByLessonCourseIdAndAction(Long courseId, String action);

    long countByAction(String action);
}
