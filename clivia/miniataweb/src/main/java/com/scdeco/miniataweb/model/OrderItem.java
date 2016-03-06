package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class OrderItem {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	@Column(name="OrderId")
	private int orderId;
	
	@Column(name="LineNo")
	private int lineNo;
	
	@Column(name="Title", length=50)
	private String title;
	
	@Column(name="Type", length=20)
	private String type;
	
	@Column(name="Spec", length=255)
	private String spec;

	@Column(name="SpecDetail", length=255)
	private String specDetail;
	
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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
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
