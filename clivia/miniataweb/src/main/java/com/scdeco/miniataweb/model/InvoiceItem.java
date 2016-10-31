package com.scdeco.miniataweb.model;

import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class InvoiceItem extends CliviaSuperModel {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	@Column(name="InvoiceId")
	private int invoiceId;
	
	@Column(name="LineNo")
	private int lineNo;	
	
	@Column(name="SnpId")
	private int snpId;
	
	@Column(name="OrderId")
	private int orderId;
	
	@Column(name="OrderBillingItemId")
	private int orderBillingItemId;
	
	@Column(name="OrderNumber", length=20, unique=true, nullable=false)
	private String orderNumber;

	@Column(name="CustomerPO", length=50)
	private String customerPO;
	
	@Column(name="Description")
	private String description;	

	@Column(name="Quantity")
	private BigDecimal quantity;
	
	@Column(name="Price")
	private BigDecimal price;
	
	@Column(name="Amount")
	private BigDecimal amount;
	
	@Column(name="Unit", length=20)
	private String unit;
	
	@Column(name="TaxCode", length=10)
	private String taxCode;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getInvoiceId() {
		return invoiceId;
	}

	public void setInvoiceId(int invoiceId) {
		this.invoiceId = invoiceId;
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

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public int getOrderBillingItemId() {
		return orderBillingItemId;
	}

	public void setOrderBillingItemId(int orderBillingItemId) {
		this.orderBillingItemId = orderBillingItemId;
	}

	public String getOrderNumber() {
		return orderNumber;
	}

	public void setOrderNumber(String orderNumber) {
		this.orderNumber = orderNumber;
	}

	public String getCustomerPO() {
		return customerPO;
	}

	public void setCustomerPO(String customerPO) {
		this.customerPO = customerPO;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public BigDecimal getQuantity() {
		return quantity;
	}

	public void setQuantity(BigDecimal quantity) {
		this.quantity = quantity;
	}

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public String getTaxCode() {
		return taxCode;
	}

	public void setTaxCode(String taxCode) {
		this.taxCode = taxCode;
	}
	
	
}
