package org.zerock.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.authentication.jaas.AuthorityGranter;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import lombok.extern.log4j.Log4j;

/* 로그인 성공 이후에 특정한 동작을 하도록 제어 */
@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler{
	
	/* 로그인 한 사용자에 부여된 권한 Authentication 객체를 이용해서 사용자가 가진 모든 권한을 체크 */
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication auth) throws IOException, ServletException {
		
		log.warn("Login Success");		
		List<String> roleNames = new ArrayList<String>();		
		auth.getAuthorities().forEach(authority -> {
			roleNames.add(authority.getAuthority());
		});
		
		log.warn("ROLE NAMES: " + roleNames);
		
		/* 사용자가 'ROLE_ADMIN' 권한을 가졌다면 로그인 후 '/sample/admin'으로 이동 */
		if(roleNames.contains("ROLE_ADMIN")) {
			response.sendRedirect("/sample/admin");
			return;
		}
		
		/* 사용자가 'ROLE_MANAGER' 권한을 가졌다면 로그인 후 '/sample/member'으로 이동 */
		if(roleNames.contains("ROLE_MANAGER")) {
			response.sendRedirect("/sample/member");
			return;
		}
		
		response.sendRedirect("/");		
	}

}
