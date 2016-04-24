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
	
	@Column(name="WSPCAD")			//whole sale price in CA$
	private Double wspCad=0.0d;
	
	@Column(name="RRPCAD")			//recommended retail price in CA$
	private Double rrpCad=0.0d;

	public Integer getUpcId() {
		return upcId;
	}

	public void setUpcId(Integer upcId) {
		this.upcId = upcId;
	}

	public Integer getGarmentId() {
		return garmentId;
	}

	public void setGarmentId(Integer garmentId) {
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

	public String getUpcNo() {
		return upcNo;
	}

	public void setUpcNo(String upcNo) {
		this.upcNo = upcNo;
	}

	public String getColour() {
		return colour;
	}

	public void setColour(String colour) {
		this.colour = colour;
	}

	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
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

}
