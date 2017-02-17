package com.scdeco.miniataweb.model;

import java.util.List;
import java.util.Map;

public class Company {
	
	CompanyInfo info;
	List<CompanyContact> contacts;
	List<CompanyAddress> addresses;
	List<CompanyJournal> journals;
	List<Map<String,String>> deleteds;
	
	public CompanyInfo getInfo() {
		return info;
	}
	public void setInfo(CompanyInfo info) {
		this.info = info;
	}
	public List<CompanyContact> getContacts() {
		return contacts;
	}
	public void setContacts(List<CompanyContact> contacts) {
		this.contacts = contacts;
	}
	public List<CompanyAddress> getAddresses() {
		return addresses;
	}
	public void setAddresses(List<CompanyAddress> addresses) {
		this.addresses = addresses;
	}

	public List<CompanyJournal> getJournals() {
		return journals;
	}
	public void setJournals(List<CompanyJournal> journals) {
		this.journals = journals;
	}
	public List<Map<String, String>> getDeleteds() {
		return deleteds;
	}
	public void setDeleteds(List<Map<String, String>> deleteds) {
		this.deleteds = deleteds;
	}
	
	
	

}
