-- script to insert the semesters into the semester table with sort order and is current
SELECT * FROM MainDB.Semester;

/*
Insert Into MainDB.Semester (Semester, Year, SortOrder, isCurrent)
Values
('Fall', 2017, 1, 0)
,('Spring', 2018, 2, 0)
,('Fall', 2018, 3, 0)
,('Spring', 2019, 4, 1);
*/