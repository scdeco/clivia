package com.scdeco.miniataweb.controller;

/*have get name and already changed*/

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.scdeco.miniataweb.dao.EmployeeInfoDao;


@Controller
@Scope("session")
@RequestMapping("/query/*")
public class QueryController {
	
	
	@Autowired
	private EmployeeInfoDao employeeInfoDao;	
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String getQueryMain(Model model,HttpServletRequest request){
		String username = (String) request.getSession().getAttribute("loginuser");
		System.out.println("-------------------------->>>>QueryController------" + username);
		model.addAttribute("theme", employeeInfoDao.getTheme(username));
		if(username == null)
			return "login/login";
		return "query/query";
	}
	
	
	@RequestMapping(value="{queryName}",method=RequestMethod.GET)
	public String getQuery(@PathVariable String queryName) {
		
		return "query/"+queryName;
	}
}
