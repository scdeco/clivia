package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class OrderUpc extends CliviaSuperModel{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	@Column(name="OrderId")
	private int orderId;
	
	@Column(name="upcId")
	private int upcId;
	
	@Column(name="BillingKey", length=20)
	private String billingKey;
	
	@Column(name="OrderQty")
	private Integer orderQty;
	
	@Column(name="DilveredQty")
	private Integer deliveredQty;
	
	@Column(name="CanceledQty")
	private Integer canceledQty;

	@Column(name="RemainQty")
	private Integer remainQty;

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

	public int getUpcId() {
		return upcId;
	}

	public void setUpcId(int upcId) {
		this.upcId = upcId;
	}

	public String getBillingKey() {
		return billingKey;
	}

	public void setBillingKey(String billingKey) {
		this.billingKey = billingKey;
	}

	public Integer getOrderQty() {
		return orderQty;
	}

	public void setOrderQty(Integer orderQty) {
		this.orderQty = orderQty;
	}

	public Integer getDeliveredQty() {
		return deliveredQty;
	}

	public void setDeliveredQty(Integer deliveredQty) {
		this.deliveredQty = deliveredQty;
	}

	public Integer getCanceledQty() {
		return canceledQty;
	}

	public void setCanceledQty(Integer canceledQty) {
		this.canceledQty = canceledQty;
	}

	public Integer getRemainQty() {
		return remainQty;
	}

	public void setRemainQty(Integer remainQty) {
		this.remainQty = remainQty;
	}

}
