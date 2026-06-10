package com.datn.backend.service;

import com.datn.backend.entity.LearningProgress;
import com.datn.backend.entity.Lesson;
import com.datn.backend.entity.QuizAttempt;
import com.datn.backend.entity.User;
import com.datn.backend.repository.CourseRepository;
import com.datn.backend.repository.LearningProgressRepository;
import com.datn.backend.repository.LessonRepository;
import com.datn.backend.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class LearningProgressServiceTest {

    @Mock
    private LearningProgressRepository learningProgressRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private LessonRepository lessonRepository;

    @Mock
    private CourseRepository courseRepository;

    private LearningProgressService learningProgressService;

    @BeforeEach
    void setUp() {
        learningProgressService = new LearningProgressService(
                learningProgressRepository,
                userRepository,
                lessonRepository,
                courseRepository
        );

        when(learningProgressRepository.findByUserIdAndLessonIdOrderByUpdatedAtDesc(1L, 1L))
                .thenReturn(List.of());
        when(learningProgressRepository.save(any(LearningProgress.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));
    }

    @Test
    void updateAfterQuizSubmitOnlyUpdatesProgressAndDoesNotChangeUserCurrentLevel() {
        User user = new User();
        user.setId(1L);
        user.setCurrentLevel("basic");

        Lesson lesson = new Lesson();
        lesson.setId(1L);

        QuizAttempt attempt = new QuizAttempt();
        attempt.setId(1L);
        attempt.setUser(user);
        attempt.setLesson(lesson);
        attempt.setScore(85.0F);

        learningProgressService.updateAfterQuizSubmit(attempt);

        assertThat(user.getCurrentLevel()).isEqualTo("basic");
        verify(userRepository, never()).save(any(User.class));
        verify(learningProgressRepository).save(any(LearningProgress.class));
    }
}
