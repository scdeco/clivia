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
public class LibEmbDesignSample {
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
}
