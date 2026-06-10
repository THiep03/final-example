package com.datn.backend.repository;

import com.datn.backend.entity.QuizAttempt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface QuizAttemptRepository extends JpaRepository<QuizAttempt, Long> {

    List<QuizAttempt> findByUserId(Long userId);

    List<QuizAttempt> findByLessonId(Long lessonId);

    Optional<QuizAttempt> findTopByUserIdAndLessonIdOrderByIdDesc(Long userId, Long lessonId);

    long countByLessonId(Long lessonId);

    @Query("select avg(attempt.score) from QuizAttempt attempt")
    Double averageQuizScore();

    @Query("select avg(attempt.score) from QuizAttempt attempt where attempt.lesson.id = :lessonId")
    Double averageQuizScoreByLessonId(Long lessonId);
}
