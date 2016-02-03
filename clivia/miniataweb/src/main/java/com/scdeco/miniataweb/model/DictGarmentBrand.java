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
	
	@Column(name="LineNumber")
	private int lineNumber;	
	
	@Column(name="Name",length=50)
	private String name;
	
	@Column(name="SizeFields",length=100)
	private String sizeFields;
	
	@Column(name="SizeTitles",length=100)
	private String sizeTitles;
	
	@Column(name="SizeTypes")
	private String sizeTypes;
	
	@Column(name="SizeTypeFields")
	private String sizeTypeFields;
	
	@Column(name="Categories",length=500)
	private String categories;

	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getLineNumber() {
		return lineNumber;
	}

	public void setLineNumber(int lineNumber) {
		this.lineNumber = lineNumber;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSizeFields() {
		return sizeFields;
	}

	public void setSizeFields(String sizeFields) {
		this.sizeFields = sizeFields;
	}

	public String getSizeTitles() {
		return sizeTitles;
	}

	public void setSizeTitles(String sizeTitles) {
		this.sizeTitles = sizeTitles;
	}

	public String getSizeTypes() {
		return sizeTypes;
	}

	public void setSizeTypes(String sizeTypes) {
		this.sizeTypes = sizeTypes;
	}

	public String getSizeTypeFields() {
		return sizeTypeFields;
	}

	public void setSizeTypeFields(String sizeTypeFields) {
		this.sizeTypeFields = sizeTypeFields;
	}

	public String getCategories() {
		return categories;
	}

	public void setCategories(String categories) {
		this.categories = categories;
	}

	
	
	
	
	
	
	

}
