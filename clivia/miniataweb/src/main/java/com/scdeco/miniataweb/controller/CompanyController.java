package com.scdeco.miniataweb.controller;

/*have get name and already changed*/

import java.security.Principal;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.CompanyDao;
import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.model.Company;
import com.scdeco.miniataweb.model.EmployeeInfo;

@Controller
@Scope("session")
@RequestMapping("/crm/*")
public class CompanyController {
	@Autowired 
	CompanyDao companyDao;

	@Autowired
	private EmployeeInfoDao employeeInfoDao;
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String crm(Model model,HttpServletRequest request){
		String loginuser = (String) request.getSession().getAttribute("loginuser");
		
		model.addAttribute("theme", employeeInfoDao.getTheme(loginuser));

		return "crm/crm";
	}
	
	@RequestMapping(value="company",method=RequestMethod.GET)
	public String company(Model model,Principal principal,HttpServletRequest request){
		
		String loginuser = (String) request.getSession().getAttribute("loginuser");
		String username=loginuser;
		EmployeeInfo employeeInfo=employeeInfoDao.findByUsername(username);
		String theme=employeeInfo!=null?employeeInfo.getTheme():"default";
		model.addAttribute("theme", theme!=null?theme:"default");		
		return "crm/company";
	}

	@RequestMapping(value="get-company",method=RequestMethod.GET)
	public @ResponseBody  Company getCompany(@RequestParam("id") Integer id,
											 @RequestParam(value="list",required=false) String[] list) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		return companyDao.getById(id,list);
	}

	@RequestMapping(value="save-company",method=RequestMethod.POST)
	public @ResponseBody  Company saveCompany(@RequestBody Company company)
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		companyDao.save(company);
		return company;
	}
	
	@RequestMapping(value="delete-company",method=RequestMethod.GET)
	public @ResponseBody  String deleteCompany(@RequestParam("id") Integer id) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		String result="";
		int companyId=id;
		if(companyId>0){
			companyDao.delete(companyId);
		}else{
			result="Can not find company in system.";
		}
		return result;
	}
	
	
}
