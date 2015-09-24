package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.OrderLineItem;

@Repository("orderLineItemDao")
public class OrderLineItemDao extends GenericDao<OrderLineItem, Integer> {
	public List<OrderLineItem> FindListByOrderItemId(Integer orderId,Integer orderItemId) {
		List<OrderLineItem> list=this.findList(super.createCriteria()
				.add(Restrictions.eq("orderId", orderId))
				.add(Restrictions.eq("orderItemId", orderItemId)));
		return list;
	}

	public List<OrderLineItem> FindListByOrderId(Integer orderId) {
		List<OrderLineItem> list=this.findList(super.createCriteria()
				.add(Restrictions.eq("orderId", orderId))
				.addOrder(Order.asc("orderItemId"))
				.addOrder(Order.asc("lineNumber")));
		return list;
	}
	
}
