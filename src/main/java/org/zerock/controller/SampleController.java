package org.zerock.controller;

import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j;

@Log4j
@RequestMapping("/sample/*")
@Controller
public class SampleController {

	/* 로그인X 사용자도 접근 */
	@GetMapping("/all")
	public void doAll() {
		log.info("do all can access eveybody");
	}
	
	/* 로그인O 사용자 접근 */
	@GetMapping("/member")
	public void doMember() {
		log.info("logined member");
	}
	
	/* 관리자권한 사용자 접근 */
	@GetMapping("/admin")
	public void doAdmin() {
		log.info("admin only");
	}
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@GetMapping("/annoMember")
	public void doMember2() {
		log.info("logined annotation member");
	}
	
	@Secured({"ROLE_ADMIN"})
	@GetMapping("/annoAdmin")
	public void doAdmin2() {
		log.info("admin annotation only");
	}
}
