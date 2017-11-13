<!doctype html>
<html lang="en">

<cfinclude template="functions.cfm" />
<cfinclude template="CourseForcast.cfm" />

<head>
	<meta charset="utf-8" />
	<link rel="apple-touch-icon" sizes="76x76" href="assets/img/apple-icon.png">
	<link rel="icon" type="image/png" href="assets/img/favicon.png">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />

	<title>View Forcast</title>

	<meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0' name='viewport' />

	<!--     Fonts and icons     -->
	<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
    <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700" />
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css" />

	<!-- CSS Files -->
    <link href="assets/css/bootstrap.min.css" rel="stylesheet" />
    <link href="assets/css/material-kit.css" rel="stylesheet"/>
</head>

<body>

<!-- Navbar will come here -->
<nav class="navbar navbar-default" role="navigation">
	<div class="container-fluid">
    	<div class="navbar-header">
    		<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
    		</button>
    		<a class="navbar-brand" href="#"></a>
    	</div>

    	<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
    		<ul class="nav navbar-nav">
				<li><a href="Home1.cfm">Home</a></li>
				<li><a href="Dashboard.cfm">Dashboard</a></li>
				<li><a href="Progress.cfm">Progress</a></li>
				<li><a href="Plan.cfm">Plan</a></li>
				<li class="active"><a href="viewForcast.cfm">Forcast</a></li>
				<li><a href="logout.cfm"><i class="fa fa-sign-out" aria-hidden="true"></i>Logout</a></li>
			</ul>
    	</div>
	</div>
</nav>
<!-- end navbar -->

<div class="wrapper">
	<!---
	<div class="header">

	</div>
	--->
	<!-- you can use the class main-raised if you want the main area to be as a page with shadows -->
	<div class="main">
		<div class="container">
			<cfoutput>
				<!-- here you can add your content -->
				View Forcast page

				<cfset var t = GenerateCourseForcast(session.studentID) />
				<cfset totalNeeded = getTotalUnitsNeeded(session.studentID) />
				<cfset requiredNeeded = getRequiredUnitsNeeded(session.studentID) />
				<cfset electiveNeeded = getElectiveUnitsNedded(session.studentID) />
				
				<br/>
				Total units needed: #totalNeeded#
				<br/>
				Required units needed: #requiredNeeded#
				<br/>
				Elective units needed: #electiveNeeded#
			</cfoutput>
		</div>
	</div>
</div>


</body>

	<!--   Core JS Files   -->
	<script src="assets/js/jquery.min.js" type="text/javascript"></script>
	<script src="assets/js/bootstrap.min.js" type="text/javascript"></script>
	<script src="assets/js/material.min.js"></script>

	<!--  Plugin for the Sliders, full documentation here: http://refreshless.com/nouislider/ -->
	<script src="assets/js/nouislider.min.js" type="text/javascript"></script>

	<!--  Plugin for the Datepicker, full documentation here: http://www.eyecon.ro/bootstrap-datepicker/ -->
	<script src="assets/js/bootstrap-datepicker.js" type="text/javascript"></script>

	<!-- Control Center for Material Kit: activating the ripples, parallax effects, scripts from the example pages etc -->
	<script src="assets/js/material-kit.js" type="text/javascript"></script>

</html>
