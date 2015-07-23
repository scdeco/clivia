package com.scdeco.miniataweb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;


@Entity
@Table(name="GarmentUPC")
public class GarmentUPC implements Serializable {

	private static final long serialVersionUID = -7615014970917440040L;

	@Id
	@GeneratedValue
	private int id;

	@Column(name="UPCNumber",length=12, unique=true, nullable=false)
	private String upcNumber;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="GarmentId", nullable = false)	
	private  Garment garment;
	
	@Column(name="Colour",length=50)
	private String colour;
	
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

	public String getUpcNumber() {
		return upcNumber;
	}

	public void setUpcNumber(String upcNumber) {
		this.upcNumber = upcNumber;
	}

	public Garment getGarment() {
		return garment;
	}

	public void setGarment(Garment garment) {
		this.garment = garment;
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
