package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public final class DictEmbroideryThread {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name="Name",length=20)
	private String name;
	
	@Column(name="Code",length=5)
	private String code; 
	
	@Column(name="Red")
	private Integer red;
	
	@Column(name="Green")
	private Integer green;
	
	@Column(name="Blue")
	private Integer blue;
	
	@Column(name="Available")
	private boolean available;
	
	@Column(name="Used")
	private boolean used;
	
	@Column(name="ColumnInChart")
	private Integer columnInChart ;

	@Column(name="RowInChart")
	private Integer rowInChart ;
	
	@Column(name="Colour")
	private Integer colour;
	
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public Integer getRed() {
		return red;
	}

	public void setRed(Integer red) {
		this.red = red;
	}

	public Integer getGreen() {
		return green;
	}

	public void setGreen(Integer green) {
		this.green = green;
	}

	public Integer getBlue() {
		return blue;
	}

	public void setBlue(Integer blue) {
		this.blue = blue;
	}

	public boolean isAvailable() {
		return available;
	}

	public void setAvailable(boolean available) {
		this.available = available;
	}

	public boolean isUsed() {
		return used;
	}

	public void setUsed(boolean used) {
		this.used = used;
	}

	public Integer getColumnInChart() {
		return columnInChart;
	}

	public void setColumnInChart(Integer columnInChart) {
		this.columnInChart = columnInChart;
	}

	public Integer getRowInChart() {
		return rowInChart;
	}

	public void setRowInChart(Integer rowInChart) {
		this.rowInChart = rowInChart;
	}

	public Integer getColour() {
		return colour;
	}

	public void setColour(Integer colour) {
		this.colour = colour;
	}

}
