package com.scdeco.miniataweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/dm/*")
public class DesignController {
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String  dm(){
		return "dm/dm";
	}
	
	@RequestMapping(value="{p}",method=RequestMethod.GET)
	public String  dstpaint(@PathVariable String p){
		return "dm/"+p;
	}
}
