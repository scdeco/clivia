package com.scdeco.miniataweb.dao;

import java.time.LocalDate;
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
		
		OrderInfo orderInfo=order.getOrderInfo();
		if(!(orderInfo.getOrderId()>0)){
			Integer orderId=cliviaAutoNumberDao.getNextNumber("OrderId");
			Integer orderNumber=cliviaAutoNumberDao.getNextNumber("OrderNumber");
			orderInfo.setOrderId(orderId);
			orderInfo.setOrderNumber('S'+orderNumber.toString());
			orderInfo.setOrderDate(LocalDate.now());
			
			if(order.getOrderItems()!=null){
				
				for(OrderItem orderItem:order.getOrderItems()){
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

		}
		else{
			List<Map<String,String>> deletedItems=order.getDeletedItems();
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
			
		}
		
		orderInfoDao.saveOrUpdate(orderInfo);
		
		if(order.getOrderItems()!=null){
			for(OrderItem orderItem:order.getOrderItems()){
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

	public OrderClivia getOrderByOrderId(int orderId){
		OrderClivia order=null;
		OrderInfo orderInfo=orderInfoDao.findByOrderId(orderId);
		if(orderInfo!=null){
			order=new OrderClivia();
			order.setOrderInfo(orderInfo);
			List<OrderItem> orderItems=orderItemDao.FindListByOrderId(orderId);
			order.setOrderItems(orderItems);
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
			order=this.getOrderByOrderId(orderInfo.getOrderId());
		}
		return order;
	}
	
	public OrderClivia getOrderById(int id){
		OrderClivia order=null;
		OrderInfo orderInfo=orderInfoDao.findById(id);
		if (orderInfo!=null){
			order=this.getOrderByOrderId(orderInfo.getOrderId());
		}
		return order;
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void deleteOrder(OrderClivia order){
		orderLineItemDao.deleteAll(order.getLineItems());
		orderImageDao.deleteAll(order.getImageItems());
		orderItemDao.deleteAll(order.getOrderItems());
		orderInfoDao.delete(order.getOrderInfo());
	}
	
}
