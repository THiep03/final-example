USE adaptive_learning_db;

ALTER TABLE quiz_answers
    ADD COLUMN response_time_seconds INT NULL AFTER selected_answer;
