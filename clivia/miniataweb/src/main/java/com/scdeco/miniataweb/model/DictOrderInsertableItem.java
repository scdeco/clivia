package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class DictOrderInsertableItem {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name="LineNumber")
	private int lineNumber;	
	
	//corresponding to a menu item of insertable items
	@Column(name="Text", length=50)
	private String text;
	
	@Column(name="MenuId", length=50)
	private String menuId;
	
	@Column(name="Spec", length=50)
	private String spec;
	
	//correspongding to a dataTable in dataSet 
	@Column(name="ItemType", length=50)
	private String itemType;
	
	@Column(name="Seperator")
	private Boolean seperator;
	
	@Column(name="State", length=50)
	private String state;
	
	@Column(name="Detailable")
	private Boolean detailable;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getMenuId() {
		return menuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}

	public String getSpec() {
		return spec;
	}

	public void setSpec(String spec) {
		this.spec = spec;
	}

	public String getItemType() {
		return itemType;
	}

	public void setItemType(String itemType) {
		this.itemType = itemType;
	}

	

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}
	
	public Boolean isSeperator() {
		return seperator;
	}

	public void setSeperator(Boolean seperator) {
		this.seperator = seperator;
	}

	public Boolean isDetailable() {
		return detailable;
	}

	public void setDetailable(Boolean detailable) {
		this.detailable = detailable;
	}



	public int getLineNumber() {
		return lineNumber;
	}

	public void setLineNumber(int lineNumber) {
		this.lineNumber = lineNumber;
	}

	public Boolean getSeperator() {
		return seperator;
	}

	public Boolean getDetailable() {
		return detailable;
	}

	@Override
	public String toString() {
		return "DictOrderInsertableItem [id=" + id + ", text=" + text
				+ ", menuId=" + menuId + ", spec=" + spec + ", itemType="
				+ itemType + ", seperator=" + seperator + ", state=" + state
				+ ", detailable=" + detailable + "]";
	}
}
