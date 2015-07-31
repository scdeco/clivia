package com.scdeco.miniataweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/garment")
public class GramentController {
	@RequestMapping( method=RequestMethod.GET)
	public String login(Model model) {

		return "/garment/mainpage";
		 
	}
}
