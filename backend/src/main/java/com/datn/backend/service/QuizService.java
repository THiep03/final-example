package com.datn.backend.service;

import com.datn.backend.dto.QuizAttemptResponse;
import com.datn.backend.dto.StartQuizRequest;
import com.datn.backend.dto.SubmitAnswerRequest;
import com.datn.backend.dto.SubmitQuizRequest;
import com.datn.backend.dto.AdaptiveAnswerRequest;
import com.datn.backend.dto.AdaptiveAnswerResponse;
import com.datn.backend.dto.AdaptiveQuizQuestionResponse;
import com.datn.backend.dto.AdaptiveStartQuizRequest;
import com.datn.backend.dto.AdaptiveStartQuizResponse;
import com.datn.backend.entity.Lesson;
import com.datn.backend.entity.Question;
import com.datn.backend.entity.QuizAnswer;
import com.datn.backend.entity.QuizAttempt;
import com.datn.backend.entity.User;
import com.datn.backend.repository.LessonRepository;
import com.datn.backend.repository.QuestionRepository;
import com.datn.backend.repository.QuizAnswerRepository;
import com.datn.backend.repository.QuizAttemptRepository;
import com.datn.backend.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
public class QuizService {

    private static final float PASS_SCORE = 70.0F;

    private final QuizAttemptRepository quizAttemptRepository;
    private final QuizAnswerRepository quizAnswerRepository;
    private final UserRepository userRepository;
    private final LessonRepository lessonRepository;
    private final QuestionRepository questionRepository;
    private final LearningProgressService learningProgressService;

    public QuizService(
            QuizAttemptRepository quizAttemptRepository,
            QuizAnswerRepository quizAnswerRepository,
            UserRepository userRepository,
            LessonRepository lessonRepository,
            QuestionRepository questionRepository,
            LearningProgressService learningProgressService
    ) {
        this.quizAttemptRepository = quizAttemptRepository;
        this.quizAnswerRepository = quizAnswerRepository;
        this.userRepository = userRepository;
        this.lessonRepository = lessonRepository;
        this.questionRepository = questionRepository;
        this.learningProgressService = learningProgressService;
    }

    @Transactional
    public QuizAttemptResponse startQuiz(StartQuizRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
        Lesson lesson = lessonRepository.findById(request.getLessonId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found"));

        QuizAttempt attempt = new QuizAttempt();
        attempt.setUser(user);
        attempt.setLesson(lesson);
        attempt.setStartedAt(LocalDateTime.now());

        QuizAttempt savedAttempt = quizAttemptRepository.save(attempt);
        return toResponse(savedAttempt);
    }

    @Transactional
    public AdaptiveStartQuizResponse startAdaptiveQuiz(AdaptiveStartQuizRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
        Lesson lesson = lessonRepository.findById(request.getLessonId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found"));
        Question firstQuestion = findFirstQuestionByDifficulty(lesson.getId(), "basic")
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "No basic question available for this lesson"
                ));

        QuizAttempt attempt = new QuizAttempt();
        attempt.setUser(user);
        attempt.setLesson(lesson);
        attempt.setStartedAt(LocalDateTime.now());
        attempt.setTotalQuestions(request.getTotalQuestions());
        attempt.setCorrectAnswers(0);

        QuizAttempt savedAttempt = quizAttemptRepository.save(attempt);

        AdaptiveStartQuizResponse response = new AdaptiveStartQuizResponse();
        response.setAttemptId(savedAttempt.getId());
        response.setQuestion(AdaptiveQuizQuestionResponse.from(firstQuestion));
        response.setCurrentDifficulty("basic");
        response.setAnsweredCount(0);
        response.setTotalQuestions(request.getTotalQuestions());
        return response;
    }

