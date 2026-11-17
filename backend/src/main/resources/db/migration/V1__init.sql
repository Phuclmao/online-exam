-- V1: Khởi tạo 12 bảng theo thiết kế trong README (mục 6).
-- Muốn thay đổi: tạo file mới V2__mo_ta.sql, KHÔNG sửa file này sau khi đã merge.

CREATE TABLE users (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          ENUM('ADMIN','TEACHER','STUDENT') NOT NULL DEFAULT 'STUDENT',
    status        ENUM('ACTIVE','LOCKED') NOT NULL DEFAULT 'ACTIVE',
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE subjects (
    id   BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    code VARCHAR(30)  NOT NULL UNIQUE
);

CREATE TABLE chapters (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    subject_id BIGINT NOT NULL,
    name       VARCHAR(200) NOT NULL,
    sort_order INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_chapters_subject FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

CREATE TABLE classes (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    teacher_id BIGINT NOT NULL,
    CONSTRAINT fk_classes_teacher FOREIGN KEY (teacher_id) REFERENCES users(id)
);

CREATE TABLE class_students (
    class_id   BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    PRIMARY KEY (class_id, student_id),
    CONSTRAINT fk_cs_class   FOREIGN KEY (class_id)   REFERENCES classes(id) ON DELETE CASCADE,
    CONSTRAINT fk_cs_student FOREIGN KEY (student_id) REFERENCES users(id)   ON DELETE CASCADE
);

CREATE TABLE questions (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    subject_id BIGINT NOT NULL,
    chapter_id BIGINT NULL,
    content    TEXT NOT NULL,
    type       ENUM('SINGLE','MULTIPLE') NOT NULL DEFAULT 'SINGLE',
    level      ENUM('EASY','MEDIUM','HARD') NOT NULL DEFAULT 'MEDIUM',
    created_by BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_q_subject FOREIGN KEY (subject_id) REFERENCES subjects(id),
    CONSTRAINT fk_q_chapter FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE SET NULL,
    CONSTRAINT fk_q_creator FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE answers (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    question_id BIGINT NOT NULL,
    content     TEXT NOT NULL,
    is_correct  BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_a_question FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

CREATE TABLE exams (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    title            VARCHAR(200) NOT NULL,
    subject_id       BIGINT NOT NULL,
    duration_minutes INT NOT NULL,
    total_score      DECIMAL(5,2) NOT NULL DEFAULT 10,
    created_by       BIGINT NOT NULL,
    created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_e_subject FOREIGN KEY (subject_id) REFERENCES subjects(id),
    CONSTRAINT fk_e_creator FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE exam_questions (
    exam_id     BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    sort_order  INT NOT NULL DEFAULT 0,
    score       DECIMAL(5,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (exam_id, question_id),
    CONSTRAINT fk_eq_exam     FOREIGN KEY (exam_id)     REFERENCES exams(id) ON DELETE CASCADE,
    CONSTRAINT fk_eq_question FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE exam_sessions (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    exam_id      BIGINT NOT NULL,
    class_id     BIGINT NULL,
    start_time   DATETIME NOT NULL,
    end_time     DATETIME NOT NULL,
    max_attempts INT NOT NULL DEFAULT 1,
    password     VARCHAR(100) NULL,
    shuffle      BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_es_exam  FOREIGN KEY (exam_id)  REFERENCES exams(id),
    CONSTRAINT fk_es_class FOREIGN KEY (class_id) REFERENCES classes(id)
);

CREATE TABLE attempts (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    session_id       BIGINT NOT NULL,
    student_id       BIGINT NOT NULL,
    started_at       DATETIME NOT NULL,
    submitted_at     DATETIME NULL,
    score            DECIMAL(5,2) NULL,
    status           ENUM('IN_PROGRESS','SUBMITTED','AUTO_SUBMITTED') NOT NULL DEFAULT 'IN_PROGRESS',
    tab_switch_count INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_at_session FOREIGN KEY (session_id) REFERENCES exam_sessions(id),
    CONSTRAINT fk_at_student FOREIGN KEY (student_id) REFERENCES users(id)
);

CREATE TABLE attempt_answers (
    attempt_id          BIGINT NOT NULL,
    question_id         BIGINT NOT NULL,
    selected_answer_ids VARCHAR(255) NULL,  -- ví dụ "12,15"
    is_correct          BOOLEAN NULL,
    PRIMARY KEY (attempt_id, question_id),
    CONSTRAINT fk_aa_attempt  FOREIGN KEY (attempt_id)  REFERENCES attempts(id) ON DELETE CASCADE,
    CONSTRAINT fk_aa_question FOREIGN KEY (question_id) REFERENCES questions(id)
);
