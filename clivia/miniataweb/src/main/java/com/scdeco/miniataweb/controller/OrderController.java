package com.scdeco.miniataweb.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.OrderMainDao;
import com.scdeco.miniataweb.model.OrderMain;


@Controller
@RequestMapping("/order/*")
public class OrderController {
	
	
	@Autowired
	OrderMainDao orderDao;

	@RequestMapping(value="/",method=RequestMethod.GET)
	public String main(Model model) {

		return "order/order";
	}

	@RequestMapping(value="get-order",method=RequestMethod.GET)
	public @ResponseBody  OrderMain getOrder(@RequestParam("number") String orderNumber){
		return orderDao.findByOrderNumber(orderNumber);
	}

	@RequestMapping(value="save-order",method=RequestMethod.POST)
	public @ResponseBody  OrderMain saveOrder(@RequestBody OrderMain orderMain){
		System.out.println("Order:"+orderMain);
		orderDao.saveOrUpdate(orderMain);
		System.out.println("Order:"+orderMain);
		return orderMain;
		
	}
	
	@RequestMapping(value="delete-order",method=RequestMethod.POST)
	public @ResponseBody  OrderMain deleteOrder(@RequestBody OrderMain orderMain){
		orderDao.deleteOrder(orderMain);
		return orderMain;
	}
	
}
