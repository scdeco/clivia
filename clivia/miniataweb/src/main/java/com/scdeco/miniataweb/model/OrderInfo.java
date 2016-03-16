package com.scdeco.miniataweb.model;

import java.time.LocalDate;
import java.time.LocalTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonSerializer;
import com.scdeco.miniataweb.util.CliviaLocalTimeJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalTimeJsonSerializer;

@Entity
public class OrderInfo {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
		
	@Column(name="OrderNumber", length=20, unique=true, nullable=false)
	private String orderNumber;

	@Column(name="OrderName", length=100)
	private String orderName;
	
	@Column(name="CustomerId")
	private Integer customerId;
	
	@Column(name="Buyer", length=50)
	private String buyer;
	
	@Column(name="CustomerPO", length=50)
	private String customerPO;
	
	@Column(name="OrderStatus")
	private Integer orderStatus;
	
	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name="RequireDate")
	private LocalDate requireDate;
	
	@JsonSerialize(using=CliviaLocalTimeJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalTimeJsonDeserializer.class)
	@Column(name="RequireTime")
	private LocalTime requireTime;
	
	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name="OrderDate")
	private LocalDate orderDate;
	
	@JsonSerialize(using=CliviaLocalTimeJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalTimeJsonDeserializer.class)
	@Column(name="OrderTime")
	private LocalTime orderTime;

	@Column(name="CreateBy")
	private Integer createBy;

	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name="FinishDate")
	private LocalDate finishDate;
	
	@Column(name="FinishBy")
	private Integer finishBy;
	
	
	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name="InvoiceDate")
	private LocalDate invoiceDate;
	
	@Column(name="InvoiceBy")
	private Integer invoiceBy;

	@Column(name="RepId")
	private Integer repId;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getOrderNumber() {
		return orderNumber;
	}

	public void setOrderNumber(String orderNumber) {
		this.orderNumber = orderNumber;
	}

	public String getOrderName() {
		return orderName;
	}

	public void setOrderName(String orderName) {
		this.orderName = orderName;
	}

	public Integer getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}

	public String getBuyer() {
		return buyer;
	}

	public void setBuyer(String buyer) {
		this.buyer = buyer;
	}

	public String getCustomerPO() {
		return customerPO;
	}

	public void setCustomerPO(String customerPO) {
		this.customerPO = customerPO;
	}

	public Integer getOrderStatus() {
		return orderStatus;
	}

	public void setOrderStatus(Integer orderStatus) {
		this.orderStatus = orderStatus;
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

	public LocalDate getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(LocalDate orderDate) {
		this.orderDate = orderDate;
	}

	public LocalTime getOrderTime() {
		return orderTime;
	}

	public void setOrderTime(LocalTime orderTime) {
		this.orderTime = orderTime;
	}

	public Integer getCreateBy() {
		return createBy;
	}

	public void setCreateBy(Integer createBy) {
		this.createBy = createBy;
	}

	public LocalDate getFinishDate() {
		return finishDate;
	}

	public void setFinishDate(LocalDate finishDate) {
		this.finishDate = finishDate;
	}

	public Integer getFinishBy() {
		return finishBy;
	}

	public void setFinishBy(Integer finishBy) {
		this.finishBy = finishBy;
	}

	public LocalDate getInvoiceDate() {
		return invoiceDate;
	}

	public void setInvoiceDate(LocalDate invoiceDate) {
		this.invoiceDate = invoiceDate;
	}

	public Integer getInvoiceBy() {
		return invoiceBy;
	}

	public void setInvoiceBy(Integer invoiceBy) {
		this.invoiceBy = invoiceBy;
	}

	public Integer getRepId() {
		return repId;
	}

	public void setRepId(Integer repId) {
		this.repId = repId;
	}
	

}
