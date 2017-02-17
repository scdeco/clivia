package com.scdeco.miniataweb.model;

import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class CompanyInfo  extends CliviaSuperModel{

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
	
	
	@Column(name="RegularInstructions",columnDefinition="TEXT")
	private String regularInstructions;
	
	@Column(name="PricingInstructions",columnDefinition="TEXT")
	private String pricingInstructions;

	@Column(name="cardNum",length=20)
	private String cardNum;

	@Column(name="taxCode",length=60)
	private String taxCode;

	@Column(name="expiryDate",length=10)
	private String expiryDate;
	
	@Column(name="pstExempt",length=60)
	private String pstExempt;
	
	@Column(name="gstExempt",length=60)
	private String gstExempt;
	
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

	public String getRegularInstructions() {
		return regularInstructions;
	}

	public void setRegularInstructions(String regularInstructions) {
		this.regularInstructions = regularInstructions;
	}

	public String getPricingInstructions() {
		return pricingInstructions;
	}

	public void setPricingInstructions(String pricingInstructions) {
		this.pricingInstructions = pricingInstructions;
	}

	public String getCardNum() {
		return cardNum;
	}

	public void setCardNum(String cardNum) {
		this.cardNum = cardNum;
	}

	public String getTaxCode() {
		return taxCode;
	}

	public void setTaxCode(String taxCode) {
		this.taxCode = taxCode;
	}

	public String getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}

	public String getPstExempt() {
		return pstExempt;
	}

	public void setPstExempt(String pstExempt) {
		this.pstExempt = pstExempt;
	}

	public String getGstExempt() {
		return gstExempt;
	}

	public void setGstExempt(String gstExempt) {
		this.gstExempt = gstExempt;
	}



}
