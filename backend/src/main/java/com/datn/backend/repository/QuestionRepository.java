package com.datn.backend.repository;

import com.datn.backend.entity.Question;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuestionRepository extends JpaRepository<Question, Long> {

    List<Question> findByLessonId(Long lessonId);

    long countByLessonId(Long lessonId);
}
