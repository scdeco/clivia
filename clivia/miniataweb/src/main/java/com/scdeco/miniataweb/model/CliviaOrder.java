package com.scdeco.miniataweb.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

@Entity
public class CliviaOrder {
	
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
	
	@JsonSerialize(using=IsoDateJsonSerializer.class)
	@JsonDeserialize(using = IsoDateJsonDeserializer.class)
	@Column(name="RequiredDate")
	private LocalDate requiredDate;
	
	
	@Column(name="RequiredTime")
	private LocalTime requiredTime;

	
	@Column(name="CreatedAt")
	private LocalDateTime createdAt;

	@Column(name="CreatedBy")
	private Integer createdBy;

	
	@Column(name="ModifiedAt")
	private LocalDateTime modifiedAt;
	
	@Column(name="ModifiedBy")
	private Integer modifiedBy;

	
	@Column(name="FinishedAt")
	private LocalDateTime finishedAt;
	
	@Column(name="FinishedBy")
	private Integer finishedBy;
	
	
	@Column(name="InvoicedAt")
	private LocalDateTime invoicedAt;
	
	@Column(name="InvoicedBy")
	private Integer invoicedBy;

	
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


	public LocalDate getRequiredDate() {
		return requiredDate;
	}

	public void setRequiredDate(LocalDate requiredDate) {
		this.requiredDate = requiredDate;
	}

//	@JsonSerialize(using=IsoDateJsonSerializer.class)
	public LocalTime getRequiredTime() {
		return requiredTime;
	}

	public void setRequiredTime(LocalTime requiredTime) {
		this.requiredTime = requiredTime;
	}

//	@JsonSerialize(using=IsoDateJsonSerializer.class)
	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public Integer getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(Integer createdBy) {
		this.createdBy = createdBy;
	}

//	@JsonSerialize(using=IsoDateJsonSerializer.class)
	public LocalDateTime getModifiedAt() {
		return modifiedAt;
	}

	public void setModifiedAt(LocalDateTime modifiedAt) {
		this.modifiedAt = modifiedAt;
	}

	public Integer getModifiedBy() {
		return modifiedBy;
	}

	public void setModifiedBy(Integer modifiedBy) {
		this.modifiedBy = modifiedBy;
	}

	public LocalDateTime getFinishedAt() {
		return finishedAt;
	}

	public void setFinishedAt(LocalDateTime finishedAt) {
		this.finishedAt = finishedAt;
	}

	public Integer getFinishedBy() {
		return finishedBy;
	}

	public void setFinishedBy(Integer finishedBy) {
		this.finishedBy = finishedBy;
	}

	@JsonSerialize(using=IsoDateJsonSerializer.class)
	public LocalDateTime getInvoicedAt() {
		return invoicedAt;
	}

	public void setInvoicedAt(LocalDateTime invoicedAt) {
		this.invoicedAt = invoicedAt;
	}

	public Integer getInvoicedBy() {
		return invoicedBy;
	}

	public void setInvoicedBy(Integer invoicedBy) {
		this.invoicedBy = invoicedBy;
	}
	


	@Override
	public String toString() {
		return "CliviaOrder [id=" + id + ", orderNumber=" + orderNumber
				+ ", orderName=" + orderName + ", customerId=" + customerId
				+ ", buyer=" + buyer + ", customerPO=" + customerPO
				+ ", orderStatus=" + orderStatus + ", requiredDate="
				+ requiredDate + ", requiredTime=" + requiredTime
				+ ", createdAt=" + createdAt + ", createdBy=" + createdBy
				+ ", modifiedAt=" + modifiedAt + ", modifiedBy=" + modifiedBy
				+ ", finishedAt=" + finishedAt + ", finishedBy=" + finishedBy
				+ ", invoicedAt=" + invoicedAt + ", invoicedBy=" + invoicedBy
				+ "]";
	}
	

}
