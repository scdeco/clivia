package com.scdeco.miniataweb.controller;

/*have get name and already changed*/

import java.time.LocalDate;



import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.model.EmployeeInfo;

@Controller
@Scope("session")
@RequestMapping("/service/*")
public class ServiceController {
	
	
	@Autowired
	EmployeeInfoDao employeeInfoDao;
	

	@RequestMapping(value="/get-date",method=RequestMethod.GET)
	public @ResponseBody LocalDate getDate(){
		return LocalDate.now();
	}
	 
	@RequestMapping(value="/save-theme",method=RequestMethod.GET)
	public @ResponseBody String  saveTheme(@RequestParam("theme") String theme, String username, HttpServletRequest request){
		/*Map<String, String> result=new HashMap<>();*/
		
		String loginuser = (String) request.getSession().getAttribute("loginuser");
		System.out.println("Session ServiceController  : " + loginuser);
		
		if(username == null){
			username = loginuser;
		}		
		
		System.out.println("Name ServiceController  : " + loginuser);
		EmployeeInfo employeeInfo=employeeInfoDao.findByUsername(username);
		if(employeeInfo!=null){
			employeeInfo.setTheme(theme);
			employeeInfoDao.saveOrUpdate(employeeInfo);
			//result.put("result", "succeed");
		}/*else{
			result.put("result", "failed");
		}*/
		return username;
	}
	

}
