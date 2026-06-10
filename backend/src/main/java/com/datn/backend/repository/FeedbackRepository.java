package com.datn.backend.repository;

import com.datn.backend.entity.Feedback;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface FeedbackRepository extends JpaRepository<Feedback, Long> {

    List<Feedback> findByUserId(Long userId);

    List<Feedback> findByLessonId(Long lessonId);

    List<Feedback> findByUserIdAndLessonId(Long userId, Long lessonId);
}
