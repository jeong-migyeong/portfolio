<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CustomLogin</title>
    <!-- Bootstrap Core CSS -->
    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
</head>
<body>
	
	<div class="container">
		<div class="row">
			<div class="col-md-4 col-md-offset-4">
				<div class="login-panel panel panel-default">
					<div class="panel-heading">
                        <h3 class="panel-title">Please Sign In</h3>
                    </div>
					<form role="form" method="post" action="/login">
						<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
						<fieldset>
							<div class="form-group">
								<input class="form-control" placeholder="userid" type="text" name="username" autofocus="autofocus">
							</div>
							<div class="form-group">
								<input class="form-control" placeholder="password" type="password" name="password" value="">
							</div>
							<div class="checkbox">
								<label><input type="checkbox" name="remember-me"> Remember Me</label>
							</div>
							<!-- Change this to a button or input when using this as a form -->
					        <a href="index.html" class="btn btn-lg btn-success btn-block">Login</a>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>

    <!-- jQuery -->
    <script src="/resources/vendor/jquery/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="/resources/vendor/bootstrap/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="/resources/vendor/metisMenu/metisMenu.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="/resources/dist/js/sb-admin-2.js"></script>

	<script>
		$(".btn-success").on("click", function(e){
			e.preventDefault();
			$("form").submit();
		});
	</script>
	
	<c:if test="${param.logout != null}">
		<script>
			$(document).ready(function(e){
				alert("로그아웃하였습니다.");
			});
		</script>
	</c:if>
	
</body>
</html>