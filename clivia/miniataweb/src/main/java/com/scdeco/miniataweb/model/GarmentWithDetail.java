package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class GarmentWithDetail {

	@Id
	@Column(name="upcId")
	private Integer upcId; 
	
	@Column(name="garmentId")
	private Integer garmentId;
		
	@Column(name="StyleNumber",length=20)
	private String styleNumber;

	@Column(name="StyleName", length=50)
	private String styleName;
	
	@Column(name="Brand",length=30)
	private String brand;
	
	@Column(name="UPCNumber",length=12)		//barcode
	private String upcNumber;

	@Column(name="Colour",length=50)
	private String colour;
	
	@Column(name="Size",length=20)
	private String size;
	
	@Column(name="QOH")
	private Integer qoh;
	
	@Column(name="SQ")
	private Integer sq;
	
	@Column(name="PQ")
	private Integer pq;

	public Integer getUpcId() {
		return upcId;
	}
	
	public Integer getGarmentId() {
		return garmentId;
	}

	public String getStyleNumber() {
		return styleNumber;
	}

	public String getStyleName() {
		return styleName;
	}

	public String getBrand() {
		return brand;
	}

	public String getUpcNumber() {
		return upcNumber;
	}

	public String getColour() {
		return colour;
	}

	public String getSize() {
		return size;
	}

	public Integer getQoh() {
		return qoh;
	}

	public Integer getSq() {
		return sq;
	}

	public Integer getPq() {
		return pq;
	}

}
