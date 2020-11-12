<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@ include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Member Register</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Member Register</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<form id="operForm" role="form" action="/member/register" method="post">
					<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
					<div class="form-group">
						<label>Userid</label>
						<input class="form-control" type="text" name="userid" required="required">
					</div>
					<div class="form-group">
						<label>Userpw</label>
						<input class="form-control" type="password" name="userpw" required="required">
					</div>
					<div class="form-group">
						<label>Userpw 확인</label>
						<input class="form-control" type="password" name="userpw2" required="required">
					</div>
					<div class="form-group">
						<label>UserName</label>
						<input class="form-control" type="text" name="userName" required="required">
					</div>
					<div class="form-group">
						<label>Auth</label>
                        <SELECT name="auth" class="form-control">
                           	<option value="ROLE_USER">ROLE_USER</option>
                           	<option value="ROLE_MEMBER">ROLE_MEMBER</option>
                           	<option value="ROLE_ADMIN">ROLE_ADMIN</option>
                        </SELECT>
					</div>
					
					<button type="submit" data-oper="register" class="btn btn-default">Submit Button</button>
					<button type="reset" class="btn btn-default">Reset Button</button>
				</form>
			
			</div>
			<!-- end panel-body -->
		</div>
		<!-- end panel -->
	</div>
</div>
<!-- /.row  -->


<script>
	$(document).ready(function () {
		var operForm = $("#operForm");

		$("button[data-oper='register']").on("click", function (e) {
			e.preventDefault();
			
			var userid = $("input[name='userid']").val();
			var userpw = $("input[name='userpw']").val();
			var userpw2 = $("input[name='userpw2']").val();
			var userName = $("input[name='userName']").val();
			
			if(userid.lenght ==0 || userid == ""){	/* 아이디를 입력하지 않았을 경우 */
				alert("Userid를 입력해주세요.");
				$("input[name='userid']").focus();	/* 경고창 확인을 누르면 입력 커서가 userid로 간다 */
				return ;
			}
			
			if(userpw.length < 4){
				alert("비밀번호의 글자수를 4글자 이상 적어주세요.");
				return ;
			}
			
			if(userpw != userpw2){	/* 두 비밀번호가 다르면 경고창 */
				alert("비밀번호가 일치하지 않습니다.");
				return ;
			}

			operForm.submit();
		});
	});
</script>

<%@ include file="../includes/footer.jsp"%>