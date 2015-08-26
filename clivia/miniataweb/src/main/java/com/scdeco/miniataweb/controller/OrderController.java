package com.scdeco.miniataweb.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.CliviaOrderDao;
import com.scdeco.miniataweb.model.CliviaOrder;


@Controller
@RequestMapping("/order/*")
public class OrderController {
	
	
	@Autowired
	CliviaOrderDao orderDao;

	@RequestMapping(value="/",method=RequestMethod.GET)
	public String main(Model model) {

		return "order/order";
	}

	@RequestMapping(value="get-order",method=RequestMethod.GET)
	public @ResponseBody  CliviaOrder getOrder(@RequestParam("number") String orderNumber){
		return orderDao.findByOrderNumber(orderNumber);
	}

	@RequestMapping(value="save-order",method=RequestMethod.POST)
	public @ResponseBody  CliviaOrder saveOrder(@RequestBody CliviaOrder cliviaOrder){
		System.out.println("Order:"+cliviaOrder);
		orderDao.saveOrUpdate(cliviaOrder);
		System.out.println("Order:"+cliviaOrder);
		return cliviaOrder;
		
	}
	
	@RequestMapping(value="delete-order",method=RequestMethod.POST)
	public @ResponseBody  CliviaOrder deleteOrder(@RequestBody CliviaOrder cliviaOrder){
		orderDao.deleteOrder(cliviaOrder);
		return cliviaOrder;
	}
	
}
