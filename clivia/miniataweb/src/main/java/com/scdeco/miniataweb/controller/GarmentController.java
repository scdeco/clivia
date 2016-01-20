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
import com.scdeco.miniataweb.dao.GarmentTransDao;
import com.scdeco.miniataweb.model.Garment;
import com.scdeco.miniataweb.model.GarmentTrans;

@Controller
@RequestMapping("/garment/*")
public class GarmentController {
	
	@Autowired
	GarmentDao garmentDao;
	
	@Autowired
	GarmentTransDao garmentTransDao;
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String main(Model model) {

		return "garment/garment";
	}

	@RequestMapping(value="product",method=RequestMethod.GET)
	public String  edit(){
		return "garment/product";
	}
	
	@RequestMapping(value="inventory",method=RequestMethod.GET)
	public String  inventory(){
		return "garment/inventory";
	}
	
	@RequestMapping(value="transaction",method=RequestMethod.GET)
	public String  transaction(){
		return "garment/transaction";
	}
	
	
	@RequestMapping(value="get-product",method=RequestMethod.GET)
	public @ResponseBody  Garment getGarment(@RequestParam("styleNumber") String styleNumber){
		return garmentDao.findByStyleNumber(styleNumber);
	}

	@RequestMapping(value="save-product",method=RequestMethod.POST)
	public @ResponseBody  Garment saveGarment(@RequestBody Garment garment){
		garmentDao.saveOrUpdate(garment);
		return garment;
	}
	
	@RequestMapping(value="delete-product",method=RequestMethod.POST)
	public @ResponseBody  Garment deleteGarment(@RequestBody Garment garment){
		garmentDao.deleteGarment(garment);
		return garment;
	}

	
	@RequestMapping(value="get-transaction",method=RequestMethod.GET)
	public @ResponseBody  GarmentTrans getGarmentTrans(@RequestParam("number") String transNumber){
		return garmentTransDao.getGarmentTransByTransNumber(transNumber);
	}

	@RequestMapping(value="save-transaction",method=RequestMethod.POST)
	public @ResponseBody  GarmentTrans saveGarmentTrans(@RequestBody GarmentTrans garmentTrans){
		garmentTransDao.save(garmentTrans);
		return garmentTrans;
	}
	
/*	@RequestMapping(value="delete-transaction",method=RequestMethod.POST)
	public @ResponseBody  GarmentTrans deleteGarmentTrans(@RequestBody GarmentTrans garmentTrans){
		garmentTransDao.delete(garmentTrans);
		return garmentTrans;
	}*/
		
}
