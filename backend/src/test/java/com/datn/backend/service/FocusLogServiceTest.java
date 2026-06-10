package com.datn.backend.service;

import com.datn.backend.dto.FocusLogRequest;
import com.datn.backend.dto.FocusLogResponse;
import com.datn.backend.entity.FocusLog;
import com.datn.backend.entity.Lesson;
import com.datn.backend.entity.User;
import com.datn.backend.repository.FocusLogRepository;
import com.datn.backend.repository.LessonRepository;
import com.datn.backend.repository.QuizAttemptRepository;
import com.datn.backend.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class FocusLogServiceTest {

    @Mock
    private FocusLogRepository focusLogRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private LessonRepository lessonRepository;

    @Mock
    private QuizAttemptRepository quizAttemptRepository;

    private FocusLogService focusLogService;

    @BeforeEach
    void setUp() {
        focusLogService = new FocusLogService(
                focusLogRepository,
                userRepository,
                lessonRepository,
                quizAttemptRepository
        );
    }

    @Test
    void createFocusLogStoresValidRequestAndDefaultsRecordedAt() {
        User user = new User();
        user.setId(1L);
        Lesson lesson = new Lesson();
        lesson.setId(1L);
        FocusLogRequest request = new FocusLogRequest();
        request.setUserId(1L);
        request.setLessonId(1L);
        request.setStatus("focused");
        request.setFocusScore(90.0F);

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(lessonRepository.findById(1L)).thenReturn(Optional.of(lesson));
        when(focusLogRepository.save(any(FocusLog.class))).thenAnswer(invocation -> {
            FocusLog focusLog = invocation.getArgument(0);
            focusLog.setId(10L);
            return focusLog;
        });

        FocusLogResponse response = focusLogService.createFocusLog(request);

        assertThat(response.getId()).isEqualTo(10L);
        assertThat(response.getUserId()).isEqualTo(1L);
        assertThat(response.getLessonId()).isEqualTo(1L);
        assertThat(response.getStatus()).isEqualTo("focused");
        assertThat(response.getFocusScore()).isEqualTo(90.0F);
        assertThat(response.getRecordedAt()).isNotNull();
        verify(focusLogRepository).save(any(FocusLog.class));
    }
}
