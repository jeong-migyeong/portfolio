package org.zerock.controller;

import java.util.Collection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.MemberVO;
import org.zerock.domain.AuthVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.MemberService;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller	//스프링의 빈으로 인식할 수 있게함
@RequestMapping("/member/*")		//현재 클래스의 모든 메서들들의 기본적인 URL경로	//'/member'로 시작하는 모든 처리를 MemberController가 하도록 지정
@AllArgsConstructor	//MemberService에 의존적	//어노테이션을 이용해서 생성자를 만들도 자동으로 주입하도록 함	//생성자를 만들지 않을 경우 @Setter(onMethod_ = @Autowired)를 이용해서 처리
public class MemberController {

	private MemberService service;
	
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list: " + model);
		model.addAttribute("list", service.getList(cri));
		//PageDTO를 사용할 수 있도록 Model에 담아서 화면에 전달
		//'pageMaker'라는 이름으로 PageDTO 클래스에서 객체를 만들어서 Model에 담아줌
		//PageDTO를 구성하기위해서는 전체 데이터 수 가 필요 -> 그 처리가 이루어지지 않았으므로 임의의 값으로 123
		//model.addAttribute("pageMaker", new PageDTO(cri, 123));	
		
		model.addAttribute("cri", cri);
		
		int total = service.getTotalCount(cri);
		model.addAttribute("total", total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	/* 게시물의 등록 작업은 POST방식으로 처리 
	 * 화면에 입력을 받아야 하므로 GET방식*/
	/* @PreAuthorize : 로그인한 사용자에 한해서 게시물이 작성되도록 : 로그인 하지 않은 사용자는 로그인 페이지로 이동
	 * "isAutheticated()" : 어떠한 사용자든 로그인이 성공한 사용자만이 해당 기능을 사용할 수 있도록 처리 */
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/register")
	public void register() {
		
	}
	
	/* POST방식으로 처리되는 register()
	 * 등록 작업이 끝난 후 다시 목록 화면으로 이동하기 위해서 - String을 리턴타입 & RedirectAttributes를 파라미터로 지정
	 * RedirectAttributes를 이용해서 새롭게 등록된 게시물의 번호를 같이 전달  */
	/* @PreAuthorize : 로그인한 사용자에 한해서 게시물이 작성되도록 : 로그인 하지 않은 사용자는 로그인 페이지로 이동 
	 * "isAutheticated()" : 어떠한 사용자든 로그인이 성공한 사용자만이 해당 기능을 사용할 수 있도록 처리 */
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/register")
	public String register(MemberVO member, AuthVO auth, RedirectAttributes rttr) {
				
		log.info("register: " + member);
		log.info("register: " + auth);
		
		member.setUserpw(pwencoder.encode(member.getUserpw()));	//비밀번호 암호화 -> 복호화X
		
		service.register(member, auth);
		//service.registerAuth(auth);
		
		rttr.addFlashAttribute("result", member.getUserid());
		return "redirect:/member/list";		//'redirect:'접두어를 사용 - 스프링MVC 내부적으로 response.sendRedirect()를 처리해줌
	}
	
	/* 등록 처리와 유사 
	 * 특별한 경우가 아니라면 조회는 GET방식으로 처리 - @GetMapping을 이용
	 * @RequestParam("bno") - bno값을 좀 더 명시적으로 처리(생략해도 무방)
	 * Model 파라미터 - 화면 쪽으로 해당 번호의 게시물을 전달해야 하므로 */
	/* 조회페이지에서 목록으로 이동하기 위한 이벤트를 처리
	 * Criteria를 파라미터로 추가해서 받고 전달
	 * @ModelAttribute는 자동으로 Model에 데이터를 지정한 이름으로 담아준다. */
	@GetMapping({"/get","/modify"})
	public void get(@RequestParam("userid") String userid, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("/get or modify");
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication(); 
		//User user = (User) authentication.getPrincipal(); 
		Collection<? extends GrantedAuthority>  authorities = authentication.getAuthorities(); 
		boolean roles = authorities.stream().filter(o -> o.getAuthority().equals("ROLE_ADMIN")).findAny().isPresent();

		model.addAttribute("user", roles);
		model.addAttribute("member", service.get(userid));
	}

	/*등록과 유사
	 * 변경된 내용을 수집해서 MemberVO 파라미터로 처리하고, MemberService를 호출
	 * 수정작업을 시작하는 화면의 경우에는 GET방식으로 접근 하지만, 실제 작업은 POST방식으로 동작 - @PostMapping */
	/* 작성자를 의미하는 writer를 같이 추가해서 @PreAuthorize로 검사 */
	/* @PreAuthorize("principal.username == #member.writer") */
	@PostMapping("/modify")
	@PreAuthorize("isAuthenticated()")
	public String modify(MemberVO member, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify: " + member);
		
		if(service.modify(member)) {			//service.modify()는 수정 여부를 boolean으로 처리
			rttr.addFlashAttribute("result", "success");		//수정이 성공한 경우에만 RedirectAttributes에 추가
		}
		
		return "redirect:/member/list" + cri.getListLink();
	}
	
	/*조회와 유사
	* 삭제는 반드시 POST방식으로만 처리
	* 삭제 후 페이지의 이동이 필요하므로 RedirectAttributes를 파라미터로 사용
	* 'redirect'를 이용해서 삭제 처리후 다시 목록 페이지로 이동*/
	/* 작성자를 의미하는 writer를 같이 추가해서 @PreAuthorize로 검사 */
	/* @PreAuthorize("principal.username == #writer") */
	@PostMapping("/remove")
	@PreAuthorize("isAuthenticated()")
	public String remove(@RequestParam("userid") String userid, @ModelAttribute("cri") Criteria cri,  RedirectAttributes rttr) {
		log.info("remove..." + userid);
		
		if(service.remove(userid)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/member/list" + cri.getListLink();
	}
}
