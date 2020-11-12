<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="../includes/header.jsp"%>
<link href="/resources/dist/css/upload.css" rel="stylesheet">

<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">Board Read Page</h1>
  </div>
  <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">
      <div class="panel-heading">Board Read Page</div>
      <!-- /.panel-heading -->
      <div class="panel-body">
        <div class="form-group">
          <label>Bno</label>
          <input class="form-control" name="bno" readonly="readonly" value='<c:out value="${board.bno }" />' />
        </div>
        
        <div class="form-group">
          <label>IP</label>
          <input class="form-control" name="ip" readonly="readonly" value='<c:out value="${board.ip }" />' />
        </div>

        <div class="form-group">
          <label>Title</label>
          <input class="form-control" name="title" readonly="readonly" value='<c:out value="${board.title }" />' />
        </div>

        <div class="form-group">
          <label>Text Area</label>
          <textarea class="form-control" name="content" rows="3" readonly="readonly"><c:out value="${board.content }"/></textarea>
        </div>

        <div class="form-group">
          <label>Writer</label>
          <input class="form-control" name="writer" readonly="readonly" value='<c:out value="${board.writer }" />' />
        </div>
		
		<!-- 로그인 관련 정보인 'principal'을 JSP내에서는 'pinfo'라는 이름의 변수로 사용  -->
		<sec:authentication property="principal" var="pinfo" />	
		<sec:authorize access="isAuthenticated()">	<!-- 인증받은 사용자만이 영향을 받기 위해서 지정 -->
			<c:if test="${pinfo.username eq board.writer}">		<!-- 'username'과 'writer'가 일치하는지 확인 -->
        		<button data-oper="modify" class="btn btn-default">Modify</button>
        	</c:if>
        </sec:authorize>
        <button data-oper="list" class="btn btn-info">List</button>
        
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
						<div class="uploadResult">
							<ul>					
							</ul>
						</div>
					</div> <!-- end panel-body -->
				</div>	<!-- end panel -->
			</div>
		</div>	<!-- end row -->

        <!-- Modal 추가 -->
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
          aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                  &times;
                </button>
                <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
              </div>
              <div class="modal-body">
                <div class="form-group">
                  <label>Reply</label>
                  <input class="form-control" name="reply" value="New Reply!!!" />
                </div>
                <div class="form-group">
                  <label>Replyer</label>
                  <input class="form-control" name="replyer" value="replyer" readonly="readonly" />
                </div>
                <div class="form-group">
                  <label>Reply Date</label>
                  <input class="form-control" name="replyDate" value="" />
                </div>
              </div>
              <div class="modal-footer">
                <button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
                <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
                <button id="modalRegisterBtn" type="button" class="btn btn-info">Register</button>
                <button id="modalCloseBtn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              </div>
            </div>
            <!-- /.modal-content -->
          </div>
          <!-- /.modal-dialog -->
        </div>
        <!-- /.modal -->

        <!-- get.jsp는 operForm이라는 id를 가진 이미 이용했기 때문에
				cri라는 이름으로 전달된 Criteria 객체를 이용해서 pageNum과 amount값을 태그로 구성하고,
				버튼을 클릭했을 때 정상적으로 목록 페이지로 이동하게 처리 -->
        <form id="operForm" action="/board/modify" method="get">
          <input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno}"/>' />
          <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}" />' />
          <input type="hidden" name="amount" value='<c:out value="${cri.amount}" />' />
          <input type="hidden" name="keyword" value='<c:out value="${cri.keyword}" />' />
          <input type="hidden" name="type" value='<c:out value="${cri.type}" />' />
        </form>
      </div>
      <!-- end panel-body -->
    </div>
    <!-- end panel -->
  </div>
</div>
<!-- /.row  -->

<div class="row">
  <div class="col-lg-12">
    <!-- /.panel -->
    <div class="panel panel-default">
      <div class="panel-heading">
        <i class="fa fa-comments fa-fw"></i> Reply
        <sec:authorize access="isAuthenticated()">	<!-- 로그인 한 사용자만 댓글을 추가할 수 있도록 처리 -->
        	<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
        </sec:authorize>
      </div>

      <!-- /.panel-heading -->
      <div class="panel-body">
        <ul class="chat">
          <!-- start chat -->
          <li class="left clearfix" data-rno="12">
            <div>
              <!-- <div class="header">
								<strong class="primary-font">user00</strong>
								<small class="pull-right text-muted">2020-09-05 09:19</small>
							</div> -->
            </div>
          </li>
          <!-- end reply -->
        </ul>
        <!--./ end ul -->
      </div>
      <!-- ./end .chat-panel-body -->

      <div class="panel-footer"></div>
    </div>
    <!-- end panel -->
  </div>
