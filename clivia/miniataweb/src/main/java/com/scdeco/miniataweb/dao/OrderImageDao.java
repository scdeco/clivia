package com.scdeco.miniataweb.dao;

import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.OrderImage;

@Repository("orderImageDao")
public class OrderImageDao  extends OrderItemGenericDao<OrderImage, Integer> {

	
}
