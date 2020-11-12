package org.zerock.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
public class CommonController {

	/* 간단히 사용자가 알아볼 수 있는 에러 메시지만을 Model에 추가
	 * Authentication 타입의 파라미터를 받도록 설계해서 필요한 경우에 시용자의 정보를 확인할 수 있도록 한다. */
	@GetMapping("/accessError")
	public void accessDenied(Authentication auth, Model model) {
		log.info("access Denied: " + auth);
		model.addAttribute("msg", "Access Denied");
	}
	
	/* 에러 메시지와 로그아웃 메시지를 파라미터로 사용 */
	@GetMapping("/customLogin")
	public void loginInput(String error, String logout, Model model) {
		log.info("error: " + error);
		log.info("logout: " + logout);
		
		if(error != null) {
			model.addAttribute("error", "Login Error Check Your Account");
		}
		
		if(logout != null) {
			model.addAttribute("logout", "Logout!!");
		}
	}
	
	/* 로그아웃 시 세션을 무효화시키는 설정이나 특정한 쿠키를 지우는 작업을 지정 */
	/* 로그아웃을 결정하는 페이지에 대한 메서드 */
	@GetMapping("/customLogout")
	public void logoutGET() {
		log.info("custom logout");
	}
}
