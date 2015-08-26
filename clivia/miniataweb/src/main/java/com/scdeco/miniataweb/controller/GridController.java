package com.scdeco.miniataweb.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.scdeco.miniataweb.dao.GridColumnDao;
import com.scdeco.miniataweb.dao.GridInfoDao;
import com.scdeco.miniataweb.model.GridColumn;
import com.scdeco.miniataweb.model.GridInfo;

@Controller
@RequestMapping("/cliviagrid/*")
public class GridController {

	@Autowired
	GridInfoDao gridInfoDao;
	
	@Autowired
	GridColumnDao gridColumnDao;
	
	@RequestMapping(value="grid",method=RequestMethod.GET)
	public String get(Model model,
			@RequestParam(value="gridNo",required=true) String gridNo,
			@RequestParam(value="filter",required=false) String filter){

		System.out.println("Grid#:"+gridNo+"   filter:"+filter);
		
		GridInfo gridInfo=gridInfoDao.findByGridNo(gridNo);
		List<GridColumn> gridColumnList=gridColumnDao.findColumnListByGridId(gridInfo.getId()); 
		
		model.addAttribute("cliviaGridInfo",gridInfo);
		model.addAttribute("cliviaGridColumnList",gridColumnList);
		model.addAttribute("dataFilter",filter);
		model.addAttribute("version","10008js");
		
		return 	"cliviagrid/cliviagrid";
	}
	
	
	@RequestMapping(value="define",method=RequestMethod.GET)
	public String get(){
		return "cliviagrid/define";
	}
	
	
	
	
}

