package com.scdeco.miniataweb.controller;

import java.security.Principal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.model.EmployeeInfo;

@Controller
@RequestMapping("/service/*")
public class ServiceController {
	
	@Autowired
	EmployeeInfoDao employeeInfoDao;
	
	@RequestMapping(value="/get-date",method=RequestMethod.GET)
	public @ResponseBody LocalDate getDate(){
		return LocalDate.now();
	}
	 
	@RequestMapping(value="/save-theme",method=RequestMethod.GET)
	public @ResponseBody Map<String, String>  saveTheme(@RequestParam("theme") String theme,Principal principal){
		Map<String, String> result=new HashMap<>();
		
		String username=principal.getName();
		EmployeeInfo employeeInfo=employeeInfoDao.findByUsername(username);
		if(employeeInfo!=null){
			employeeInfo.setTheme(theme);
			employeeInfoDao.saveOrUpdate(employeeInfo);
			result.put("result", "succeed");
		}else{
			result.put("result", "failed");
		}
		return result;
	}
	

}
