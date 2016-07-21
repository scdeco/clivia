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
	
	@Column(name="Colourway",length=100)
	private String colourway;
	
	@Column(name="BackGroundColour")
	private int backGroundColour;
	
	@Column(name="Remark",length=255)
	private String remark;
	
	@Lob @Basic(fetch=FetchType.EAGER)
	@Column(name="Thumbnail")
	private byte[] thumbnail;
	
}
