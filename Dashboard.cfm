<!doctype html>
<html lang="en">

<cfinclude template="functions.cfm" />

<cfquery datasource="MainDB" name='qCourse'>
	Select c.Semester, c.Year, c.Department, c.CourseNumber, c.CourseName, ce.Grade, c.Units
	From CourseEnrollment ce
		Join Course c ON (c.PK_Course = ce.Course_PK)
	    Join Semester s ON (s.Semester = c.Semester AND s.Year = c.Year)
	 Where ce.Student_PK = #session.studentID#
	 Order By s.SortOrder
	;
</cfquery>

<head>
	<meta charset="utf-8" />
	<link rel="apple-touch-icon" sizes="76x76" href="assets/img/apple-icon.png">
	<link rel="icon" type="image/png" href="assets/img/favicon.png">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />

	<title>Dashboard</title>

	<meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0' name='viewport' />

	<!--     Fonts and icons     -->
	<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
    <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700" />
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css" />

	<!-- CSS Files -->
    <link href="assets/css/bootstrap.min.css" rel="stylesheet" />
    <link href="assets/css/material-kit.css" rel="stylesheet"/>

    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load('current', {'packages':['table']});
      google.charts.setOnLoadCallback(drawTable);

      function drawTable() {
        var data = new google.visualization.DataTable();
        data.addColumn('number', '' )
        data.addColumn('string', 'Semester');
		data.addColumn('string', 'Year');
		data.addColumn('string', 'Department');
		data.addColumn('string', 'Course Number');
		data.addColumn('string', 'Course Name');
		data.addColumn('string', 'Grade');
		data.addColumn('string', 'Unit(s)');
		data.addRows([
			<cfloop query="qCourse">
			<cfoutput>
				[#currentRow#,
				'#Semester#', 
				'#Year#', 
				'#Department#', 
				'#CourseNumber#', 
				'#CourseName#', 
				'#Grade#', 
				'#Units#' 
				],
			</cfoutput>
			</cfloop>
		])
        <!---
        data.addColumn('string', 'Name');
        data.addColumn('number', 'Salary');
        data.addColumn('boolean', 'Full Time Employee');
        data.addRows([
          ['Mike',  {v: 10000, f: '$10,000'}, true],
          ['Jim',   {v:8000,   f: '$8,000'},  false],
          ['Alice', {v: 12500, f: '$12,500'}, true],
          ['Bob',   {v: 7000,  f: '$7,000'},  true]
        ]);
        --->
        var table = new google.visualization.Table(document.getElementById('table_div'));

        table.draw(data, {showRowNumber: false, width: '100%', height: '100%'});
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
    		<a class="navbar-brand" href="#">iGAPS Dashboard</a>
    	</div>

    	<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
    		<ul class="nav navbar-nav">
				<li><a href="Home1.cfm">Home</a></li>
        		<li class="active"><a href="Dashboard.cfm">Dashboard</a></li>
        		<li><a href="Progress.cfm">Progress</a></li>
        		<li><a href="Plan.cfm">Plan</a></li>
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
			<!-- here you can add your content -->
			<!--- Dashboard page --->
			<br/>

			<div id="table_div"></div>
			
			<div id='divSummary'>
				<!--- 
				<cfset testName = getFullName('oneName', 'twoName') />
				<cfoutput>Name: #testName#</cfoutput>
				 --->
				<!--- calc data points --->
				<cfset totalUnits2 = getUnitsCompleted(session.studentID) />
				<cfset tempGPA = getGPA(session.studentID) />
				<cfoutput>	
					<br/>
					GPA: #tempGPA#
					<br/>
					Total Units: #totalUnits2#
				</cfoutput>
			</div>
			
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
