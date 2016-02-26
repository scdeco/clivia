package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

import org.hibernate.annotations.Formula;

@Entity
public class CompanyWithInfo {

	@Id
	@Column(name="id")
	private int id;
	
	@Column(name="BusinessName")
	private String businessName;
	
	@Column(name="Category")
	private String category;
	
	@Column(name="City")
	private String city;
	
	@Column(name="Province")
	private String province;
	
	@Column(name="Country")
	private String country;
	
	@Column(name="WebSite")
	private String website;
	
	@Column(name="RepId")
	private Integer repId;
	
	@Column(name="CsrId")
	private Integer csrId;
	
	@Column(name="IsCustomer")
	private Boolean isCustomer=true;
	
	@Column(name="IsSupplier")
	private Boolean isSupplier=false;
	
	@Column(name="Status")
	private Integer status;
	
	@Column(name="repFirstName")
	private String repFirstName;
	
	@Column(name="repLastName")
	private String repLastName;
	
	@Formula("concat(repFirstName,' ',ifnull(repLastName,''))")
	private String repName;	

	@Column(name="csrFirstName")
	private String csrFirstName;
	
	@Column(name="csrLastName")
	private String csrLastName;
	
	@Formula("concat(csrFirstName,' ',ifnull(csrLastName,''))")
	private String csrName;

	public int getId() {
		return id;
	}

	public String getBusinessName() {
		return businessName;
	}

	public String getCategory() {
		return category;
	}

	public String getCity() {
		return city;
	}

	public String getProvince() {
		return province;
	}

	public String getCountry() {
		return country;
	}

	public String getWebsite() {
		return website;
	}

	public Integer getRepId() {
		return repId;
	}

	public Integer getCsrId() {
		return csrId;
	}

	public Boolean getIsCustomer() {
		return isCustomer;
	}

	public Boolean getIsSupplier() {
		return isSupplier;
	}

	public Integer getStatus() {
		return status;
	}

	public String getRepFirstName() {
		return repFirstName;
	}

	public String getRepLastName() {
		return repLastName;
	}

	public String getRepName() {
		return repName;
	}

	public String getCsrFirstName() {
		return csrFirstName;
	}

	public String getCsrLastName() {
		return csrLastName;
	}

	public String getCsrName() {
		return csrName;
	}	

}
