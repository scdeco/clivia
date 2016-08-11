package com.scdeco.miniataweb.dao;

import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.Company;

@Repository ("companyDao")
public class CompanyDao extends GenericMainItemDao<Company>{
	
	public CompanyDao(){
		super();
		
		//property names of model Company
		super.registeredItemListNames=new String[]{"contacts","addresses","journals"};
		
		//Dao names of corresponding properties
		super.registeredItemModelNames=new String[]{"companyContact","companyAddress","companyJournal"};
		super.daoPrefix="company";
		
		super.infoItemName="info";
		super.infoDaoName="companyInfo";

		super.mainIdFieldName="companyId";
	}
	
	
	
}
