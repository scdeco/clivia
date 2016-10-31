package com.scdeco.miniataweb.model;

import java.util.List;
import java.util.Map;

public class Invoice {
	InvoiceInfo info;
	List<InvoiceItem> items;
	List<Map<String,String>> deleteds;
	public InvoiceInfo getInfo() {
		return info;
	}
	public void setInfo(InvoiceInfo info) {
		this.info = info;
	}
	public List<InvoiceItem> getItems() {
		return items;
	}
	public void setItems(List<InvoiceItem> items) {
		this.items = items;
	}
	public List<Map<String, String>> getDeleteds() {
		return deleteds;
	}
	public void setDeleteds(List<Map<String, String>> deleteds) {
		this.deleteds = deleteds;
	}
}
