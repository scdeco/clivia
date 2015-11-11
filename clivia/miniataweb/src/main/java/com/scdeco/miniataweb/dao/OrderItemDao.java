package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.OrderItem;

@Repository("orderItemDao")
public class OrderItemDao extends GenericDao<OrderItem> {
	public List<OrderItem> FindListByOrderId(Integer orderId) {
		List<OrderItem> list=this.findList(
				super.createCriteria()
					.add(Restrictions.eq("orderId", orderId))
					.addOrder(Order.asc("lineNumber")));
		return list;
	}
}
