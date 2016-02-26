package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class DictGarmentBrand {
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	@Column(name="LineNo")
	private int lineNo;	
	
	@Column(name="Name",length=50)
	private String name;

	@Column(name="ShortName",length=50)
	private String shortName;
	
	@Column(name="HasInventory")
	private Boolean hasInventory;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getLineNo() {
		return lineNo;
	}

	public void setLineNo(int lineNo) {
		this.lineNo = lineNo;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getShortName() {
		return shortName;
	}

	public void setShortName(String shortName) {
		this.shortName = shortName;
	}

	public Boolean getHasInventory() {
		return hasInventory;
	}

	public void setHasInventory(Boolean hasInventory) {
		this.hasInventory = hasInventory;
	}
}
