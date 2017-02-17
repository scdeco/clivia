package com.scdeco.miniataweb.controller;

/*have get name and already changed*/

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

import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.dao.GridDao;
import com.scdeco.miniataweb.model.Grid;

@Controller
@Scope("session")
@RequestMapping("/gd/*")
public class GridController {

	@Autowired
	GridDao gridDao;
	
	@Autowired
	private EmployeeInfoDao employeeInfoDao;
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String list(Model model,HttpServletRequest request){
		
		String loginuser = (String) request.getSession().getAttribute("loginuser");
		System.out.println("-------------------------->>>>GridController------" + loginuser);
		model.addAttribute("theme", employeeInfoDao.getTheme(loginuser));
		if(loginuser == null)
			return "login/login";
		return "gd/gd";
	}
	
	@RequestMapping(value="grid",method=RequestMethod.GET)
	public String grid(){
		return "gd/grid";
	}

	@RequestMapping(value="get-grid",method=RequestMethod.GET)
	public @ResponseBody  Grid getgrid(@RequestParam("gridNo") String gridNo) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		return gridDao.getByGridNo(gridNo);
	}

	@RequestMapping(value="save-grid",method=RequestMethod.POST)
	public @ResponseBody  Grid savegrid(@RequestBody Grid grid)
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		gridDao.save(grid);
		return grid;
	}
	
	@RequestMapping(value="delete-grid",method=RequestMethod.GET)
	public @ResponseBody  String deletegrid(@RequestParam("id") Integer id) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		String result="";
		
		int gridId=id;
		if(gridId>0){
			gridDao.delete(gridId);
		}else{
			result="Can not find grid in system.";
		}
		return result;
	}
	
	
	
	
}

