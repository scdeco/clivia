package com.scdeco.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {
	 
	 @RequestMapping("/")
	 public String login(@RequestParam(value="username", required=false, defaultValue="World") String username, Model model) {
	  
	   model.addAttribute("username", username);
	   //returns the view name
	   return "login";
	 
	 }
}
