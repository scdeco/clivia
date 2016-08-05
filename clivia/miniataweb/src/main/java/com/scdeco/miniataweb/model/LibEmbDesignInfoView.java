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
public class LibEmbDesignInfoView {

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

	@Column(name = "CompanyName", length = 100)
	private String companyName;

	public int getId() {
		return id;
	}

	public String getOriginalFileName() {
		return originalFileName;
	}

	public String getDescription() {
		return description;
	}

	public Integer getSize() {
		return size;
	}

	public LocalDateTime getUploadAt() {
		return uploadAt;
	}

	public String getUploadBy() {
		return uploadBy;
	}

	public String getRemark() {
		return remark;
	}

	public byte[] getThumbnail() {
		return thumbnail;
	}

	public String getFileName() {
		return fileName;
	}

	public String getFilePath() {
		return filePath;
	}

	public String getDesignNumber() {
		return designNumber;
	}

	public Integer getCompanyId() {
		return companyId;
	}

	public BigDecimal getWidth() {
		return width;
	}

	public BigDecimal getHeight() {
		return height;
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

	public Integer getStepCount() {
		return stepCount;
	}

	public String getCompanyName() {
		return companyName;
	}

	
	
}
