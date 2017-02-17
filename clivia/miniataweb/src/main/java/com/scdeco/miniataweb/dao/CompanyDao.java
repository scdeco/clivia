package com.scdeco.miniataweb.dao;

import org.springframework.context.annotation.DependsOn;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.Company;


@Repository ("companyDao")
@DependsOn({"companyInfoDao", "companyContactDao","companyAddressDao","companyJournalDao"})
public class CompanyDao extends GenericItemSetDao<Company>{
	
	protected void initItemSet() throws NoSuchFieldException, SecurityException{
		
		
		IdDependentItem mainItem=new IdDependentItem(super.mainEntityClass,"info","companyInfo","companyId");
		
		IdDependentItem contact=new IdDependentItem(super.mainEntityClass,"contacts","companyContact","");
		IdDependentItem address=new IdDependentItem(super.mainEntityClass,"addresses","companyAddress","");
		IdDependentItem journal=new IdDependentItem(super.mainEntityClass,"journals","companyJournal","");
		
		mainItem.dependentItems.add(contact);
		mainItem.dependentItems.add(address);
		mainItem.dependentItems.add(journal);
		super.setMainItem(mainItem);
	}
	
	
}
