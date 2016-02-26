package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;


@Entity
public class GarmentUpc {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	@Column(name="GarmentId", nullable = false)	
	private int garmentId;
	
	@Column(name="UPCNo",length=12)		//barcode
	private String upcNo;

	@Column(name="Colour",length=50,nullable=false)
	private String colour;
	
	@Column(name="Size",length=20,nullable=false)
	private String size;
	
	@Column(name="QOH")
	private Integer qoh;
	
	@Column(name="SQ")
	private Integer sq;
	
	@Column(name="PQ")
	private Integer pq;
	
	@Column(name="Remark",length=250)
	private String remark;

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

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}


	
}
