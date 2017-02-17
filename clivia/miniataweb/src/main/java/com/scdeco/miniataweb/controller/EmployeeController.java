package com.scdeco.miniataweb.controller;

/*have get name and already changed*/

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;

import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.EmployeeDao;
import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.model.Employee;
import com.scdeco.miniataweb.service.LoginService;

@Controller
@Scope("session")
@RequestMapping("/hr/*")
public class EmployeeController {


	
	@Autowired 
	EmployeeDao employeeDao;

	@Autowired
	private EmployeeInfoDao employeeInfoDao;
	
	@Autowired
	LoginService loginService;
	
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String hr(@CookieValue(value = "xxx", defaultValue = "00000") String xxx,Model model, HttpServletRequest request){
		String loginuser = (String) request.getSession().getAttribute("loginuser");
		if(loginuser ==null){
			//username = employeeInfoDao.getName();
			return "login/login";
		}
		

		System.out.println("Cookie EmployeeController>>>>>>>>>  : " + xxx);
		System.out.println("What is the username from HR controller: " + loginuser);
		System.out.println("Session EmployeeController  : " + loginuser);
		model.addAttribute("theme", employeeInfoDao.getTheme(loginuser));
		return "hr/hr";
	}
	
	@RequestMapping(value="employee",method=RequestMethod.GET)
	public String employee(){
		return "hr/employee";
	}
	public static String getCookieValue(String cookieName, HttpServletRequest request) {
	    String value = null;
	    Cookie[] cookies = request.getCookies();
	    if (cookies != null) {
	      int i = 0;
	      boolean cookieExists = false;
	      while (!cookieExists && i < cookies.length) {
	    	  System.out.println("cookies[i].getName(): " + cookies[i].getName());
	        if (cookies[i].getName().equals(cookieName)) {
	          cookieExists = true;
	          value = cookies[i].getValue();
	        } else {
	          i++;
	        }
	      }
	    }
	    return value;
	  }
	
	@RequestMapping(value="get-employee",method=RequestMethod.GET)
	public @ResponseBody  Employee getEmployee(@RequestParam("id") Integer id) 
			throws InstantiationException, IllegalAccessException, NoSuchFieldException, SecurityException, IllegalArgumentException{
		
		return employeeDao.getById(id);
	}

	@RequestMapping(value="save-employee",method=RequestMethod.POST)
	public @ResponseBody  Employee saveEmployee(@RequestBody Employee employee) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		employeeDao.save(employee);
		return employee;
	}
	
	@RequestMapping(value="delete-employee",method=RequestMethod.GET)
	public @ResponseBody  String deleteEmployee(@RequestParam("id") Integer id) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		String result="";
		
		int employeeId=id;
		if(employeeId>0){
			employeeDao.delete(employeeId);
		}else{
			result="Can not find the employee.";
		}
		return result;
	}
		
		
}
