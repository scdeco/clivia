package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.OrderMain;

@Repository ("orderDao")
public class OrderMainDaoImpl extends GenericDaoImpl<OrderMain, Integer> implements OrderMainDao {

	@Override
	public OrderMain findByOrderNumber(String orderNumber) {
		List<OrderMain> list=this.findList(super.createCriteria().add(Restrictions.eq("orderNumber",orderNumber)));
		
		return list.isEmpty()?null:list.get(0);		
	}

	@Override
	public void deleteOrder(OrderMain cliviaOrder) {
		this.delete(cliviaOrder);		
		
	}

}
