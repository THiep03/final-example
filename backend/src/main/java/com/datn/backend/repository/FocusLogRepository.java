package com.datn.backend.repository;

import com.datn.backend.entity.FocusLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface FocusLogRepository extends JpaRepository<FocusLog, Long> {

    List<FocusLog> findByUserId(Long userId);

    List<FocusLog> findByLessonId(Long lessonId);

    List<FocusLog> findByUserIdAndLessonId(Long userId, Long lessonId);

    @Query("select avg(focusLog.focusScore) from FocusLog focusLog")
    Double averageFocusScore();

    @Query("select avg(focusLog.focusScore) from FocusLog focusLog where focusLog.lesson.id = :lessonId")
    Double averageFocusScoreByLessonId(Long lessonId);
}
