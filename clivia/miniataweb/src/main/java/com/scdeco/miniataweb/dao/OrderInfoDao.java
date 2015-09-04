package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.OrderInfo;

@Repository ("orderInfoDao")
public class OrderInfoDao extends GenericDao<OrderInfo, Integer> {

	public OrderInfo findByOrderNumber(String orderNumber) {
		List<OrderInfo> list=this.findList(super.createCriteria().add(Restrictions.eq("orderNumber",orderNumber)));
		
		return list.isEmpty()?null:list.get(0);		
	}

	public OrderInfo findByOrderId(Integer orderId) {
		List<OrderInfo> list=this.findList(super.createCriteria().add(Restrictions.eq("orderId",orderId)));
		
		return list.isEmpty()?null:list.get(0);		
	}
	
	public void deleteOrder(OrderInfo cliviaOrder) {
		this.delete(cliviaOrder);		
		
	}

}
