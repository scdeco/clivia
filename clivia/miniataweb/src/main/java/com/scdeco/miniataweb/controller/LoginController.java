package com.scdeco.miniataweb.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;


import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.model.EmployeeInfo;
import com.scdeco.miniataweb.service.LoginService;


@Controller
@Scope("session")
@RequestMapping("/login/")
public class LoginController {
	  
	@Autowired
	LoginService loginService;
	
	@Autowired
	public EmployeeInfoDao employeeDao;
	
	 
	@RequestMapping( method=RequestMethod.GET)
	public String login(Model model) {
		/*   model.addAttribute("username", "zhang");
		   model.addAttribute("password", "");*/
		   return "login/login";
		 
		 }
	
	@RequestMapping(method=RequestMethod.POST)
	public String login(@RequestParam("username") String username,
						@RequestParam("password") String password,	Model model,HttpServletRequest request) {

		EmployeeInfo user=loginService.authenticate(username, password); 
		System.out.println("let us see what is: " + user);
		
		if(username !=null && user !=null){
			//employeeDao.setName(username);
			request.getSession().setAttribute("loginuser", username);
		}
		
		if(user !=null){
			
			List<EmployeeInfo> list=employeeDao.findList();
			model.addAttribute("users", list);	
			return "/login/Success";

		}
		else{
			model.addAttribute("text","username:"+username+"   password:0-"+password);
			return "login/login";
			
		}
	 
	}
	
}