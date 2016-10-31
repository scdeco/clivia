package com.scdeco.miniataweb.model;

import java.time.LocalDate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonSerializer;

@Entity
public class InvoiceInfo extends CliviaSuperModel {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
		
	@Column(name="InvoiceNumber", length=20, unique=true, nullable=false)
	private String invoiceNumber;

	@Column(name="CustomerId")
	private Integer customerId;
	
	@Column(name="Term",length=50)
	private String term;
	
	
	@Column(name="PaymentMethod",length=50)
	private String paymentMethod;
	
	@Column(name="shippingReceiver",length=100)
	private String shippingReceiver;
	
	@Column(name="ShippingAddr1",length=100)
	private String shippingAddr1;
	
	@Column(name="ShippingAddr2",length=100)
	private String shippingAddr2;

	@Column(name="ShippingAttn",length=100)
	private String shippingAttn;
	
	@Column(name="ShippingCity",length=30)
	private String shippingCity;
	
	@Column(name="ShippingProvince",length=20)
	private String shippingProvince;
	
	@Column(name="ShippingCountry",length=20)
	private String shippingCountry;

	@Column(name="ShippingPostalCode",length=10)
	private String shippingPostalCode;


	@Column(name="BillingReceiver",length=100)
	private String billingReceiver;
	
	@Column(name="BillingAddr1",length=100)
	private String billingAddr1;
	
	@Column(name="BillingAddr2",length=100)
	private String billingAddr2;

	@Column(name="BillingAttn",length=100)
	private String billingAttn;
	
	@Column(name="BillingCity",length=30)
	private String billingCity;
	
	@Column(name="BillingProvince",length=20)
	private String billingProvince;
	
	@Column(name="BillingCountry",length=20)
	private String billingCountry;

	@Column(name="BillingPostalCode",length=10)
	private String billingPostalCode;
	
	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name="InvoiceDate")
	private LocalDate invoiceDate;
	
	@Column(name="CreateBy")
	private Integer createBy;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getInvoiceNumber() {
		return invoiceNumber;
	}

	public void setInvoiceNumber(String invoiceNumber) {
		this.invoiceNumber = invoiceNumber;
	}

	public Integer getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}

	public String getTerm() {
		return term;
	}

	public void setTerm(String term) {
		this.term = term;
	}

	public String getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(String paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	public String getShippingReceiver() {
		return shippingReceiver;
	}

	public void setShippingReceiver(String shippingReceiver) {
		this.shippingReceiver = shippingReceiver;
	}

	public String getShippingAddr1() {
		return shippingAddr1;
	}

	public void setShippingAddr1(String shippingAddr1) {
		this.shippingAddr1 = shippingAddr1;
	}

	public String getShippingAddr2() {
		return shippingAddr2;
	}

	public void setShippingAddr2(String shippingAddr2) {
		this.shippingAddr2 = shippingAddr2;
	}

	public String getShippingAttn() {
		return shippingAttn;
	}

	public void setShippingAttn(String shippingAttn) {
		this.shippingAttn = shippingAttn;
	}

	public String getShippingCity() {
		return shippingCity;
	}

	public void setShippingCity(String shippingCity) {
		this.shippingCity = shippingCity;
	}

	public String getShippingProvince() {
		return shippingProvince;
	}

	public void setShippingProvince(String shippingProvince) {
		this.shippingProvince = shippingProvince;
	}

	public String getShippingCountry() {
		return shippingCountry;
	}

	public void setShippingCountry(String shippingCountry) {
		this.shippingCountry = shippingCountry;
	}

	public String getShippingPostalCode() {
		return shippingPostalCode;
	}

	public void setShippingPostalCode(String shippingPostalCode) {
		this.shippingPostalCode = shippingPostalCode;
	}

	public String getBillingReceiver() {
		return billingReceiver;
	}

	public void setBillingReceiver(String billingReceiver) {
		this.billingReceiver = billingReceiver;
	}

	public String getBillingAddr1() {
		return billingAddr1;
	}

	public void setBillingAddr1(String billingAddr1) {
		this.billingAddr1 = billingAddr1;
	}

	public String getBillingAddr2() {
		return billingAddr2;
	}

	public void setBillingAddr2(String billingAddr2) {
		this.billingAddr2 = billingAddr2;
	}

	public String getBillingAttn() {
		return billingAttn;
	}

	public void setBillingAttn(String billingAttn) {
		this.billingAttn = billingAttn;
	}

	public String getBillingCity() {
		return billingCity;
	}

	public void setBillingCity(String billingCity) {
		this.billingCity = billingCity;
	}

	public String getBillingProvince() {
		return billingProvince;
	}

	public void setBillingProvince(String billingProvince) {
		this.billingProvince = billingProvince;
	}

	public String getBillingCountry() {
		return billingCountry;
	}

	public void setBillingCountry(String billingCountry) {
		this.billingCountry = billingCountry;
	}

	public String getBillingPostalCode() {
		return billingPostalCode;
	}

	public void setBillingPostalCode(String billingPostalCode) {
		this.billingPostalCode = billingPostalCode;
	}

	public LocalDate getInvoiceDate() {
		return invoiceDate;
	}

	public void setInvoiceDate(LocalDate invoiceDate) {
		this.invoiceDate = invoiceDate;
	}

	public Integer getCreateBy() {
		return createBy;
	}

	public void setCreateBy(Integer createBy) {
		this.createBy = createBy;
	}

}
