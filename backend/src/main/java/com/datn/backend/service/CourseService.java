package com.datn.backend.service;

import com.datn.backend.dto.CourseRequest;
import com.datn.backend.dto.CourseResponse;
import com.datn.backend.dto.CourseTrendingResponse;
import com.datn.backend.entity.Course;
import com.datn.backend.repository.CourseRepository;
import com.datn.backend.repository.LessonInteractionRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.Comparator;
import java.util.List;

@Service
public class CourseService {

    private final CourseRepository courseRepository;
    private final LessonInteractionRepository lessonInteractionRepository;

    public CourseService(
            CourseRepository courseRepository,
            LessonInteractionRepository lessonInteractionRepository
    ) {
        this.courseRepository = courseRepository;
        this.lessonInteractionRepository = lessonInteractionRepository;
    }

    @Transactional(readOnly = true)
    public List<CourseResponse> getAllCourses() {
        return courseRepository.findAll()
                .stream()
                .map(CourseResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public CourseResponse getCourseById(Long id) {
        return courseRepository.findById(id)
                .map(CourseResponse::from)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Course not found"));
    }

    @Transactional(readOnly = true)
    public List<CourseTrendingResponse> getTrendingCourses() {
        return courseRepository.findAll()
                .stream()
                .map(this::toTrendingResponse)
                .sorted(Comparator.comparing(CourseTrendingResponse::getTrendScore).reversed())
                .toList();
    }

    private CourseTrendingResponse toTrendingResponse(Course course) {
        Long totalViews = lessonInteractionRepository.countByLessonCourseIdAndAction(course.getId(), "view");
        Long totalLikes = lessonInteractionRepository.countByLessonCourseIdAndAction(course.getId(), "like");
        Long totalDislikes = lessonInteractionRepository.countByLessonCourseIdAndAction(course.getId(), "dislike");

        return CourseTrendingResponse.from(course, totalViews, totalLikes, totalDislikes);
    }

    @Transactional
    public CourseResponse createCourse(CourseRequest request) {
        Course course = new Course();
        course.setTitle(request.getTitle());
        course.setDescription(request.getDescription());
        course.setThumbnailUrl(request.getThumbnailUrl());
        if (request.getStatus() != null && !request.getStatus().isBlank()) {
            course.setStatus(request.getStatus());
        }

        return CourseResponse.from(courseRepository.save(course));
    }

    @Transactional
    public CourseResponse updateCourse(Long id, CourseRequest request) {
        Course course = courseRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Course not found"));

        course.setTitle(request.getTitle());
        course.setDescription(request.getDescription());
        course.setThumbnailUrl(request.getThumbnailUrl());
        if (request.getStatus() != null && !request.getStatus().isBlank()) {
            course.setStatus(request.getStatus());
        }

        return CourseResponse.from(courseRepository.save(course));
    }

    @Transactional
    public void deleteCourse(Long id) {
        if (!courseRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Course not found");
        }

        courseRepository.deleteById(id);
    }
}
