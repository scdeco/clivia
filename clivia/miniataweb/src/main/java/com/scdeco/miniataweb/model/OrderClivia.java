package com.scdeco.miniataweb.model;

import java.util.List;
import java.util.Map;

public class OrderClivia {
	private OrderInfo orderInfo;
	private List<OrderItem> orderItems;
	private List<OrderLineItem> lineItems;
	private List<OrderImage> imageItems;
	
	private List<Map<String,String>> deletedItems;
	
	public OrderInfo getOrderInfo() {
		return orderInfo;
	}
	public void setOrderInfo(OrderInfo orderInfo) {
		this.orderInfo = orderInfo;
	}
	public List<OrderItem> getOrderItems() {
		return orderItems;
	}
	public void setOrderItems(List<OrderItem> orderItems) {
		this.orderItems = orderItems;
	}
	public List<OrderLineItem> getLineItems() {
		return lineItems;
	}
	public void setLineItems(List<OrderLineItem> lineItems) {
		this.lineItems = lineItems;
	}
	public List<Map<String, String>> getDeletedItems() {
		return deletedItems;
	}
	public void setDeletedItems(List<Map<String, String>> deletedItems) {
		this.deletedItems = deletedItems;
	}
	public List<OrderImage> getImageItems() {
		return imageItems;
	}
	public void setImageItems(List<OrderImage> imageItems) {
		this.imageItems = imageItems;
	}
	

}
