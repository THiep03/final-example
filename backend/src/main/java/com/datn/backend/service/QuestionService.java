package com.datn.backend.service;

import com.datn.backend.dto.QuestionRequest;
import com.datn.backend.dto.QuestionResponse;
import com.datn.backend.entity.Lesson;
import com.datn.backend.entity.Question;
import com.datn.backend.repository.LessonRepository;
import com.datn.backend.repository.QuestionRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class QuestionService {

    private final QuestionRepository questionRepository;
    private final LessonRepository lessonRepository;

    public QuestionService(QuestionRepository questionRepository, LessonRepository lessonRepository) {
        this.questionRepository = questionRepository;
        this.lessonRepository = lessonRepository;
    }

    @Transactional(readOnly = true)
    public List<QuestionResponse> getAllQuestions() {
        return questionRepository.findAll()
                .stream()
                .map(QuestionResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public QuestionResponse getQuestionById(Long id) {
        return questionRepository.findById(id)
                .map(QuestionResponse::from)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Question not found"));
    }

    @Transactional(readOnly = true)
    public List<QuestionResponse> getQuestionsByLessonId(Long lessonId) {
        if (!lessonRepository.existsById(lessonId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found");
        }

        return questionRepository.findByLessonId(lessonId)
                .stream()
                .map(QuestionResponse::from)
                .toList();
    }

    @Transactional
    public QuestionResponse createQuestion(QuestionRequest request) {
        Question question = new Question();
        applyRequest(question, request);
        return QuestionResponse.from(questionRepository.save(question));
    }

    @Transactional
    public QuestionResponse updateQuestion(Long id, QuestionRequest request) {
        Question question = questionRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Question not found"));

        applyRequest(question, request);
        return QuestionResponse.from(questionRepository.save(question));
    }

    @Transactional
    public void deleteQuestion(Long id) {
        if (!questionRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Question not found");
        }

        questionRepository.deleteById(id);
    }

    private void applyRequest(Question question, QuestionRequest request) {
        question.setLesson(findLesson(request.getLessonId()));
        question.setQuestionContent(request.getQuestionContent());
        question.setOptionA(request.getOptionA());
        question.setOptionB(request.getOptionB());
        question.setOptionC(request.getOptionC());
        question.setOptionD(request.getOptionD());
        question.setCorrectAnswer(request.getCorrectAnswer().trim().toUpperCase());
        question.setDifficultyLevel(request.getDifficultyLevel());
    }

    private Lesson findLesson(Long lessonId) {
        return lessonRepository.findById(lessonId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found"));
    }

}
