package org.zerock.security;

import org.springframework.security.crypto.password.PasswordEncoder;

import lombok.extern.log4j.Log4j;

/* 직접 암호화가 없는 PasswordEncoder를 구현 */
/* PasswordEncoder 인터페이스에는 encode()와 matches() 메서드가 존재 */
@Log4j
public class CustomNoOpPasswordEncoder implements PasswordEncoder {
	
	@Override
	public String encode(CharSequence rawPassword) {
		log.warn("before encode: " + rawPassword);
		return rawPassword.toString();
	}

	@Override
	public boolean matches(CharSequence rawPassword, String encodedPassword) {
		log.warn("matches: " + rawPassword + " : " + encodedPassword);
		return rawPassword.toString().equals(encodedPassword);
	}
	
}
