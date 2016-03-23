package com.scdeco.miniataweb.dao;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.model.OrderClivia;
import com.scdeco.miniataweb.model.OrderInfo;
import com.scdeco.miniataweb.model.OrderItem;
import com.scdeco.miniataweb.model.OrderUpc;
import com.scdeco.miniataweb.util.CliviaUtils;

@Repository ("orderDao")
public class OrderDao extends GenericMainItemDao<OrderClivia>{

	@Autowired
	private OrderInfoDao orderInfoDao;
	
	@Autowired
	private OrderItemDao orderItemDao;
	
	@Autowired
	private OrderUpcDao orderUpcDao;

	@Autowired
	private CliviaAutoNumberDao cliviaAutoNumberDao;
	
	private static int MAX_TMP_ID=10000;

	public OrderDao(){
		super();

		super.registeredItemListNames=new String[]{"billItems","lineItems","designItems","imageItems","fileItems","emailItems","contactItems","addressItems"};
		super.registeredItemModelNames=new String[]{"orderBillItem","orderLineItem","orderDesign","orderImage","orderFile","orderEmail","orderContact","orderAddress"};
		super.daoPrefix="order";
		
		super.infoItemName="info";
		super.infoDaoName="orderInfo";
		
		super.mainIdFieldName="orderId";
	}
	

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
			super.removeDeletedItems(order);
		}

		super.saveInfoItem(order);
		
		setMainId(order);
		
		saveAndSetOrderItemId(order,isNewOrder);
		
		super.saveSubItemList(order);

		if(order.getUpcs()!=null){
			for(OrderUpc upc:order.getUpcs()){
				orderUpcDao.saveOrUpdate(upc);
			}
		}
	}
	
	public OrderClivia getOrderByOrderNumber(String orderNumber) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		OrderClivia order=null;
		OrderInfo orderInfo=orderInfoDao.findByOrderNumber(orderNumber);
		if (orderInfo!=null){
			order=getOrderByOrderId(orderInfo.getId());
		}
		
		return order;
	}
	
	
	public OrderClivia getOrderByOrderId(int id) 
			throws InstantiationException, IllegalAccessException, NoSuchFieldException, SecurityException, IllegalArgumentException{
		OrderClivia order=super.getById(id);
		order.setItems(orderItemDao.FindListByOrderId(id));
		return order;
	}
	//not test yet
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void deleteOrder(OrderClivia order) 
					throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		orderUpcDao.deleteAll(order.getUpcs());
		super.delete(order);
	}
	
	private void setMainId(OrderClivia order) 
					throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		int orderId=order.getInfo().getId();
		
		super.setSuperId(order, "orderId", orderId, 0);

		if(order.getUpcs()!=null){
			for(OrderUpc orderUpc:order.getUpcs()){
				orderUpc.setOrderId(orderId);
			}
		}
		
	}
	
	@SuppressWarnings({ "rawtypes" })
	private void saveAndSetOrderItemId(OrderClivia order,boolean isNewOrder) 
				throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		List<OrderItem> orderItems=order.getItems();
		if(orderItems!=null){
			for(OrderItem orderItem:orderItems){
				int tmpOrderItemId=orderItem.getId();
				if(isNewOrder||tmpOrderItemId<MAX_TMP_ID)	//if is repeat order,the id is >= MAX_TMP_ID 
					orderItem.setId(0);
				if(orderItem.getIsDirty())	//new or changed
					orderItemDao.saveOrUpdate(orderItem);
				if(isNewOrder||tmpOrderItemId<MAX_TMP_ID){
					int itemIndex=orderItem.getTypeId()-1;
					GenericSubItemDao subItemDao=(GenericSubItemDao) CliviaUtils.getDao(super.registeredItemModelNames[itemIndex]);
					List subItemList=super.getItemList(order,super.registeredItemListNames[itemIndex]);
					subItemDao.setSuperId(subItemList, "orderItemId", orderItem.getId(), tmpOrderItemId);
				}
			}
		}
		
	}
	
}
