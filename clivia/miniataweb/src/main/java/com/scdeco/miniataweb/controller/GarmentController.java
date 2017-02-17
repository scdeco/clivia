package com.scdeco.miniataweb.controller;

/*have get name and already changed*/

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
import com.scdeco.miniataweb.dao.GarmentDao;
import com.scdeco.miniataweb.dao.GarmentTransDao;
import com.scdeco.miniataweb.model.Garment;
import com.scdeco.miniataweb.model.GarmentTrans;

@Controller
@Scope("session")
@RequestMapping("/im/*")
public class GarmentController {
	
	@Autowired
	GarmentDao garmentDao;
	
	@Autowired
	GarmentTransDao garmentTransDao;
	
	
	@Autowired
	private EmployeeInfoDao employeeInfoDao;
	
	@RequestMapping(value="/",method=RequestMethod.GET)
	public String  inventory(Model model, HttpServletRequest request){
		String loginuser = (String) request.getSession().getAttribute("loginuser");
		System.out.println("-------------------------->>>>GarmentController------" + loginuser);
		
		model.addAttribute("theme", employeeInfoDao.getTheme(loginuser));
		//model.addAttribute("theme", "blueopal");

		if(loginuser == null)
			return "login/login";
		
		return "im/im";
	}
	
	@RequestMapping(value="product",method=RequestMethod.GET)
	public String  product(){
		return "im/product";
	}
	
	@RequestMapping(value="transaction",method=RequestMethod.GET)
	public String  transaction(){
		return "im/transaction";
	}
	
	@RequestMapping(value="get-product",method=RequestMethod.GET)
	public @ResponseBody  Garment getGarmentProduct(@RequestParam("seasonId") int seasonId,
													@RequestParam("styleNo") String styleNo) 
					throws InstantiationException, IllegalAccessException, NoSuchFieldException, SecurityException, IllegalArgumentException{
		
		return garmentDao.getByStyleNumber(seasonId,styleNo);
	}

	@RequestMapping(value="save-product",method=RequestMethod.POST)
	public @ResponseBody  Garment saveGarmentProduct(@RequestBody Garment garment) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		garmentDao.save(garment);
		return garment;
	}
	
	@RequestMapping(value="delete-product",method=RequestMethod.GET)
	public @ResponseBody  String deleteGarmentProduct(@RequestParam("id") Integer id) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		String result="";
		
		int garmentId=id;
		if(garmentId>0){
			garmentDao.delete(garmentId);
		}else{
			result="Not a saved garment.";
		}
		return result;
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
	
	@RequestMapping(value="delete-transaction",method=RequestMethod.GET)
	public @ResponseBody String  deleteGarmentTrans(@RequestParam("id") Integer transId){
		garmentTransDao.deleteGarmentTransDetailByTransId( transId);
		return "";
	}
	

		
}
