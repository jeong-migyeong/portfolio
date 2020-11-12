<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시판</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board List Page
				<button id="regBtn" type="button" class="btn btn-xs pull-right">Register New Board</button>
			</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<table class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<th>#번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>작성일</th>
							<th>수정일</th>
							<th>조회수</th>
						</tr>
					</thead>

					<c:forEach items="${list}" var="board">
						<tr>
							<td><c:out value="${board.bno}" /></td>
							<!--  조회 페이지로 돌아갈때 현재 목록 페이지의 pageNum과 amount를 같이 전달  -->
							<td>
								<a class="move" href='<c:out value="${board.bno}" />'>								
									<c:out value="${board.title}" />
									<b>[<c:out value="${board.replyCnt}" />]</b>
								</a>
							</td>
							<td><c:out value="${board.writer}" /></td>
							<td><fmt:formatDate value="${board.regdate}"
									pattern="yyyy-MM-dd" /></td>
							<td><fmt:formatDate value="${board.updatedate}"
									pattern="yyyy-MM-dd" /></td>
							<td><c:out value="${board.hit}" /></td>
						</tr>
					</c:forEach>
				</table>
				
				<div class="row">
					<div class="col-lg-12">
						<form id="searchForm" action="/board/list" method="get">
							<select name="type">
								<!-- <select>태그의 내부는 삼항 연산자를 이용해서 해당 조건으로 검색되었다면
										'selected'라는 문자열을 출력하게 해서 화면에서 선택된 항목으로 보이도록 함 -->
								<option value="" <c:out value="${pageMaker.cri.type == null ? 'selected' : ' '}" />>--</option>
								<option value="T" <c:out value="${pageMaker.cri.type eq 'T' ? 'selected' : ' '}" />>제목</option>
								<option value="C" <c:out value="${pageMaker.cri.type eq 'C' ? 'selected' : ' '}" />>내용</option>
								<option value="W" <c:out value="${pageMaker.cri.type eq 'W' ? 'selected' : ' '}" />>작성자</option>
								<option value="TC" <c:out value="${pageMaker.cri.type eq 'TC' ? 'selected' : ' '}" />>제목 or 내용</option>
								<option value="TW" <c:out value="${pageMaker.cri.type eq 'TW' ? 'selected' : ' '}" />>제목 or 작성자</option>
								<option value="TWC" <c:out value="${pageMaker.cri.type eq 'TWC' ? 'selected' : ' '}" />>제목 or 내용 or 작성자</option>
							</select>
							<input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword}" />' />
							<input type="hidden" name="pageNum" value='<c:out value="${pageMaker.cri.pageNum}" />' />
							<input type="hidden" name="amount" value='<c:out value="${pageMaker.cri.amount}" />'  />
							<button class="btn btn-default">Search</button>
						</form>
					</div>
				</div>
				
				<!--  페이지 번호 출력  -->
				<div class="pull-right">
					<ul class="pagination">
						<c:if test="${pageMaker.prev }">
							<li class="paginate_button previous">
								<a href="${pageMaker.startPage - 1 }">Previous</a>
							</li>
						</c:if>
						<c:forEach var="num" begin="${pageMaker.startPage }" end="${pageMaker.endPage }">
							<li class="paginate_button ${pageMaker.cri.pageNum == num ? "active" : "" }">
								<a href="${num }">${num }</a>
							</li>
						</c:forEach>
						<c:if test="${pageMaker.next }">
							<li class="paginate_button next">
								<a href="${pageMaker.endPage + 1 }">Next</a>
							</li>
						</c:if>
					</ul>
				</div>
				<!--  end Pagination  -->
				
				<!--  pagination의 <a>태그가 원래의 동작을 못하도록 처리  -->
				<form id="actionForm" action="/board/list" method="get">
					<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
					<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
					<!-- 페이지 번호를 클릭해서 이동할 때에도 검색조건과 키워드는 같이 전달되어야 함 -->
					<input type="hidden" name="type" value='<c:out value="${pageMaker.cri.type}" />'>
					<input type="hidden" name="keyword" value='<c:out value="${pageMaker.cri.keyword}" />'>
				</form>
				
				<!-- Modal 추가 -->
				<div class="modal fade" id="myModal" tabindex="-1" role="dialog" 	aria-labelledby="myModalLabel" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
								<h4 class="modal-title" id="myModalLabel">Modal title</h4>
							</div>
							<div class="modal-body">처리가 완료되었습니다.</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
								<button type="button" class="btn btn-primary">Save changes</button>
							</div>
						</div>
						<!-- /.modal-content -->
					</div>
					<!-- /.modal-dialog -->
				</div>
				<!-- /.modal -->

			</div>
			<!-- end panel-body -->
		</div>
		<!-- end panel -->
	</div>
</div>
<!-- /.row  -->

<!-- jQuery -->
<script type="text/javascript">
	$(document).ready(function() {
		//상황에 따른 메시지를 확인
		var result = '<c:out value="${result}" />';	//result=bno값
		var searchForm = $("#searchForm");
		
		//modal - 알림창
		checkModal(result);
		history.replaceState({}, null, null);
		function checkModal(result) {
			if(result==='' || history.state){
				return;
			}
			if (parseInt(result) > 0) {
				$(".modal-body").html("게시글 " + parseInt(result) + " 번이 등록되었습니다.");
			}
			$("#myModal").modal("show");	//modal창을 보여줌
		}
		
		//게시물등록창(register)로 이동
		$("#regBtn").on("click", function () {
			self.location = "/board/register";
		});
		
		//<form>태그를 이용해서 URL의 이동을 처리하도록 변경
		//<a>태그를 클릭해도 페이지 이동이 없도록 preventDefault()처리
		//<form>태그 내 pageNum값은 href속성값으로 변경
		var actionForm = $("#actionForm");
		$(".paginate_button a").on("click", function(e){
			e.preventDefault();
			console.log('click');
			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
			actionForm.submit();
		});
		
		//실제 클릭은 JavaScript를 통해서 게시물의 제목을 클릭했을 때 이동하도록 이벤트 처리
		//게시물 제목을 클릭하면 <form>태그에 추가로 bno값을 전송하기 위해서 <input>태그를 추가
		//<form>태그의 action은 '/board/get'으로 변경
		$(".move").on("click", function(e){
			e.preventDefault();
			actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
			actionForm.attr("action", "/board/get");
			actionForm.submit();
		});
		
		/* 검색 버튼을 클릭하면 1페이지로 가도록 수정
			화면에 검색 조건과 키워드가 보이게 처리하는 작업을 우선으로 진행*/
		/* 브라우저에서 검색 버튼을 클릭하면 <form>태그의 전송은 막고 , 페이지의 번호는 1이 되도록 처리
			화면에 키워드가 없다면 검색을 하지 않도록 제어*/
		$("#searchForm button").on("click", function(e){
			if(!searchForm.find("option:selected").val()){
				alert("검색 종류를 선택하세요");
				return false;
			}
			if(!searchForm.find("input[name='keyword']").val()){
				alert("키워드를 입력하세요");
				return false;
			}
			searchForm.find("input[name='pageNum']").val("1");
			e.preventDefault();
			searchForm.submit();
		});
	});
</script>

<%@ include file="../includes/footer.jsp"%>