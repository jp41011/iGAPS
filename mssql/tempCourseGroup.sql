-- temp CourseGroup

Select * From CourseGroup;
select * from MainDB.CourseData;
Select * from MainDB.Catalog;

Select cg.*, cd.*, ct.isElective, ct.isRequired
From MainDB.CourseGroup cg
	Join MainDB.CourseData cd ON (cd.PK_CourseData = cg.CourseData_PK)
    Left Join MainDB.Catalog ct ON (ct.Semester='Fall' AND ct.Year=2018 AND ct.Department=cd.Department AND ct.CourseNumber=cd.CourseNumber)
;



-- formula for calcualting the groupings rating using: freq, passrate, isrequired, iselective

-- Rating for each solo course
Update MainDB.CourseGroup cg
	Join MainDB.CourseData cd ON (cd.PK_CourseData = cg.CourseData_PK)
    Left Join MainDB.Catalog ct ON (ct.Semester='Fall' AND ct.Year=2018 AND ct.Department=cd.Department AND ct.CourseNumber=cd.CourseNumber)
Set cg.Rating1 = cd.PassRate + (1 - cd.Frequency) + (0.5 * IF(ct.isRequired IS NULL, 0, 1)) + (0.1 * IF(ct.isElective IS NULL, 0, 1))
Where cg.GroupRun_PK = 2
;

-- update rating for the grouping
Update MainDB.CourseGroup cg
	Join (Select cg2.GroupRun_PK, cg2.Group_PK, cg2.Student_PK, count(*) AS Count, Sum(cg2.Rating1) AS RatingSum
			From MainDB.CourseGroup cg2
            Where cg2.GroupRun_PK = 2
            Group By cg2.GroupRun_PK, cg2.Group_PK, cg2.Student_PK
            ) groupSums ON (groupSums.GroupRun_PK = cg.GroupRun_PK AND groupSums.Group_PK = cg.Group_PK AND groupSums.Student_PK = cg.Student_PK)
    
Set cg.RatingGroup = groupSums.RatingSum
Where cg.GroupRun_PK = 2
;

----------------------- 

/*
-- courses that have the highest rating
Select cg.*, cd.*
From MainDB.CourseGroup cg
	Join MainDB.CourseData cd ON (cd.PK_CourseData = cg.CourseData_PK)
Where cg.GroupRun_PK = 2
Order by cg.RatingGroup desc, cg.Group_PK asc;
*/

-- get the top 3 suggested course groupings from the latest run for this student
-- Select cg.*, cd.*
Select cg.GroupRun_PK, cg.Group_PK, cg.Student_PK, cg.CourseData_PK, cg.Rating1, cg.RatingGroup, cd.Semester, cd.Year, cd.Department, cd.CourseNumber, cd.Professor_PK, cd.Frequency, cd.PassRate
From MainDB.CourseGroup cg
	Join MainDB.CourseData cd ON (cd.PK_CourseData = cg.CourseData_PK)
Where cg.Student_PK = 4 AND cg.GroupRun_PK = 2
Order by cg.RatingGroup desc, cg.Group_PK asc
Limit 9
;



-- get the last group run pk for this student pk
Select Max(GroupRun_PK) as MaxGroupRunPK
From MainDB.CourseGroup cg
Where cg.Student_PK = 4
;
