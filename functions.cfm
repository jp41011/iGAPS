<!--- helper functions --->

<cffunction name="getFullName" output="false" access="public" returnType="string">
    <cfargument name="firstName" type="string" required="false" default="" />
    <cfargument name="lastName" type="string" required="false" default="" />

    <cfset var fullName = arguments.firstName & " " & arguments.lastname />

    <cfreturn fullName />
</cffunction>



<cffunction name="getUnitsCompleted" output="false" returntype="numeric">
	<cfargument name="studentID" type="numeric" required="true" default="" />
	
	<cfquery name="qData" datasource="MainDB">
	Select count(Units) AS CourseCount, sum(Units) AS TotalUnits
	From CourseEnrollment ce
		Join Course c ON (c.PK_Course = ce.Course_PK)
	Where ce.Grade IS NOT NULL 
		AND Left(ce.Grade, 1) IN ('A', 'B', 'C', 'D') 
		AND ce.Student_PK = #arguments.studentID#
	;
	</cfquery>

	<cfset var units = qData.TotalUnits />

	<cfreturn units />
</cffunction>


<cffunction name="getUnitsNeed" output="false" returntype="numeric">
	<cfargument name="studentID" type="numeric" required="true" default="" />
	<cfset var units = 0 />

	<cfreturn units />
</cffunction>


<cffunction name="getGPA" output="true" returntype="numeric">
	<cfargument name="studentID" type='numeric' required="true" />

	<cfquery name="qData" datasource="MainDB">
	Select ce.Grade
	From CourseEnrollment ce
		Join Course c ON (c.PK_Course = ce.Course_PK)
	Where ce.Grade IS NOT NULL 
		AND ce.Student_PK = #arguments.studentID#
	;
	</cfquery>

	<cfset var curCount = 0 />
	<cfset var curSum = 0 />

	<cfloop query="qData">
		<cfset var curGrade = Left(qData.Grade, 1) />
		<cfset var curSign = Right(qData.Grade, 1) />

		<cfif curGrade eq 'A'>
			<cfset curSum = curSum + 4 />
		<cfelseif curGrade eq 'B'>
			<cfset curSum = curSum + 3 />
		<cfelseif curGrade eq 'C'>
			<cfset curSum = curSum + 2 />
		<cfelseif curGrade eq 'D'>
			<cfset curSum = curSum + 1 />
		<cfelseif curGrade eq 'F'>
			<cfset curSum = curSum + 0 />
		<cfelse>
			<!--- should not get to this case --->
		</cfif>

		<cfif curSign eq '+'>
			<cfset curSum = curSum + 0.3 />
		<cfelseif curSign eq '-'>
			<cfset curSum = curSum - 0.3 />
		</cfif>

		<cfset curCount = curCount + 1 />
	</cfloop>

	<cfset var gpa = Round(curSum / curCount, 2) />
	<cfreturn gpa />
</cffunction>



<!--- Gen Course Map --->

<cffunction name="genCourseMap" output="true" returntype="any">

<cfquery name='qNextSemester' datasource="MainDB">
	Select Semester, Year
	From MainDB.Semester
	Where isNext = 1;
</cfquery>


<cfquery name='qCourseOptions' datasource="MainDB">
<!---
Set @nextSemester = '#qNextSemester.Semester#', @nextYear = #qNextSemester.Year#, @studentID = #Session.studentID#, @firstSemester = '#Session.firstSemester#', @firstYear=#Session.firstYear#;

-- Select cd.*, cg.isRequired, cg.isElective
--->
Select cd.PK_CourseData, cd.Semester, cd.Year, cd.Department, cd.CourseNumber, cd.Professor_PK, cd.Frequency, cd.PassRate, cg.isRequired, cg.isElective
From MainDB.Course c
	Left Join MainDB.CourseData cd ON (cd.Semester = c.Semester AND cd.Year = c.Year AND cd.Department=c.Department AND cd.CourseNumber=c.CourseNumber AND cd.Professor_PK=c.Professor_PK)
	Left Join MainDB.Catalog cg ON (cg.Semester='#Session.firstSemester#' AND cg.Year='#Session.firstYear#' AND cg.Department=c.Department AND cg.CourseNumber=c.CourseNumber)
Where c.Semester = '#qNextSemester.Semester#'
	AND c.Year = '#qNextSemester.Year#' 
    AND (Left(c.CourseNumber, 1) = '2' 
		OR (c.Department = 'CSci' 
			AND c.CourseNumber='174') 
        )
	AND c.Department + '_' + c.CourseNumber NOT IN (Select c2.Department+'_'+c2.CourseNumber
													From MainDB.CourseEnrollment ce
														Join MainDB.Course c2 ON (c2.PK_Course = ce.Course_PK)
													Where ce.Student_PK = #Session.studentID# 
													AND Left(Grade,1) IN ('A', 'B', 'C')
													)
;
</cfquery>


<!--- <cfdump var='#qCourseOptions#' /> --->
<cfreturn qCourseOptions />
</cffunction>

