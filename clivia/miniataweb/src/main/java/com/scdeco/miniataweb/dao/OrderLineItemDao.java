package com.scdeco.miniataweb.dao;

import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.OrderLineItem;

@Repository("orderLineItemDao")
public class OrderLineItemDao extends GenericSubItemDao<OrderLineItem> {
	
}
