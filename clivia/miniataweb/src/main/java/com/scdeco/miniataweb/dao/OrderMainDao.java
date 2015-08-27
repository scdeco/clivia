package com.scdeco.miniataweb.dao;

import com.scdeco.miniataweb.model.OrderMain;

public interface OrderMainDao extends GenericDao<OrderMain, Integer> {
	OrderMain findByOrderNumber(String orderNumber);
	void deleteOrder(OrderMain cliviaOrder);
}
