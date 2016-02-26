package com.scdeco.miniataweb.model;

import java.time.LocalDate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonSerializer;

@Entity
public class GarmentTransInfo {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	@Column(name="TransNo", length=20, unique=true, nullable=false)	
	private String transNo;
	
	@Column(name="Brand",length=20)
	private String brand;
	
	
	@Column(name="Description")
	private String description;
	
	@Column(name="IsIn")
	private Boolean isIn;
	
	@Column(name="Type")		//0:Manual, 1:Invoice
	private Integer type;
	
	@Column(name="BatchNo",length=50) 
	private String batchNo;

	@Column(name="Reference", length=50)		//PONo Or SONo
	private String reference;
	
	@Column(name="Packaging",length=50)
	private String packaging;
	
	@Column(name="Location",length=50)  //in only
	private String location;
	
	@Column(name="Remark")
	private String remark;
	
	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name="TransDate")
	private LocalDate transDate;
	
	@Column(name="OperaterUserId")
	private Integer operaterUserId;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTransNo() {
		return transNo;
	}

	public void setTransNo(String transNo) {
		this.transNo = transNo;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	
	public Boolean getIsIn() {
		return isIn;
	}

	public void setIsIn(Boolean isIn) {
		this.isIn = isIn;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public String getBatchNo() {
		return batchNo;
	}

	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}

	public String getReference() {
		return reference;
	}

	public void setReference(String reference) {
		this.reference = reference;
	}

	public String getPackaging() {
		return packaging;
	}

	public void setPackaging(String packaging) {
		this.packaging = packaging;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public LocalDate getTransDate() {
		return transDate;
	}

	public void setTransDate(LocalDate date) {
		this.transDate = date;
	}

	public Integer getOperaterUserId() {
		return operaterUserId;
	}

	public void setOperaterUserId(Integer operaterUserId) {
		this.operaterUserId = operaterUserId;
	}	
}
