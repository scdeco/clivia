package com.scdeco.miniataweb.dao;

import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.OrderUpc;

@Repository("orderUpcDao")
public class OrderUpcDao extends GenericSubItemDao<OrderUpc> {
	
/*	public List<OrderUpc> findListByOrderId(int orderId) {
		List<OrderUpc> list=this.findList(super.createCriteria()
				.add(Restrictions.eq("orderId", orderId)));
		return list;
	}	
	
	public void deleteListByOrderId(int orderId){
		List<OrderUpc> orderUpcs=findListByOrderId(orderId);
		if(orderUpcs!=null){
			for(OrderUpc orderUpc:orderUpcs){
				this.deleteById(orderUpc.getId());
			}
		}
	}*/
}
