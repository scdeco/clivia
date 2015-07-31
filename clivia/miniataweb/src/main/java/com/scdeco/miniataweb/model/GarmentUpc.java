package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;


@Entity
public class GarmentUpc {

	@Id
	@GeneratedValue
	private int id;

	@Column(name="GarmentId", nullable = false)	
	private int garmentId;
	
	
	@Column(name="UPCNumber",length=12, unique=true, nullable=false)
	private String upcNumber;

	
	@Column(name="ColourCode",length=10)
	private String colourCode;
	
	@Column(name="Size",length=10)
	private String size;
	
	@Column(name="QtyInStock",length=6)
	private Integer qtyInStock;
	
	@Column(name="QtyInOrder",length=6)
	private Integer qtyInOrder;

	@Column(name="Remark",length=250)
	private String remark;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getGarmentId() {
		return garmentId;
	}

	public void setGarmentId(int garmentId) {
		this.garmentId = garmentId;
	}

	public String getUpcNumber() {
		return upcNumber;
	}

	public void setUpcNumber(String upcNumber) {
		this.upcNumber = upcNumber;
	}

	public String getColourCode() {
		return colourCode;
	}

	public void setColour(String colourCode) {
		this.colourCode = colourCode;
	}

	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
	}

	public Integer getQtyInStock() {
		return qtyInStock;
	}

	public void setQtyInStock(Integer qtyInStock) {
		this.qtyInStock = qtyInStock;
	}

	public Integer getQtyInOrder() {
		return qtyInOrder;
	}

	public void setQtyInOrder(Integer qtyInOrder) {
		this.qtyInOrder = qtyInOrder;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}


	
}
