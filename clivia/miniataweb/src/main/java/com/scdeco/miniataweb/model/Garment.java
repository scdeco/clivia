package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Garment  {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
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
	
	@Column(name="Colourway",length=250)
	private String colourway;
	
	@Column(name="SizeRange",length=150)
	private String sizeRange;
	
	@Column(name="TotalQtyInStock")
	private Integer totalQtyInStock;
	
	@Column(name="TotalQtyInSO")
	private Integer totalQtyInSO;

	@Column(name="TotalQtyInPO")
	private Integer totalQtyInPO;

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

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
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

	public Integer getTotalQtyInSO() {
		return totalQtyInSO;
	}

	public void setTotalQtyInSO(Integer totalQtyInSO) {
		this.totalQtyInSO = totalQtyInSO;
	}

	public Integer getTotalQtyInPO() {
		return totalQtyInPO;
	}

	public void setTotalQtyInPO(Integer totalQtyInPO) {
		this.totalQtyInPO = totalQtyInPO;
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