</div>
<!-- end row  -->

<script type="text/javascript" src="/resources/js/reply.js"></script>

<script type="text/javascript">
  $(document).ready(function () {
    console.log("=============");
    console.log("JS TEST");

    var bnoValue = '<c:out value="${board.bno}"/>';
    var replyUL = $(".chat");

    showList(1);

    /* 댓글 리스트로 출력함수 */
    function showList(page) {
      console.log("show list " + page);

      //showList()는 페이지 번호를 파라미터로 받도록 설계
      replyService.getList({
          bno: bnoValue,
          page: page || 1,
        },
        function (replyCnt, list) {
          console.log("replyCnt: " + replyCnt);
          console.log("list: " + list);
          console.log(list);

          if (page == -1) {
            /* 마지막으로 보던 페이지를 보여줌 */
            pageNum = Math.ceil(replyCnt / 10.0);
            showList(pageNum);
            return;
          }

          if (list == null || list.length == 0) {
            //파라미터가 없는 경우에는 자동으로 1페이지가 호출되도록 설정
            replyUL.html("등록된 댓글이 없습니다.");
            return;
          }

          var str = "";
          for (var i = 0, len = list.length || 0; i < len; i++) {
            str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
            str +=
              " <div><div class='header'><strong class='primary-font'>" +
              list[i].replyer +
              "</strong>";
            str +=
              "<small class='pull-right text-muted'>" +
              replyService.displayTime(list[i].updateDate) +
              "</small></div>";
            str += "<p>" + list[i].reply + "</p></div></li>";
          }
          replyUL.html(str);

          showReplyPage(replyCnt); /* 페이지 번호 */
        }
      ); /* end function */
    } /* end showList */

    var modal = $(".modal");
    var modalInputReply = modal.find("input[name='reply']");
    var modalInputReplyer = modal.find("input[name='replyer']");
    var modalInputReplyDate = modal.find("input[name='replyDate']");

    var modalModBtn = $("#modalModBtn");
    var modalRemoveBtn = $("#modalRemoveBtn");
    var modalRegisterBtn = $("#modalRegisterBtn");
    
    /* 현재 로그인한 사용자가 댓글 작성자가 됨 */
    var replyer = null;
    <sec:authorize access="isAuthenticated()">
    	replyer = '<sec:authentication property="principal.username" />';		/* 'username'을 'replyer'라는 변수로 처리' */
    </sec:authorize>
    var csrfHeaderName = "${_csrf.headerName }";
    var csrfTokenValue = "${_csrf.token }";

    /* New Reply버튼을 눌렀을때 */
    $("#addReplyBtn").on("click", function (e) {
      modal.find("input").val(""); /* <input>태그를 찾아서 value값을 비워준다 */
      modal.find("input[name='replyer']").val(replyer); 	/* 현재 로그인한 사용자의 이름으로 replyer 항목이 고정되도록 수정 */
      modalInputReplyDate.closest("div").hide(); /* 작성날짜 <div>를 숨긴다 */
      modal.find("button[id != 'modalCloseBtn']").hide(); /* modify, remove, register버튼을 숨긴다 */ /* <button>태그에서 id가 modalCloseBtn이 아닌 것을 숨긴다 */

      /* modalInputReplyer.attr("readonly", false); */ /* Replyer를 작성할 수 있다. */

      modalRegisterBtn.show(); /* modify, remove, register버튼을 숨긴것에서 register버튼을 보여주겠다 */

      $(".modal").modal("show"); /* modal을 보여준다 */
    });

    //Ajax spring security header...
    /* 모든 Ajax 전송시 CSRF 토큰을 같이 전송하도록 세팅 */
    $(document).ajaxSend(function(e, xhr, options){
    	xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
    });
    
    /* 댓글 등록 */
    modalRegisterBtn.on("click", function (e) {
      var reply = {
        /* object(객체) <- 멤버변수 */
        reply: modalInputReply.val(),
        replyer: modalInputReplyer.val(),
        bno: bnoValue,
      };
      replyService.add(reply, function (result) {
        /* 등록 */
        alert(result); /* 등록알림창 */

        modal.find("input").val(""); /* 등록후 입력항목 비우기 */
        modal.modal("hide"); /* 등록후 모달창 숨기기 */

        //showList(1); /* 리스트 갱신 */ /* 추가된 댓글까지 가져오기 위해서 */
        showList(-1); /* 우선 전체 댓글 수 파악 */ /* 마지막으로 보던 페이지로 이동 */
      });
    });

    /* 댓글 조회 클릭 이벤트 처리 */
    $(".chat").on("click", "li", function (e) {
      var rno = $(this).data("rno"); /* 누른 댓글의 rno값을 this(rno)로 받기 */

      replyService.get(rno, function (reply) {
        /* 데이터 입력 받기 */
        modalInputReply.val(reply.reply);
        modalInputReplyer.val(reply.replyer).attr("readonly", "readonly");
        modalInputReplyDate
          .val(replyService.displayTime(reply.replyDate))
          .attr("readonly", "readonly");
        modal.data("rno", reply.rno); /* data-rno */

        modalInputReplyDate.closest("div").show(); /* 작성날짜 <div>를 보이기 */

        modal
          .find("button[id != 'modalCloseBtn']")
          .hide(); /* close버튼 이외에 다 숨기기 */
        modalModBtn.show(); /* modify버튼 보이기 */
        modalRemoveBtn.show(); /* remove버튼 보이기 */

        $(".modal").modal("show"); /* 모달 창 보이기 */
      });
    });

    /* update */
    modalModBtn.on("click", function (e) {
    	var originalReplyer = modalInputReplyer.val();
    	var reply = {  /* object(객체) <- 멤버변수 */
        	rno: modal.data("rno") /* 위의 this(rno) 받기 */ ,
        	reply: modalInputReply.val(),
        	replyer: originalReplyer };
    	
    	if(!replyer){
      	  alert("로그인 후 수정이 가능합니다.");
      	  modal.modal("hide");
      	  return;
        }
    	
    	console.log("Original Replyer: " + originalReplyer);	//댓글의 원래 작성자
        
        if(replyer != originalReplyer){
      	  alert("자신이 작성한 댓글만 수정이 가능합니다.");
      	  modal.modal("hide");
      	  return;
        }
    	
      	replyService.update(reply, function (result) {
	        alert(result); /* 결과창으로 알려주기(success or error) */
	        modal.modal("hide"); /* 모달창 숨기기 */
	        showList(pageNum); /* 현재 댓글이 포함된 페이지로 이동 */
      	});
    });

    /* remove */
    modalRemoveBtn.on("click", function (e) {
      var rno = modal.data("rno"); /* object(객체) <- 멤버변수 */ /* remove는 rno값만 있으면 된다 */
      console.log("RNO: " + rno);
      console.log("REPLYER: " + replyer);
      
      if(!replyer){
    	  alert("로그인 후 삭제가 가능합니다.");
    	  modal.modal("hide");
    	  return;
      }
      
      var originalReplyer = modalInputReplyer.val();
      console.log("Original Replyer: " + originalReplyer);	//댓글의 원래 작성자
      
      if(replyer != originalReplyer){
    	  alert("자신이 작성한 댓글만 삭제가 가능합니다.");
    	  modal.modal("hide");
    	  return;
      }
      
      replyService.remove(rno, originalReplyer, function (result) {
        alert(result); /* 결과창으로 알려주기(success or error) */
        modal.modal("hide"); //모달창 숨기기
        showList(pageNum); /* 현재 댓글이 포함된 페이지로 이동 */
      });
    });

    /* 댓글 페이지 번호 출력 */
    var pageNum = 1;
    var replyPageFooter = $(".panel-footer");

    /* 기존의 Java로 작성되는 PageMaker의 JavaScript에 해당 */
    function showReplyPage(replyCnt) {
      var endNum = Math.ceil(pageNum / 10.0) * 10;
      var startNum = endNum - 9;

      var prev = startNum != 1; /* 1페이지일때 이전페이지는 false이다 */ /* 11페이지일때는 이전페이지는 true이다 */
      var next = false;

      if (endNum * 10 >= replyCnt) {
        /* 댓글 수에 맞춰서 마지막페이지를 지정한다. */
        endNum = Math.ceil(replyCnt / 10.0);
      }

      if (endNum * 10 < replyCnt) {
        /* 만약 10페이지일때 11페이지가 있으면 next버튼이 활성화 된다 */
        next = true;
      }

      var str = "<ul class='pagination pull-right'>"; /* 페이지 버튼 오른쪽으로 */

      if (prev) {
        str += "<li class='page-item'><a class='page-link' href='" + (startNum - 1) + "'>Previous</a></li>";
      }

      for (var i = startNum; i <= endNum; i++) {
        var active = pageNum == i ? "active" : "";

        str += "<li class='page-item " + active + " '><a class='page-link' href='" + i + "'>" + i + "</a></li>";
      }

      if (next) {
        str += "<li class='page-item'><a class='page-link' href='" + (endNum + 1) + "'>Next</a></li>";
      }

      str += "</ul></div>";

      console.log(str);

      replyPageFooter.html(str);
    }

    /* 페이지의 번호를 클릭했을때 새로운 댓글을 가져옴 */
    replyPageFooter.on("click", "li a", function (e) {
      /* 댓글의 페이지 번호는 <a> 태그 내에 존재 */
      e.preventDefault(); /* <a> 태그의 기본 동작을 제한 */
      console.log("page click");

      var targetPageNum = $(this).attr("href"); /* 댓글 페이지 번호를 변경 */

      console.log("targetPageNum: " + targetPageNum);

      pageNum = targetPageNum;

      showList(pageNum); /* 해당 페이지의 댓글을 가져옴 */
    });
  });

  //for replyService add test
  //Ajax호출은 replyService라는 이름의객체에 감춰져 있으므로 필요한 파라미터들만 전달하는 형태로 간결해진다.
  //replyService의 add()에 던져야 하는 파라미터는 JavaScript의 객체 타입으로 만들어서전송해 주고,
  //Ajax전송 결과를 처리하는 함수를 파라미터로 같이 전달
  /* replyService.add(
			{reply : "JS Test", replyer : "tester", bno : bnoValue},
			function(result) {
				alert("RESULT: " + result);
			}
	); */

  /* 해당 게시물의 모든 댓글을 가져오는지 확인 */
  /* replyService.getList({bno:bnoValue, page:1}, function(list){
			for(var i = 0, len = list.length || 0; i < len; i++){
				console.log(list[i]);
			}
	}); */

  /* 4번 댓글 삭제 테스트 */
  /* replyService.remove(4, function(count){
		console.log(count);
		
		if(count === "success"){
			alert("REMOVED");
		}
	}, function(err){
		alert('ERROR...');
	}); */

  /* 5번 댓글 수정 */
  /* replyService.update({
		rno : 5,
		bno : bnoValue,
		reply : "Modified Reply..."
	}, function(result){
		alert("수정 완료...");
	}); */

  /* 10번 댓글 조회 */
  /* replyService.get(10, function(data){
		console.log(data);
	}); */
