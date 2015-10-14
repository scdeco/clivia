package com.scdeco.miniataweb.model;

import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class OrderPricingItem {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name="OrderId")
	private int orderId;
	
	@Column(name="OrderItemId")
	private int orderItemId;
	
	@Column(name="OrderPricingItemId")
	private int orderPricingItemId;
	
	
	@Column(name="LineNumber")
	private int lineNumber;	
	
	@Column(name="IosId")
	private int iosId;
	
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
	

}
