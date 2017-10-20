-- script to copy the courses from one year to the next years.
-- course catalog for 2017 - 2020

Select *
From MainDB.Course;

Select *
From MainDB.Course
Where Year=2017;

Select *
From MainDB.Course
Where Year=2018;

-- SET SQL_SAFE_UPDATES = 0;
-- Delete From MainDB.Course Where Year IN (2019, 2020);

/*
-- back up 2018 to 2016
Insert Into MainDB.Course (Department, CourseNumber, CourseName, Semester, Year, Professor_PK, Units)
Select Department, CourseNumber, CourseName, Semester, 2016 as Year, Professor_PK, Units
From MainDB.Course
Where Year=2018;
*/

/*
-- 2017 to 2018
Insert Into MainDB.Course (Department, CourseNumber, CourseName, Semester, Year, Professor_PK, Units)
Select Department, CourseNumber, CourseName, Semester, 2018 as Year, Professor_PK, Units
From MainDB.Course
Where Year=2017;
*/

/*
-- 2018 to 2019
Insert Into MainDB.Course (Department, CourseNumber, CourseName, Semester, Year, Professor_PK, Units)
Select Department, CourseNumber, CourseName, Semester, 2019 as Year, Professor_PK, Units
From MainDB.Course
Where Year=2018;
*/

/*
-- 2019 to 2020
Insert Into MainDB.Course (Department, CourseNumber, CourseName, Semester, Year, Professor_PK, Units)
Select Department, CourseNumber, CourseName, Semester, 2020 as Year, Professor_PK, Units
From MainDB.Course
Where Year=2019;
*/




