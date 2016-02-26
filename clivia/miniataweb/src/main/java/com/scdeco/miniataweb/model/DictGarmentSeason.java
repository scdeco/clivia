package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class DictGarmentSeason {
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	@Column(name="brandId")
	private int brandId;
	
	@Column(name="Name",length=50)
	private String name;
	
	@Column(name="IsCurrent")
	private Boolean isCurrent;
	
	@Column(name="SizeFields",length=100)
	private String sizeFields;
	
	@Column(name="SizeTitles",length=100)
	private String sizeTitles;
	
	@Column(name="SizeTypes")
	private String sizeTypes;
	
	@Column(name="SizeTypeFields")
	private String sizeTypeFields;
	
	@Column(name="Categories",length=500)
	private String categories;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getBrandId() {
		return brandId;
	}

	public void setBrandId(int brandId) {
		this.brandId = brandId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Boolean getIsCurrent() {
		return isCurrent;
	}

	public void setIsCurrent(Boolean isCurrent) {
		this.isCurrent = isCurrent;
	}

	public String getSizeFields() {
		return sizeFields;
	}

	public void setSizeFields(String sizeFields) {
		this.sizeFields = sizeFields;
	}

	public String getSizeTitles() {
		return sizeTitles;
	}

	public void setSizeTitles(String sizeTitles) {
		this.sizeTitles = sizeTitles;
	}

	public String getSizeTypes() {
		return sizeTypes;
	}

	public void setSizeTypes(String sizeTypes) {
		this.sizeTypes = sizeTypes;
	}

	public String getSizeTypeFields() {
		return sizeTypeFields;
	}

	public void setSizeTypeFields(String sizeTypeFields) {
		this.sizeTypeFields = sizeTypeFields;
	}

	public String getCategories() {
		return categories;
	}

	public void setCategories(String categories) {
		this.categories = categories;
	}

	
}
