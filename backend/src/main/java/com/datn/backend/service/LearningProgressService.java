package com.datn.backend.service;

import com.datn.backend.dto.LearningProgressResponse;
import com.datn.backend.entity.LearningProgress;
import com.datn.backend.entity.Lesson;
import com.datn.backend.entity.QuizAttempt;
import com.datn.backend.entity.User;
import com.datn.backend.repository.CourseRepository;
import com.datn.backend.repository.LearningProgressRepository;
import com.datn.backend.repository.LessonRepository;
import com.datn.backend.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class LearningProgressService {

    private static final float COMPLETE_SCORE = 70.0F;

    private final LearningProgressRepository learningProgressRepository;
    private final UserRepository userRepository;
    private final LessonRepository lessonRepository;
    private final CourseRepository courseRepository;

    public LearningProgressService(
            LearningProgressRepository learningProgressRepository,
            UserRepository userRepository,
            LessonRepository lessonRepository,
            CourseRepository courseRepository
    ) {
        this.learningProgressRepository = learningProgressRepository;
        this.userRepository = userRepository;
        this.lessonRepository = lessonRepository;
        this.courseRepository = courseRepository;
    }

    @Transactional
    public void updateAfterQuizSubmit(QuizAttempt attempt) {
        updateLearningProgress(attempt);
    }

    @Transactional
    public LearningProgressResponse startProgress(Long userId, Long lessonId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy người dùng"));
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy bài học"));

        LearningProgress progress = getOrCreateProgress(user, lesson);

        progress.setLastWatchedAt(LocalDateTime.now());

        return LearningProgressResponse.from(learningProgressRepository.save(progress));
    }

    @Transactional
    public LearningProgressResponse completeProgress(Long userId, Long lessonId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy người dùng"));
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy bài học"));

        LearningProgress progress = getOrCreateProgress(user, lesson);
        LocalDateTime now = LocalDateTime.now();

        progress.setProgressPercent(100.0F);
        progress.setCompleted(true);
        progress.setCompletedAt(now);
        progress.setLastWatchedAt(now);

        return LearningProgressResponse.from(learningProgressRepository.save(progress));
    }

    @Transactional(readOnly = true)
    public List<LearningProgressResponse> getProgressByUserId(Long userId) {
        if (!userRepository.existsById(userId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy người dùng");
        }

        return learningProgressRepository.findByUserId(userId)
                .stream()
                .map(LearningProgressResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<LearningProgressResponse> getProgressByUserIdAndCourseId(Long userId, Long courseId) {
        if (!userRepository.existsById(userId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy người dùng");
        }
        if (!courseRepository.existsById(courseId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy khóa học");
        }

        return learningProgressRepository.findByUserIdAndCourseId(userId, courseId)
                .stream()
                .map(LearningProgressResponse::from)
                .toList();
    }

    private void updateLearningProgress(QuizAttempt attempt) {
        User user = attempt.getUser();
        Lesson lesson = attempt.getLesson();
        LocalDateTime now = LocalDateTime.now();

        LearningProgress progress = getOrCreateProgress(user, lesson);

        progress.setLastWatchedAt(now);
        if (attempt.getScore() != null && attempt.getScore() >= COMPLETE_SCORE) {
            progress.setProgressPercent(100.0F);
            progress.setCompleted(true);
            progress.setCompletedAt(now);
        } else {
            Float currentPercent = progress.getProgressPercent() == null ? 0.0F : progress.getProgressPercent();
            Float quizPercent = attempt.getScore() == null ? 0.0F : attempt.getScore();
            progress.setProgressPercent(Math.max(currentPercent, quizPercent));
            if (progress.getCompleted() == null) {
                progress.setCompleted(false);
            }
        }

        learningProgressRepository.save(progress);
    }

    private LearningProgress getOrCreateProgress(User user, Lesson lesson) {
        List<LearningProgress> existingProgress = learningProgressRepository
                .findByUserIdAndLessonIdOrderByUpdatedAtDesc(user.getId(), lesson.getId());

        if (existingProgress.isEmpty()) {
            return createProgress(user, lesson);
        }

        if (existingProgress.size() > 1) {
            learningProgressRepository.deleteAll(existingProgress.subList(1, existingProgress.size()));
        }

        return existingProgress.get(0);
    }

    private LearningProgress createProgress(User user, Lesson lesson) {
        LearningProgress progress = new LearningProgress();
        progress.setUser(user);
        progress.setLesson(lesson);
        progress.setProgressPercent(0.0F);
        progress.setCompleted(false);
        return progress;
    }
}
