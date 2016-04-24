package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
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
	
	@Column(name="WSPCAD")			//whole sale price in CA$
	private Double wspCad=0.0d;
	
	@Column(name="RRPCAD")			//recommended retail price in CA$
	private Double rrpCad=0.0d;
	
	@Column(name="Used")
	private Boolean used=false;
	
	@Column(name="Remark",length=500)
	private String  remark;

	public int getGarmentId() {
		return garmentId;
	}

	public void setGarmentId(int garmentId) {
		this.garmentId = garmentId;
	}

	public String getStyleNo() {
		return styleNo;
	}

	public void setStyleNo(String styleNo) {
		this.styleNo = styleNo;
	}

	public String getStyleName() {
		return styleName;
	}

	public void setStyleName(String styleName) {
		this.styleName = styleName;
	}

	public int getBrandId() {
		return brandId;
	}

	public void setBrandId(int brandId) {
		this.brandId = brandId;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public int getSeasonId() {
		return seasonId;
	}

	public void setSeasonId(int seasonId) {
		this.seasonId = seasonId;
	}

	public String getSeason() {
		return season;
	}

	public void setSeason(String season) {
		this.season = season;
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

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
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

	public Integer getQoh() {
		return qoh;
	}

	public void setQoh(Integer qoh) {
		this.qoh = qoh;
	}

	public Integer getSq() {
		return sq;
	}

	public void setSq(Integer sq) {
		this.sq = sq;
	}

	public Integer getPq() {
		return pq;
	}

	public void setPq(Integer pq) {
		this.pq = pq;
	}

	public Double getWsp() {
		return wsp;
	}

	public void setWsp(Double wsp) {
		this.wsp = wsp;
	}

	public Double getRrp() {
		return rrp;
	}

	public void setRrp(Double rrp) {
		this.rrp = rrp;
	}

	public Double getWspCad() {
		return wspCad;
	}

	public void setWspCad(Double wspCad) {
		this.wspCad = wspCad;
	}

	public Double getRrpCad() {
		return rrpCad;
	}

	public void setRrpCad(Double rrpCad) {
		this.rrpCad = rrpCad;
	}

	public Boolean getUsed() {
		return used;
	}

	public void setUsed(Boolean used) {
		this.used = used;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}
