package com.scdeco.miniataweb.model;

import java.util.List;

public class Company {
	CompanyInfo info;
	List<CompanyContact> contactItems;
	List<CompanyAddress> addressItems;
	List<CompanyJournal> journalItems;
	List<Integer> contactDeletedItems;
	List<Integer> addressDeletedItems;
	List<Integer> journalDeletedItems;
	
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
	public List<Integer> getContactDeletedItems() {
		return contactDeletedItems;
	}
	public void setContactDeletedItems(List<Integer> contactDeletedItems) {
		this.contactDeletedItems = contactDeletedItems;
	}
	public List<Integer> getAddressDeletedItems() {
		return addressDeletedItems;
	}
	public void setAddressDeletedItems(List<Integer> addressDeletedItems) {
		this.addressDeletedItems = addressDeletedItems;
	}
	public List<Integer> getJournalDeletedItems() {
		return journalDeletedItems;
	}
	public void setJournalDeletedItems(List<Integer> journalDeletedItems) {
		this.journalDeletedItems = journalDeletedItems;
	}
	

}
