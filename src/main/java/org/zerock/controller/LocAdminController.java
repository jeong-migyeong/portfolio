package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.zerock.service.LocAdminService;

import lombok.AllArgsConstructor;

@Controller	//스프링의 빈으로 인식할 수 있게함
@AllArgsConstructor
public class LocAdminController {
	
	private LocAdminService service;
	
	@GetMapping("/locAdmin")
	public String getList(Model model) {

		model.addAttribute("list", service.getList());
	 
		return "locAdmin";
	}
}
