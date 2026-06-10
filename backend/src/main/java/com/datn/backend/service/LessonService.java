package com.datn.backend.service;

import com.datn.backend.dto.LessonRequest;
import com.datn.backend.dto.LessonResponse;
import com.datn.backend.entity.Course;
import com.datn.backend.entity.FileStorage;
import com.datn.backend.entity.Lesson;
import com.datn.backend.repository.CourseRepository;
import com.datn.backend.repository.LessonRepository;
import jakarta.persistence.EntityManager;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class LessonService {

    private final LessonRepository lessonRepository;
    private final CourseRepository courseRepository;
    private final EntityManager entityManager;

    public LessonService(
            LessonRepository lessonRepository,
            CourseRepository courseRepository,
            EntityManager entityManager
    ) {
        this.lessonRepository = lessonRepository;
        this.courseRepository = courseRepository;
        this.entityManager = entityManager;
    }

    @Transactional(readOnly = true)
    public List<LessonResponse> getAllLessons() {
        return lessonRepository.findAll()
                .stream()
                .map(LessonResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public LessonResponse getLessonById(Long id) {
        return lessonRepository.findById(id)
                .map(LessonResponse::from)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found"));
    }

    @Transactional
    public LessonResponse createLesson(LessonRequest request) {
        Lesson lesson = new Lesson();
        lesson.setCourse(findCourse(request.getCourseId()));
        lesson.setVideoFile(findVideoFile(request.getVideoFileId()));
        lesson.setTitle(request.getTitle());
        lesson.setDescription(request.getDescription());
        lesson.setVideoUrl(request.getVideoUrl());
        lesson.setDuration(request.getDuration());
        lesson.setOrderNumber(request.getOrderNumber());

        return LessonResponse.from(lessonRepository.save(lesson));
    }

    @Transactional
    public LessonResponse updateLesson(Long id, LessonRequest request) {
        Lesson lesson = lessonRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found"));

        lesson.setCourse(findCourse(request.getCourseId()));
        lesson.setVideoFile(findVideoFile(request.getVideoFileId()));
        lesson.setTitle(request.getTitle());
        lesson.setDescription(request.getDescription());
        lesson.setVideoUrl(request.getVideoUrl());
        lesson.setDuration(request.getDuration());
        lesson.setOrderNumber(request.getOrderNumber());

        return LessonResponse.from(lessonRepository.save(lesson));
    }

    @Transactional
    public void deleteLesson(Long id) {
        if (!lessonRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found");
        }

        lessonRepository.deleteById(id);
    }

    private Course findCourse(Long courseId) {
        if (courseId == null) {
            return null;
        }

        return courseRepository.findById(courseId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Course not found"));
    }

    private FileStorage findVideoFile(Long videoFileId) {
        if (videoFileId == null) {
            return null;
        }

        FileStorage videoFile = entityManager.find(FileStorage.class, videoFileId);
        if (videoFile == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Video file not found");
        }
        return videoFile;
    }
}
