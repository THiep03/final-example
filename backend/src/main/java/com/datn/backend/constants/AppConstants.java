package com.datn.backend.constants;

public final class AppConstants {

    private AppConstants() {}

    public static final class Role {
        public static final String ADMIN = "admin";
        public static final String STUDENT = "student";
    }

    public static final class Difficulty {
        public static final String BASIC = "basic";
        public static final String MEDIUM = "medium";
        public static final String HARD = "hard";
    }

    public static final class CourseStatus {
        public static final String DRAFT = "draft";
        public static final String PUBLISHED = "published";
    }

    public static final class FocusStatus {
        public static final String FOCUSED = "focused";
        public static final String DISTRACTED = "distracted";
        public static final String NO_FACE = "no_face";
        public static final String DROWSY = "drowsy";
    }

    public static final class LessonAction {
        public static final String VIEW = "view";
        public static final String LIKE = "like";
        public static final String DISLIKE = "dislike";
    }

    public static final class QuizResult {
        public static final String PASS = "pass";
        public static final String FAIL = "fail";
        public static final float PASS_SCORE = 70.0F;
        public static final int RESPONSE_TIME_HARD = 45;
        public static final int RESPONSE_TIME_MEDIUM = 30;
        public static final int RESPONSE_TIME_BASIC = 20;
    }

    public static final class Recommendation {
        public static final String NEXT_LESSON = "next_lesson";
        public static final String REVIEW_LESSON = "review_lesson";
        public static final String PRACTICE_MORE = "practice_more";
    }

    public static final class FileType {
        public static final String VIDEO = "video";
        public static final String IMAGE = "image";
        public static final String DOCUMENT = "document";
    }

    public static final class StorageProvider {
        public static final String LOCAL = "local";
        public static final String GOOGLE_DRIVE = "google_drive";
    }

    public static final class FileFolder {
        public static final String VIDEOS = "videos";
        public static final String IMAGES = "images";
        public static final String DOCUMENTS = "documents";
    }
}
