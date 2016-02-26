package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class GarmentWithInfo {
	@Id
	@Column(name="garmentId")
	private int garmentId;
		
	@Column(name="StyleNo", length=20,unique=true,nullable=false)
	private String styleNo;

	@Column(name="StyleName", length=50)
	private String styleName;
	
	@Column(name="brandId")
	private int brandId;

	@Column(name="brand",length=50)
	private String brand;
	
	@Column(name="seasonId")
	private int seasonId;

	@Column(name="season",length=50)
	private String season;
	
	@Column(name="Description", length=200)
	private String description;
	
	@Column(name="Feature", length=200)
	private String feature;
	
	@Column(name="Keyword", length=100)
	private String keyword;

	@Column(name="Category", length=50)
	private String category;
	
	@Column(name="Colourway",length=250)
	private String colourway;
	
	@Column(name="SizeRange",length=150)
	private String sizeRange;
	
	@Column(name="QOH")			//quantity on hand
	private Integer qoh=0;
	
	@Column(name="SQ")			// sale quantity
	private Integer sq=0;

	@Column(name="PQ")			//purchase quantity
	private Integer pq=0;

	@Column(name="WSP")			//whole sale price
	private Double wsp=0.0d;
	
	@Column(name="RRP")			//recommended retail price
	private Double rrp=0.0d;
	
	@Column(name="Used")
	private Boolean used=false;
	
	@Column(name="Remark",length=500)
	private String  remark;

	public int getGarmentId() {
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

	public String getDescription() {
		return description;
	}

	public String getFeature() {
		return feature;
	}

	public String getKeyword() {
		return keyword;
	}

	public String getCategory() {
		return category;
	}

	public String getColourway() {
		return colourway;
	}

	public String getSizeRange() {
		return sizeRange;
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

	public Boolean getUsed() {
		return used;
	}

	public String getRemark() {
		return remark;
	}
}
