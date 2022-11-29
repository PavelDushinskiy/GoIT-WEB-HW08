-- 5 студентів із найбільшим середнім балом з усіх предметів
SELECT s.stud_name AS NAME, ROUND(AVG(grade), 2) AS AVG_GRADE
FROM grades g
LEFT JOIN students s ON g.grad_stud_id = s.stud_id
GROUP BY g.grad_stud_id
ORDER BY AVG_GRADE DESC
LIMIT 5;

-- 1 студент із найвищим середнім балом з одного предмета
SELECT s2.subj_name AS SUBJECT, s.stud_name AS NAME, ROUND(AVG(grade), 2) AS AVG_GRADE
FROM grades g
LEFT JOIN students s ON g.grad_stud_id = s.stud_id
LEFT JOIN subjects s2 ON g.grad_subj_id = s2.subj_id
WHERE s2.subj_id = 5
GROUP BY NAME
ORDER BY AVG_GRADE DESC
LIMIT 1;

-- Середній бал в групі по одному предмету
SELECT s2.subj_name AS SUBJECT, g2.grp_name AS GROUP_NAME, ROUND(AVG(grade), 2) AS AVG_GRADE
FROM grades g
LEFT JOIN students s ON g.grad_stud_id = s.stud_id
LEFT JOIN subjects s2 ON g.grad_subj_id = s2.subj_id
LEFT JOIN [groups] g2 ON g2.grp_id = s.stud_grp_id
WHERE s2.subj_id = 1
GROUP BY SUBJECT, GROUP_NAME
ORDER BY AVG_GRADE DESC;

-- Середній бал у потоці
SELECT ROUND(AVG(grade), 2) AS AVG_GRADE
FROM grades g;

-- Які курси читає викладач
SELECT s.subj_name AS SUBJECT, t.teach_name AS TEACHER
FROM teachers t
LEFT JOIN subjects s ON s.subj_teacher_id = t.teach_id
WHERE t.teach_id = 1;

-- Список студентів у групі
SELECT s.stud_name AS NAME, g.grp_name
FROM students s
LEFT JOIN groups g ON s.stud_grp_id = g.grp_id
WHERE g.grp_id = 1;

-- Оцінки студентів у групі з предмета
SELECT g2.grp_name AS GROUP_NAME, s2.subj_name AS SUBJECT,
	   s.stud_name AS NAME, g.grade AS GRADE, g.grad_date AS [DATE]
FROM grades g
LEFT JOIN students s ON g.grad_stud_id = s.stud_id
LEFT JOIN subjects s2 ON g.grad_subj_id = s2.subj_id
LEFT JOIN [groups] g2 ON g2.grp_id = s.stud_grp_id
WHERE s2.subj_id = 1 AND g2.grp_id = 1
ORDER BY NAME, [DATE];

-- Оцінки студентів у групі з предмета на останньому занятті
SELECT g.grad_date AS [DATE]
FROM grades g
LEFT JOIN students s ON g.grad_stud_id = s.stud_id
LEFT JOIN [groups] g2 ON g2.grp_id = s.stud_grp_id
WHERE g.grad_subj_id = 1 AND g2.grp_id = 2
ORDER BY g.grad_date DESC
LIMIT 1;

SELECT g2.grp_name AS GROUP_NAME, s2.subj_name AS SUBJECT,
	   s.stud_name AS NAME, g.grade AS GRADE, g.grad_date AS [DATE]
FROM grades g
LEFT JOIN students s ON g.grad_stud_id = s.stud_id
LEFT JOIN subjects s2 ON g.grad_subj_id = s2.subj_id
LEFT JOIN [groups] g2 ON g2.grp_id = s.stud_grp_id
WHERE s2.subj_id = 2
AND g2.grp_id = 3
AND g.grad_date = (	SELECT g.grad_date AS [DATE]
					FROM grades g
					LEFT JOIN students s ON g.grad_stud_id = s.stud_id
					LEFT JOIN [groups] g2 ON g2.grp_id = s.stud_grp_id
					WHERE g.grad_subj_id = 2 AND g2.grp_id = 3
					ORDER BY g.grad_date DESC
					LIMIT 1);

-- Список курсів, які відвідує студент
SELECT DISTINCT s2.subj_name AS SUBJECT, s.stud_name AS NAME
FROM grades g
LEFT JOIN students s ON s.stud_id = g.grad_stud_id
LEFT JOIN subjects s2 ON s2.subj_id = g.grad_subj_id
WHERE s.stud_id = 2;

-- Список курсів, які студенту читає викладач
SELECT DISTINCT s.stud_name AS NAME, s2.subj_name AS SUBJECT, t.teach_name AS TEACHER
FROM grades g
LEFT JOIN students s ON s.stud_id = g.grad_stud_id
LEFT JOIN subjects s2 ON s2.subj_id = g.grad_subj_id
LEFT JOIN teachers t ON t.teach_id = s2.subj_teacher_id
WHERE t.teach_id = 2 AND g.grad_stud_id = 2;

-- Середній бал, який викладач ставить студенту
SELECT DISTINCT s.stud_name AS NAME, t.teach_name AS TEACHER, ROUND(AVG(grade), 2) AS AVG_GRADE
FROM grades g
LEFT JOIN students s ON s.stud_id = g.grad_stud_id
LEFT JOIN subjects s2 ON s2.subj_id = g.grad_subj_id
LEFT JOIN teachers t ON t.teach_id = s2.subj_teacher_id
WHERE t.teach_id = 3 AND g.grad_stud_id = 2
GROUP BY NAME, TEACHER;

-- Середній бал, який ставить викладач
SELECT t.teach_name AS TEACHER, ROUND(AVG(grade), 2) AS AVG_GRADE
FROM grades g
LEFT JOIN subjects s2 ON s2.subj_id = g.grad_subj_id
LEFT JOIN teachers t ON t.teach_id = s2.subj_teacher_id
WHERE t.teach_id = 2
GROUP BY TEACHER;
