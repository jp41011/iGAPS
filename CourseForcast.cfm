<!--- 
1. add course history for student from course enrollment to course forcast table
2. generate the best course group for next semester for this student
3. add the best course group for this student to the course forcast
4. repeat until student has fulfill untill has met all of the unit requirements

Should make all of this a function
--->

<cfinclude template="functions.cfm" />

<cffunction name="GenerateCourseForcast" access="public">
	<cfargument name="studentID" type="numeric" required="true" default="" />

	<!--- All the crazy good stuff here --->
	<!--- first clear the table of all the students old data --->
	<cfquery name='qDeleteOld' datasource="MainDB">
		Delete From MainDB.CourseForcast
		Where Student_PK = #arguments.studentID#;
	</cfquery>

	<!--- insert all of the previously taken courses to the forcast table --->
	<cfquery name="qInsertPreviousCourses" datasource="MainDB">
		Insert Into MainDB.CourseForcast (Student_PK, Course_PK, Grade)
		Select ce.Student_PK, ce.Course_PK, ce.Grade
		From MainDB.CourseEnrollment ce
		Where ce.Student_PK = #arguments.studentID#
	</cfquery>

	<!--- check if all unit requirements have been met --->
	<!--- if not all requirements met then call the course grouping generator and add courses to the forcast. Do this until unit requirements have been met --->
	<!--- TODO left off here --->

</cffunction> 

<!--- return the number of total units required for this student --->
<cffunction name="getTotalUnitsNeeded" access="public">
	<cfargument name="studentID" type="numeric" required="true" default="" />

	<!--- units needed based on catalog year of student --->
	<cfquery datasource="MainDB" name='qReqs'>
		Select RequiredUnits, ElectiveUnits, TotalUnits
		From Requirements
		Where Semester = '#session.FirstSemester#'
			AND Year = #session.FirstYear#
	</cfquery>

	<cfset var totalUnitsNeeded = qReqs.TotalUnits />

	<!--- total units the student already has --->
	<cfquery name="qData" datasource="MainDB">
		Select Sum(c.Units) AS totalUnits
		From MainDB.CourseForcast cf
			Join MainDB.Course c ON (c.PK_Course = cf.Course_PK)
		Where cf.Student_PK = #arguments.studentID#
		;
	</cfquery>
	<cfset var totalUnitsTaken = qData.totalUnits />

	<cfset var unitsStillNeeded = totalUnitsNeeded - totalUnitsTaken />

	<cfreturn unitsStillNeeded />
</cffunction>


<!--- return the number of required units needed --->
<cffunction name="getRequiredUnitsNeeded" access="public">
	<cfargument name="studentID" type="numeric" required="true" default="" />

	<!--- units needed based on catalog year of student --->
	<cfquery datasource="MainDB" name='qReqs'>
		Select RequiredUnits, ElectiveUnits, TotalUnits
		From Requirements
		Where Semester = '#session.FirstSemester#'
			AND Year = #session.FirstYear#
	</cfquery>

	<cfset var requiredUnitsNeeded = qReqs.RequiredUnits />

	<!--- required units already taken --->
	<cfquery datasource="MainDB" name="qRequiredUnits">
		Select Sum(c.Units) AS units
		From CourseForcast cf
			Left Join Course c ON (c.PK_Course = cf.Course_PK)
		    Left Join Catalog cg ON (cg.Department = c.Department AND cg.CourseNumber = c.CourseNumber)
		Where cf.Student_PK = #session.studentID# AND cg.Semester = '#session.FirstSemester#' AND cg.Year = #Session.FirstYear# AND cg.isRequired = 1
		;
	</cfquery>

	<cfset var requiredUnitsTaken = qRequiredUnits.units />

	<cfset var requiredUnitsStillNeeded = requiredUnitsNeeded - requiredUnitsTaken />

	<cfreturn requiredUnitsStillNeeded />
</cffunction>


<!--- return the number of elective units needed --->
<cffunction name="getElectiveUnitsNedded" access="public">
	<cfargument name="studentID" type="numeric" required="true" default="" />

	<!--- units needed based on catalog year of student --->
	<cfquery datasource="MainDB" name='qReqs'>
		Select RequiredUnits, ElectiveUnits, TotalUnits
		From Requirements
		Where Semester = '#session.FirstSemester#'
			AND Year = #session.FirstYear#
	</cfquery>

	<cfset var electiveUnitsNeeded = qReqs.ElectiveUnits />

	<!--- elective units already taken --->
	<cfquery datasource="MainDB" name="qElectiveUnits">
		Select Sum(c.Units) AS units
		From CourseForcast cf
			Left Join Course c ON (c.PK_Course = cf.Course_PK)
		    Left Join Catalog cg ON (cg.Department = c.Department AND cg.CourseNumber = c.CourseNumber)
		Where cf.Student_PK = #session.studentID# AND cg.Semester = '#session.FirstSemester#' AND cg.Year = #Session.FirstYear# AND cg.isRequired = 0 AND cg.isElective = 1
		;
	</cfquery>

	<cfset var electiveUnitsTaken = qElectiveUnits.units />

	<cfset var electiveUnitsStillNeeded = electiveUnitsNeeded - electiveUnitsTaken />

	<cfreturn electiveUnitsStillNeeded />
</cffunction>
