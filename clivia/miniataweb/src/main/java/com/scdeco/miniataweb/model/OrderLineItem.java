package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class OrderLineItem {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name="OrderId")
	private int orderId;
	
	@Column(name="OrderItemId")
	private int orderItemId;
	
	@Column(name="OrderLineItemId")
	private int orderLineItemId;
	
	@Column(name="LineNumber")
	private int lineNumber;
	
	@Column(name="Brand",length=30)
	private String brand;
	
	@Column(name="StyleNumber",length=20)
	private String styleNumber;
	
	@Column(name="Description",length=255)
	private String description;
	
	@Column(name="Colour",length=50)
	private String colour;
	
	@Column(name="Size",length=20)
	private String size;

	@Column(name="Qty00")
	private Integer qty00;
	
	@Column(name="Qty01")
	private Integer qty01;

	@Column(name="Qty02")
	private Integer qty02;
	
	@Column(name="Qty03")
	private Integer qty03;
	
	@Column(name="Qty04")
	private Integer qty04;
	
	@Column(name="Qty05")
	private Integer qty05;
	
	@Column(name="Qty06")
	private Integer qty06;
	
	@Column(name="Qty07")
	private Integer qty07;
	
	@Column(name="Qty08")
	private Integer qty08;
	
	@Column(name="Qty09")
	private Integer qty09;
	
	@Column(name="Qty10")
	private Integer qty10;
	
	@Column(name="Qty11")
	private Integer qty11;
	
	@Column(name="Qty12")
	private Integer qty12;
	
	@Column(name="Qty13")
	private Integer qty13;
	
	
	@Column(name="Quantity")
	private Integer quantity;
		
	@Column(name="Remark",length=50)
	private String remark;
	
	
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

	public int getOrderItemId() {
		return orderItemId;
	}

	public void setOrderItemId(int orderItemId) {
		this.orderItemId = orderItemId;
	}

	public int getOrderLineItemId() {
		return orderLineItemId;
	}

	public void setOrderLineItemId(int orderLineItemId) {
		this.orderLineItemId = orderLineItemId;
	}

	public int getLineNumber() {
		return lineNumber;
	}

	public void setLineNumber(int lineNumber) {
		this.lineNumber = lineNumber;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public String getStyleNumber() {
		return styleNumber;
	}

	public void setStyleNumber(String styleNumber) {
		this.styleNumber = styleNumber;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
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

	public Integer getQty00() {
		return qty00;
	}

	public void setQty00(Integer qty00) {
		this.qty00 = qty00;
	}

	public Integer getQty01() {
		return qty01;
	}

	public void setQty01(Integer qty01) {
		this.qty01 = qty01;
	}

	public Integer getQty02() {
		return qty02;
	}

	public void setQty02(Integer qty02) {
		this.qty02 = qty02;
	}

	public Integer getQty03() {
		return qty03;
	}

	public void setQty03(Integer qty03) {
		this.qty03 = qty03;
	}

	public Integer getQty04() {
		return qty04;
	}

	public void setQty04(Integer qty04) {
		this.qty04 = qty04;
	}

	public Integer getQty05() {
		return qty05;
	}

	public void setQty05(Integer qty05) {
		this.qty05 = qty05;
	}

	public Integer getQty06() {
		return qty06;
	}

	public void setQty06(Integer qty06) {
		this.qty06 = qty06;
	}

	public Integer getQty07() {
		return qty07;
	}

	public void setQty07(Integer qty07) {
		this.qty07 = qty07;
	}

	public Integer getQty08() {
		return qty08;
	}

	public void setQty08(Integer qty08) {
		this.qty08 = qty08;
	}

	public Integer getQty09() {
		return qty09;
	}

	public void setQty09(Integer qty09) {
		this.qty09 = qty09;
	}

	public Integer getQty10() {
		return qty10;
	}

	public void setQty10(Integer qty10) {
		this.qty10 = qty10;
	}

	public Integer getQty11() {
		return qty11;
	}

	public void setQty11(Integer qty11) {
		this.qty11 = qty11;
	}

	public Integer getQty12() {
		return qty12;
	}

	public void setQty12(Integer qty12) {
		this.qty12 = qty12;
	}

	public Integer getQty13() {
		return qty13;
	}

	public void setQty13(Integer qty13) {
		this.qty13 = qty13;
	}

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	
}
