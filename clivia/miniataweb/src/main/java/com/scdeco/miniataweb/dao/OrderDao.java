package com.scdeco.miniataweb.dao;

import java.lang.reflect.Field;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.model.OrderClivia;
import com.scdeco.miniataweb.model.OrderInfo;
import com.scdeco.miniataweb.model.OrderItem;
import com.scdeco.miniataweb.model.OrderUpc;
import com.scdeco.miniataweb.util.CliviaApplicationContext;

@Repository ("orderDao")
public class OrderDao {

	@Autowired
	private OrderInfoDao orderInfoDao;
	
	@Autowired
	private OrderItemDao orderItemDao;
	
	@Autowired
	private OrderUpcDao orderUpcDao;

	@Autowired
	private CliviaAutoNumberDao cliviaAutoNumberDao;
	
	private static int MAX_TMP_ID=10000;

	final String[] registeredOrderItemNames=new String[]{"lineItems","billItems","imageItems","contactItems"};
	final String[] registeredOrderItemDaoNames=new String[]{"orderLineItem","orderBillItem","orderImage","orderContact"};
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void save(OrderClivia order) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
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
		
		Class orderClass= order.getClass();
		
		for(int i=0;i<registeredOrderItemNames.length;i++){
			
			Field itemListField = orderClass.getDeclaredField(registeredOrderItemNames[i]);
			itemListField.setAccessible(true);
			List itemList=(List) itemListField.get(order);
			
			if(itemList!=null){
				GenericDao dao=getDao(registeredOrderItemDaoNames[i]);
				for(Object item:itemList){
					dao.saveOrUpdate(item);
				}

			}
		}		

		if(order.getUpcs()!=null){
			for(OrderUpc upc:order.getUpcs()){
				orderUpcDao.saveOrUpdate(upc);
			}
		}
	}
	
	@SuppressWarnings({ "rawtypes" })
	public OrderClivia getOrderById(int orderId) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		OrderClivia order=null;
		OrderInfo orderInfo=orderInfoDao.findById(orderId);
		if(orderInfo!=null){
			order=new OrderClivia();
			order.setInfo(orderInfo);
			
			List<OrderItem> orderItems=orderItemDao.FindListByOrderId(orderId);
			order.setItems(orderItems);
		
			Class orderClass= order.getClass();
			
			for(int i=0;i<registeredOrderItemNames.length;i++){
				Field itemListField = orderClass.getDeclaredField(registeredOrderItemNames[i]);
				itemListField.setAccessible(true);

				OrderItemGenericDao dao=(OrderItemGenericDao) getDao(registeredOrderItemDaoNames[i]);
				
				List  itemList=dao.findListByOrderId(orderId);
				itemListField.set(order, itemList);
			}

		}
			
		return order;
		
	}
	
	public OrderClivia getOrderByOrderNumber(String orderNumber) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		OrderClivia order=null;
		OrderInfo orderInfo=orderInfoDao.findByOrderNumber(orderNumber);
		if (orderInfo!=null){
			order=this.getOrderById(orderInfo.getId());
		}
		return order;
	}
	
	//not test yet
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void deleteOrder(OrderClivia order) 
					throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		orderUpcDao.deleteAll(order.getUpcs());

		Class orderClass= order.getClass();
		
		for(int i=0;i<registeredOrderItemNames.length;i++){
			Field itemField = orderClass.getDeclaredField(registeredOrderItemNames[i]);
			itemField.setAccessible(true);
			List itemList=(List) itemField.get(order);
			
			if(itemList!=null){
				GenericDao dao=getDao(registeredOrderItemDaoNames[i]);
				dao.deleteAll(itemList);
			}
		}
		
		orderItemDao.deleteAll(order.getItems());
		orderInfoDao.delete(order.getInfo());
	}
	
	@SuppressWarnings({ "rawtypes" })
	private void setOrderId(OrderClivia order) 
					throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		int orderId=order.getInfo().getId();
		
		if(order.getItems()!=null){
			for(OrderItem orderItem:order.getItems()){
				orderItem.setOrderId(orderId);
			}
		}

		Class orderClass= order.getClass();
		
		for(int i=0;i<registeredOrderItemNames.length;i++){
			Field itemField = orderClass.getDeclaredField(registeredOrderItemNames[i]);
			itemField.setAccessible(true);
			List itemList=(List) itemField.get(order);
			
			if(itemList!=null){
				GenericDao dao=getDao(registeredOrderItemDaoNames[i]);

				Class itemClass=dao.getEntityClass();
				Field fieldOrderItemId=itemClass.getDeclaredField("orderId");
				fieldOrderItemId.setAccessible(true);
				for(Object item:itemList){
					fieldOrderItemId.setInt(item, orderId);
				}
			}
		}

		if(order.getUpcs()!=null){
			for(OrderUpc orderUpc:order.getUpcs()){
				orderUpc.setOrderId(orderId);
			}
		}
		
	}
	
	@SuppressWarnings({ "rawtypes" })
	private void setOrderItemId(OrderClivia order,int tmpOrderItemId,int newOrderItemId) 
				throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		Class orderClass= order.getClass();
		
		for(int i=0;i<registeredOrderItemNames.length;i++){
			Field itemField = orderClass.getDeclaredField(registeredOrderItemNames[i]);
			itemField.setAccessible(true);
			List itemList=(List) itemField.get(order);
			
			if(itemList!=null){
				GenericDao dao=getDao(registeredOrderItemDaoNames[i]);

				Class itemClass=dao.getEntityClass();
				Field fieldOrderItemId=itemClass.getDeclaredField("orderItemId");
				fieldOrderItemId.setAccessible(true);
				for(Object item:itemList){
					if(fieldOrderItemId.getInt(item)==tmpOrderItemId)
						fieldOrderItemId.setInt(item, newOrderItemId);
				}
			}
		}
		
	}
	
	@SuppressWarnings("rawtypes")
	private void removeDeletedItems(List<Map<String,String>> deletedItems){
		if(!deletedItems.isEmpty()){
			System.out.println("deleted:"+deletedItems);
			
			for(Map<String,String> item:deletedItems){
		        	int id=Integer.parseInt(item.get("id"));
		        	
					char[] c=item.get("entity").toCharArray();
					c[0]=Character.toUpperCase(c[0]);
					String daoName="order"+new String(c);
		        	
					GenericDao dao=getDao(daoName);
		        	dao.deleteById(id);
		        	
		     }				
		}
	}
	
    @SuppressWarnings("rawtypes")
	private GenericDao getDao(String daoName){
    	
    	if(!daoName.toLowerCase().endsWith("dao"))
    		daoName+="Dao";
    	return ((GenericDao)CliviaApplicationContext.getBean(daoName));
    }
	
}
