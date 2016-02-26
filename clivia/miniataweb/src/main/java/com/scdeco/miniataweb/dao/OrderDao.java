package com.scdeco.miniataweb.dao;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.model.OrderClivia;
import com.scdeco.miniataweb.model.OrderImage;
import com.scdeco.miniataweb.model.OrderInfo;
import com.scdeco.miniataweb.model.OrderItem;
import com.scdeco.miniataweb.model.OrderLineItem;

@Repository ("orderDao")
public class OrderDao {

	@Autowired
	private OrderInfoDao orderInfoDao;
	
	@Autowired
	private OrderItemDao orderItemDao;
	
	@Autowired
	private OrderLineItemDao orderLineItemDao;

	@Autowired
	private OrderPricingItemDao orderPricingItemDao;
	
	@Autowired
	private OrderImageDao orderImageDao;
	
	@Autowired
	private OrderEmbDesignDao orderEmbDesignDao;
	
	@Autowired
	private CliviaAutoNumberDao cliviaAutoNumberDao;
	
	
	
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void save(OrderClivia order){
		
		OrderInfo orderInfo=order.getInfo();
		
		boolean isNewOrder=orderInfo.getId()<=0;
		
		if(isNewOrder){
			Integer orderNumber=cliviaAutoNumberDao.getNextNumber("OrderNumber");
			orderInfo.setOrderNumber('S'+orderNumber.toString());
			orderInfo.setOrderDate(LocalDate.now());
			orderInfo.setOrderTime(LocalTime.now());
		}

		orderInfoDao.saveOrUpdate(orderInfo);
		
		int orderId= orderInfo.getId();

		if(order.getItems()!=null){
			for(OrderItem orderItem:order.getItems()){
				orderItem.setOrderId(orderId);
			}
		}
			
		if(order.getLineItems()!=null){
			for(OrderLineItem lineItem:order.getLineItems()){
				lineItem.setOrderId(orderId);
			}
		}
			
		if(order.getImageItems()!=null){
			for(OrderImage imageItem:order.getImageItems()){
				imageItem.setOrderId(orderId);
			}
		}

		List<Map<String,String>> deletedItems=order.getDeleteds();
		System.out.println("deleted:"+deletedItems);
		for(Map<String,String> item:deletedItems){
				String daoName=item.get("entity");
	        	int id=Integer.parseInt(item.get("id"));
	        	switch (daoName){
	        	case "lineItem":
	        		orderLineItemDao.deleteById(id);
	        		break;
	        	case "imageItem":
	        		orderImageDao.deleteById(id);
	        		break;
	        	}
	        	
	     }				
		
		if(order.getItems()!=null){
			for(OrderItem orderItem:order.getItems()){
				orderItemDao.saveOrUpdate(orderItem);
			}
		}
		
		if(order.getLineItems()!=null){
			for(OrderLineItem lineItem:order.getLineItems()){
				orderLineItemDao.saveOrUpdate(lineItem);
			}
		}
		
		if(order.getImageItems()!=null){
			for(OrderImage imageItem:order.getImageItems()){
				orderImageDao.saveOrUpdate(imageItem);
			}
		}
	}
	
	
	

	public OrderClivia getOrderById(int orderId){
		OrderClivia order=null;
		OrderInfo orderInfo=orderInfoDao.findById(orderId);
		if(orderInfo!=null){
			order=new OrderClivia();
			order.setInfo(orderInfo);
			List<OrderItem> orderItems=orderItemDao.FindListByOrderId(orderId);
			order.setItems(orderItems);
			List<OrderLineItem> lineItems=orderLineItemDao.FindListByOrderId(orderId);
			order.setLineItems(lineItems);
			List<OrderImage> imageItems=orderImageDao.FindListByOrderId(orderId);
			order.setImageItems(imageItems);
		}
			
		return order;
		
	}
	
	public OrderClivia getOrderByOrderNumber(String orderNumber){
		OrderClivia order=null;
		OrderInfo orderInfo=orderInfoDao.findByOrderNumber(orderNumber);
		if (orderInfo!=null){
			order=this.getOrderById(orderInfo.getId());
		}
		return order;
	}
	
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void deleteOrder(OrderClivia order){
		orderLineItemDao.deleteAll(order.getLineItems());
		orderImageDao.deleteAll(order.getImageItems());
		orderItemDao.deleteAll(order.getItems());
		orderInfoDao.delete(order.getInfo());
	}
	
}
