package com.scdeco.miniataweb.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;

import org.hibernate.annotations.Formula;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.scdeco.miniataweb.util.CliviaLocalDateTimeJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalDateTimeJsonSerializer;

@Entity
public class LibEmbDesignInfo extends CliviaSuperModel {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	@Column(name="OriginalFileName")
	private String originalFileName;
	
	@Column(name="Description")
	private String description;
	
	@Column(name="Size")
	private Integer size;
	
	@JsonSerialize(using=CliviaLocalDateTimeJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateTimeJsonDeserializer.class)
	@Column(name="UploadAt")
	private LocalDateTime uploadAt;
	
	@Column(name="UploadBy")
	private String uploadBy;
	
	@Column(name="Remark")
	private String remark;
	
	@Lob @Basic(fetch=FetchType.EAGER)
	@Column(name="thumbnail")
	private byte[] thumbnail;
	
	@Column(name="FileName")
	private String fileName;
	
	@Column(name="FilePath")
	private String filePath;
	
	@Column(name="DesignNumber",length=10)
	private String designNumber;
	
	@Column(name="CompanyId")
	private Integer companyId;
	
	@Column(name="Width")
	private BigDecimal width;
	
	@Column(name="Height")
	private BigDecimal height;
	
	@Formula("Width*0.03937")
	private BigDecimal widthInch;
	
	@Formula("Height*0.03937")
	private BigDecimal heightInch;
		
	@Column(name="StitchCount")
	private Integer stitchCount;
	
	@Column(name="StepCount")
	private Integer stepCount;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getOriginalFileName() {
		return originalFileName;
	}

	public void setOriginalFileName(String originalFileName) {
		this.originalFileName = originalFileName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Integer getSize() {
		return size;
	}

	public void setSize(Integer size) {
		this.size = size;
	}

	public LocalDateTime getUploadAt() {
		return uploadAt;
	}

	public void setUploadAt(LocalDateTime uploadAt) {
		this.uploadAt = uploadAt;
	}

	public String getUploadBy() {
		return uploadBy;
	}

	public void setUploadBy(String uploadBy) {
		this.uploadBy = uploadBy;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public byte[] getThumbnail() {
		return thumbnail;
	}

	public void setThumbnail(byte[] thumbnail) {
		this.thumbnail = thumbnail;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getDesignNumber() {
		return designNumber;
	}

	public void setDesignNumber(String designNumber) {
		this.designNumber = designNumber;
	}

	public Integer getCompanyId() {
		return companyId;
	}

	public void setCompanyId(Integer companyId) {
		this.companyId = companyId;
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

	public BigDecimal getWidthInch() {
		return widthInch;
	}

	public BigDecimal getHeightInch() {
		return heightInch;
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


}
