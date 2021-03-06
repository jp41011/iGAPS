<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<link rel="apple-touch-icon" sizes="76x76" href="assets/img/apple-icon.png">
	<link rel="icon" type="image/png" href="assets/img/favicon.png">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />

	<title>Login Page</title>

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

<!-- end navbar -->

<div class="wrapper">
	<!-- <div class="header">
	</div> -->

	<!-- you can use the class main-raised if you want the main area to be as a page with shadows -->
	<div class="main">
		<div class="container">
			<!-- here you can add your content -->
			<cfform name="loginForm" onsubmit="checkForm()" method="post" action="signIn.cfm">

				<div class="section section-full-screen section-signup" style="background-image: url('assets/img/Fresno-State-Sign.jpg'); background-size: cover; background-position: top center; min-height: 700px;">
					<div class="container">
						<div class="row">
							<div class="col-md-4 col-md-offset-4">
								<div class="card card-signup">
									<form class="form" method="" action="">
										
										<div class="content">

											<!-- <div class="input-group">
												<span class="input-group-addon">
													<i class="material-icons">face</i>
												</span>
												<input type="text" class="form-control" placeholder="First Name...">
											</div> -->

											<div class="input-group">
												<span class="input-group-addon">
													<i class="material-icons">email</i>
												</span>
												<input type="text" name='username' class="form-control" placeholder="Username">
											</div>

											<div class="input-group">
												<span class="input-group-addon">
													<i class="material-icons">lock_outline</i>
												</span>
												<input type="password" name='password' placeholder="Password" class="form-control" />
											</div>

											<!-- If you want to add a checkbox to this form, uncomment this code

											<div class="checkbox">
												<label>
													<input type="checkbox" name="optionsCheckboxes" checked>
													Subscribe to newsletter
												</label>
											</div> -->
										</div>
										<div class="footer text-center">
											<!-- <a href="#pablo" class="btn btn-simple btn-primary btn-lg">Login</a> -->
											<button class="btn btn-primary btn-round" id='submit' name='submit' type='submit'>Login<div class="ripple-container"></div></button>
										</div>
									</form>
								</div>

							</div>
						</div>
					</div>
				</div>
			</cfform>		
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
