package com.scdeco.miniataweb.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.DataSourceRequest;
import com.scdeco.miniataweb.dao.DataSourceResult;
import com.scdeco.miniataweb.dao.GenericDao;
import com.scdeco.miniataweb.dao.GridColumnDao;
import com.scdeco.miniataweb.dao.GridInfoDao;
import com.scdeco.miniataweb.model.GridColumn;
import com.scdeco.miniataweb.model.GridInfo;
import com.scdeco.miniataweb.util.CliviaApplicationContext;

@Controller
@RequestMapping("/cliviagrid")
public class CliviaGridController {

	@Autowired
	GridInfoDao gridInfoDao;
	
	@Autowired
	GridColumnDao gridColumnDao;
	
	@Autowired
	CliviaApplicationContext cliviaApplicationContext;
	
	@RequestMapping(method=RequestMethod.GET)
	public String get(@RequestParam("gridNo") String gridNo, Model model){

		GridInfo gridInfo=gridInfoDao.findByGridNo(gridNo);
		List<GridColumn> gridColumnList=gridColumnDao.findColumnListByGridId(gridInfo.getId()); 
		
		model.addAttribute("gridInfo",gridInfo);
		model.addAttribute("gridColumnList",gridColumnList);
		model.addAttribute("version","10006");
		
		return "cliviagrid/cliviagrid";
	}
	
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/read/{daoName}",method = RequestMethod.POST)
    public  @ResponseBody  DataSourceResult  read(@RequestBody DataSourceRequest request,@PathVariable String daoName){
    	System.out.println(request);
    	DataSourceResult result=((GenericDao)cliviaApplicationContext.getBean(daoName)).findListByRequest(request);
    	System.out.println(result);
       return result;
    }
}
