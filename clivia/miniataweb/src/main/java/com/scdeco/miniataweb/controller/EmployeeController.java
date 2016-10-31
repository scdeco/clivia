package com.scdeco.miniataweb.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.EmployeeDao;
import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.model.Employee;

@Controller
@RequestMapping("/hr/*")
public class EmployeeController {

	@Autowired 
	EmployeeDao employeeDao;

	@Autowired
	private EmployeeInfoDao employeeInfoDao;
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String hr(Model model,Principal principal){
		
		model.addAttribute("theme", employeeInfoDao.getTheme(principal.getName()));

		return "hr/hr";
	}
	
	@RequestMapping(value="employee",method=RequestMethod.GET)
	public String employee(){
		return "hr/employee";
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
