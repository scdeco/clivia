package com.scdeco.miniataweb.controller;

/*have get name and already changed*/

import java.security.Principal;

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
@RequestMapping("/dm/*")
public class DesignController {

	@Autowired
	private EmployeeInfoDao employeeInfoDao;
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String  dm(Model model,Principal principal, HttpServletRequest request){
		String loginuser = (String) request.getSession().getAttribute("loginuser");
		model.addAttribute("theme", employeeInfoDao.getTheme(loginuser));
		if (loginuser == null)
			return "login/login";
		
		return "dm/dm";
	}
	
	
	@RequestMapping(value="{p}",method=RequestMethod.GET)
	public String  dstpaint(@PathVariable String p){
		return "dm/"+p;
	}
}
