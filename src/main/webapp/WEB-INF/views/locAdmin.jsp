<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">위치추적</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Location List Page
				<!-- <button id="regBtn" type="button" class="btn btn-xs pull-right">Register New Board</button> -->
			</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<table class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<!-- <th>#번호</th> -->
							<th>위도</th>
							<th>경도</th>
							<th>작성일</th>
							<th>ip주소</th>
							<th>위치보기</th>
						</tr>
					</thead>

					<c:forEach items="${list }" var="locAdmin">
						<tr>
							<td><c:out value="${locAdmin.lat}" /></td>
							<td><c:out value="${locAdmin.lng}" /></td>
							<td><fmt:formatDate value="${locAdmin.inputDate}" pattern="yyyy-MM-dd" /></td>
							<td><c:out value="${locAdmin.ip}" /></td>
							<td><a href="https://www.google.com/maps/place/?q=${locAdmin.lat} ${locAdmin.lng}" target="_blank">map</a></td>
						</tr>
					</c:forEach>
					
					
				</table>
			</div>
			<!-- end panel-body -->
		</div>
		<!-- end panel -->
	</div>
</div>
<!-- /.row  -->

<!-- jQuery -->

<%@ include file="includes/footer.jsp"%>
