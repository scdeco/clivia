package com.scdeco.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/login")
public class LoginController {
	 
	//@Autowired
	//LoginService loginService;
	 
	@RequestMapping(method=RequestMethod.GET)
	public String login(Model model) {
		   model.addAttribute("username", "zhang");
		   model.addAttribute("password", "00");
		   //returns the view name
		   return "login/login";
		 
		 }

	@RequestMapping(method=RequestMethod.POST)
	public String login(@RequestParam("username") String username,
						@RequestParam("password") String password,	Model model) {

		model.addAttribute("username", username);
		model.addAttribute("password", "abcd56");
		model.addAttribute("text","username:"+username+"   password:"+password);
		 
	   //returns the view name
		return "login/login";
	 
	}
}
