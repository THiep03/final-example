package com.datn.backend.repository;

import com.datn.backend.entity.QuizAnswer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuizAnswerRepository extends JpaRepository<QuizAnswer, Long> {

    List<QuizAnswer> findByQuizAttemptId(Long quizAttemptId);
}
