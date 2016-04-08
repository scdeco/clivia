package com.scdeco.miniataweb.model;

import java.time.LocalDate;
import java.time.LocalTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonSerializer;
import com.scdeco.miniataweb.util.CliviaLocalTimeJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalTimeJsonSerializer;

@Entity
public class OrderInfoView {
	
	@Id
	@Column(name = "orderId", nullable = false)
	private int orderId;

	@Column(name = "buyer", length = 50)
	private String buyer;

	@Column(name = "creatorId")
	private Integer creatorId;

	@Column(name = "customerId")
	private Integer customerId;

	@Column(name = "customerPO", length = 50)
	private String customerPo;

	@Column(name = "finishBy")
	private Integer finishBy;

	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name = "finishDate", length = 10)
	private LocalDate finishDate;

	@Column(name = "invoiceBy")
	private Integer invoiceBy;

	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name = "invoiceDate", length = 10)
	private LocalDate invoiceDate;

	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name = "orderDate", length = 10)
	private LocalDate orderDate;

	@Column(name = "orderName", length = 100)
	private String orderName;

	@Column(name = "orderNumber", nullable = false, length = 20)
	private String orderNumber;

	@Column(name = "orderStatus")
	private Integer orderStatus;

	@JsonSerialize(using=CliviaLocalTimeJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalTimeJsonDeserializer.class)
	@Column(name = "orderTime", length = 8)
	private LocalTime orderTime;

	@Column(name = "repId")
	private Integer repId;

	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name = "requireDate", length = 10)
	private LocalDate requireDate;

	@JsonSerialize(using=CliviaLocalTimeJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalTimeJsonDeserializer.class)
	@Column(name = "requireTime", length = 8)
	private LocalTime requireTime;

	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name="CancelDate")
	private LocalDate cancelDate;
	
	
	@Column(name = "businessName", length = 100)
	private String businessName;

	@Column(name = "creator", length = 511)
	private String creator;

	@Column(name = "rep", length = 511)
	private String rep;

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public String getBuyer() {
		return buyer;
	}

	public void setBuyer(String buyer) {
		this.buyer = buyer;
	}

	public Integer getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(Integer creatorId) {
		this.creatorId = creatorId;
	}

	public Integer getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}

	public String getCustomerPo() {
		return customerPo;
	}

	public void setCustomerPo(String customerPo) {
		this.customerPo = customerPo;
	}

	public Integer getFinishBy() {
		return finishBy;
	}

	public void setFinishBy(Integer finishBy) {
		this.finishBy = finishBy;
	}

	public LocalDate getFinishDate() {
		return finishDate;
	}

	public void setFinishDate(LocalDate finishDate) {
		this.finishDate = finishDate;
	}

	public Integer getInvoiceBy() {
		return invoiceBy;
	}

	public void setInvoiceBy(Integer invoiceBy) {
		this.invoiceBy = invoiceBy;
	}

	public LocalDate getInvoiceDate() {
		return invoiceDate;
	}

	public void setInvoiceDate(LocalDate invoiceDate) {
		this.invoiceDate = invoiceDate;
	}

	public LocalDate getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(LocalDate orderDate) {
		this.orderDate = orderDate;
	}

	public String getOrderName() {
		return orderName;
	}

	public void setOrderName(String orderName) {
		this.orderName = orderName;
	}

	public String getOrderNumber() {
		return orderNumber;
	}

	public void setOrderNumber(String orderNumber) {
		this.orderNumber = orderNumber;
	}

	public Integer getOrderStatus() {
		return orderStatus;
	}

	public void setOrderStatus(Integer orderStatus) {
		this.orderStatus = orderStatus;
	}

	public LocalTime getOrderTime() {
		return orderTime;
	}

	public void setOrderTime(LocalTime orderTime) {
		this.orderTime = orderTime;
	}

	public Integer getRepId() {
		return repId;
	}

	public void setRepId(Integer repId) {
		this.repId = repId;
	}

	public LocalDate getRequireDate() {
		return requireDate;
	}

	public void setRequireDate(LocalDate requireDate) {
		this.requireDate = requireDate;
	}

	public LocalTime getRequireTime() {
		return requireTime;
	}

	public void setRequireTime(LocalTime requireTime) {
		this.requireTime = requireTime;
	}

	public LocalDate getCancelDate() {
		return cancelDate;
	}

	public void setCancelDate(LocalDate cancelDate) {
		this.cancelDate = cancelDate;
	}

	public String getBusinessName() {
		return businessName;
	}

	public void setBusinessName(String businessName) {
		this.businessName = businessName;
	}

	public String getCreator() {
		return creator;
	}

	public void setCreator(String creator) {
		this.creator = creator;
	}

	public String getRep() {
		return rep;
	}

	public void setRep(String rep) {
		this.rep = rep;
	}

}
