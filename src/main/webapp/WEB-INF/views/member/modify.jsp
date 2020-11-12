<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@ include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Member Modify Page</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Member Modify Page</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<form id="operForm" role="form" action="/member/modify" method="post">
					<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
					<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum }" />'>
					<input type="hidden" name="amount" value='<c:out value="${cri.amount }" />'>
					<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}" />'>
					<input type="hidden" name="type" value='<c:out value="${cri.type}" />'>
					
					<div class="form-group">
						<label>Userid</label>
						<input class="form-control" type="text" name="userid" value='<c:out value="${member.userid }"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>UserName</label>
						<input class="form-control" type="text" name="userName" value='<c:out value="${member.userName }"/>' required="required">
					</div>
					<div class="form-group">
						<label>Auth</label>
                        <SELECT name="auth" class="form-control">
                           	<option value="ROLE_USER">ROLE_USER</option>
                           	<option value="ROLE_MEMBER">ROLE_MEMBER</option>
                           	<option value="ROLE_ADMIN">ROLE_ADMIN</option>
                        </SELECT>
					</div>
					<div class="form-group">
						<label>Update Date</label>
						<input class="form-control" name="updateDate" readonly="readonly" value="<fmt:formatDate pattern='yyyy/MM/dd' value='${member.updateDate}' />">
					</div>
					
					<sec:authentication property="principal" var="pinfo" />	
					<sec:authorize access="isAuthenticated()">	<!-- 인증받은 사용자만이 영향을 받기 위해서 지정 -->
						<c:if test="${user }">		<!-- 'username'과 'writer'가 일치하는지 확인 -->
							<button type="submit" data-oper='modify' class="btn btn-default">Modify</button>
							<button type="submit" data-oper='remove' class="btn btn-danger">Remove</button>
						</c:if>
					</sec:authorize>
					<button type="submit" data-oper='list' class="btn btn-info">List</button>
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

		$("button").on("click", function (e) {
			e.preventDefault();
			var oper = $(this).data("oper");
			console.log(oper);
			
			if(oper === 'remove'){
				operForm.attr("action", "/member/remove");
			}else if(oper === 'list'){
				operForm.attr("action", "/member/list").attr("method", "get");
				
				var pageNumTag = $("input[name='pagenum']").clone();
				var amountTag = $("input[name='amount']").clone();
				var keywordTag = $("input[name='keyword']").clone();
				var typeTag = $("input[name='type']").clone();
				
				operForm.empty();
				
				operForm.append(pageNumTag);
				operForm.append(amountTag);
				operForm.append(keywordTag);
				operForm.append(typeTag);
			}
			
			operForm.submit();
		});
	});
</script>

<%@ include file="../includes/footer.jsp"%>