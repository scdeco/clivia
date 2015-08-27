package com.scdeco.miniataweb.model;

import java.math.BigDecimal;

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
	
	@Column(name="LineNumber")
	private int lineNumber;
	
	@Column(name="Brand",length=30)
	private String brand;
	
	@Column(name="StyleNumber",length=20)
	private String styleNumber;
	
	@Column(name="Description",length=200)
	private String description;
	
	@Column(name="Colour",length=50)
	private String colour;
	
	@Column(name="Size",length=20)
	private String size;
	
	@Column(name="Quantity")
	private Integer quantity;
	
	@Column(name="Price",precision=19,scale=2)
	private BigDecimal price;
	
	@Column(name="Amount",precision=19,scale=2)
	private BigDecimal amount;
	
	@Column(name="Remark",length=50)
	private String reamrk;
}
