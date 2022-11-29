-- Table: Students
DROP TABLE IF EXISTS students;
CREATE TABLE students (
    stud_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    stud_name VARCHAR(255) UNIQUE NOT NULL,
    stud_grp_id INTEGER,
	FOREIGN KEY (stud_grp_id) REFERENCES groups (grp_id) 
);

-- Table: grades
DROP TABLE IF EXISTS grades;
CREATE TABLE grades (
    grad_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    grade INTEGER,
	grad_date DATE NOT NULL,
	grad_stud_id INTEGER,
	grad_subj_id INTEGER,
	FOREIGN KEY (grad_stud_id) REFERENCES students (stud_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
    FOREIGN KEY (grad_subj_id) REFERENCES subjects (subj_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

-- Table: Groups
DROP TABLE IF EXISTS groups;
CREATE TABLE groups (
    grp_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    grp_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table: Subjects
DROP TABLE IF EXISTS subjects;
CREATE TABLE subjects (
    subj_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    subj_name VARCHAR(50) UNIQUE NOT NULL,
	subj_teacher_id INTEGER,
	FOREIGN KEY (subj_teacher_id) REFERENCES teachers (teach_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

-- Table: Teachers
DROP TABLE IF EXISTS teachers;
CREATE TABLE teachers (
    teach_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    teach_name VARCHAR(255) UNIQUE NOT NULL
);