package com.scdeco.miniataweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/garment/*")
public class GarmentController {
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String main(Model model) {

		return "garment/mainpage";
		 
	}

	@RequestMapping(value="edit",method=RequestMethod.GET)
	public String  edit(){
		return "garment/edit";
	}

}
