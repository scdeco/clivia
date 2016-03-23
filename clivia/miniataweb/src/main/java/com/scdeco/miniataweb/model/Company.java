package com.scdeco.miniataweb.model;

import java.util.List;
import java.util.Map;

public class Company {
	
	CompanyInfo info;
	List<CompanyContact> contactItems;
	List<CompanyAddress> addressItems;
	List<CompanyJournal> journalItems;
	List<Map<String,String>> deleteds;
	
	
	public CompanyInfo getInfo() {
		return info;
	}
	public void setInfo(CompanyInfo info) {
		this.info = info;
	}
	public List<CompanyContact> getContactItems() {
		return contactItems;
	}
	public void setContactItems(List<CompanyContact> contactItems) {
		this.contactItems = contactItems;
	}
	public List<CompanyAddress> getAddressItems() {
		return addressItems;
	}
	public void setAddressItems(List<CompanyAddress> addressItems) {
		this.addressItems = addressItems;
	}
	public List<CompanyJournal> getJournalItems() {
		return journalItems;
	}
	public void setJournalItems(List<CompanyJournal> journalItems) {
		this.journalItems = journalItems;
	}
	public List<Map<String, String>> getDeleteds() {
		return deleteds;
	}
	public void setDeleteds(List<Map<String, String>> deleteds) {
		this.deleteds = deleteds;
	}

}
