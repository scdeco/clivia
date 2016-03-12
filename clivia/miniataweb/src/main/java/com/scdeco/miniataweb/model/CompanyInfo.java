package com.scdeco.miniataweb.model;

import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class CompanyInfo {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name="BusinessName",length=100,unique=true,nullable=false)
	private String businessName;
	
	@Column(name="Category", length=50)
	private String category;
	
	@Column(name="City",length=30)
	private String city;
	
	@Column(name="Province",length=20)
	private String province;
	
	@Column(name="Country",length=20)
	private String country;
	
	@Column(name="WebSite",length=80)
	private String website;
	
	@Column(name="RepId")
	private Integer repId;
	
	@Column(name="CsrId")
	private Integer csrId;
	
	@Column(name="IsCustomer")
	private Boolean isCustomer=true;
	
	@Column(name="IsSupplier")
	private Boolean isSupplier=false;
	
	@Column(name="UseWSP")
	private Boolean useWsp=true;
	
	@Column(name="Term",length=50)
	private String term;
	
	//peecentage off
	@Column(name="Discount")
	private BigDecimal discount;
	
	@Column(name="Status")
	private Integer status;
	
	@Column(name="SalesNote",columnDefinition="TEXT")
	private String salesNote;
	
	@Column(name="SpecialRequirement",columnDefinition="TEXT")
	private String specialRequirement;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getBusinessName() {
		return businessName;
	}

	public void setBusinessName(String businessName) {
		this.businessName = businessName;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
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

	public String getWebsite() {
		return website;
	}

	public void setWebsite(String website) {
		this.website = website;
	}

	public Integer getRepId() {
		return repId;
	}

	public void setRepId(Integer repId) {
		this.repId = repId;
	}

	public Integer getCsrId() {
		return csrId;
	}

	public void setCsrId(Integer csrId) {
		this.csrId = csrId;
	}

	public Boolean getIsCustomer() {
		return isCustomer;
	}

	public void setIsCustomer(Boolean isCustomer) {
		this.isCustomer = isCustomer;
	}

	public Boolean getIsSupplier() {
		return isSupplier;
	}

	public void setIsSupplier(Boolean isSupplier) {
		this.isSupplier = isSupplier;
	}

	public Boolean getUseWsp() {
		return useWsp;
	}

	public void setUseWsp(Boolean useWsp) {
		this.useWsp = useWsp;
	}

	public String getTerm() {
		return term;
	}

	public void setTerm(String term) {
		this.term = term;
	}

	public BigDecimal getDiscount() {
		return discount;
	}

	public void setDiscount(BigDecimal discount) {
		this.discount = discount;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getSalesNote() {
		return salesNote;
	}

	public void setSalesNote(String salesNote) {
		this.salesNote = salesNote;
	}

	public String getSpecialRequirement() {
		return specialRequirement;
	}

	public void setSpecialRequirement(String specialRequirement) {
		this.specialRequirement = specialRequirement;
	}


}
