package com.datn.backend.repository;

import com.datn.backend.entity.LearningProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface LearningProgressRepository extends JpaRepository<LearningProgress, Long> {

    List<LearningProgress> findByUserIdAndLessonIdOrderByUpdatedAtDesc(Long userId, Long lessonId);

    List<LearningProgress> findByUserId(Long userId);

    @Query("select progress " +
            "from LearningProgress progress " +
            "where progress.user.id = :userId " +
            "and progress.lesson.course.id = :courseId")
    List<LearningProgress> findByUserIdAndCourseId(Long userId, Long courseId);
}
