<!doctype html>
<html lang="en">

<cfinclude template="functions.cfm" />

<cfquery datasource="MainDB" name='qReqs'>
	Select RequiredUnits, ElectiveUnits, TotalUnits
	From Requirements
	Where Semester = '#session.FirstSemester#'
		AND Year = #session.FirstYear#
</cfquery>

<cfquery datasource="MainDB" name="qRequiredUnits">
Select Sum(c.Units) AS units
From CourseEnrollment ce
	Left Join Course c ON (c.PK_Course = ce.Course_PK)
    Left Join Catalog cg ON (cg.Department = c.Department AND cg.CourseNumber = c.CourseNumber)
Where ce.Student_PK = #session.studentID# AND cg.Semester = '#session.FirstSemester#' AND cg.Year = #Session.FirstYear# AND cg.isRequired = 1
;
</cfquery>

<cfquery datasource="MainDB" name="qElectiveUnits">
Select Sum(c.Units) AS units
From CourseEnrollment ce
	Left Join Course c ON (c.PK_Course = ce.Course_PK)
    Left Join Catalog cg ON (cg.Department = c.Department AND cg.CourseNumber = c.CourseNumber)
Where ce.Student_PK = #session.studentID# AND cg.Semester = '#session.FirstSemester#' AND cg.Year = #Session.FirstYear# AND cg.isRequired = 0 AND cg.isElective = 1
;
</cfquery>

<cfset qTotalUnits = getUnitsCompleted(session.studentID) />

<head>
	<meta charset="utf-8" />
	<link rel="apple-touch-icon" sizes="76x76" href="assets/img/apple-icon.png">
	<link rel="icon" type="image/png" href="assets/img/favicon.png">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />

	<title>Progress</title>

	<meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0' name='viewport' />

	<!--     Fonts and icons     -->
	<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
		<link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700" />
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css" />

	<!-- CSS Files -->
		<link href="assets/css/bootstrap.min.css" rel="stylesheet" />
		<link href="assets/css/material-kit.css" rel="stylesheet"/>

	<!--Load the AJAX API-->
		<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
		<script type="text/javascript">
			google.charts.load('current', {'packages':['bar']});
			google.charts.setOnLoadCallback(drawChart);


			function drawChart() {
				<!---
				var data = google.visualization.arrayToDataTable([
					['Year', 'Sales', 'Expenses', 'Profit'],
					['2014', 1000, 400, 200],
					['2015', 1170, 460, 250],
					['2016', 660, 1120, 300],
					['2017', 1030, 540, 350]
				]);

				var options = {
					chart: {
						title: 'Company Performance',
						subtitle: 'Sales, Expenses, and Profit: 2014-2017',
					}
				};
				--->
				var data = google.visualization.arrayToDataTable([
						<cfoutput>
							['Category', 'Required', 'Completed']
							,['Required Units', #qReqs.RequiredUnits#, #qRequiredUnits.units#]
							,['Elective Units', #qReqs.ElectiveUnits#, #qElectiveUnits.units#]
							,['Other Units', #qReqs.TotalUnits - qReqs.RequiredUnits - qReqs.ElectiveUnits#, #qTotalUnits - qRequiredUnits.units - qElectiveUnits.units#]
							,['Total Units', #qReqs.TotalUnits#, #qTotalUnits#]
						</cfoutput>
						]);

				

				var options = {
					chart: {
						title: 'Progress Snapshot'
						,subtitle: 'Unit requirements breakdown'
					}
				};

				var chart = new google.charts.Bar(document.getElementById('columnchart_material'));

				chart.draw(data, google.charts.Bar.convertOptions(options));
			}
		</script>

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
				<a class="navbar-brand" href="#">iGAPS Progress</a>
			</div>

			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
				<li><a href="Home1.cfm">Home</a></li>
						<li><a href="Dashboard.cfm">Dashboard</a></li>
						<li class="active"><a href="Progress.cfm">Progress</a></li>
						<li><a href="Plan.cfm">Plan</a></li>
						<li><a href="logout.cfm"><i class="fa fa-sign-out" aria-hidden="true"></i>Logout</a></li>
				</ul>
			</div>
	</div>
</nav>
<!-- end navbar -->

<div class="wrapper">
	<!--- <div class="header">

	</div> --->
	<!-- you can use the class main-raised if you want the main area to be as a page with shadows -->
	<div class="main">
		<div class="container">
			<!-- here you can add your content -->
			<!--- Progress page --->
			<!--Div that will hold the pie chart-->
				 <!--- <div id="columnchart_material" style="width: 800px; height: 500px;"></div> --->

				 <div id="columnchart_material" style="width: 600px; height: 500px;"></div>
				 

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
