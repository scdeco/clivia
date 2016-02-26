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
public class GarmentTransJournal {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	@Column(name="UpcId", nullable = false)	
	private int upcId;
	
	@Column(name="RefNo")
	private String refNo; 
	
	@Column(name="Type")		//0:manual 1:invoice(out) 2:receipt(in)
	private Integer type;
	
	@Column(name="Quantity")	//+:in,-:out
	private Integer quantity;

	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name="TransDate")
	private LocalDate transDate;
	
	@Column(name="OperaterUserId")
	private Integer operaterUserId;

	@Column(name="Remark")
	private String remark;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getUpcId() {
		return upcId;
	}

	public void setUpcId(int upcId) {
		this.upcId = upcId;
	}

	public String getRefNo() {
		return refNo;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	public LocalDate getTransDate() {
		return transDate;
	}

	public void setTransDate(LocalDate transDate) {
		this.transDate = transDate;
	}

	public Integer getOperaterUserId() {
		return operaterUserId;
	}

	public void setOperaterUserId(Integer operaterUserId) {
		this.operaterUserId = operaterUserId;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}
