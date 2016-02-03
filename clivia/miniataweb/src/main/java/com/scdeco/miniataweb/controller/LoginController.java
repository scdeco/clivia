package com.scdeco.miniataweb.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.model.EmployeeInfo;
import com.scdeco.miniataweb.service.LoginService;
import com.scdeco.miniataweb.util.DataSourceRequest;
import com.scdeco.miniataweb.util.DataSourceResult;

@Controller
@RequestMapping("/login")
public class LoginController {
	  
	@Autowired
	LoginService loginService;
	
	@Autowired
	EmployeeInfoDao employeeDao;
	 
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
		EmployeeInfo user=loginService.authenticate(username, password); 
		if(user !=null){
			
			List<EmployeeInfo> list=employeeDao.findList();
			model.addAttribute("users", list);
			model.addAttribute("version",version);
			
			return "login/loginSucceed";

		}
		else{
			model.addAttribute("text","username:"+username+"   password:0-"+password);
			return "login/login";
			
		}
	 
	}
	
	@RequestMapping(value="/read",method=RequestMethod.POST)
	public @ResponseBody DataSourceResult  read(){
		DataSourceResult result=employeeDao.findListByDataSourceRequest(new DataSourceRequest());
		System.out.println(result);
		return result;
	}

}
