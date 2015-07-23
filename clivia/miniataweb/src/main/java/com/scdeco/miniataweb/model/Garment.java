package com.scdeco.miniataweb.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Currency;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name="Garment")
public class Garment implements Serializable {

	private static final long serialVersionUID = -6998488637341081811L;

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
	
	@Column(name="Type", length=30)
	private String type;
	
	@Column(name="Gender", length=10)
	private String gender;
	
	@Column(name="Colour",length=50)
	private String availableColour;
	
	@Column(name="Size",length=50)
	private String availableSize;
	
	@Column(name="TotalQtyInStock")
	private int totalQtyInStock;
	
	@Column(name="TotalQtyInOrder")
	private int totalQtyInOrder;
	
	@Column(name="WholeSalePrice")
	private Currency wholeSalePrice;
	
	@Column(name="RetailPrice")
	private Currency retailPrice;
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "garment")
	private List<GarmentUPC> garmentUPCs = new ArrayList<GarmentUPC>();
	
	public void addUPC(GarmentUPC garmentUPC){
		if(garmentUPC.getGarment()!=this)
			garmentUPC.setGarment(this);
		garmentUPCs.add(garmentUPC);
		
	}

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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getAvailableColour() {
		return availableColour;
	}

	public void setAvailableColour(String availableColour) {
		this.availableColour = availableColour;
	}

	public String getAvailableSize() {
		return availableSize;
	}

	public void setAvailableSize(String availableSize) {
		this.availableSize = availableSize;
	}

	public int getTotalQtyInStock() {
		return totalQtyInStock;
	}

	public void setTotalQtyInStock(int totalQtyInStock) {
		this.totalQtyInStock = totalQtyInStock;
	}

	public int getTotalQtyInOrder() {
		return totalQtyInOrder;
	}

	public void setTotalQtyInOrder(int totalQtyInOrder) {
		this.totalQtyInOrder = totalQtyInOrder;
	}

	public Currency getWholeSalePrice() {
		return wholeSalePrice;
	}

	public void setWholeSalePrice(Currency wholeSalePrice) {
		this.wholeSalePrice = wholeSalePrice;
	}

	public Currency getRetailPrice() {
		return retailPrice;
	}

	public void setRetailPrice(Currency retailPrice) {
		this.retailPrice = retailPrice;
	}

	public List<GarmentUPC> getGarmentUPCs() {
		return garmentUPCs;
	}

	public void setGarmentUPCs(List<GarmentUPC> garmentUPCs) {
		this.garmentUPCs = garmentUPCs;
	}
	 		

}
