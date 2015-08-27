package com.scdeco.miniataweb.controller;

import java.time.LocalDate;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/service/*")
public class ServiceController {
	
	@RequestMapping(value="/get-date",method=RequestMethod.GET)
	public @ResponseBody LocalDate getDate(){
		return LocalDate.now();
	}
	  

}
