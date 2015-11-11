package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

public class OrderItemGenericDao<T> extends GenericDao<T> {
	public List<T> FindListByOrderItemId(Integer orderId,Integer orderItemId) {
		List<T> list=this.findList(super.createCriteria()
				.add(Restrictions.eq("orderId", orderId))
				.add(Restrictions.eq("orderItemId", orderItemId)));
		return list;
	}

	public List<T> FindListByOrderId(Integer orderId) {
		List<T> list=this.findList(super.createCriteria()
				.add(Restrictions.eq("orderId", orderId))
				.addOrder(Order.asc("orderItemId"))
				.addOrder(Order.asc("lineNumber")));
		return list;
	}	

}
