package com.scdeco.miniataweb.model;

import java.time.LocalDate;
import java.time.LocalTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonSerializer;
import com.scdeco.miniataweb.util.CliviaLocalTimeJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalTimeJsonSerializer;

@Entity
public class GarmentTransaction {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name="TransNumber")	
	private Integer transNumber;
	
	@Column(name="Description")
	private String description;
	
	@Column(name="Type")		//0:manual, 1:PO, 2:SO
	private Integer type;
	
	@Column(name="BatchNumber",length=50) 
	private String batchNumber;

	@Column(name="Reference", length=50)		//PONumber Or SONumber
	private String reference;

	@Column(name="TotalQty")
	private Integer totalQty;
	
	@Column(name="PackageQty")
	private Integer packageQty;
	
	@Column(name="PackageUnit",length=10)
	private String packageUnit;
	
	@Column(name="Location",length=50)  //in only
	private String location;
	
	@Column(name="Remark")
	private String remark;
	
	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name="Date")
	private LocalDate date;
	
	@JsonSerialize(using=CliviaLocalTimeJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalTimeJsonDeserializer.class)
	@Column(name="Time")
	private LocalTime time;
	
	@Column(name="OperaterUserId")
	private Integer operaterUserId;	
}
