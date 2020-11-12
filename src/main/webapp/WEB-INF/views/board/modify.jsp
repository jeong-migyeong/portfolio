<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="../includes/header.jsp"%>
<link href="/resources/dist/css/upload.css" rel="stylesheet">

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Modify Page</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Modify Page</div>
			<!-- /.panel-heading -->
			<div class="panel-body">

				<form role="form" action="/board/modify" method="post">
					<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
					<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum }" />'>
					<input type="hidden" name="amount" value='<c:out value="${cri.amount }" />'>
					<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}" />'>
					<input type="hidden" name="type" value='<c:out value="${cri.type}" />'>

					<div class="form-group">
						<label>Bno</label> <input class="form-control" name="bno"
							readonly="readonly" value='<c:out value="${board.bno }" />'>
					</div>

					<div class="form-group">
						<label>Title</label> <input class="form-control" name="title"
							value='<c:out value="${board.title }" />'>
					</div>

					<div class="form-group">
						<label>Text Area</label>
						<textarea class="form-control" name="content" rows="3"><c:out
								value="${board.content}" /></textarea>
					</div>

					<div class="form-group">
						<label>Writer</label> <input class="form-control" name="writer"
							readonly="readonly" value='<c:out value="${board.writer }" />'>
					</div>

					<div class="form-group">
						<label>RegDate</label> <input class="form-control" name="regDate"
							readonly="readonly"
							value="<fmt:formatDate pattern='yyyy/MM/dd' value='${board.regdate}' />">
					</div>

					<div class="form-group">
						<label>Update Date</label> <input class="form-control"
							name="updatedate" readonly="readonly"
							value="<fmt:formatDate pattern='yyyy/MM/dd' value='${board.updatedate}' />">
					</div>
					
					<!-- 첨부파일 원본 이미지 -->
					<div class="bigPictureWrapper">
						<div class="bigPicture">
						</div>
					</div>	<!-- end bigPictureWrapper -->
					
					<!-- 첨부파일 목록 -->
					<div class="row">
						<div class="col-lg-12">
							<div class="panel panel-default">
								<div class="panel-heading">Files</div>	<!-- end panel-heading -->
								<div class="panel-body">
									<div class="form-group uploadDiv">
										<input type="file" name="uploadFile" multiple="multiple">
									</div>
									<div class="uploadResult">
										<ul>	</ul>
									</div>
								</div> <!-- end panel-body -->
							</div>	<!-- end panel -->
						</div>
					</div>	<!-- end row -->

					<!-- 로그인한 사용자가 게시물의 작성자인 경우에만 수정과 삭제가 가능하도록 제어 -->
					<!-- 로그인 관련 정보인 'principal'을 JSP내에서는 'pinfo'라는 이름의 변수로 사용  -->
					<sec:authentication property="principal" var="pinfo" />	
					<sec:authorize access="isAuthenticated()">	<!-- 인증받은 사용자만이 영향을 받기 위해서 지정 -->
						<c:if test="${pinfo.username eq board.writer}">		<!-- 'username'과 'writer'가 일치하는지 확인 -->
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

<script type="text/javascript">
	$(document).ready(function () {
		
		//버튼에 따라서 다른 동작
		//<button>태그의 'data-oper'속성을 이용해서 원하는 기능을 동작하도록 처리
		var formObj = $("form");
		
		$('button').on("click", function(e) {
			e.preventDefault();	//기능 무효화
			var operation = $(this).data("oper");
			console.log(operation);
			
			if(operation === 'remove'){
				formObj.attr("action", "/board/remove");
			}else if(operation === 'list'){
				//move to list
				//사용자가 'List' 버튼을 클릭하면 <form>태그에서 필요한 부분만 잠시 복사(clone) 해서 보관해 두고,
				//<form> 태그 내의 모든 내용은 지워버립니다(empty)
				//이후에 다시 필요한 태그들만 추가해서 '/board/list'를 호출하는 형태를 이용
				formObj.attr("action", "/board/list").attr("method", "get");
				
				var pageNumTag = $("input[name='pagenum']").clone();
				var amountTag = $("input[name='amount']").clone();
				var keywordTag = $("input[name='keyword']").clone();
				var typeTag = $("input[name='type']").clone();
				
				formObj.empty();
				
				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(keywordTag);
				formObj.append(typeTag);
			}else if(operation === 'modify'){
				console.log("submit clicked");
				
				var str = "";
				
				$(".uploadResult ul li").each(function(i, obj){
					var jobj = $(obj);
					console.log(jobj);
					
					str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
				});
				formObj.append(str);
			}
			formObj.submit();
		});
	});
</script>

<script>
	$(document).ready(function(){
		(function(){
			var bno = '<c:out value="${board.bno}"/>';
			
			$.getJSON("/board/getAttachList", {bno: bno}, function(arr){
				console.log(arr);
				
				var str = "";
				
				$(arr).each(function(i, attach){
					//image type
					if(attach.fileType){
						var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
						
						str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'><div>";
						str += "<span>" + attach.fileName + "</span>";
						str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
						str += "<img src='/display?fileName=" + fileCallPath + "'>";
						str += "</div>";
						str += "</li>";
					} else {
						str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'><div>";
						str += "<span>" + attach.fileName + "</span><br/>";
						str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
						str += "<img src='/resources/img/attach.png'></a>";
						str += "</div>";
						str += "</li>";
					}
				});
				$(".uploadResult ul").html(str);
			});	//end getJSON
		})();	//end function
		
		$(".uploadResult").on("click", "button", function(e){
			console.log("delete file");
			
			if(confirm("Remove this file?")){
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
		});
		
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880;//1024*1024*5		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";

		function checkExtension(fileName, fileSize){	//파일 용량 체크
			if(fileSize >= maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드 할 수 없습니다.");
				return false;
			}
			return true;
		}
		
		$("input[type='file']").change(function(e){		//file 변경
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			
			var files = inputFile[0].files;
			
			console.log(files);
			
			for(var i = 0; i < files.length; i++){
				if(!checkExtension(files[i].name, files[i].size)){
					return false;
				}
				
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url:"/uploadAjaxAction",
				processData:false,
				contentType:false,
				beforeSend: function(xhr){
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				data:formData,
				type:"POST",
				dataType:"json",
				success:function(result){
					console.log(result);					
					showUploadResult(result);		//업로드 결과처리 함수
				}
			});	//$.ajax
		});
		
		/* 업로드된 결과를 화면에 섬네일 등을 만들어서 처리하는 부분 */
		function showUploadResult(uploadResultArr){
			if(!uploadResultArr || uploadResultArr.length==0){
				return;
			}
			
			var uploadUL = $(".uploadResult ul");
			
			var str = "";
			
			$(uploadResultArr).each(function(i, obj){
				//image type
				if(obj.image){
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
					
					//var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
					
					str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'><div>";
					str += "<span>" + obj.fileName + "</span>";
					str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/display?fileName=" + fileCallPath + "'>";
					str += "</div>";
					str += "</li>";
				} else {
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
					
					var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
					
					//var originPath = obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName;
					
					//originPath = originPath.replace(new RegExp(/\\/g), "/");
					
					str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'><div>";
					str += "<span>" + obj.fileName + "</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/resources/img/attach.png'></a>";
					str += "</div>";
					str += "</li>";
				}
			});
			uploadUL.append(str);
		}
	});
</script>

<%@ include file="../includes/footer.jsp"%>