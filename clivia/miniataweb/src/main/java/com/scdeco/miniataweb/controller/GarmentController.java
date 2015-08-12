package com.scdeco.miniataweb.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.GarmentDao;
import com.scdeco.miniataweb.model.Garment;

@Controller
@RequestMapping("/garment/*")
public class GarmentController {
	
	@Autowired
	GarmentDao garmentDao;
	
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String main(Model model) {

		return "garment/main";
		 
	}

	@RequestMapping(value="edit",method=RequestMethod.GET)
	public String  edit(){
		return "garment/edit-product";
	}
	
	@RequestMapping(value="product",method=RequestMethod.GET)
	public @ResponseBody  Garment getGarment(@RequestParam("style") String styleNumber){
		System.out.println("request:"+styleNumber);
			return garmentDao.FindByStyleNumber(styleNumber);
	}

	@RequestMapping(value="save",method=RequestMethod.POST)
	public @ResponseBody  Garment saveGarment(@RequestBody Garment garment){
		System.out.println("request:"+garment);
		garmentDao.saveOrUpdate(garment);
		return garment;
	}
	
	@RequestMapping(value="order",method=RequestMethod.GET)
	public String  order(){
		return "garment/order";
	}

	
}
