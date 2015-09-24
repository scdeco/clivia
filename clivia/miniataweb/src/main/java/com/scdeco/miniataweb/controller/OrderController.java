package com.scdeco.miniataweb.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.OrderDao;
import com.scdeco.miniataweb.model.OrderClivia;


@Controller
@RequestMapping("/order/*")
public class OrderController {
	
	@Autowired
	OrderDao orderDao;

	@RequestMapping(value="/",method=RequestMethod.GET)
	public String order(Model model) {

		return "order/order";
	}
	
	@RequestMapping(value="ordermain",method=RequestMethod.GET)
	public String orderMain(Model model) {

		return "order/ordermain";
	}
	@RequestMapping(value="orderinfo",method=RequestMethod.GET)
	public String orderHeader(Model model) {

		return "order/orderinfo";
	}
	
	@RequestMapping(value="orderitem",method=RequestMethod.GET)
	public String main(Model model) {

		return "order/orderitem";
	}
	
	@RequestMapping(value="lineitem",method=RequestMethod.GET)
	public String LineItem() {

		return "order/lineitem";
		
	}

	@RequestMapping(value="orderimage",method=RequestMethod.GET)
	public String OrderImage() {

		return "order/orderimage";
		
	}
	
	
	@RequestMapping(value="get-order",method=RequestMethod.GET)
	public @ResponseBody  OrderClivia getOrder(@RequestParam("number") String orderNumber){
		System.out.println("Order#:"+orderNumber);
		return orderDao.getOrderByOrderNumber(orderNumber);
	}

	@RequestMapping(value="save-order",method=RequestMethod.POST)
	public @ResponseBody  OrderClivia saveOrder(@RequestBody OrderClivia order){
		System.out.println("Order:"+order);
		orderDao.save(order);
		System.out.println("Order:"+order);
		return order;
	}
	
	@RequestMapping(value="delete-order",method=RequestMethod.POST)
	public @ResponseBody  OrderClivia deleteOrder(@RequestBody OrderClivia order){
		orderDao.deleteOrder(order);
		return order;
	}
	

}
