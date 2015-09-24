package com.scdeco.miniataweb.model;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.scdeco.miniataweb.util.CliviaLocalDateTimeJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalDateTimeJsonSerializer;

public class LibFile {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	@Column(name="OriginalFileName",length=255)
	private String originalFileName;
	
	@Column(name="Description",length=255)
	private String description;
	
	@JsonSerialize(using=CliviaLocalDateTimeJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateTimeJsonDeserializer.class)
	@Column(name="UploadAt")
	private LocalDateTime uploadAt;
	
	@Column(name="UploadBy", length=50)
	private String uploadBy;
	
	@Column(name="Remark", length=255)
	String remark;
	
}
