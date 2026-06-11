package com.datn.backend.repository;

import com.datn.backend.entity.FocusLog;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface FocusLogRepository extends JpaRepository<FocusLog, Long> {

    List<FocusLog> findByUserId(Long userId);

    List<FocusLog> findByLessonId(Long lessonId);

    List<FocusLog> findByUserIdAndLessonId(Long userId, Long lessonId);

    @Query("select f from FocusLog f join fetch f.user join fetch f.lesson order by f.recordedAt desc")
    List<FocusLog> findLatestWithDetails(Pageable pageable);

    @Query("select avg(focusLog.focusScore) from FocusLog focusLog")
    Double averageFocusScore();

    @Query("select avg(focusLog.focusScore) from FocusLog focusLog where focusLog.lesson.id = :lessonId")
    Double averageFocusScoreByLessonId(Long lessonId);
}
