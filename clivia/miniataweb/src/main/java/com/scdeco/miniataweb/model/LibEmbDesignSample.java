package com.scdeco.miniataweb.model;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;

@Entity
public class LibEmbDesignSample extends CliviaSuperModel{
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;	
	
	@Column(name="LibEmbDesignId")
	private int libEmbDesignId;
	
	@Column(name="RunningSteps")
	private String runningSteps;
	
	@Column(name="Colourway")
	private String colourway;
	
	@Column(name="Remark")
	private String remark;
	
	@Lob @Basic(fetch=FetchType.EAGER)
	@Column(name="Thumbnail")
	private byte[] thumbnail;

	@Column(name="FileName")
	private String imageFileName;
	
	@Column(name="FilePath")
	private String imageFilePath;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getLibEmbDesignId() {
		return libEmbDesignId;
	}

	public void setLibEmbDesignId(int libEmbDesignId) {
		this.libEmbDesignId = libEmbDesignId;
	}

	public String getRunningSteps() {
		return runningSteps;
	}

	public void setRunningSteps(String runningSteps) {
		this.runningSteps = runningSteps;
	}

	public String getColourway() {
		return colourway;
	}

	public void setColourway(String colourway) {
		this.colourway = colourway;
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

	public String getImageFileName() {
		return imageFileName;
	}

	public void setImageFileName(String imageFileName) {
		this.imageFileName = imageFileName;
	}

	public String getImageFilePath() {
		return imageFilePath;
	}

	public void setImageFilePath(String imageFilePath) {
		this.imageFilePath = imageFilePath;
	}	
}
