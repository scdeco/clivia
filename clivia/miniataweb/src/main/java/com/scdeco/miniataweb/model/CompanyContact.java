package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import org.hibernate.annotations.Formula;

@Entity
public class CompanyContact {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name="CompanyId")
	private Integer companyId;
	
	@Column(name="LineNo")
	private Integer lineNo;
	
	@Column(name="Title",length=10)
	private String title;
	
	@Column(name="FirstName",length=50,nullable=false)
	private String firstName;
	
	@Column(name="LastName",length=50)
	private String lastName;
	
	@Formula("concat(FirstName,' ',ifnull(LastName,''))")
	private String fullName;
	
	@Column(name="Phone",length=50)
	private String phone;
	
	@Column(name="Email",length=100)
	private String email;
	
	@Column(name="Position",length=20)
	private String position;

	@Column(name="IsBuyer")
	private Boolean isBuyer;

	@Column(name="IsActive")
	private Boolean isActive;
	
	@Column(name="Remark",length=200)
	private String  remark;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Integer getCompanyId() {
		return companyId;
	}

	public void setCompanyId(Integer companyId) {
		this.companyId = companyId;
	}

	public Integer getLineNo() {
		return lineNo;
	}

	public void setLineNo(Integer lineNo) {
		this.lineNo = lineNo;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public Boolean getIsBuyer() {
		return isBuyer;
	}

	public void setIsBuyer(Boolean isBuyer) {
		this.isBuyer = isBuyer;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}


}
