<!DOCTYPE html>
<html lang="en">

<cfif isDefined("form.lg_username") && len(form.lg_username) gt 0>
	<cfset username = form.lg_username>
	<cfset password = form.lg_password>

	<cfquery datasource="MainDB" name="qLogin">
		Select * 
		From Student
		Where Username = '#username#' AND Password = '#password#'
	</cfquery>

	<cfif qLogin.recordCount gt 0>
		found user
	<cfelse>
		no user
	</cfif>
	<hr/>
	<cfoutput>
		username: #username#
		<br/>
		password: #password#
	</cfoutput>
<cfelse> <!--- form was not submitted redirect to the login page--->
	<cflocation url="login.cfm" />
</cfif>

<head>
<!--- JQuery --->

<!--- Bootstrap --->

<!--- Font Awesome --->

</head>
<body>

</body>
</html>