package com.scdeco.miniataweb.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.EmployeeDao;
import com.scdeco.miniataweb.dao.GridColumnDao;
import com.scdeco.miniataweb.dao.GridInfoDao;
import com.scdeco.miniataweb.model.GridColumn;
import com.scdeco.miniataweb.model.GridInfo;

@Controller
@RequestMapping("/cliviagrid")
public class CliviaGridController {

	@Autowired
	GridInfoDao gridInfoDao;
	
	@Autowired
	GridColumnDao gridColumnDao;
	
	@Autowired
	EmployeeDao employeeDao;	
	
	@RequestMapping(method=RequestMethod.GET)
	public String create(@RequestParam("gridNo") String gridNo, Model model){
 

		GridInfo gridInfo=gridInfoDao.findByGridNo(gridNo);
		
		if(gridInfo==null)
			return "login/login";
		
		List<GridColumn> gridColumnList=gridColumnDao.findColumnListByGridId(gridInfo.getId()); 
		
		if(gridColumnList.isEmpty())
			return "login/login";

		List<GridInfo> gridData=gridInfoDao.findList();
		
		model.addAttribute("gridInfo",gridInfo);
		model.addAttribute("gridColumnList",gridColumnList);
		model.addAttribute("gridData",gridData);
		model.addAttribute("version","10004");
		
		return "cliviagrid/cliviagrid";
	}
	
	
    @RequestMapping(value="/read",method = RequestMethod.GET)
    public  @ResponseBody  List<GridInfo> read(){
       return gridInfoDao.findList();
    }
}
