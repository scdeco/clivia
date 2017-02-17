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

import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.dao.LibEmbDesignDao;
import com.scdeco.miniataweb.model.EmployeeInfo;
import com.scdeco.miniataweb.model.LibEmbDesign;

@Controller
@Scope("session")
@RequestMapping("/lib/emb/*")
public class LibEmbDesignController {
	
	@Autowired
	LibEmbDesignDao libEmbDesignDao;
	
	@Autowired
	private EmployeeInfoDao employeeInfoDao;
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String  dm(Model model,Principal principal,HttpServletRequest request){
		String loginuser = (String) request.getSession().getAttribute("loginuser");
		String username=loginuser;
		EmployeeInfo employeeInfo=employeeInfoDao.findByUsername(username);
		System.out.println("-------------------------->>>>LibEmbController------" + username);
		String theme=employeeInfo!=null?employeeInfo.getTheme():"default";
		model.addAttribute("theme", theme!=null?theme:"default");		
		return "dm/dm";
	}
	
	
	@RequestMapping(value="get-embdesign",method=RequestMethod.GET)
	public @ResponseBody  LibEmbDesign getLibEmbDesign(
											 @RequestParam(value="id",required=false) Integer id,
											 @RequestParam(value="number",required=false) String number,
											 @RequestParam(value="list",required=false) String[] list,
											 @RequestParam(value="needStitches",required=false) boolean needStitches, 
											 @RequestParam(value="needThumbnail",required=false) boolean needThumbnail) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		if(id!=null)
			return libEmbDesignDao.getById(id,list,needThumbnail);
		else
			return libEmbDesignDao.getByNumber(number, list, needThumbnail);
	}	
	
	
	@RequestMapping(value="save-embdesign",method=RequestMethod.POST)
	public @ResponseBody  LibEmbDesign saveLibEmbDesign(@RequestBody LibEmbDesign design)
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		libEmbDesignDao.save(design);
		return design;
	}
	
	@RequestMapping(value="delete-embdesign",method=RequestMethod.GET)
	public @ResponseBody  String deleteLibEmbDesign(@RequestParam("id") Integer id) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		String result="";
		
		int designId=id;
		if(designId>0){
			libEmbDesignDao.delete(designId);
		}else{
			result="Can not find design in system.";
		}
		return result;
	}
	
	
	
	
}
