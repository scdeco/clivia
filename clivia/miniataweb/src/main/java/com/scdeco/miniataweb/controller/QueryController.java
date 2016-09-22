package com.scdeco.miniataweb.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.model.EmployeeInfo;

@Controller
@RequestMapping("/query/*")
public class QueryController {
	
	
	@Autowired
	private EmployeeInfoDao employeeInfoDao;	
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String getQueryMain(Model model,Principal principal){
		
		model.addAttribute("theme", employeeInfoDao.getTheme(principal.getName()));

		
		return "query/query";
	}
	
	
	@RequestMapping(value="{queryName}",method=RequestMethod.GET)
	public String getQuery(@PathVariable String queryName) {
		
		return "query/"+queryName;
	}
}
