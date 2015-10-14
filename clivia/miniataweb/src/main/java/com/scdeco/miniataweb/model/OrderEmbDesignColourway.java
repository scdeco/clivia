package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class OrderEmbDesignColourway {
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	@Column(name="OrderId")
	private int orderId;
	
	@Column(name="OrderItemId")
	private int orderItemId;
	
	@Column(name="OrderEmbDesignId")
	private int orderEmbDesignId;
	
	@Column(name="LineNumber")
	private int lineNumber;
	
	@Column(name="Remark", length=255)
	String remark;
	
	@Column(name="libEmbDesignColourwayId")
	private int libEmbDesignColourwayId;

}