    @Transactional
    public AdaptiveAnswerResponse answerAdaptiveQuestion(AdaptiveAnswerRequest request) {
        QuizAttempt attempt = quizAttemptRepository.findById(request.getAttemptId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Quiz attempt not found"));

        if (attempt.getFinishedAt() != null) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Quiz attempt already submitted");
        }

        Question question = findQuestionForAttempt(request.getQuestionId(), attempt);
        List<QuizAnswer> existingAnswers = quizAnswerRepository.findByQuizAttemptId(attempt.getId());
        Set<Long> answeredQuestionIds = extractAnsweredQuestionIds(existingAnswers);
        if (answeredQuestionIds.contains(question.getId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Question already answered in this attempt");
        }

        String selectedAnswer = normalizeAnswer(request.getSelectedAnswer());
        boolean correct = selectedAnswer.equalsIgnoreCase(question.getCorrectAnswer());
        String answeredDifficulty = normalizeDifficulty(question.getDifficultyLevel());

        QuizAnswer quizAnswer = new QuizAnswer();
        quizAnswer.setQuizAttempt(attempt);
        quizAnswer.setQuestion(question);
        quizAnswer.setSelectedAnswer(selectedAnswer);
        quizAnswer.setResponseTimeSeconds(request.getResponseTimeSeconds());
        quizAnswer.setCorrect(correct);
        quizAnswer.setDifficultyLevel(answeredDifficulty);
        quizAnswerRepository.save(quizAnswer);

        answeredQuestionIds.add(question.getId());
        int answeredCount = existingAnswers.size() + 1;
        int correctAnswers = (int) existingAnswers.stream()
                .filter(answer -> Boolean.TRUE.equals(answer.getCorrect()))
                .count() + (correct ? 1 : 0);
        int targetTotalQuestions = attempt.getTotalQuestions() == null || attempt.getTotalQuestions() < 1
                ? answeredCount
                : attempt.getTotalQuestions();
        float currentScore = calculateScore(correctAnswers, answeredCount);
        String nextDifficulty = calculateNextDifficulty(
                normalizeDifficulty(request.getCurrentDifficulty()),
                correct,
                isFastAnswer(answeredDifficulty, request.getResponseTimeSeconds())
        );

        Optional<Question> nextQuestion = answeredCount >= targetTotalQuestions
                ? Optional.empty()
                : findNextQuestion(attempt.getLesson().getId(), nextDifficulty, answeredQuestionIds);

        if (nextQuestion.isEmpty()) {
            return finishAdaptiveAttempt(
                    attempt,
                    correct,
                    answeredDifficulty,
                    nextDifficulty,
                    currentScore,
                    correctAnswers,
                    answeredCount,
                    answeredCount
            );
        }

        AdaptiveAnswerResponse response = new AdaptiveAnswerResponse();
        response.setFinished(false);
        response.setCorrect(correct);
        response.setCurrentDifficulty(answeredDifficulty);
        response.setNextDifficulty(normalizeDifficulty(nextQuestion.get().getDifficultyLevel()));
        response.setNextQuestion(AdaptiveQuizQuestionResponse.from(nextQuestion.get()));
        response.setCurrentScore(currentScore);
        response.setAnsweredCount(answeredCount);
        response.setTotalQuestions(targetTotalQuestions);
        return response;
    }

    @Transactional
    public QuizAttemptResponse submitQuiz(SubmitQuizRequest request) {
        QuizAttempt attempt = quizAttemptRepository.findById(request.getAttemptId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Quiz attempt not found"));

        if (attempt.getFinishedAt() != null) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Quiz attempt already submitted");
        }

        validateNoDuplicateQuestions(request.getAnswers());

        int correctAnswers = 0;
        for (SubmitAnswerRequest answerRequest : request.getAnswers()) {
            Question question = findQuestionForAttempt(answerRequest.getQuestionId(), attempt);
            String selectedAnswer = normalizeAnswer(answerRequest.getSelectedAnswer());
            boolean correct = selectedAnswer.equalsIgnoreCase(question.getCorrectAnswer());

            QuizAnswer quizAnswer = new QuizAnswer();
            quizAnswer.setQuizAttempt(attempt);
            quizAnswer.setQuestion(question);
            quizAnswer.setSelectedAnswer(selectedAnswer);
            quizAnswer.setCorrect(correct);
            quizAnswer.setDifficultyLevel(question.getDifficultyLevel());
            quizAnswerRepository.save(quizAnswer);

            if (correct) {
                correctAnswers++;
            }
        }

        int totalQuestions = request.getAnswers().size();
        float score = totalQuestions == 0 ? 0.0F : (correctAnswers * 100.0F) / totalQuestions;
        attempt.setTotalQuestions(totalQuestions);
        attempt.setCorrectAnswers(correctAnswers);
        attempt.setScore(score);
        attempt.setResultStatus(score >= PASS_SCORE ? "pass" : "fail");
        attempt.setFinishedAt(LocalDateTime.now());

        QuizAttempt savedAttempt = quizAttemptRepository.save(attempt);
        learningProgressService.updateAfterQuizSubmit(savedAttempt);
        return toResponse(savedAttempt);
    }

    @Transactional(readOnly = true)
    public QuizAttemptResponse getAttemptById(Long id) {
        QuizAttempt attempt = quizAttemptRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Quiz attempt not found"));
        return toResponse(attempt);
    }

    @Transactional(readOnly = true)
    public List<QuizAttemptResponse> getAttemptsByUserId(Long userId) {
        if (!userRepository.existsById(userId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
        }

        return quizAttemptRepository.findByUserId(userId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<QuizAttemptResponse> getAttemptsByLessonId(Long lessonId) {
        if (!lessonRepository.existsById(lessonId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found");
        }

        return quizAttemptRepository.findByLessonId(lessonId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    private QuizAttemptResponse toResponse(QuizAttempt attempt) {
        List<QuizAnswer> answers = quizAnswerRepository.findByQuizAttemptId(attempt.getId());
        return QuizAttemptResponse.from(attempt, answers);
    }

    private Question findQuestionForAttempt(Long questionId, QuizAttempt attempt) {
        Question question = questionRepository.findById(questionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Question not found"));

        if (!question.getLesson().getId().equals(attempt.getLesson().getId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Question does not belong to the quiz lesson");
        }

        return question;
    }

    private void validateNoDuplicateQuestions(List<SubmitAnswerRequest> answers) {
        Set<Long> questionIds = new HashSet<>();
        for (SubmitAnswerRequest answer : answers) {
            if (!questionIds.add(answer.getQuestionId())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Duplicate question in submitted answers");
            }
        }
    }

    private String normalizeAnswer(String answer) {
        if (answer == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Selected answer must not be null");
        }
        return answer.trim().toUpperCase();
    }

    private AdaptiveAnswerResponse finishAdaptiveAttempt(
            QuizAttempt attempt,
            boolean correct,
            String currentDifficulty,
            String nextDifficulty,
            float finalScore,
            int correctAnswers,
            int answeredCount,
            int totalQuestions
    ) {
        attempt.setCorrectAnswers(correctAnswers);
        attempt.setTotalQuestions(totalQuestions);
        attempt.setScore(finalScore);
        attempt.setResultStatus(finalScore >= PASS_SCORE ? "pass" : "fail");
        attempt.setFinishedAt(LocalDateTime.now());

        QuizAttempt savedAttempt = quizAttemptRepository.save(attempt);
        learningProgressService.updateAfterQuizSubmit(savedAttempt);

        AdaptiveAnswerResponse response = new AdaptiveAnswerResponse();
        response.setFinished(true);
        response.setCorrect(correct);
        response.setCurrentDifficulty(currentDifficulty);
        response.setNextDifficulty(nextDifficulty);
        response.setCurrentScore(finalScore);
        response.setFinalScore(finalScore);
        response.setResultStatus(finalScore >= PASS_SCORE ? "pass" : "fail");
        response.setCorrectAnswers(correctAnswers);
        response.setAnsweredCount(answeredCount);
        response.setTotalQuestions(totalQuestions);
        return response;
    }

    private Optional<Question> findFirstQuestionByDifficulty(Long lessonId, String difficulty) {
        return questionRepository.findByLessonId(lessonId)
                .stream()
                .filter(question -> difficulty.equals(normalizeDifficulty(question.getDifficultyLevel())))
                .min(Comparator.comparing(Question::getId));
    }

    private Optional<Question> findNextQuestion(Long lessonId, String preferredDifficulty, Set<Long> answeredQuestionIds) {
        List<Question> availableQuestions = questionRepository.findByLessonId(lessonId)
                .stream()
                .filter(question -> !answeredQuestionIds.contains(question.getId()))
                .sorted(Comparator.comparing(Question::getId))
                .toList();

        for (String difficulty : fallbackDifficulties(preferredDifficulty)) {
            Optional<Question> question = availableQuestions.stream()
                    .filter(item -> difficulty.equals(normalizeDifficulty(item.getDifficultyLevel())))
                    .findFirst();
            if (question.isPresent()) {
                return question;
            }
        }

        return Optional.empty();
    }

    private Set<Long> extractAnsweredQuestionIds(List<QuizAnswer> answers) {
        Set<Long> questionIds = new HashSet<>();
        for (QuizAnswer answer : answers) {
            questionIds.add(answer.getQuestion().getId());
        }
        return questionIds;
    }

    private float calculateScore(int correctAnswers, int answeredCount) {
        return answeredCount == 0 ? 0.0F : (correctAnswers * 100.0F) / answeredCount;
    }

    private boolean isFastAnswer(String difficulty, Integer responseTimeSeconds) {
        int responseTime = responseTimeSeconds == null ? Integer.MAX_VALUE : responseTimeSeconds;
        return switch (normalizeDifficulty(difficulty)) {
            case "hard" -> responseTime <= 45;
            case "medium" -> responseTime <= 30;
            default -> responseTime <= 20;
        };
    }

    private String calculateNextDifficulty(String currentDifficulty, boolean correct, boolean fast) {
        String difficulty = normalizeDifficulty(currentDifficulty);
        if (correct && fast) {
            return switch (difficulty) {
                case "basic" -> "medium";
                case "medium" -> "hard";
                default -> "hard";
            };
        }
        if (correct) {
            return difficulty;
        }
        return switch (difficulty) {
            case "hard" -> "medium";
            case "medium" -> "basic";
            default -> "basic";
        };
    }

    private List<String> fallbackDifficulties(String difficulty) {
        return switch (normalizeDifficulty(difficulty)) {
            case "hard" -> List.of("hard", "medium", "basic");
            case "medium" -> List.of("medium", "basic", "hard");
            default -> List.of("basic", "medium", "hard");
        };
    }

    private String normalizeDifficulty(String difficulty) {
        if ("medium".equals(difficulty) || "hard".equals(difficulty)) {
            return difficulty;
        }
        return "basic";
    }
}
