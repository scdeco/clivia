package com.scdeco.miniataweb.controller;

/*have get name and already changed*/

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.DictOrderInsertableItemDao;
import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.dao.OrderDao;
import com.scdeco.miniataweb.model.DictOrderInsertableItem;
import com.scdeco.miniataweb.model.EmployeeInfo;
import com.scdeco.miniataweb.model.OrderClivia;
import com.scdeco.miniataweb.model.OrderInfo;


@Controller
@Scope("session")
@RequestMapping("/om/*")
public class OrderController {
	
	@Autowired
	private OrderDao orderDao;
	
	@Autowired
	private DictOrderInsertableItemDao dictOrderInsertableItemDao;
	
	@Autowired
	private EmployeeInfoDao employeeInfoDao;
	EmployeeInfo employee;

	@RequestMapping(value="/",method=RequestMethod.GET)
	public String order(Model model, HttpServletRequest request){
		
		String loginuser = (String) request.getSession().getAttribute("loginuser");
		System.out.println("-------------------------->>>>OrderController------" + loginuser);
		if(loginuser == null){
			
			model.addAttribute("theme", employeeInfoDao.getTheme(loginuser));
		}else{
			model.addAttribute("theme", employeeInfoDao.getTheme(loginuser));
		}
		
		if (loginuser == null)
			return "login/login";
		
		List<DictOrderInsertableItem> orderInsertableItems=dictOrderInsertableItemDao.findList(); 

		model.addAttribute("orderInsertableItems",orderInsertableItems);
		
		return "om/order";
	}
	
	
	
	@RequestMapping(value="{detail}",method=RequestMethod.GET)
	public String orderMain(@PathVariable String detail) {
		System.out.println("detail:"+detail);
		return "om/"+detail;
	}

	
	
/*	@RequestMapping(value="item/{itemtype}",method=RequestMethod.GET)
	public String orderItem(@PathVariable String itemtype) {
		
		return "order/"+itemtype;
	}*/

	@RequestMapping(value="get-order",method=RequestMethod.GET)
	public @ResponseBody  OrderClivia getOrder(@RequestParam("number") String orderNumber,
											   @RequestParam(value="list",required=false) String[] list)
				throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		System.out.println("Order#:"+orderNumber);
		return orderDao.getByOrderNumber(orderNumber,list);
	}

	@RequestMapping(value="save-order",method=RequestMethod.POST)
	public @ResponseBody  OrderClivia saveOrder(@RequestBody OrderClivia order,HttpServletRequest request) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		String username= (String) request.getSession().getAttribute("loginuser");
		EmployeeInfo employeeInfo=employeeInfoDao.findByUsername(username);
		OrderInfo orderInfo=order.getInfo();
		orderInfo.setCreateBy(employeeInfo.getId());
		
		orderDao.save(order);
		return order;
	}
	
	@RequestMapping(value="delete-order",method=RequestMethod.GET)
	public @ResponseBody String deleteOrder(@RequestParam("id") int id) 
				throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		orderDao.delete(id);
		
		return "";
	}

	@RequestMapping(value="print-order",method=RequestMethod.POST)
	public String printConfirm(@RequestBody Map<String,String> data,Model model,@RequestParam("file") String file){
		
		System.out.println(data);
		model.addAttribute("data",data);
		return "/om/"+file;
	}
	

}
