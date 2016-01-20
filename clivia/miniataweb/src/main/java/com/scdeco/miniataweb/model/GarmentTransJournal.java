package com.scdeco.miniataweb.model;

import java.time.LocalDate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonSerializer;

@Entity
public class GarmentTransJournal {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	@Column(name="UpcId", nullable = false)	
	private int upcId;
	
	@Column(name="RefNumber")
	private String refNumber; 
	
	@Column(name="Type")		//0:manual 1:invoice(out) 2:receipt(in)
	private Integer type;
	
	@Column(name="Quantity")	//+:in,-:out
	private Integer quantity;

	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name="TransDate")
	private LocalDate transDate;
	
	@Column(name="OperaterUserId")
	private Integer operaterUserId;

	@Column(name="Remark")
	private String remark;
	
}
