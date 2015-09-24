package com.scdeco.miniataweb.model;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.scdeco.miniataweb.util.CliviaLocalDateTimeJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalDateTimeJsonSerializer;

@Entity
public class OrderFile {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	@Column(name="OrderId")
	private int orderId;
	
	@Column(name="OrderItemId")
	private int orderItemId;
	
	@Column(name="LineNumber")
	private int lineNumber;
	
	@Column(name="FileName",length=255)
	String fileName;
	
	@Column(name="Description",length=255)
	String description;
	
	@JsonSerialize(using=CliviaLocalDateTimeJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateTimeJsonDeserializer.class)
	@Column(name="UploadAt")
	LocalDateTime uploadAt;
	
	@Column(name="Remark", length=255)
	String remark;
	
	
}
