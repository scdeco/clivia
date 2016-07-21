package com.scdeco.miniataweb.model;

import java.time.LocalDate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import org.hibernate.annotations.Formula;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonSerializer;


@Entity
public class EmployeeInfo extends CliviaSuperModel{

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name="FirstName",length=50,nullable=false)
	private String firstName;
	
	@Column(name="LastName",length=50)
	private String lastName;
	
	@Formula("concat(FirstName,' ',ifnull(LastName,''))")
	private String fullName;
	
	@Column(name="Department",length=10)
	private String department;

	@Column(name="Position",length=20)
	private String position;
	
	@Column(name="Address",length=100)
	private String address;
	
	@Column(name="City",length=30)
	private String city;
	
	@Column(name="Province",length=20)
	private String province;
	
	@Column(name="Country",length=20)
	private String country;

	@Column(name="PostalCode",length=10)
	private String postalCode;

	@Column(name="Phone",length=50)
	private String phone;	

	@Column(name="Email",length=50)
	private String email;	

	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name="HireDate")
	private LocalDate hireDate;
	
	@Column(name="Username",length=20)
	private String username;
	
	@Column(name="Password",length=20)
	private String password;
	
	@Column(name="IsActive")
	private Boolean isActive=true;
	
	@Column(name="IsRep")
	private Boolean isRep=false;
	
	@Column(name="IsCsr")
	private Boolean isCsr=false;
	
	@Column(name="Remark",length=500)
	private String  remark;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
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

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
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

	public LocalDate getHireDate() {
		return hireDate;
	}

	public void setHireDate(LocalDate hireDate) {
		this.hireDate = hireDate;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	public Boolean getIsRep() {
		return isRep;
	}

	public void setIsRep(Boolean isRep) {
		this.isRep = isRep;
	}

	public Boolean getIsCsr() {
		return isCsr;
	}

	public void setIsCsr(Boolean isCsr) {
		this.isCsr = isCsr;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}



}
