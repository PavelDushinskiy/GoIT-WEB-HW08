from datetime import datetime, date, timedelta
import faker
from random import randint, choice
import sqlite3

NUMBER_STUDENTS = 30
NUMBER_GROUPS = 3
NUMBER_SUBJECTS = 5
NUMBER_TEACHERS = 3
NUMBER_GRADES_PER_STUDENT = 20

groups = ['F-1', 'S-2', 'A-3']
subjects = ['Історія', 'Українська мова', 'Тензорне обчислення', 'Деталі машин', 'Фізичне виховання']


def date_range(start: date, end: date) -> list:
    result = []
    current_date = start
    while current_date <= end:
        if current_date.isoweekday() < 6:
            result.append(current_date)
        current_date += timedelta(1)
    return result


def generate_fake_data(number_students, number_teachers) -> tuple():
    fake_students = []
    fake_teachers = []
    fake_data = faker.Faker('uk-UA')

    ''' Згенеруємо студентів'''
    for _ in range(number_students):
        fake_students.append(fake_data.name())
    '''Згенеруємо викладачів'''
    for _ in range(number_teachers):
        fake_teachers.append(fake_data.name())

    return fake_students, fake_teachers


def prepare_data(groups, teachers, students, subjects) -> tuple():
    for_groups = []
    for group in groups:
        for_groups.append((group,))

    for_teachers = []
    for teacher in teachers:
        for_teachers.append((teacher,))

    for_students = []
    for student in students:
        for_students.append((student, randint(1, NUMBER_GROUPS)))

    for_subjects = []
    for subject in subjects:
        for_subjects.append((subject, randint(1, NUMBER_TEACHERS)))

    for_grades = []
    start_date = datetime.strptime("2021-09-01", "%Y-%m-%d")
    end_date = datetime.strptime("2022-05-25", "%Y-%m-%d")
    d_range = date_range(start=start_date, end=end_date)
    for d in d_range:
        r_subjects = [randint(1, NUMBER_SUBJECTS) for _ in range(randint(1, 3))]
        r_students = [randint(1, NUMBER_STUDENTS) for _ in range(randint(1, 5))]
        for subject in r_subjects:
            for student in r_students:
                for_grades.append((randint(1, 12), student, d.date(), subject))

    return for_groups, for_teachers, for_students, for_subjects, for_grades


def insert_data_to_db(groups, teachers, students, subjects, grades) -> None:
    with sqlite3.connect('university.db') as con:

        cur = con.cursor()
        try:
            sql_to_groups = """INSERT INTO groups(grp_name)
                                   VALUES (?)"""
            cur.executemany(sql_to_groups, groups)

            sql_to_teachers = """INSERT INTO teachers(teach_name)
                                   VALUES (?)"""
            cur.executemany(sql_to_teachers, teachers)

            sql_to_students = """INSERT INTO students(stud_name, stud_grp_id)
                                  VALUES (?, ?)"""
            cur.executemany(sql_to_students, students)

            sql_to_subjects = """INSERT INTO subjects(subj_name, subj_teacher_id)
                                  VALUES (?, ?)"""
            cur.executemany(sql_to_subjects, subjects)

            sql_to_grades = """INSERT INTO grades(grade, grad_stud_id, grad_date, grad_subj_id)
                                  VALUES (?, ?, ?, ?)"""
            cur.executemany(sql_to_grades, grades)

        except sqlite3.IntegrityError as err:
            print(err)

        con.commit()


if __name__ == "__main__":
    students, teachers = generate_fake_data(NUMBER_STUDENTS, NUMBER_TEACHERS)
    groups, teachers, students, subjects, grades = prepare_data(groups, teachers, students, subjects)
    insert_data_to_db(groups, teachers, students, subjects, grades)
