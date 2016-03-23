package com.scdeco.miniataweb.model;

import java.util.List;
import java.util.Map;

public class Garment {
	
	private GarmentInfo info;
	private List<GarmentUpc> upcItems;
	private List<GarmentImage> imageItems;
	List<Map<String,String>> deleteds;
	
	
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
	public List<GarmentImage> getImageItems() {
		return imageItems;
	}
	public void setImageItems(List<GarmentImage> imageItems) {
		this.imageItems = imageItems;
	}
	public List<Map<String, String>> getDeleteds() {
		return deleteds;
	}
	public void setDeleteds(List<Map<String, String>> deleteds) {
		this.deleteds = deleteds;
	}
	
}
