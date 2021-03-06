package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class OrderItem extends CliviaSuperModel{
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	@Column(name="OrderId")
	private int orderId;
	
	@Column(name="LineNo")
	private int lineNo;
	
	@Column(name="Title", length=50)
	private String title;
	
	@Column(name="TypeId", length=20)
	private Integer typeId;
	
	@Column(name="Spec", length=255)
	private String spec;

	@Column(name="SpecDetail", length=255)
	private String specDetail;
	
	//if >0,this item is billable,and bill to the snpId
	@Column(name="snpId")
	private Integer snpId;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public int getLineNo() {
		return lineNo;
	}

	public void setLineNo(int lineNo) {
		this.lineNo = lineNo;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Integer getTypeId() {
		return typeId;
	}

	public void setTypeId(Integer typeId) {
		this.typeId = typeId;
	}

	public String getSpec() {
		return spec;
	}

	public void setSpec(String spec) {
		this.spec = spec;
	}

	public String getSpecDetail() {
		return specDetail;
	}

	public void setSpecDetail(String specDetail) {
		this.specDetail = specDetail;
	}

	public Integer getSnpId() {
		return snpId;
	}

	public void setSnpId(Integer snpId) {
		this.snpId = snpId;
	}

	

}
