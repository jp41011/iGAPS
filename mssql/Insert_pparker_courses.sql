/*
Script to insert the courses history for pparker
*/
select * from MainDB.Student;

Select *
From MainDB.CourseEnrollment;

Insert into MainDB.CourseEnrollment(Student_PK, Course_PK, Grade)
values
(3, 593, 'B')
,(3, 127, 'A')
,(3, 139, 'A')
,(3, 262, 'B')
,(3, 587, 'A')
,(3, 221, 'B')
,(3, 250, 'B')
,(3, 594, 'B')
,(3, 595, 'C')
,(3, 396, 'B')
,(3, 343, 'A')
;