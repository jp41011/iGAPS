<!doctype html>
<html lang="en">

<cfset insertFlag = (isDefined("url.gen") ? (url.gen eq 1 ? true : false) : false) />
<!--- <cfset insertFlag = (insertFlag eq 1 ? insertFlag : false) /> --->

<cfdump var = '#insertFlag#' />

<cfinclude template="functions.cfm" />

<!--- get query with all the list of possible coureses for next semster --->
<cfset qCourseOptions = genCourseMap() />
<cfset arrayCourses=ArrayNew(1) /> <!--- array to store course info --->

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

<!--- <cfdump var = "#qCourseOptions#" /> --->
<!--- <cfdump var = "#arrayCourses#" /> --->

<cfset maxCourseCount = 3 />

<cfquery name='qGetGroupRunPK' datasource="MainDB">
	Select Max(GroupRun_PK) AS MaxGroupRunPK From MainDB.CourseGroup;
</cfquery>

<cfquery name='qGetGroupPK' datasource="MainDB">
	Select Max(Group_PK) AS MaxGroupPK From MainDB.CourseGroup;
</cfquery>

<cfset GroupRun_PK = qGetGroupRunPK.MaxGroupRunPK + 1 />
<!--- <cfset Group_PK = qGetGroupPK.MaxGroupPK + 1 /> --->
<cfset Group_PK = 0 />

<!--- <cfdump var = '#Group_PK#' /> --->

<!--- get and set the group PK --->

<!--- testing ---
<cfoutput>
	array[1] = #arrayCourses[1].getCourseNumber()#
	<br/>
	arrayLen = #ArrayLen(arrayCourses)#
	<br/>
</cfoutput>
--->

<cfset groupingCount = 0 />

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
						(#GroupRun_PK#, #Group_PK#, #Session.studentID#, #arrayCourses[firstClass].getPK_CourseData()#)
						,(#GroupRun_PK#, #Group_PK#, #Session.studentID#, #arrayCourses[secondClass].getPK_CourseData()#)
						,(#GroupRun_PK#, #Group_PK#, #Session.studentID#, #arrayCourses[thirdClass].getPK_CourseData()#)
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



<head>
	<meta charset="utf-8" />
	<link rel="apple-touch-icon" sizes="76x76" href="assets/img/apple-icon.png">
	<link rel="icon" type="image/png" href="assets/img/favicon.png">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />

	<title>Plan</title>

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
    		<a class="navbar-brand" href="#">iGAPS Plan</a>
    	</div>

    	<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
    		<ul class="nav navbar-nav">
				<li><a href="Home1.cfm">Home</a></li>
        		<li><a href="Dashboard.cfm">Dashboard</a></li>
        		<li><a href="Progress.cfm">Progress</a></li>
        		<li class="active"><a href="Plan.cfm">Plan</a></li>
        		<li><a href="logout.cfm"><i class="fa fa-sign-out" aria-hidden="true"></i>Logout</a></li>
    		</ul>
    	</div>
	</div>
</nav>
<!-- end navbar -->

<div class="wrapper">
	<!--- <div class="header"> Header </div> --->
	<!-- you can use the class main-raised if you want the main area to be as a page with shadows -->
	<div class="main">
		<div class="container">
			<!-- here you can add your content -->
			Plan Page
			<br/>
			<!---
			<cfobject name="node0" component="CourseNode" />
			<cfdump var = #node0# />
			--->
			<!---
			<cfset node1 = createObject('component', 'CourseNode') />
			<!--- <cfset pVar = node1.NodeID /> --->
			<cfset pVar = node1.getNodeID() />
			<!--- <cfset nVar = node1.setNodeID(969) />
			<cfset nVar = node1.getNodeID() /> --->
			<cfset publicVar = node1.NodeNum />
			<cfset publicVar2 = node1.setNodeNum(123) />
			<cfset publicVar2 = node1.NodeNum />
			<cfset fReturn = node1.getCourseName() />
			<cfoutput>
				pVar: #pVar#
				<br/>
				<!--- nVar: #nVar# --->
				<br/>
				publicVar: #publicVar#
				<br/>
				publicVar2: #publicVar2#
				<br/>
				fReturn: #fReturn#
			</cfoutput>
			<cfdump var=#node1# />
			<br/>123
			--->
			<hr/>

			<!--- <cfset tempVar = genCourseMap() /> --->
			<cfdump var='#tempVar#' />


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
