package com.scdeco.miniataweb.model;

import java.math.BigDecimal;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;

@Entity
public class LibEmbDesign {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;

	@Column(name="DesignNumber",length=10)
	private String designNumber;
	
	@Column(name="DesignName",length=200)
	private String designName;
	
	@Column(name="CustomerNumber")
	private int customerNumber;
	
	@Column(name="Width")
	private BigDecimal width;
	
	@Column(name="Height")
	private BigDecimal height;
	
	@Column(name="StitcheCount")
	private int stitchCount;
	
	@Column(name="StepCount")
	private int stepCount;
	

	@Column(name="DstFileName")
	private String dstFileName;
	
	@Column(name="DstFilePath")
	private String dstFilePath;
	
	@Column(name="EmbFileName")
	private String embFileName;
	
	@Column(name="EmbFilePath")
	private String embFilePath;
	
	
	@Lob @Basic(fetch=FetchType.EAGER)
	@Column(name="Thumbnail")
	private byte[] thumbnail;

}
