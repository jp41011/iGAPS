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

	<!--- get units needed --->
	<cfset var tempTotalUnitsNeeded = getTotalUnitsNeeded(arguments.studentID) />
	<cfset var tempRequiredUnitsNeeded = getRequiredUnitsNeeded(arguments.studentID) />
	<cfset var tempElectiveUnitsNeeded = getElectiveUnitsNedded(arguments.studentID) />

	<!--- no units needed. nothing to do exit --->
	<cfif tempTotalUnitsNeeded lte 0 
		AND tempRequiredUnitsNeeded lte 0
		AND tempElectiveUnitsNeeded lte 0 >

		nothing done
		<cfreturn />
	</cfif>
	something done

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
	<cfset var loopCount = 0 />
	
	<!--- cfloop start --->
	<cfloop condition="1 eq 1">
		Inside the loop: <cfoutput>#loopCount#</cfoutput>
		<!--- get units needed --->
		<cfset var tempTotalUnitsNeeded = getTotalUnitsNeeded(arguments.studentID) />
		<cfset var tempRequiredUnitsNeeded = getRequiredUnitsNeeded(arguments.studentID) />
		<cfset var tempElectiveUnitsNeeded = getElectiveUnitsNedded(arguments.studentID) />
		<cfset var loopCount = loopCount + 1 />
		<!--- no units needed. nothing to do exit --->
		<cfif tempTotalUnitsNeeded lte 0 
			AND tempRequiredUnitsNeeded lte 0
			AND tempElectiveUnitsNeeded lte 0>
			Completed Forcast
			<cfbreak />
		</cfif>

		<cfif loopCount gt 8>
			more than 8 loops
			<cfbreak />
		</cfif>


	<!--- get the latest semester for this student --->
	<cfquery name="qLatestSemester" datasource="MainDB">
		Select Max(s.PK_Semester) AS PK_Semester
		From MainDB.CourseForcast cf
			Join MainDB.Course c ON (c.PK_Course = cf.Course_PK)
		    Join MainDB.Semester s ON (s.Year = c.Year AND s.Semester = c.Semester)
		Where cf.Student_PK = #arguments.studentID#
	</cfquery>

	<!--- get the next semester for this student --->
	<cfquery name="qNextSemester" datasource="MainDB">
		Select s.Semester, s.Year
		From MainDB.Semester s
		Where s.PK_Semester = #qLatestSemester.PK_Semester + 1#
	</cfquery>

	<cfquery name='qCourseOptions' datasource="MainDB">
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
															From MainDB.CourseForcast cf
																Join MainDB.Course c2 ON (c2.PK_Course = cf.Course_PK)
															Where cf.Student_PK = #arguments.studentID# 
															<!--- AND Left(Grade,1) IN ('A', 'B', 'C') --->
															)
		;
	</cfquery>

	<!--- <cfdump var = #qCourseOptions# /> --->

	<cfset arrayCourses=ArrayNew(1) /> <!--- array to store course info --->

	<!--- create node objects for each course and add it to the array --->
	<cfloop query="qCourseOptions">
		<cfset var node = createObject('component', 'CourseNode') />

		<cfset var t = node.setPK_CourseData(#PK_CourseData#) />
		<cfset var t = node.setSemester(#Semester#) />
		<cfset var t = node.setYear(#Year#) />
		<cfset var t = node.setDepartment(#Department#) />
		<cfset var t = node.setCourseNumber(#CourseNumber#) />
		<cfset var t = node.setProfessor_PK(#Professor_PK#) />
		<cfset var t = node.setFrequency(#Frequency#) />
		<cfset var t = node.setPassRate(#PassRate#) />
		<cfset var t = node.setisRequired(#isRequired#) />
		<cfset var t = node.setisElective(#isElective#) />

		<cfset var tt = ArrayAppend(arrayCourses, #node#) />
	</cfloop>

	<!--- <cfdump var=#arrayCourses# /> --->

	<cfset maxCourseCount = 3 />

	<cfquery name='qGetGroupRunPK' datasource="MainDB">
		Select Max(GroupRun_PK) AS MaxGroupRunPK From MainDB.CourseGroup;
	</cfquery>

	<cfset GroupRun_PK = qGetGroupRunPK.MaxGroupRunPK + 1 />
	<cfset Group_PK = 0 />

	<cfset groupingCount = 0 />
	<cfset insertFlag = true />

	<!--- loop through courses and generate all groups of 3 --->
	<cfloop index = "firstClass" from = "1" to = "#ArrayLen(arrayCourses) - maxCourseCount + 1#"> 
		<cfloop index="secondClass" from = "#firstClass+1#" to ="#ArrayLen(arrayCourses) - maxCourseCount + 2#">
			<cfloop index="thirdClass" from = "#secondClass+1#" to ="#ArrayLen(arrayCourses) - maxCourseCount + 3#">
				<cfset groupingCount = groupingCount+1 />
				<cfoutput>
					<!--- Group #groupingCount#: #firstClass#, #secondClass#, #thirdClass# --->
					
					<cfset Group_PK = Group_PK + 1/> <!--- increase group index --->
					<!---
					(#GroupRun_PK#) Group #Group_Pk#: #arrayCourses[firstClass].getPK_CourseData()#, #arrayCourses[secondClass].getPK_CourseData()#, #arrayCourses[thirdClass].getPK_CourseData()#
					<br/>
					--->

					<cfif insertFlag eq true>
						<!--- insert this grouping to the table --->
						<cfquery name="qInsertGrouping" datasource="MainDB">
							Insert Into MainDB.CourseGroup (GroupRun_PK, Group_PK, Student_PK, CourseData_PK)
							Values 
							(#GroupRun_PK#, #Group_PK#, #arguments.studentID#, #arrayCourses[firstClass].getPK_CourseData()#)
							,(#GroupRun_PK#, #Group_PK#, #arguments.studentID#, #arrayCourses[secondClass].getPK_CourseData()#)
							,(#GroupRun_PK#, #Group_PK#, #arguments.studentID#, #arrayCourses[thirdClass].getPK_CourseData()#)
						</cfquery>
						<!--- 
						<br/>
						Added to DB
						 --->
					</cfif>
				</cfoutput>

			</cfloop>
		</cfloop>
	</cfloop>

	<cfif insertFlag eq true>
		<!--- Upate the course rating --->
		<cfquery name='qUpdateRating1' datasource="MainDB">
			-- Rating for each solo course
			Update MainDB.CourseGroup cg
				Join MainDB.CourseData cd ON (cd.PK_CourseData = cg.CourseData_PK)
			    Left Join MainDB.Catalog ct ON (ct.Semester='#Session.FirstSemester#' AND ct.Year=#Session.FirstYear# AND ct.Department=cd.Department AND ct.CourseNumber=cd.CourseNumber)
			Set cg.Rating1 = cd.PassRate + (1 - cd.Frequency) + (0.5 * IF(ct.isRequired IS NULL, 0, 1)) + (0.1 * IF(ct.isElective IS NULL, 0, 1))
			Where cg.GroupRun_PK = #GroupRun_PK#
			;
		</cfquery>

		<!--- update the grouping rating --->
		<cfquery name='qUpdateRatingGroup' datasource="MainDB">
			-- update rating for the grouping
			Update MainDB.CourseGroup cg
				Join (Select cg2.GroupRun_PK, cg2.Group_PK, cg2.Student_PK, count(*) AS Count, Sum(cg2.Rating1) AS RatingSum
						From MainDB.CourseGroup cg2
			            Where cg2.GroupRun_PK = #GroupRun_PK#
			            Group By cg2.GroupRun_PK, cg2.Group_PK, cg2.Student_PK
			            ) groupSums ON (groupSums.GroupRun_PK = cg.GroupRun_PK AND groupSums.Group_PK = cg.Group_PK AND groupSums.Student_PK = cg.Student_PK)
			    
			Set cg.RatingGroup = groupSums.RatingSum
			Where cg.GroupRun_PK = #GroupRun_PK#
			;
		</cfquery>

	</cfif>

	<!--- if did not insert on this page load then query the latest (max) GroupRunPK for this student --->
	<cfif insertFlag eq false> 
		<cfquery name='qLastGroupRun' datasource="MainDB">
			Select Max(GroupRun_PK) as MaxGroupRunPK
			From MainDB.CourseGroup cg
			Where cg.Student_PK = #arguments.studentID#
			;
		</cfquery>

		<cfset GroupRun_PK = qLastGroupRun.MaxGroupRunPK />
	</cfif>

	<!--- select the top grouping to display and insert it into the course Forcast table --->
	<cfquery name='qTopGroup' datasource="MainDB">
		<!--- 
		Select c.PK_Course, cg.GroupRun_PK, cg.Group_PK, cg.Student_PK, cg.CourseData_PK, cg.Rating1, cg.RatingGroup, cd.Semester, cd.Year, cd.Department, cd.CourseNumber, cd.Professor_PK, cd.Frequency, cd.PassRate
		--->
		Insert Into MainDB.CourseForcast (Student_PK, Course_PK)
		Select cg.Student_PK, c.PK_Course
		From MainDB.CourseGroup cg
			Join MainDB.CourseData cd ON (cd.PK_CourseData = cg.CourseData_PK)
			Join MainDB.Course c ON (c.Semester = cd.Semester AND c.Year = cd.Year AND c.Department = cd.Department AND c.CourseNumber = cd.CourseNumber)
		Where cg.Student_PK = #arguments.studentID# AND cg.GroupRun_PK = #GroupRun_PK#
		Order by cg.RatingGroup desc, cg.Group_PK asc
		Limit #maxCourseCount#
		;
	</cfquery>

	<!--- <cfdump var="#qTopGroup#" /> --->

	</cfloop>
	<!--- cfloop end --->


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
