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

	@Column(name = "businessName", length = 100)
	private String businessName;

	@Column(name = "creator", length = 511)
	private String creator;

	@Column(name = "rep", length = 511)
	private String rep;

	public int getOrderId() {
		return orderId;
	}

	public String getBuyer() {
		return buyer;
	}

	public Integer getCreatorId() {
		return creatorId;
	}

	public Integer getCustomerId() {
		return customerId;
	}

	public String getCustomerPo() {
		return customerPo;
	}

	public Integer getFinishBy() {
		return finishBy;
	}

	public LocalDate getFinishDate() {
		return finishDate;
	}

	public Integer getInvoiceBy() {
		return invoiceBy;
	}

	public LocalDate getInvoiceDate() {
		return invoiceDate;
	}

	public LocalDate getOrderDate() {
		return orderDate;
	}

	public String getOrderName() {
		return orderName;
	}

	public String getOrderNumber() {
		return orderNumber;
	}

	public Integer getOrderStatus() {
		return orderStatus;
	}

	public LocalTime getOrderTime() {
		return orderTime;
	}

	public Integer getRepId() {
		return repId;
	}

	public LocalDate getRequireDate() {
		return requireDate;
	}

	public LocalTime getRequireTime() {
		return requireTime;
	}

	public String getBusinessName() {
		return businessName;
	}

	public String getCreator() {
		return creator;
	}

	public String getRep() {
		return rep;
	}
}
