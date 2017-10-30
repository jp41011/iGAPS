<!--- CourseNode --->
<cfcomponent>

<cfset this.PK_CourseData = 0 />
<cfset this.Semester = '' />
<cfset this.Year = 0 />
<cfset this.Department = '' />
<cfset this.CourseNumber = '' />
<cfset this.Professor_PK = 0 />
<cfset this.Frequency = 0 />
<cfset this.PassRate = 0 />
<cfset this.isRequired = 0 />
<cfset this.isElective = 0 />


<!--- setter functions --->
<cffunction name="setPK_CourseData" access="public">
	<cfargument name="newPK_CourseData" />
	<cfset this.PK_CourseData = newPK_CourseData />
	<cfreturn />
</cffunction>

<cffunction name="setSemester" access="public">
	<cfargument name="newSemester" />
	<cfset this.Semester = newSemester />
	<cfreturn />
</cffunction>

<cffunction name="setYear" access="public">
	<cfargument name="newYear" />
	<cfset this.Year = newYear />
	<cfreturn />
</cffunction>

<cffunction name="setDepartment" access="public">
	<cfargument name="newDepartment" />
	<cfset this.Department = newDepartment />
	<cfreturn />
</cffunction>

<cffunction name="setCourseNumber" access="public">
	<cfargument name="newCourseNumber" />
	<cfset this.CourseNumber = newCourseNumber />
	<cfreturn />
</cffunction>

<cffunction name="setProfessor_PK" access="public">
	<cfargument name="newProfessor_PK" />
	<cfset this.Professor_PK = newProfessor_PK />
	<cfreturn />
</cffunction>

<cffunction name="setFrequency" access="public">
	<cfargument name="newFrequency" />
	<cfset this.Frequency = newFrequency />
	<cfreturn />
</cffunction>

<cffunction name="setPassRate" access="public">
	<cfargument name="newPassRate" />
	<cfset this.PassRate = newPassRate />
	<cfreturn />
</cffunction>

<cffunction name="setisRequired" access="public">
	<cfargument name="newisRequired" />
	<cfset this.isRequired = newisRequired />
	<cfreturn />
</cffunction>

<cffunction name="setisElective" access="public">
	<cfargument name="newisElective" />
	<cfset this.isElective = newisElective />
	<cfreturn />
</cffunction>


<!--- Getter functions --->
<cffunction name="getPK_CourseData" access="public">
	<cfreturn this.PK_CourseData />
</cffunction>

<cffunction name="getSemester" access="public">
	<cfreturn this.Semester />
</cffunction>

<cffunction name="getYear" access="public">
	<cfreturn this.Year />
</cffunction>

<cffunction name="getDepartment" access="public">
	<cfreturn this.Department />
</cffunction>

<cffunction name="getCourseNumber" access="public">
	<cfreturn this.CourseNumber />
</cffunction>

<cffunction name="getProfessor_PK" access="public">
	<cfreturn this.Professor_PK />
</cffunction>

<cffunction name="getFrequency" access="public">
	<cfreturn this.Frequency />
</cffunction>

<cffunction name="getPassRate" access="public">
	<cfreturn this.PassRate />
</cffunction>

<cffunction name="getisRequired" access="public">
	<cfreturn this.isRequired />
</cffunction>

<cffunction name="getisElective" access="public">
	<cfreturn this.isElective />
</cffunction>


</cfcomponent>