package com.scdeco.miniataweb.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.scdeco.miniataweb.dao.EmployeeDao;
import com.scdeco.miniataweb.model.Employee;
import com.scdeco.miniataweb.service.LoginService;

@Controller
@RequestMapping("/login")
public class LoginController {
	  
	@Autowired
	LoginService loginService;
	
	@Autowired
	EmployeeDao employeeDao;
	 
	private String version="0036";
	
	@RequestMapping( method=RequestMethod.GET)
	public String login(Model model) {
		   model.addAttribute("username", "zhang");
		   model.addAttribute("password", "");
		   model.addAttribute("version",version);
		   return "login/login";
		 
		 }

	@RequestMapping(method=RequestMethod.POST)
	public String login(@RequestParam("username") String username,
						@RequestParam("password") String password,	Model model) {

		model.addAttribute("username", username);
		model.addAttribute("password", "");
		Employee user=loginService.authenticate(username, password); 
		if(user !=null){
			
			List<Employee> list=employeeDao.findList();
			model.addAttribute("users", list);
			model.addAttribute("version",version);
			
			return "login/loginSucceed";

		}
		else{
			model.addAttribute("text","username:"+username+"   password:0-"+password);
			return "login/login";
			
		}
	 
	}
}
