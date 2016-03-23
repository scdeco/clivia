package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

public class OrderItemGenericDao<T> extends GenericDao<T> {
	public List<T> findListByOrderItemId(Integer orderItemId) {
		Criteria criteria=super.createCriteria()
								.add(Restrictions.eq("orderItemId", orderItemId));
		
		if(hasLineNoField())
			criteria.addOrder(Order.asc("lineNo"));
		
		
		List<T> list=this.findList(criteria);
		return list;
	}

	public List<T> findListByOrderId(Integer orderId) {
		
		Criteria criteria=super.createCriteria()
				.add(Restrictions.eq("orderId", orderId))
				.addOrder(Order.asc("orderItemId"));
		
		if(hasLineNoField())
			criteria.addOrder(Order.asc("lineNo"));

		List<T> list=this.findList(criteria);
		
		return list;
	}	
	
	public void deleteByOrderItemId(Integer orderItemId){
		List<T> list=findListByOrderItemId(orderItemId);
		this.deleteAll(list);
	}
	
	private boolean hasLineNoField(){
		boolean result=false;
		try {
			super.getEntityClass().getDeclaredField("lineNo");
			result=true;
		} catch (NoSuchFieldException | SecurityException e) {
			System.out.println("lineNo is not a declared field ");
		}
		
		return result;
	}

}
