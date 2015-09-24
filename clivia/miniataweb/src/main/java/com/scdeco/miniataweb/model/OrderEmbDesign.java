package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

public class OrderEmbDesign {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	@Column(name="OrderId")
	private int orderId;
	
	@Column(name="OrderItemId")
	private int orderItemId;
	
	@Column(name="LineNumber")
	private int lineNumber;
}
