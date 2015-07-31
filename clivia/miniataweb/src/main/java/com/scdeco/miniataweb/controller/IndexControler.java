package com.scdeco.miniataweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/testtag")
public class IndexControler {
	@RequestMapping(method=RequestMethod.GET)
	public String get(){
		return "testtag";
	}
}
