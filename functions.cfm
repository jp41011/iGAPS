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
