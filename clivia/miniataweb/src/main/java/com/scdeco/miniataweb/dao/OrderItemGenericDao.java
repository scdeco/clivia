package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

public class OrderItemGenericDao<T> extends GenericDao<T> {
	public List<T> findListByOrderItemId(Integer orderItemId) {
		List<T> list=this.findList(super.createCriteria()
				.add(Restrictions.eq("orderItemId", orderItemId))
				.addOrder(Order.asc("lineNo")));
		return list;
	}

	public List<T> findListByOrderId(Integer orderId) {
		List<T> list=this.findList(super.createCriteria()
				.add(Restrictions.eq("orderId", orderId))
				.addOrder(Order.asc("orderItemId"))
				.addOrder(Order.asc("lineNo")));
		return list;
	}	
	
	public void deleteByOrderItemId(Integer orderItemId){
		List<T> list=findListByOrderItemId(orderItemId);
		this.deleteAll(list);
	}

}
