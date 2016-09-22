package com.scdeco.miniataweb.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.scdeco.miniataweb.dao.EmployeeInfoDao;

@Controller
@RequestMapping("/dm/*")
public class DesignController {

	@Autowired
	private EmployeeInfoDao employeeInfoDao;
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String  dm(Model model,Principal principal){
		
		model.addAttribute("theme", employeeInfoDao.getTheme(principal.getName()));

		return "dm/dm";
	}
	
	@RequestMapping(value="{p}",method=RequestMethod.GET)
	public String  dstpaint(@PathVariable String p){
		return "dm/"+p;
	}
}
