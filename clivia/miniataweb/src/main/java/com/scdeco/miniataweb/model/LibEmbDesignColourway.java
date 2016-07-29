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
public class LibEmbDesignColourway extends CliviaSuperModel{
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;	
	
	@Column(name="LibEmbDesignId")
	private int libEmbDesignId;
	
	@Column(name="RunningSteps",length=255)
	private String runningSteps;
	
	@Column(name="Threads",length=100)
	private String threads;
	
	@Column(name="BackgroundColour")
	private String backgroundColour;
	
	@Column(name="Remark",length=255)
	private String remark;
	
	@Lob @Basic(fetch=FetchType.EAGER)
	@Column(name="Thumbnail")
	private byte[] thumbnail;

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

	public String getThreads() {
		return threads;
	}

	public void setThreads(String threads) {
		this.threads = threads;
	}

	public String getBackgroundColour() {
		return backgroundColour;
	}

	public void setBackgroundColour(String backgroundColour) {
		this.backgroundColour = backgroundColour;
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
	
}
