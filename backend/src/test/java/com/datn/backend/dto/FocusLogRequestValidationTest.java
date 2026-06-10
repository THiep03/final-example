package com.datn.backend.dto;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

class FocusLogRequestValidationTest {

    private static ValidatorFactory validatorFactory;
    private static Validator validator;

    @BeforeAll
    static void setUpValidator() {
        validatorFactory = Validation.buildDefaultValidatorFactory();
        validator = validatorFactory.getValidator();
    }

    @AfterAll
    static void closeValidatorFactory() {
        validatorFactory.close();
    }

    @Test
    void acceptsValidFocusLogRequest() {
        FocusLogRequest request = validRequest();

        Set<ConstraintViolation<FocusLogRequest>> violations = validator.validate(request);

        assertThat(violations).isEmpty();
    }

    @Test
    void rejectsUnsupportedStatus() {
        FocusLogRequest request = validRequest();
        request.setStatus("unknown");

        Set<ConstraintViolation<FocusLogRequest>> violations = validator.validate(request);

        assertThat(violations)
                .extracting(ConstraintViolation::getMessage)
                .contains("Status must be focused, distracted, or no_face");
    }

    @Test
    void rejectsFocusScoreBelowZero() {
        FocusLogRequest request = validRequest();
        request.setFocusScore(-1.0F);

        Set<ConstraintViolation<FocusLogRequest>> violations = validator.validate(request);

        assertThat(violations)
                .extracting(ConstraintViolation::getMessage)
                .contains("Focus score must be at least 0");
    }

    @Test
    void rejectsFocusScoreAboveOneHundred() {
        FocusLogRequest request = validRequest();
        request.setFocusScore(101.0F);

        Set<ConstraintViolation<FocusLogRequest>> violations = validator.validate(request);

        assertThat(violations)
                .extracting(ConstraintViolation::getMessage)
                .contains("Focus score must be at most 100");
    }

    private FocusLogRequest validRequest() {
        FocusLogRequest request = new FocusLogRequest();
        request.setUserId(1L);
        request.setLessonId(1L);
        request.setStatus("focused");
        request.setFocusScore(90.0F);
        return request;
    }
}
