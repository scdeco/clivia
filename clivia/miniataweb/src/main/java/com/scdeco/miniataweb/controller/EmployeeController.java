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
	public @ResponseBody  Employee getEmployee(@RequestParam("id") Integer id){
		return employeeDao.getEmployeeById(id);
	}

	@RequestMapping(value="save-employee",method=RequestMethod.POST)
	public @ResponseBody  Employee saveEmployee(@RequestBody Employee employee){
		employeeDao.save(employee);
		return employee;
	}
	
	@RequestMapping(value="delete-employee",method=RequestMethod.GET)
	public @ResponseBody  String deleteEmployee(@RequestParam("id") Integer id){
		String result="";
		
		int employeeId=id;
		if(employeeId>0){
			result=employeeDao.delete(employeeId);
		}else{
			result="Not a saved employee.";
		}
		return result;
	}
		
		
}
