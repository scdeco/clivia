package com.scdeco.miniataweb.model;

import java.util.List;

public class Garment {
	
	private GarmentInfo info;
	private List<GarmentUpc> upcItems;
	private List<GarmentImage> imageItems;
	private int[] deletedUpcItems;
	private int[] deletedImageItems;
	
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
	public int[] getDeletedUpcItems() {
		return deletedUpcItems;
	}
	public void setDeletedUpcItems(int[] deletedUpcItems) {
		this.deletedUpcItems = deletedUpcItems;
	}
	public int[] getDeletedImageItems() {
		return deletedImageItems;
	}
	public void setDeletedImageItems(int[] deletedImageItems) {
		this.deletedImageItems = deletedImageItems;
	}
	
}