</script>

<script type="text/javascript">
  $(document).ready(function () {
    var operForm = $("#operForm");

    $("button[data-oper='modify']").on("click", function (e) {
      operForm.attr("action", "/board/modify").submit();
    });

    $("button[data-oper='list']").on("click", function (e) {
      operForm.find("#bno").remove();
      operForm.attr("action", "/board/list");
      operForm.submit();
    });
  });
</script>

<script>
	$(document).ready(function(){
		
		(function(){
			var bno = '<c:out value="${board.bno}" />';
			
			$.getJSON("/board/getAttachList", {bno: bno}, function(arr){
				console.log(arr);
				
				var str = "";
				
				$(arr).each(function(i, attach){
					//image type
					if(attach.fileType){
						var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
						
						str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'><div>";
						str += "<img src='/display?fileName=" + fileCallPath + "'>";
						str += "</div>";
						str += "</li>";
					} else {
						str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'><div>";
						str += "<span>" + attach.fileName + "</span><br/>";
						str += "<img src='/resources/img/attach.png'>";
						str += "</div>";
						str += "</li>";
					}
				});
				$(".uploadResult ul").html(str);
			});	//end getJSON
		})();	//end function
		
		//일반파일 다운로드 처리
		$(".uploadResult").on("click", "li", function(e){
			console.log("view image");
			
			var liObj = $(this);
			
			var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));
			
			if(liObj.data("type")){
				showImage(path.replace(new RegExp(/\\/g), "/"));
			}else{
				//download
				self.location = "/download?fileName="+path
			}
		});
		
		//이미지파일 화면에서 원본 이미지
		function showImage(fileCallPath){
			//alert(fileCallPath);
			
			$(".bigPictureWrapper").css("display", "flex").show();
			
			
			$(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>")
										.animate({width:'100%', height:'100%'}, 1000);
			
			//원본이미지 창 닫기
			$(".bigPictureWrapper").on("click", function(e){
				$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
				setTimeout(function(){
					$('.bigPictureWrapper').hide();
				}, 1000);
			});
		}
	});
</script>

<%@ include file="../includes/footer.jsp"%>