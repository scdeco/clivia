package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class CompanyAddress  extends CliviaSuperModel{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name="CompanyId")
	private int companyId=0;

	@Column(name="LineNo")
	private Integer lineNo;

	@Column(name="Receiver",length=100)
	private String receiver;
	
	@Column(name="Addr1",length=100)
	private String addr1;
	
	@Column(name="Addr2",length=100)
	private String addr2;

	@Column(name="Attn",length=100)
	private String attn;
	
	@Column(name="City",length=30)
	private String city;
	
	@Column(name="Province",length=20)
	private String province;
	
	@Column(name="Country",length=20)
	private String country;

	@Column(name="PostalCode",length=10)
	private String postalCode;
	
	@Column(name="status")
	private Integer status;	

	@Column(name="Billing")
	private Boolean billing;
	
	@Column(name="Shipping")
	private Boolean shipping;
	
	@Column(name="Remark",length=200)
	private String  remark;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getCompanyId() {
		return companyId;
	}

	public void setCompanyId(int companyId) {
		this.companyId = companyId;
	}

	public Integer getLineNo() {
		return lineNo;
	}

	public void setLineNo(Integer lineNo) {
		this.lineNo = lineNo;
	}

	public String getReceiver() {
		return receiver;
	}

	public void setReceiver(String receiver) {
		this.receiver = receiver;
	}

	public String getAddr1() {
		return addr1;
	}

	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}

	public String getAddr2() {
		return addr2;
	}

	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}

	public String getAttn() {
		return attn;
	}

	public void setAttn(String attn) {
		this.attn = attn;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public String getPostalCode() {
		return postalCode;
	}

	public void setPostalCode(String postalCode) {
		this.postalCode = postalCode;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Boolean getBilling() {
		return billing;
	}

	public void setBilling(Boolean billing) {
		this.billing = billing;
	}

	public Boolean getShipping() {
		return shipping;
	}

	public void setShipping(Boolean shipping) {
		this.shipping = shipping;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}



}
