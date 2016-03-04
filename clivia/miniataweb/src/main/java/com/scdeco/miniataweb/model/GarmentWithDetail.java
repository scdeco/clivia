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
		
	@Column(name="StyleNo",length=20)
	private String styleNo;

	@Column(name="StyleName", length=50)
	private String styleName;

	@Column(name="BrandId")
	private int brandId;
	
	@Column(name="Brand",length=30)
	private String brand;

	@Column(name="seasonId")
	private int seasonId;
	
	@Column(name="Season",length=30)
	private String season;
	
	
	@Column(name="UPCNo",length=12)		//barcode
	private String upcNo;

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
	
	@Column(name="WSP")			//whole sale price
	private Double wsp;
	
	@Column(name="RRP")			//recommended retail price
	private Double rrp;

	public Integer getUpcId() {
		return upcId;
	}

	public Integer getGarmentId() {
		return garmentId;
	}

	public String getStyleNo() {
		return styleNo;
	}

	public String getStyleName() {
		return styleName;
	}

	public int getBrandId() {
		return brandId;
	}

	public String getBrand() {
		return brand;
	}

	public int getSeasonId() {
		return seasonId;
	}

	public String getSeason() {
		return season;
	}

	public String getUpcNo() {
		return upcNo;
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

	public Double getWsp() {
		return wsp;
	}

	public Double getRrp() {
		return rrp;
	}

}
