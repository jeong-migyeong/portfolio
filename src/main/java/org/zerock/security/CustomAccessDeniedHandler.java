package org.zerock.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import lombok.extern.log4j.Log4j;

/* CustomAccessDeniedHandler 클래스는 AccessDeniedHandler 인터페이스를 직접 구현 */
@Log4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler {

	/* 접근 제한이 걸리는 경우 리다이렉트 하는 방식으로 동작 */
	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		
		log.error("Access Denied Handler");
		
		log.error("Redirect.....");
		
		response.sendRedirect("/accessError");
		
	}

}
