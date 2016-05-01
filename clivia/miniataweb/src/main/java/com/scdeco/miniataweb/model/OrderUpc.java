package com.scdeco.miniataweb.model;

import java.math.BigDecimal;

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
	
	@Column(name="OrderQty")
	private Integer orderQty;
	
	@Column(name="DilveredQty")
	private Integer deliveredQty;
	
	@Column(name="CanceledQty")
	private Integer canceledQty;

	@Column(name="RemainQty")
	private Integer remainQty;
	
	@Column(name="ListPrice")
	private BigDecimal listPrice;

	//percentage off
	@Column(name="Discount")
	private BigDecimal discount;

	@Column(name="OrderPrice")
	private BigDecimal orderPrice;

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

	public BigDecimal getListPrice() {
		return listPrice;
	}

	public void setListPrice(BigDecimal listPrice) {
		this.listPrice = listPrice;
	}

	public BigDecimal getDiscount() {
		return discount;
	}

	public void setDiscount(BigDecimal discount) {
		this.discount = discount;
	}

	public BigDecimal getOrderPrice() {
		return orderPrice;
	}

	public void setOrderPrice(BigDecimal orderPrice) {
		this.orderPrice = orderPrice;
	}
	
}
