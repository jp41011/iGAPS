<html>

<head>
<script>
    window.location.replace("./login.cfm");
  </script>
</head>

<cfquery datasource="MainDB" name='qStudent'>
	Select *
	From MainDB.Student
</cfquery>

<body>
<cfoutput>

<cfloop query='qStudent'>
	#Username# - #FirstName#<br/>
</cfloop>

</cfoutput>
</body>

</html>