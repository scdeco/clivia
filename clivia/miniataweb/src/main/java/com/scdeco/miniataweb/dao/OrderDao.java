package com.scdeco.miniataweb.dao;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.model.OrderBillItem;
import com.scdeco.miniataweb.model.OrderClivia;
import com.scdeco.miniataweb.model.OrderImage;
import com.scdeco.miniataweb.model.OrderInfo;
import com.scdeco.miniataweb.model.OrderItem;
import com.scdeco.miniataweb.model.OrderLineItem;
import com.scdeco.miniataweb.model.OrderUpc;

@Repository ("orderDao")
public class OrderDao {

	@Autowired
	private OrderInfoDao orderInfoDao;
	
	@Autowired
	private OrderItemDao orderItemDao;
	
	@Autowired
	private OrderLineItemDao orderLineItemDao;

	@Autowired
	private OrderBillItemDao orderBillItemDao;
	
	@Autowired
	private OrderImageDao orderImageDao;
	
	@Autowired
	private OrderEmbDesignDao orderEmbDesignDao;
	
	@Autowired
	private OrderUpcDao orderUpcDao;

	@Autowired
	private CliviaAutoNumberDao cliviaAutoNumberDao;
	
	private static int MAX_TMP_ID=10000;
	
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void save(OrderClivia order){
		
		OrderInfo orderInfo=order.getInfo();
		
		boolean isNewOrder=orderInfo.getId()<=0;
		
		if(isNewOrder){
			Integer orderNumber=cliviaAutoNumberDao.getNextNumber("OrderNumber");
			orderInfo.setOrderNumber('S'+orderNumber.toString());
			orderInfo.setOrderDate(LocalDate.now());
			orderInfo.setOrderTime(LocalTime.now());
		}else{
			removeDeletedItems(order.getDeleteds());
			orderUpcDao.deleteListByOrderId(orderInfo.getId());
		}

		orderInfoDao.saveOrUpdate(orderInfo);
		
		setOrderId(order);
		
		if(order.getItems()!=null){
			for(OrderItem orderItem:order.getItems()){
				int tmpOrderItemId=orderItem.getId();
				if(isNewOrder||tmpOrderItemId<MAX_TMP_ID)
					orderItem.setId(0);
				orderItemDao.saveOrUpdate(orderItem);
				if(isNewOrder||tmpOrderItemId<MAX_TMP_ID)
					setOrderItemId(order,tmpOrderItemId,orderItem.getId());
			}
		}

		if(order.getBillItems()!=null){
			for(OrderBillItem billItem:order.getBillItems()){
				orderBillItemDao.saveOrUpdate(billItem);
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
		
		if(order.getUpcs()!=null){
			for(OrderUpc upc:order.getUpcs()){
				orderUpcDao.saveOrUpdate(upc);
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
			
			List<OrderBillItem> billItems=orderBillItemDao.findListByOrderId(orderId);
			order.setBillItems(billItems);

			List<OrderLineItem> lineItems=orderLineItemDao.findListByOrderId(orderId);
			order.setLineItems(lineItems);
			
			List<OrderImage> imageItems=orderImageDao.findListByOrderId(orderId);
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
		
		orderBillItemDao.deleteAll(order.getBillItems());
		orderLineItemDao.deleteAll(order.getLineItems());
		orderImageDao.deleteAll(order.getImageItems());
		orderItemDao.deleteAll(order.getItems());
		orderInfoDao.delete(order.getInfo());
	}
	
	
	private void setOrderId(OrderClivia order){
		int orderId=order.getInfo().getId();
		
		if(order.getItems()!=null){
			for(OrderItem orderItem:order.getItems()){
				orderItem.setOrderId(orderId);
			}
		}

		if(order.getBillItems()!=null){
			for(OrderBillItem billItem:order.getBillItems()){
				billItem.setOrderId(orderId);
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
		
		if(order.getUpcs()!=null){
			for(OrderUpc orderUpc:order.getUpcs()){
				orderUpc.setOrderId(orderId);
			}
		}
		
	}
	
	private void setOrderItemId(OrderClivia order,int tmpOrderItemId,int newOrderItemId){
		
		if(order.getLineItems()!=null){
			for(OrderLineItem lineItem:order.getLineItems()){
				if(lineItem.getOrderItemId()==tmpOrderItemId)
					lineItem.setOrderItemId(newOrderItemId);
			}
		}
			
		if(order.getBillItems()!=null){
			for(OrderBillItem billItem:order.getBillItems()){
				if(billItem.getOrderItemId()==tmpOrderItemId)
					billItem.setOrderItemId(newOrderItemId);
			}
		}
			
		if(order.getImageItems()!=null){
			for(OrderImage imageItem:order.getImageItems()){
				if(imageItem.getOrderItemId()==tmpOrderItemId)
					imageItem.setOrderItemId(newOrderItemId);
			}
		}		
	}
	
	
	private void removeDeletedItems(List<Map<String,String>> deletedItems){
		if(!deletedItems.isEmpty()){
			System.out.println("deleted:"+deletedItems);
			
			for(Map<String,String> item:deletedItems){
					String daoName=item.get("entity");
		        	int id=Integer.parseInt(item.get("id"));
		        	
		        	switch (daoName){
		        	case "item":
		        		orderItemDao.deleteById(id);
		        		break;
		        	case "lineItem":
		        		orderLineItemDao.deleteById(id);
		        		break;
		        	case "billItem":
		        		orderBillItemDao.deleteById(id);
		        		break;
		        	case "imageItem":
		        		orderImageDao.deleteById(id);
		        		break;
		        	}
		        	
		     }				
		}
	}
	
	
	
}
