package com.scdeco.miniataweb.model;

import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class OrderBillItem {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name="OrderId")
	private int orderId;
	
	@Column(name="OrderItemId")
	private int orderItemId;
	
	@Column(name="LineNo")
	private int lineNo;	
	
	@Column(name="snpId")
	private int snpId;
	
	@Column(name="ItemNumber", length=20)
	private String itemNumber;
	
	@Column(name="Description")
	private String description;	
	
	@Column(name="OrderQty")
	private  BigDecimal orderQty;
	
	@Column(name="FinishQty")
	private BigDecimal finishQty;
	
	@Column(name="InvoiceQty")
	private BigDecimal invoiceQty;
	
	@Column(name="Unit", length=20)
	private String unit;
	
	@Column(name="OrderPrice")
	private BigDecimal orderPrice;
	
	@Column(name="InvoicePrice")
	private BigDecimal invoicePrice;
	
	@Column(name="OrderAmt")
	private BigDecimal orderAmt;
	
	@Column(name="FinishAmt")
	private BigDecimal finishAmt;
	
	@Column(name="InvoiceAmt")
	private BigDecimal invoiceAmt;
	
	@Column(name="Remark")
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

	public int getLineNo() {
		return lineNo;
	}

	public void setLineNo(int lineNo) {
		this.lineNo = lineNo;
	}

	public int getSnpId() {
		return snpId;
	}

	public void setSnpId(int snpId) {
		this.snpId = snpId;
	}

	public String getItemNumber() {
		return itemNumber;
	}

	public void setItemNumber(String itemNumber) {
		this.itemNumber = itemNumber;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public BigDecimal getOrderQty() {
		return orderQty;
	}

	public void setOrderQty(BigDecimal orderQty) {
		this.orderQty = orderQty;
	}

	public BigDecimal getFinishQty() {
		return finishQty;
	}

	public void setFinishQty(BigDecimal finishQty) {
		this.finishQty = finishQty;
	}

	public BigDecimal getInvoiceQty() {
		return invoiceQty;
	}

	public void setInvoiceQty(BigDecimal invoiceQty) {
		this.invoiceQty = invoiceQty;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public BigDecimal getOrderPrice() {
		return orderPrice;
	}

	public void setOrderPrice(BigDecimal orderPrice) {
		this.orderPrice = orderPrice;
	}

	public BigDecimal getInvoicePrice() {
		return invoicePrice;
	}

	public void setInvoicePrice(BigDecimal invoicePrice) {
		this.invoicePrice = invoicePrice;
	}

	public BigDecimal getOrderAmt() {
		return orderAmt;
	}

	public void setOrderAmt(BigDecimal orderAmt) {
		this.orderAmt = orderAmt;
	}

	public BigDecimal getFinishAmt() {
		return finishAmt;
	}

	public void setFinishAmt(BigDecimal finishAmt) {
		this.finishAmt = finishAmt;
	}

	public BigDecimal getInvoiceAmt() {
		return invoiceAmt;
	}

	public void setInvoiceAmt(BigDecimal invoiceAmt) {
		this.invoiceAmt = invoiceAmt;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}
