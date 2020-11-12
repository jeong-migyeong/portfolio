package org.zerock.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.NoticeAttachVO;
import org.zerock.domain.NoticeVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.NoticeService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

//10.2 NoticeConrtoller의 작성
@Log4j
@Controller	//스프링의 빈으로 인식할 수 있게함
@RequestMapping("/notice/*")		//현재 클래스의 모든 메서들들의 기본적인 URL경로	//'/board'로 시작하는 모든 처리를 NoticeController가 하도록 지정
@AllArgsConstructor	//NoticeService에 의존적	//어노테이션을 이용해서 생성자를 만들도 자동으로 주입하도록 함	//생성자를 만들지 않을 경우 @Setter(onMethod_ = @Autowired)를 이용해서 처리
public class NoticeController {

	//10.2.1 목록에 대한 처리와 테스트
	private NoticeService service;
	
	//list()는 나중에 게시물의 목록을 전달해야 하므로 Model을 파라미터로 지정
	//getList()에 결과를 담아서 전달(addAttribute)
	/*
	 * @GetMapping("/list") public void list(Model model) { log.info("list");
	 * model.addAttribute("list", service.getList()); }
	 */
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list: " + cri);
		model.addAttribute("list", service.getList(cri));
		//PageDTO를 사용할 수 있도록 Model에 담아서 화면에 전달
		//'pageMaker'라는 이름으로 PageDTO 클래스에서 객체를 만들어서 Model에 담아줌
		//PageDTO를 구성하기위해서는 전체 데이터 수 가 필요 -> 그 처리가 이루어지지 않았으므로 임의의 값으로 123
		//model.addAttribute("pageMaker", new PageDTO(cri, 123));	
		
		int total = service.getTotal(cri);
		log.info("total: " + total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	//11.3 등록 입력 페이지와 등록 처리
	/* 게시물의 등록 작업은 POST방식으로 처리 
	 * 화면에 입력을 받아야 하므로 GET방식*/
	/* @PreAuthorize : 로그인한 사용자에 한해서 게시물이 작성되도록 : 로그인 하지 않은 사용자는 로그인 페이지로 이동
	 * "isAutheticated()" : 어떠한 사용자든 로그인이 성공한 사용자만이 해당 기능을 사용할 수 있도록 처리 */
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/register")
	public void register() {
		
	}
	
	//10.2.2 등록 처리와 테스트
	/* POST방식으로 처리되는 register()
	 * 등록 작업이 끝난 후 다시 목록 화면으로 이동하기 위해서 - String을 리턴타입 & RedirectAttributes를 파라미터로 지정
	 * RedirectAttributes를 이용해서 새롭게 등록된 게시물의 번호를 같이 전달  */
	/* @PreAuthorize : 로그인한 사용자에 한해서 게시물이 작성되도록 : 로그인 하지 않은 사용자는 로그인 페이지로 이동 
	 * "isAutheticated()" : 어떠한 사용자든 로그인이 성공한 사용자만이 해당 기능을 사용할 수 있도록 처리 */
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/register")
	public String register(NoticeVO board, RedirectAttributes rttr) {
		//ip
		HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String ip = req.getHeader("X-FORWARDED-FOR");
		if (ip == null)
			ip = req.getRemoteAddr();
		board.setIp(ip);
		
		log.info("================================");
		log.info("register: " + board);
		
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}
		log.info("================================");
		
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		return "redirect:/board/list";		//'redirect:'접두어를 사용 - 스프링MVC 내부적으로 response.sendRedirect()를 처리해줌
	}
	
	//10.2.3 조회 처리와 테스트
	/* 등록 처리와 유사 
	 * 특별한 경우가 아니라면 조회는 GET방식으로 처리 - @GetMapping을 이용
	 * @RequestParam("bno") - bno값을 좀 더 명시적으로 처리(생략해도 무방)
	 * Model 파라미터 - 화면 쪽으로 해당 번호의 게시물을 전달해야 하므로 */
	/* 조회페이지에서 목록으로 이동하기 위한 이벤트를 처리
	 * Criteria를 파라미터로 추가해서 받고 전달
	 * @ModelAttribute는 자동으로 Model에 데이터를 지정한 이름으로 담아준다. */
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("/get or modify");
		model.addAttribute("board", service.get(bno));
	}
	
	//10.2.4 수정 처리와 테스트
	/*등록과 유사
	 * 변경된 내용을 수집해서 NoticeVO 파라미터로 처리하고, NoticeService를 호출
	 * 수정작업을 시작하는 화면의 경우에는 GET방식으로 접근 하지만, 실제 작업은 POST방식으로 동작 - @PostMapping */
	/* 작성자를 의미하는 writer를 같이 추가해서 @PreAuthorize로 검사 */
	@PreAuthorize("principal.username == #board.writer")
	@PostMapping("/modify")
	public String modify(NoticeVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify: " + board);
		
		if(service.modify(board)) {			//service.modify()는 수정 여부를 boolean으로 처리
			rttr.addFlashAttribute("result", "success");		//수정이 성공한 경우에만 RedirectAttributes에 추가
		}
		
		/*
		 * rttr.addAttribute("pageNum", cri.getPageNum());
		 * rttr.addAttribute("amount", cri.getAmount());
		 * rttr.addAttribute("type", cri.getType());
		 * rttr.addAttribute("keyword", cri.getKeyword());
		 */
		
		return "redirect:/board/list" + cri.getListLink();
	}
	
	//10.2.5 삭제 처리와 테스트
	/*조회와 유사
	* 삭제는 반드시 POST방식으로만 처리
	* 삭제 후 페이지의 이동이 필요하므로 RedirectAttributes를 파라미터로 사용
	* 'redirect'를 이용해서 삭제 처리후 다시 목록 페이지로 이동*/
	/* 작성자를 의미하는 writer를 같이 추가해서 @PreAuthorize로 검사 */
	@PreAuthorize("principal.username == #writer")
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") long bno, @ModelAttribute("cri") Criteria cri,  RedirectAttributes rttr, String writer) {
		List<NoticeAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno)) {
			//delete Attach Files
			deleteFiles(attachList);
			rttr.addFlashAttribute("result", "success");
		}
		
		/*
		 * rttr.addAttribute("pageNum", cri.getPageNum());
		 * rttr.addAttribute("amount",  cri.getAmount());
		 * rttr.addAttribute("type", cri.getType());
		 * rttr.addAttribute("keyword", cri.getKeyword());
		 */
		
		return "redirect:/board/list" + cri.getListLink();
	}
	
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<NoticeAttachVO>> getAttachList(long bno){
		log.info("getAttachList " + bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	private void deleteFiles(List<NoticeAttachVO> attachList) {
		if(attachList==null || attachList.size()==0) {
			return;
		}
		
		log.info("delete attach files----------------------------------");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());
				
				Files.deleteIfExists(file);
				
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
					Files.delete(thumbNail);
				}
			}catch (Exception e) {
				log.error("delete file error " + e.getMessage());
			}	//end catch
		});	//end foreach
	}
}
