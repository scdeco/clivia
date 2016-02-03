package com.scdeco.miniataweb.model;

import java.util.List;

public class GarmentTrans {
	
	private GarmentTransInfo info;
	private List<GarmentTransDetail> items;
	
	public GarmentTransInfo getInfo() {
		return info;
	}
	
	public void setInfo(GarmentTransInfo info) {
		this.info = info;
	}
	public List<GarmentTransDetail> getItems() {
		return items;
	}
	public void setItems(List<GarmentTransDetail> items) {
		this.items = items;
	}
}
