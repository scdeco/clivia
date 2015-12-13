package com.scdeco.miniataweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


@Controller
@RequestMapping("/common/*")
public class CommonController {
	@RequestMapping(value="{detail}",method=RequestMethod.GET)
	public String common(@PathVariable String detail) {
		System.out.println("detail:"+detail);
		return "common/"+detail;
	}
}
