package com.scdeco.miniataweb.model;

import java.util.List;
import java.util.Map;

public class OrderClivia {
	
	private OrderInfo info;
	private List<OrderItem> items;
	private List<OrderLineItem> lineItems;
	private List<OrderImage> imageItems;
	
	private List<Map<String,String>> deletedItems;
	
	public OrderInfo getInfo() {
		return info;
	}
	public void setInfo(OrderInfo info) {
		this.info = info;
	}
	public List<OrderItem> getItems() {
		return items;
	}
	public void setItems(List<OrderItem> items) {
		this.items = items;
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
