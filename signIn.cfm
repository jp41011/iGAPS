<!DOCTYPE html>
<html lang="en">
test1
<!--- <cfif isDefined("form.lg_username") && len(form.lg_username) gt 0> --->
<cfif isDefined("form.submit")> <!--- check form name --->
	<cfset username = form.username>
	<cfset password = form.password>
	submitted form
	<cfquery datasource="MainDB" name="qLogin">
		Select Username, FirstName, LastName, FirstSemester, FirstYear, Major
		From Student
		Where Username = '#username#' AND Password = '#password#'
	</cfquery>

	<cfif qLogin.recordCount gt 0>
		found user
		<cfset session.isLoggedIn = true>
		<cfset session.Username = qLogin.username>
		<cfset session.FirstName = qLogin.FirstName>
		<cfset session.LastName = qLogin.LastName>
		<cfset session.FullName = session.FirstName & ' ' & session.LastName>
		<cfset session.FirstSemester = qLogin.FirstSemester>
		<cfset session.FirstYear = qLogin.FirstYear>
		<cfset session.Major = qLogin.Major>
		<cflocation url="Home1.cfm" addtoken="false">
	<cfelse>
		no user
		<cfset session.isLoggedIn = false>
		<cfset StructClear(Session)>
		<cflocation url="login.cfm?msg=loginFail" addtoken="false"/>
	</cfif>
	<hr/>
	<cfoutput>
		username: #username#
	</cfoutput>
<cfelse> <!--- form was not submitted redirect to the login page--->
	<cflocation url="login.cfm?msg=loginFail" addtoken="false"/>
</cfif>
form.submit: <cfoutput>#form.submit#</cfoutput>
<head>
<!--- JQuery --->

<!--- Bootstrap --->

<!--- Font Awesome --->

</head>
<body>

</body>
</html>