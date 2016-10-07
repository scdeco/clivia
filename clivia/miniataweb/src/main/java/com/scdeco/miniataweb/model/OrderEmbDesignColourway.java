package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class OrderEmbDesignColourway extends CliviaSuperModel{
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	@Column(name="OrderId")
	private int orderId;
	
	@Column(name="OrderItemId")
	private int orderItemId;
	
	@Column(name="OrderEmbDesignId")
	private int orderEmbDesignId;
	
	@Column(name="LineNumber")
	private int lineNumber;

	@Column(name="RunningSteps",length=255)
	private String runningSteps;
	
	@Column(name="Threads",length=100)
	private String threads;
	
	@Column(name="BackgroundColour")
	private String backgroundColour;
	
	@Column(name="Remark", length=255)
	String remark;

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

	public int getOrderEmbDesignId() {
		return orderEmbDesignId;
	}

	public void setOrderEmbDesignId(int orderEmbDesignId) {
		this.orderEmbDesignId = orderEmbDesignId;
	}

	public int getLineNumber() {
		return lineNumber;
	}

	public void setLineNumber(int lineNumber) {
		this.lineNumber = lineNumber;
	}

	public String getRunningSteps() {
		return runningSteps;
	}

	public void setRunningSteps(String runningSteps) {
		this.runningSteps = runningSteps;
	}

	public String getThreads() {
		return threads;
	}

	public void setThreads(String threads) {
		this.threads = threads;
	}

	public String getBackgroundColour() {
		return backgroundColour;
	}

	public void setBackgroundColour(String backgroundColour) {
		this.backgroundColour = backgroundColour;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	

}
