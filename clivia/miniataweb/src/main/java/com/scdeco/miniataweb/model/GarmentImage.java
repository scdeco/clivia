package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

public class GarmentImage {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	@Column(name="GarmentId", nullable = false)	
	private int garmentId;
	
	@Column(name="ImageId", nullable = false)	
	private int imageId;
	
	@Column(name="Desc", length=200)
	private String desc;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getGarmentId() {
		return garmentId;
	}

	public void setGarmentId(int garmentId) {
		this.garmentId = garmentId;
	}

	public int getImageId() {
		return imageId;
	}

	public void setImageId(int imageId) {
		this.imageId = imageId;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	
}
