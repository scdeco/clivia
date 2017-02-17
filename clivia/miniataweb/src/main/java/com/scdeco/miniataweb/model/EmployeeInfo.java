package com.scdeco.miniataweb.model;

import java.time.LocalDate;
import java.time.LocalTime;

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
import com.scdeco.miniataweb.util.CliviaLocalTimeJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalTimeJsonSerializer;


@Entity
public class EmployeeInfo extends CliviaSuperModel{

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
		
	@Column(name="Theme",length=30)
	private String theme;
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getTheme() {
		return theme;
	}

	public void setTheme(String theme) {
		this.theme = theme;
	}

	
	//-----------------------Main Field--------------------------
	@Column(name="FirstName",length=50,nullable=false)
	private String firstName;
	
	@Column(name="LastName",length=50)
	private String lastName;
	
	@Formula("concat(FirstName,' ',ifnull(LastName,''))")
	private String fullName;
	
	@Column(name="empNum",length=50)
	private String empNum;	
	
	@Column(name="Department",length=10)
	private String department;

	@Column(name="Position",length=20)
	private String position;
	
	@Column(name="IsActive")
	private Boolean isActive=true;
	
	@Column(name="IsRep")
	private Boolean isRep=false;
	
	@Column(name="IsCsr")
	private Boolean isCsr=false;
		
	@Column(name="Remark",length=500)
	private String  remark;
	
	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name="HireDate")
	private LocalDate hireDate;
		
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
	
	public String getEmpNum() {
		return empNum;
	}

	public void setEmpNum(String empNum) {
		this.empNum = empNum;
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


	public LocalDate getHireDate() {
		return hireDate;
	}

	public void setHireDate(LocalDate hireDate) {
		this.hireDate = hireDate;
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
	//----------------------------End Main Field-------------------------------
	
	
	//----------------------------Contact Info Field---------------------------
	@Column(name="Address",length=100)
	private String address;
	
	@Column(name="Country",length=20)
	private String country;
	
	@Column(name="Province",length=20)
	private String province;
		
	@Column(name="City",length=30)
	private String city;
	
	@Column(name="PostalCode",length=10)
	private String postalCode;

	@Column(name="Phone",length=50)
	private String phone;	

	@Column(name="Email",length=50)
	private String email;	
	
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
	//----------------------End Contact Info------------------------
	

	
	//------------------------App User Field----------------------
	@Column(name="Username",length=20)
	private String username;
	
	@Column(name="Password",length=20)
	private String password;
	
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
	//-----------------------end User Field--------------------------
	
	//-----------------------Note Field------------------------------
	@Column(name="note",length=300)
	private String note;
	
	public String getNote (){
		return note;
	}
	
	public void setNote (String note){
		this.note = note;
	}
	//-----------------------End Field-------------------------------
	
	
	//-----------------------Salary bar-----------------------------
	@Column(name="workType",length=30)
	private String workType;
	
	@Column(name="salaryAmount",length=30)
	private String salaryAmount;
	
	@JsonSerialize(using=CliviaLocalTimeJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalTimeJsonDeserializer.class)
	@Column(name="startWorkTime")
	private LocalTime startWorkTime;
	
	@JsonSerialize(using=CliviaLocalTimeJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalTimeJsonDeserializer.class)
	@Column(name="endWorkTime")
	private LocalTime endWorkTime;
	
	@Column(name="breakTime",length=30)
	private String breakTime;
	
	public String getWorkType() {
		return workType;
	}

	public void setWorkType(String workType) {
		this.workType = workType;
	}

	public String getSalaryAmount() {
		return salaryAmount;
	}

	public void setSalaryAmount(String salaryAmount) {
		this.salaryAmount = salaryAmount;
	}

	public String getBreakTime() {
		return breakTime;
	}

	public void setBreakTime(String breakTime) {
		this.breakTime = breakTime;
	}

	public LocalTime getStartWorkTime() {
		return startWorkTime;
	}

	public void setStartWorkTime(LocalTime startWorkTime) {
		this.startWorkTime = startWorkTime;
	}

	public LocalTime getEndWorkTime() {
		return endWorkTime;
	}

	public void setEndWorkTime(LocalTime endWorkTime) {
		this.endWorkTime = endWorkTime;
	}

	//----------------------End Salary bar--------------------------

	//----------------------Start Permission bar--------------------
	
	@Column(name="crmPremission",length=10)
	private String crmPremission;
	
	@Column(name="omPremission",length=10)
	private String omPremission;
	
	@Column(name="imPremission",length=10)
	private String imPremission;
	
	@Column(name="dstPremission",length=10)
	private String dstPremission;
	
	@Column(name="hrPremission",length=10)
	private String hrPremission;
	
	@Column(name="ivPremission",length=10)
	private String ivPremission;
	
	@Column(name="spiPremission",length=10)
	private String spiPremission;
	
	@Column(name="pduPremission",length=10)
	private String pduPremission;
	
	@Column(name="salPremission",length=10)
	private String salPremission;
	
	@Column(name="querryPremission",length=10)
	private String querryPremission;
	
	public String getCrmPremission() {
		return crmPremission;
	}

	public void setCrmPremission(String crmPremission) {
		this.crmPremission = crmPremission;
	}

	public String getOmPremission() {
		return omPremission;
	}

	public void setOmPremission(String omPremission) {
		this.omPremission = omPremission;
	}

	public String getImPremission() {
		return imPremission;
	}

	public void setImPremission(String imPremission) {
		this.imPremission = imPremission;
	}

	public String getDstPremission() {
		return dstPremission;
	}

	public void setDstPremission(String dstPremission) {
		this.dstPremission = dstPremission;
	}

	public String getHrPremission() {
		return hrPremission;
	}

	public void setHrPremission(String hrPremission) {
		this.hrPremission = hrPremission;
	}

	public String getIvPremission() {
		return ivPremission;
	}

	public void setIvPremission(String ivPremission) {
		this.ivPremission = ivPremission;
	}

	public String getSpiPremission() {
		return spiPremission;
	}

	public void setSpiPremission(String spiPremission) {
		this.spiPremission = spiPremission;
	}

	public String getPduPremission() {
		return pduPremission;
	}

	public void setPduPremission(String pduPremission) {
		this.pduPremission = pduPremission;
	}

	public String getSalPremission() {
		return salPremission;
	}

	public void setSalPremission(String salPremission) {
		this.salPremission = salPremission;
	}

	public String getQuerryPremission() {
		return querryPremission;
	}

	public void setQuerryPremission(String querryPremission) {
		this.querryPremission = querryPremission;
	}
		
	//----------------------End Permission bar-----------------------
	
}
