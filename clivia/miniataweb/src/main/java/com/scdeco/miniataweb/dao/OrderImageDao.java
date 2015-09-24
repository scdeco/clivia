package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.OrderImage;

@Repository("orderImageDao")
public class OrderImageDao  extends GenericDao<OrderImage, Integer> {
	public List<OrderImage> FindListByOrderItemId(Integer orderId,Integer orderItemId) {
		List<OrderImage> list=this.findList(super.createCriteria()
				.add(Restrictions.eq("orderId", orderId))
				.add(Restrictions.eq("orderItemId", orderItemId)));
		return list;
	}

	public List<OrderImage> FindListByOrderId(Integer orderId) {
		List<OrderImage> list=this.findList(super.createCriteria()
				.add(Restrictions.eq("orderId", orderId))
				.addOrder(Order.asc("orderItemId"))
				.addOrder(Order.asc("lineNumber")));
		return list;
	}
	
}
