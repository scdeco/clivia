package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Garment  {

	@Id
	@GeneratedValue
	private int id;
		
	@Column(name="StyleNumber", length=20,unique=true,nullable=false)
	private String styleNumber;

	@Column(name="StyleName", length=50)
	private String styleName;
	
	@Column(name="Description", length=200)
	private String description;
	
	@Column(name="Feature", length=200)
	private String feature;
	
	@Column(name="Season", length=100)
	private String season;
	
	@Column(name="Category", length=30)
	private String category;
	
	@Column(name="Brand",length=30)
	private String brand;
	
	@Column(name="Gender", length=10)
	private String gender;
	
	@Column(name="Colourway",length=50)
	private String colourway;
	
	@Column(name="SizeRange",length=50)
	private String sizeRange;
	
	@Column(name="TotalQtyInStock")
	private Integer totalQtyInStock;
	
	@Column(name="TotalQtyInOrder")
	private Integer totalQtyInOrder;
	
	@Column(name="WholeSalePrice")
	private Double wholeSalePrice;
	
	@Column(name="RetailPrice")
	private Double retailPrice;
	
	@Column(name="Remark",length=500)
	private String  remark;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getStyleNumber() {
		return styleNumber;
	}

	public void setStyleNumber(String styleNumber) {
		this.styleNumber = styleNumber;
	}

	public String getStyleName() {
		return styleName;
	}

	public void setStyleName(String styleName) {
		this.styleName = styleName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getFeature() {
		return feature;
	}

	public void setFeature(String feature) {
		this.feature = feature;
	}

	public String getSeason() {
		return season;
	}

	public void setSeason(String season) {
		this.season = season;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getGender() {
		return gender;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}
	
	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getColourway() {
		return colourway;
	}

	public void setColourway(String colourway) {
		this.colourway = colourway;
	}

	public String getSizeRange() {
		return sizeRange;
	}

	public void setSizeRange(String sizeRange) {
		this.sizeRange = sizeRange;
	}

	public Integer getTotalQtyInStock() {
		return totalQtyInStock;
	}

	public void setTotalQtyInStock(Integer totalQtyInStock) {
		this.totalQtyInStock = totalQtyInStock;
	}

	public Integer getTotalQtyInOrder() {
		return totalQtyInOrder;
	}

	public void setTotalQtyInOrder(Integer totalQtyInOrder) {
		this.totalQtyInOrder = totalQtyInOrder;
	}

	public Double getWholeSalePrice() {
		return wholeSalePrice;
	}

	public void setWholeSalePrice(Double wholeSalePrice) {
		this.wholeSalePrice = wholeSalePrice;
	}

	public Double getRetailPrice() {
		return retailPrice;
	}

	public void setRetailPrice(Double retailPrice) {
		this.retailPrice = retailPrice;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}



}