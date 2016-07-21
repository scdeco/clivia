package com.scdeco.miniataweb.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.LibEmbDesignDao;
import com.scdeco.miniataweb.model.LibEmbDesign;

@Controller
@RequestMapping("/lib/emb/*")
public class LibEmbDesignController {
	
	@Autowired
	LibEmbDesignDao libEmbDesignDao;
	
	@RequestMapping(value="/",method=RequestMethod.GET)

	public String  dm(){
		return "dm/dm";
	}
	
	
	@RequestMapping(value="get-embdesign",method=RequestMethod.GET)
	public @ResponseBody  LibEmbDesign getLibEmbDesign(@RequestParam("id") Integer id,
											 @RequestParam(value="list",required=false) String[] list,
											 @RequestParam(value="needStitches",required=false) boolean needStitches, 
											 @RequestParam(value="needThumbnail",required=false) boolean needThumbnail) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		return libEmbDesignDao.getById(id,list,needStitches,needThumbnail);
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
