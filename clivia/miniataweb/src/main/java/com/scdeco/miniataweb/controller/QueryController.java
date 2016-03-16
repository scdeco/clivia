package com.scdeco.miniataweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/query/*")
public class QueryController {
	
	@RequestMapping(value="{queryName}",method=RequestMethod.GET)
	public String getQuery(@PathVariable String queryName) {
		
		return "query/"+queryName;
	}
}
