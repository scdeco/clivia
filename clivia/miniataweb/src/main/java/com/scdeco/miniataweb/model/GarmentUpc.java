package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;


@Entity
public class GarmentUpc {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	@Column(name="GarmentId", nullable = false)	
	private int garmentId;
	
	
	@Column(name="UPCNumber",length=12, unique=true, nullable=false)
	private String upcNumber;

	
	@Column(name="Colour",length=50)
	private String colour;
	
	@Column(name="Size",length=20)
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

	public String getColour() {
		return colour;
	}

	public void setColour(String colour) {
		this.colour = colour;
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
