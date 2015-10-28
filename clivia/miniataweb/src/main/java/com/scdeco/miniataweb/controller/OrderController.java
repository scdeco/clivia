package com.scdeco.miniataweb.controller;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.DictOrderInsertableItemDao;
import com.scdeco.miniataweb.dao.OrderDao;
import com.scdeco.miniataweb.model.DictOrderInsertableItem;
import com.scdeco.miniataweb.model.OrderClivia;


@Controller
@RequestMapping("/order/*")
public class OrderController {
	
	@Autowired
	private OrderDao orderDao;
	
	@Autowired
	private DictOrderInsertableItemDao dictOrderInsertableItemDao;

	@RequestMapping(value="/",method=RequestMethod.GET)
	public String order(Model model) {
		
		List<DictOrderInsertableItem> orderInsertableItems=dictOrderInsertableItemDao.findList(); 
		System.out.println("insertable:"+orderInsertableItems);
		model.addAttribute("orderInsertableItems",orderInsertableItems);
		
		return "order/order";
	}
	
	
	
	@RequestMapping(value="{detail}",method=RequestMethod.GET)
	public String orderMain(@PathVariable String detail) {
		System.out.println("detail:"+detail);
		return "order/"+detail;
	}

	
	
/*	@RequestMapping(value="item/{itemtype}",method=RequestMethod.GET)
	public String orderItem(@PathVariable String itemtype) {
		
		return "order/"+itemtype;
	}*/

	@RequestMapping(value="get-order",method=RequestMethod.GET)
	public @ResponseBody  OrderClivia getOrder(@RequestParam("number") String orderNumber){
		System.out.println("Order#:"+orderNumber);
		return orderDao.getOrderByOrderNumber(orderNumber);
	}

	@RequestMapping(value="save-order",method=RequestMethod.POST)
	public @ResponseBody  OrderClivia saveOrder(@RequestBody OrderClivia order){
		orderDao.save(order);
		return order;
	}
	
	@RequestMapping(value="delete-order",method=RequestMethod.POST)
	public @ResponseBody  OrderClivia deleteOrder(@RequestBody OrderClivia order){
		orderDao.deleteOrder(order);
		return order;
	}
	

}
