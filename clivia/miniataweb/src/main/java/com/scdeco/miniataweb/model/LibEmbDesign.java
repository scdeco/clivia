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
	private Integer customerNumber;
	
	@Column(name="Width")
	private BigDecimal width;
	
	@Column(name="Height")
	private BigDecimal height;
	
	@Column(name="StitcheCount")
	private Integer stitchCount;
	
	@Column(name="StepCount")
	private Integer stepCount;
	

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


	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public String getDesignNumber() {
		return designNumber;
	}


	public void setDesignNumber(String designNumber) {
		this.designNumber = designNumber;
	}


	public String getDesignName() {
		return designName;
	}


	public void setDesignName(String designName) {
		this.designName = designName;
	}


	public Integer getCustomerNumber() {
		return customerNumber;
	}


	public void setCustomerNumber(Integer customerNumber) {
		this.customerNumber = customerNumber;
	}


	public BigDecimal getWidth() {
		return width;
	}


	public void setWidth(BigDecimal width) {
		this.width = width;
	}


	public BigDecimal getHeight() {
		return height;
	}


	public void setHeight(BigDecimal height) {
		this.height = height;
	}


	public Integer getStitchCount() {
		return stitchCount;
	}


	public void setStitchCount(Integer stitchCount) {
		this.stitchCount = stitchCount;
	}


	public Integer getStepCount() {
		return stepCount;
	}


	public void setStepCount(Integer stepCount) {
		this.stepCount = stepCount;
	}


	public String getDstFileName() {
		return dstFileName;
	}


	public void setDstFileName(String dstFileName) {
		this.dstFileName = dstFileName;
	}


	public String getDstFilePath() {
		return dstFilePath;
	}


	public void setDstFilePath(String dstFilePath) {
		this.dstFilePath = dstFilePath;
	}


	public String getEmbFileName() {
		return embFileName;
	}


	public void setEmbFileName(String embFileName) {
		this.embFileName = embFileName;
	}


	public String getEmbFilePath() {
		return embFilePath;
	}


	public void setEmbFilePath(String embFilePath) {
		this.embFilePath = embFilePath;
	}


	public byte[] getThumbnail() {
		return thumbnail;
	}


	public void setThumbnail(byte[] thumbnail) {
		this.thumbnail = thumbnail;
	}

}
