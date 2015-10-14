package com.scdeco.miniataweb.dao;

import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.OrderPricingItem;

@Repository("orderPricingItemDao")
public class OrderPricingItemDao extends OrderItemGenericDao<OrderPricingItem, Integer> {
	
}
