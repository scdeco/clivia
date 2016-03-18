package com.scdeco.miniataweb.model;

import java.util.List;
import java.util.Map;

public class OrderClivia {
	
	private OrderInfo info;
	private List<OrderItem> items;
	private List<OrderBillItem> billItems;
	private List<OrderLineItem> lineItems;
	private List<OrderImage> imageItems;
	private List<OrderContact> contactItems;

	private List<OrderUpc> upcs;
	
	private List<Map<String,String>> deleteds;

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

	public List<OrderBillItem> getBillItems() {
		return billItems;
	}

	public void setBillItems(List<OrderBillItem> billItems) {
		this.billItems = billItems;
	}

	public List<OrderLineItem> getLineItems() {
		return lineItems;
	}

	public void setLineItems(List<OrderLineItem> lineItems) {
		this.lineItems = lineItems;
	}

	public List<OrderImage> getImageItems() {
		return imageItems;
	}

	public void setImageItems(List<OrderImage> imageItems) {
		this.imageItems = imageItems;
	}

	public List<OrderContact> getContactItems() {
		return contactItems;
	}

	public void setContactItems(List<OrderContact> contactItems) {
		this.contactItems = contactItems;
	}

	public List<OrderUpc> getUpcs() {
		return upcs;
	}

	public void setUpcs(List<OrderUpc> upcs) {
		this.upcs = upcs;
	}

	public List<Map<String, String>> getDeleteds() {
		return deleteds;
	}

	public void setDeleteds(List<Map<String, String>> deleteds) {
		this.deleteds = deleteds;
	}
	
	

	

}
