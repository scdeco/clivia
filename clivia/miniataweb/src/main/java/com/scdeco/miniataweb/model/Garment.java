package com.scdeco.miniataweb.model;

import java.util.List;

public class Garment {
	
	private GarmentInfo info;
	private List<GarmentUpc> upcItems;
	private int[] deletedUpcItems;
	
	public GarmentInfo getInfo() {
		return info;
	}
	public void setInfo(GarmentInfo info) {
		this.info = info;
	}
	public List<GarmentUpc> getUpcItems() {
		return upcItems;
	}
	public void setUpcItems(List<GarmentUpc> upcItems) {
		this.upcItems = upcItems;
	}
	public int[] getDeletedUpcItems() {
		return deletedUpcItems;
	}
	public void setDeletedUpcItems(int[] deletedUpcItems) {
		this.deletedUpcItems = deletedUpcItems;
	}
	
}
