package com.datn.backend.service;

import com.datn.backend.dto.AdaptiveAnswerRequest;
import com.datn.backend.dto.AdaptiveAnswerResponse;
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
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class QuizServiceTest {

    @Mock
    private QuizAttemptRepository quizAttemptRepository;

    @Mock
    private QuizAnswerRepository quizAnswerRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private LessonRepository lessonRepository;

    @Mock
    private QuestionRepository questionRepository;

    @Mock
    private LearningProgressService learningProgressService;

    private QuizService quizService;
    private User user;
    private Lesson lesson;

    @BeforeEach
    void setUp() {
        quizService = new QuizService(
                quizAttemptRepository,
                quizAnswerRepository,
                userRepository,
                lessonRepository,
                questionRepository,
                learningProgressService
        );

        user = new User();
        user.setId(1L);
        user.setCurrentLevel("basic");

        lesson = new Lesson();
        lesson.setId(1L);
    }

    @Test
    void startAdaptiveQuizReturnsBasicQuestion() {
        Question basicQuestion = question(1L, "basic", "A");
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(lessonRepository.findById(1L)).thenReturn(Optional.of(lesson));
        when(questionRepository.findByLessonId(1L)).thenReturn(List.of(
                question(2L, "medium", "A"),
                basicQuestion
        ));
        when(quizAttemptRepository.save(any(QuizAttempt.class))).thenAnswer(invocation -> {
            QuizAttempt attempt = invocation.getArgument(0);
            attempt.setId(10L);
            return attempt;
        });

        AdaptiveStartQuizResponse response = quizService.startAdaptiveQuiz(startRequest(3));

        assertThat(response.getAttemptId()).isEqualTo(10L);
        assertThat(response.getCurrentDifficulty()).isEqualTo("basic");
        assertThat(response.getQuestion().getId()).isEqualTo(1L);
        assertThat(response.getQuestion().getDifficultyLevel()).isEqualTo("basic");
        assertThat(response.getAnsweredCount()).isZero();
        assertThat(response.getTotalQuestions()).isEqualTo(3);
    }

    @Test
    void correctFastBasicAnswerIncreasesNextDifficultyToMedium() {
        AdaptiveAnswerResponse response = answerWith(
                attempt(3),
                question(1L, "basic", "A"),
                List.of(question(1L, "basic", "A"), question(2L, "medium", "A")),
                "A",
                "basic",
                20
        );

        assertThat(response.getFinished()).isFalse();
        assertThat(response.getCorrect()).isTrue();
        assertThat(response.getNextDifficulty()).isEqualTo("medium");
        assertThat(response.getNextQuestion().getDifficultyLevel()).isEqualTo("medium");
    }

    @Test
    void correctFastMediumAnswerIncreasesNextDifficultyToHard() {
        AdaptiveAnswerResponse response = answerWith(
                attempt(3),
                question(2L, "medium", "A"),
                List.of(question(2L, "medium", "A"), question(3L, "hard", "A")),
                "A",
                "medium",
                30
        );

        assertThat(response.getFinished()).isFalse();
        assertThat(response.getNextDifficulty()).isEqualTo("hard");
    }

    @Test
    void correctSlowAnswerKeepsCurrentDifficulty() {
        AdaptiveAnswerResponse response = answerWith(
                attempt(3),
                question(2L, "medium", "A"),
                List.of(question(2L, "medium", "A"), question(4L, "medium", "A"), question(3L, "hard", "A")),
                "A",
                "medium",
                31
        );

        assertThat(response.getFinished()).isFalse();
        assertThat(response.getNextDifficulty()).isEqualTo("medium");
    }

    @Test
    void wrongMediumAnswerDecreasesNextDifficultyToBasic() {
        AdaptiveAnswerResponse response = answerWith(
                attempt(3),
                question(2L, "medium", "A"),
                List.of(question(2L, "medium", "A"), question(1L, "basic", "A")),
                "B",
                "medium",
                10
        );

        assertThat(response.getCorrect()).isFalse();
        assertThat(response.getNextDifficulty()).isEqualTo("basic");
    }

    @Test
    void wrongHardAnswerDecreasesNextDifficultyToMedium() {
        AdaptiveAnswerResponse response = answerWith(
                attempt(3),
                question(3L, "hard", "A"),
                List.of(question(3L, "hard", "A"), question(2L, "medium", "A")),
                "B",
                "hard",
                10
        );

        assertThat(response.getCorrect()).isFalse();
        assertThat(response.getNextDifficulty()).isEqualTo("medium");
    }

    @Test
    void adaptiveQuizDoesNotReturnDuplicateQuestion() {
        AdaptiveAnswerResponse response = answerWith(
                attempt(3),
                question(1L, "basic", "A"),
                List.of(question(1L, "basic", "A"), question(2L, "medium", "A")),
                "A",
                "basic",
                10
        );

        assertThat(response.getNextQuestion().getId()).isEqualTo(2L);
    }

    @Test
    void adaptiveQuizFinishesWhenEnoughTotalQuestionsAnswered() {
        QuizAttempt attempt = attempt(1);

        AdaptiveAnswerResponse response = answerWith(
                attempt,
                question(1L, "basic", "A"),
                List.of(question(1L, "basic", "A"), question(2L, "medium", "A")),
                "A",
                "basic",
                10
        );

        assertThat(response.getFinished()).isTrue();
        assertThat(response.getFinalScore()).isEqualTo(100.0F);
        assertThat(response.getResultStatus()).isEqualTo("pass");
        assertThat(response.getCorrectAnswers()).isEqualTo(1);
        assertThat(attempt.getFinishedAt()).isNotNull();
        verify(learningProgressService).updateAfterQuizSubmit(attempt);
    }

    @Test
    void adaptiveQuizDoesNotUpdateUsersCurrentLevel() {
        user.setCurrentLevel("hard");
        QuizAttempt attempt = attempt(1);

        answerWith(
                attempt,
                question(1L, "basic", "A"),
                List.of(question(1L, "basic", "A")),
                "A",
                "basic",
                10
        );

        assertThat(user.getCurrentLevel()).isEqualTo("hard");
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void adaptiveQuizRejectsDuplicateAnswerInSameAttempt() {
        QuizAttempt attempt = attempt(3);
        Question currentQuestion = question(1L, "basic", "A");
        QuizAnswer existingAnswer = answer(attempt, currentQuestion, true);

        when(quizAttemptRepository.findById(10L)).thenReturn(Optional.of(attempt));
        when(questionRepository.findById(1L)).thenReturn(Optional.of(currentQuestion));
        when(quizAnswerRepository.findByQuizAttemptId(10L)).thenReturn(List.of(existingAnswer));

        assertThatThrownBy(() -> quizService.answerAdaptiveQuestion(answerRequest(1L, "A", "basic", 10)))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("Question already answered");
    }

    private AdaptiveStartQuizRequest startRequest(int totalQuestions) {
        AdaptiveStartQuizRequest request = new AdaptiveStartQuizRequest();
        request.setUserId(1L);
        request.setLessonId(1L);
        request.setTotalQuestions(totalQuestions);
        return request;
    }

    private AdaptiveAnswerResponse answerWith(
            QuizAttempt attempt,
            Question currentQuestion,
            List<Question> lessonQuestions,
            String selectedAnswer,
            String currentDifficulty,
            int responseTimeSeconds
    ) {
        when(quizAttemptRepository.findById(10L)).thenReturn(Optional.of(attempt));
        when(questionRepository.findById(currentQuestion.getId())).thenReturn(Optional.of(currentQuestion));
        when(quizAnswerRepository.findByQuizAttemptId(10L)).thenReturn(List.of());
        when(quizAnswerRepository.save(any(QuizAnswer.class))).thenAnswer(invocation -> invocation.getArgument(0));
        lenient().when(quizAttemptRepository.save(any(QuizAttempt.class))).thenAnswer(invocation -> invocation.getArgument(0));
        lenient().when(questionRepository.findByLessonId(1L)).thenReturn(lessonQuestions);

        return quizService.answerAdaptiveQuestion(answerRequest(
                currentQuestion.getId(),
                selectedAnswer,
                currentDifficulty,
                responseTimeSeconds
        ));
    }

    private AdaptiveAnswerRequest answerRequest(
            Long questionId,
            String selectedAnswer,
            String currentDifficulty,
            int responseTimeSeconds
    ) {
        AdaptiveAnswerRequest request = new AdaptiveAnswerRequest();
        request.setAttemptId(10L);
        request.setQuestionId(questionId);
        request.setSelectedAnswer(selectedAnswer);
        request.setCurrentDifficulty(currentDifficulty);
        request.setResponseTimeSeconds(responseTimeSeconds);
        return request;
    }

    private QuizAttempt attempt(int totalQuestions) {
        QuizAttempt attempt = new QuizAttempt();
        attempt.setId(10L);
        attempt.setUser(user);
        attempt.setLesson(lesson);
        attempt.setStartedAt(LocalDateTime.now());
        attempt.setTotalQuestions(totalQuestions);
        attempt.setCorrectAnswers(0);
        return attempt;
    }

    private Question question(Long id, String difficulty, String correctAnswer) {
        Question question = new Question();
        question.setId(id);
        question.setLesson(lesson);
        question.setQuestionContent("Question " + id);
        question.setOptionA("A");
        question.setOptionB("B");
        question.setOptionC("C");
        question.setOptionD("D");
        question.setCorrectAnswer(correctAnswer);
        question.setDifficultyLevel(difficulty);
        return question;
    }

    private QuizAnswer answer(QuizAttempt attempt, Question question, boolean correct) {
        QuizAnswer answer = new QuizAnswer();
        answer.setId(question.getId());
        answer.setQuizAttempt(attempt);
        answer.setQuestion(question);
        answer.setCorrect(correct);
        answer.setSelectedAnswer(correct ? question.getCorrectAnswer() : "B");
        answer.setDifficultyLevel(question.getDifficultyLevel());
        return answer;
    }
}
