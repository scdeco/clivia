package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class OrderServiceEmb extends CliviaSuperModel {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name="OrderId")
	private int orderId;
	
	@Column(name="OrderItemId")
	private int orderItemId;

	@Column(name="LineItemId")
	private int lineItemId;
	
	@Column(name="LineNo")
	private int lineNo;	
	
	@Column(name="Location",length=100)
	private String location;
	
	@Column(name="designId")
	private int designId;
 
	@Column(name="DesignNo",length=50)
	private String designNo;
	
	@Column(name="DesignName",length=50)
	private String designName;
	
	@Column(name="StitchCount")
	private int stitchCount;
	
	@Column(name="ColourCount")
	private int colourCount;
	
	@Column(name="ThreadCode",length=100)
	private String threadCode;
	
	@Column(name="RunningStep",length=300)
	private String runningStep;
	
	@Column(name="colourValue",length=130)
	private String colourValue;

	@Column(name="Remark",length=50)
	private String remark;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public int getOrderItemId() {
		return orderItemId;
	}

	public void setOrderItemId(int orderItemId) {
		this.orderItemId = orderItemId;
	}

	public int getLineItemId() {
		return lineItemId;
	}

	public void setLineItemId(int lineItemId) {
		this.lineItemId = lineItemId;
	}

	public int getLineNo() {
		return lineNo;
	}

	public void setLineNo(int lineNo) {
		this.lineNo = lineNo;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public int getDesignId() {
		return designId;
	}

	public void setDesignId(int designId) {
		this.designId = designId;
	}

	public String getDesignNo() {
		return designNo;
	}

	public void setDesignNo(String designNo) {
		this.designNo = designNo;
	}

	public String getDesignName() {
		return designName;
	}

	public void setDesignName(String designName) {
		this.designName = designName;
	}

	public int getStitchCount() {
		return stitchCount;
	}

	public void setStitchCount(int stitchCount) {
		this.stitchCount = stitchCount;
	}

	public int getColourCount() {
		return colourCount;
	}

	public void setColourCount(int colourCount) {
		this.colourCount = colourCount;
	}

	public String getThreadCode() {
		return threadCode;
	}

	public void setThreadCode(String threadCode) {
		this.threadCode = threadCode;
	}

	public String getRunningStep() {
		return runningStep;
	}

	public void setRunningStep(String runningStep) {
		this.runningStep = runningStep;
	}

	public String getColourValue() {
		return colourValue;
	}

	public void setColourValue(String colourValue) {
		this.colourValue = colourValue;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}


	
}