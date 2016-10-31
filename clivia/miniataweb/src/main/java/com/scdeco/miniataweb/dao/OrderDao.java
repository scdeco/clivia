package com.scdeco.miniataweb.dao;

import java.time.LocalDate;
import java.time.LocalTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.model.OrderClivia;
import com.scdeco.miniataweb.model.OrderInfo;

@Repository ("orderDao")
public class OrderDao extends GenericItemSetDao<OrderClivia>{

	@Autowired
	private OrderInfoDao orderInfoDao;
	
	@Autowired
	private CliviaAutoNumberDao cliviaAutoNumberDao;
	
	protected void initItemSet() throws NoSuchFieldException, SecurityException{
		
		IdDependentItem mainItem=new IdDependentItem(super.mainEntityClass,"info","orderInfo","orderId");
		
		IdDependentItem item=new IdDependentItem(super.mainEntityClass,"items","orderItem","orderItemId");		//has dependentItems
		IdDependentItem upcItem=new IdDependentItem(super.mainEntityClass,"upcItems","orderUpc","");
		
		IdDependentItem billItem=new IdDependentItem(super.mainEntityClass,"billItems","orderBillItem","");
		IdDependentItem lineItem=new IdDependentItem(super.mainEntityClass,"lineItems","orderLineItem","lineItemId");		//has dependentItems
		IdDependentItem designItem=new IdDependentItem(super.mainEntityClass,"designItems","orderDesign","");
		IdDependentItem imageItem=new IdDependentItem(super.mainEntityClass,"imageItems","orderImage","");
		IdDependentItem fileItem=new IdDependentItem(super.mainEntityClass,"fileItems","orderFile","");
		IdDependentItem emailItem=new IdDependentItem(super.mainEntityClass,"emailItems","orderEmail","");
		IdDependentItem contactItem=new IdDependentItem(super.mainEntityClass,"contactItems","orderContact","");
		IdDependentItem addressItem=new IdDependentItem(super.mainEntityClass,"addressItems","orderAddress","");

		IdDependentItem serviceEmb=new IdDependentItem(super.mainEntityClass,"serviceEmbs","orderServiceEmb","");
		
		mainItem.dependentItems.add(item);
		mainItem.dependentItems.add(upcItem);
		
		item.dependentItems.add(billItem);
		item.dependentItems.add(lineItem);
		item.dependentItems.add(designItem);
		item.dependentItems.add(imageItem);
		item.dependentItems.add(fileItem);
		item.dependentItems.add(emailItem);
		item.dependentItems.add(contactItem);
		item.dependentItems.add(addressItem);
		
		lineItem.dependentItems.add(serviceEmb);
		
		super.setMainItem(mainItem);
	}
	

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void save(OrderClivia order) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		OrderInfo orderInfo=order.getInfo();
		
		boolean isNewOrder=orderInfo.getIsNewDi();
		
		if(isNewOrder){
			Integer orderNumber=cliviaAutoNumberDao.getNextNumber("OrderNumber");
			orderInfo.setOrderNumber(orderNumber.toString());
			if(orderInfo.getOrderDate()==null){
				orderInfo.setOrderDate(LocalDate.now());
				orderInfo.setOrderTime(LocalTime.now());
			}
		}
		
		super.save(order);

	}

	public OrderClivia getByOrderNumber(String orderNumber, String[] list) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		OrderClivia order=null;
		OrderInfo orderInfo=orderInfoDao.findByOrderNumber(orderNumber);
		if (orderInfo!=null){
			order=super.getById(orderInfo.getId(),list);
		}
		
		return order;
	}
	

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void delete(String orderNumber) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException {
		
		OrderInfo orderInfo=orderInfoDao.findByOrderNumber(orderNumber);
		if(orderInfo!=null)
			super.delete(orderInfo.getId());
	}

	
}
