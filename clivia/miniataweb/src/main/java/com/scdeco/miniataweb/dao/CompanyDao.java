package com.scdeco.miniataweb.dao;

import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.Company;

@Repository ("companyDao")
public class CompanyDao extends GenericMainItemDao<Company>{
	
	public CompanyDao(){
		super();

		super.registeredItemListNames=new String[]{"contactItems","addressItems","journalItems"};
		super.registeredItemModelNames=new String[]{"companyContact","companyAddress","companyJournal"};
		super.daoPrefix="company";
		
		super.infoItemName="info";
		super.infoDaoName="companyInfo";

		super.mainIdFieldName="companyId";
		
	}
	
}
