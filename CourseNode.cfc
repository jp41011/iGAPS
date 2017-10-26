<!--- CourseNode --->
<cfcomponent>

<cfset NodeID = 01 />
<cfset this.NodeNum = 2 />

<cffunction name="getCourseName" access="public" returntype="any">
	<cfset var returnVar = 11 />
	<cfreturn returnVar />
</cffunction>

<cffunction name="setNodeNum" access="public">
	<cfargument name="newVal" type="numeric" />
	<cfset this.NodeNum = newVal />
	<cfreturn />
</cffunction>

<cffunction name="getNodeID" access="public" returntype="numeric">
	<cfreturn NodeID />
</cffunction>

</cfcomponent>