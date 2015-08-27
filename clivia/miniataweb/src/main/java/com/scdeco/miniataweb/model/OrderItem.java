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
	
	@Column(name="Type", length=10)
	private String type;
	

}
