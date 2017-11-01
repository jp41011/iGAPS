-- CourseData

use MainDB;
/*
select * from MainDB.CourseData;

select * 
from MainDB.Course c
Where c.Department = 'CSci' AND Left(c.CourseNumber, 1) = '2'
;
*/
-- a smallest (inclusive), b biggest (exclusive)
-- SET @a = 0.25, @b = 1;
-- select @a as 'test1', @b as 'test2';
-- SELECT RAND()*(@b - @a) + @a;

SET @a = 0.25, @b = 1;

Insert Into MainDB.CourseData (Semester, Year, Department, CourseNumber, Professor_PK, Frequency, PassRate)
Select c.Semester, c.Year, c.Department, c.CourseNumber, c.Professor_PK, RAND()*(@b - @a) + @a AS 'Freq', RAND()*(@b - @a) + @a AS 'PRate'
From MainDB.Course c
Where c.Department = 'CSci' 
	-- AND Left(c.CourseNumber, 1) = '2'
    AND c.CourseNumber = '174'
;

