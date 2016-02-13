package com.scdeco.miniataweb.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.CompanyDao;
import com.scdeco.miniataweb.model.Company;

@Controller
@RequestMapping("/crm/*")
public class CompanyController {
	@Autowired 
	CompanyDao companyDao;
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String list(){
		return "crm/crm";
	}
	
	@RequestMapping(value="company",method=RequestMethod.GET)
	public String company(){
		return "crm/company";
	}

	@RequestMapping(value="get-company",method=RequestMethod.GET)
	public @ResponseBody  Company getCompany(@RequestParam("id") Integer id){
		return companyDao.getCompanyById(id);
	}

	@RequestMapping(value="save-company",method=RequestMethod.POST)
	public @ResponseBody  Company saveCompany(@RequestBody Company company){
		companyDao.save(company);
		return company;
	}
	
	@RequestMapping(value="delete-company",method=RequestMethod.GET)
	public @ResponseBody  String deleteCompany(@RequestParam("id") Integer id){
		String result="";
		
		int companyId=id;
		if(companyId>0){
			result=companyDao.delete(companyId);
		}else{
			result="Not a saved company.";
		}
		return result;
	}
	
	
}