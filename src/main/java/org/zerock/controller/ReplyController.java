package org.zerock.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/replies")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {

	private ReplyService service;
	
	/* 등록작업 */
	/* create()는 @PostMapping으로 POST방식으로만 동작하도록 설계
	 * consumes와 produces를 이용해서 JSON방식의 데이터만 처리하도록 하고, 문자열을 반환하도록 설계 
	 * create()의 파라미터는 @RequestBody를 적용해서 JSON데이터를 ReplyVO타입으로 변환하도록 지정*/
	/* create()는 내부적으로 ReplyServiceImpl을 호출해서 register()를 호출 */
	/* @PreAuthorize : 로그인한 사용자에 한해서 댓글이 작성되도록 : 로그인 하지 않은 사용자는 로그인 페이지로 이동
	 * "isAutheticated()" : 어떠한 사용자든 로그인이 성공한 사용자만이 해당 기능을 사용할 수 있도록 처리 */
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/new", consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){
		log.info("ReplyVO: " + vo);
		
		int insertCount = service.register(vo);
		
		log.info("Reply INSERT COUNT: " + insertCount);
		
		return insertCount == 1 ?
				new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	/* 특정 게시물의 댓글 목록과 총 댓글 수 확인 */
	@GetMapping(value = "/pages/{bno}/{page}",
			produces = {MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyPageDTO> getList(
			@PathVariable("page") int page,
			@PathVariable("bno") long bno){
		log.info("getlist............");
		
		Criteria cri = new Criteria(page, 10);
		log.info(cri);
		
		return new ResponseEntity<ReplyPageDTO>(service.getListPage(cri, bno), HttpStatus.OK);
	}
	
	/* 댓글 조회 */
	@GetMapping(value = "/{rno}",
			produces = {MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") long rno){
		log.info("get: " + rno);
		return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
	}
	
	/* 댓글 삭제 */
	/* JSON으로 전송되는 데이터를 처리하도록 작성 
	 * @RequestBody가 적용되어 JSON으로 된 데이터를 받도록 */
	@PreAuthorize("principal.username == #vo.replyer")
	@DeleteMapping(value = "/{rno}", produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> remove(@RequestBody ReplyVO vo, @PathVariable("rno") long rno){
		log.info("remove: " + rno);
		log.info("replyer: " + vo.getReplyer());
		return service.remove(rno) == 1 ?
				new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	/* 댓글 수정 */
	@PreAuthorize("principal.username == #vo.replyer")
	@RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH},
			value = "/{rno}",
			consumes = "application/json",
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") long rno){
		/* vo.setRno(rno); */
		log.info("rno: " + rno);
		log.info("modify: " + vo);
		return service.modify(vo) == 1 ?
				new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
