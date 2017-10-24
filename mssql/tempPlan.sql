-- courses the student can take next semester Plancfm.sql

Use MainDB;
-----
-- Here!!

Set @nextSemester = 'Spring', @nextYear = 2019, @studentID=4, @firstSemester='Fall', @firstYear=2018;

Select cd.*, cg.isRequired, cg.isElective
From MainDB.Course c
	Left Join MainDB.CourseData cd ON (cd.Semester = c.Semester AND cd.Year = c.Year AND cd.Department=c.Department AND cd.CourseNumber=c.CourseNumber AND cd.Professor_PK=c.Professor_PK)
	Left Join MainDB.Catalog cg ON (cg.Semester=@firstSemester AND cg.Year=@firstYear AND cg.Department=c.Department AND cg.CourseNumber=c.CourseNumber)
Where c.Semester = @nextSemester
	AND c.Year = @nextYear 
    AND (Left(c.CourseNumber, 1) = '2' 
		OR (c.Department = 'CSci' 
			AND c.CourseNumber='174') 
        )
	AND c.Department + '_' + c.CourseNumber NOT IN (Select c2.Department+'_'+c2.CourseNumber
													From MainDB.CourseEnrollment ce
														Join MainDB.Course c2 ON (c2.PK_Course = ce.Course_PK)
													Where ce.Student_PK = @studentID 
													AND Left(Grade,1) IN ('A', 'B', 'C')
													)
;




--
