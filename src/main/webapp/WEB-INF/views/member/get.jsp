<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@ include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Member Read Page</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Member Read Page</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<form id="operForm" role="form" action="/member/modify" method="get">
					<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
					<div class="form-group">
						<label>Userid</label>
						<input class="form-control" value="${member.userid }" name="userid" readonly="readonly" />
					</div>
					<div class="form-group">
						<label>UserName</label>
						<input class="form-control" value="${member.userName }" name="userName" readonly="readonly" />
					</div>
					<div class="form-group">
						<label>Auth</label>
						<input class="form-control" value="${member.authList[0].auth}" name="auth" readonly="readonly" />
					</div>
					
					<!-- 로그인 관련 정보인 'principal'을 JSP내에서는 'pinfo'라는 이름의 변수로 사용  -->
					<sec:authentication property="principal" var="pinfo" />	
					<sec:authorize access="isAuthenticated()">	<!-- 인증받은 사용자만이 영향을 받기 위해서 지정 -->
						<c:if test="${user}">		<!-- 'username'과 'writer'가 일치하는지 확인 -->
        					<button data-oper="modify" class="btn btn-default">Modify</button>
        				</c:if>
       				 </sec:authorize>
        			<button data-oper="list" class="btn btn-info">List</button>
					
					<!-- <button type="submit" data-oper="register" class="btn btn-default">Modify</button>
					<button type="reset" class="btn btn-info">List</button> -->
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

		$("button[data-oper='modify']").on("click", function (e) {
			operForm.attr("action", "/member/modify").submit();
		});
		
		$("button[data-oper='list']").on("click", function (e) {
		      operForm.find("#userid").remove();
		      operForm.attr("action", "/member/list");
		      operForm.submit();
		});
	});
</script>

<%@ include file="../includes/footer.jsp"%>