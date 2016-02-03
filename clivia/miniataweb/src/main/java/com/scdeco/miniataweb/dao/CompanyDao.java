package com.scdeco.miniataweb.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.model.Company;
import com.scdeco.miniataweb.model.CompanyAddress;
import com.scdeco.miniataweb.model.CompanyContact;
import com.scdeco.miniataweb.model.CompanyInfo;
import com.scdeco.miniataweb.model.CompanyJournal;

@Repository ("companyDao")
public class CompanyDao {
	@Autowired
	CompanyInfoDao companyInfoDao;
	
	@Autowired
	CompanyContactDao companyContactDao;
	
	@Autowired
	CompanyAddressDao companyAddressDao;
	
	@Autowired
	CompanyJournalDao companyJournalDao;

	public Company getCompanyById(int id){
		Company company=null;
		CompanyInfo info=companyInfoDao.findById(id);
		if(info!=null){
			company=new Company();
			company.setInfo(info);
			
			company.setContactItems(companyContactDao.findListByCompanyId(id));
			company.setAddressItems(companyAddressDao.findListByCompanyId(id));
			company.setJournalItems(companyJournalDao.findListByCompanyId(id));
		}
		return company;
	}
	
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void save(Company company){
		
		CompanyInfo  info=company.getInfo();
		
		companyInfoDao.saveOrUpdate(info);
		
		int companyId=info.getId();
		
		if(company.getContactDeletedItems()!=null && !company.getContactDeletedItems().isEmpty())
			for(int id:company.getContactDeletedItems()){
				companyContactDao.deleteById(id);
			}
		
		if(company.getAddressDeletedItems()!=null && !company.getAddressDeletedItems().isEmpty())
			for(int id:company.getAddressDeletedItems()){
				companyAddressDao.deleteById(id);
			}

		if(company.getJournalDeletedItems()!=null && !company.getJournalDeletedItems().isEmpty())
			for(int id:company.getJournalDeletedItems()){
				companyJournalDao.deleteById(id);
			}

		if(company.getContactItems()!=null && !company.getContactItems().isEmpty())
			for(CompanyContact contact:company.getContactItems()){
				contact.setCompanyId(companyId);
				companyContactDao.saveOrUpdate(contact);
			}

		if(company.getAddressItems()!=null && !company.getAddressItems().isEmpty())
			for(CompanyAddress address:company.getAddressItems()){
				address.setCompanyId(companyId);
				companyAddressDao.saveOrUpdate(address);
			}		
		
		if(company.getJournalItems()!=null && !company.getJournalItems().isEmpty())
			for(CompanyJournal journal:company.getJournalItems()){
				journal.setCompanyId(companyId);
				companyJournalDao.saveOrUpdate(journal);
			}
		
	}
	
	//all dependencies of company and itself will be deleted
	public String delete(Company company) {
		String result="";
		if(company!=null){
			CompanyInfo info=company.getInfo();
			if(info.getId()<=0){
				result="New company.";
/*			}else if(false){
				result="This company is used and can not delete.";
*/			}else{
				
				if (company.getContactItems()!=null && !company.getContactItems().isEmpty())
					companyContactDao.deleteAll(company.getContactItems());

				if (company.getAddressItems()!=null && !company.getAddressItems().isEmpty())
					companyAddressDao.deleteAll(company.getAddressItems());
				
				if (company.getJournalItems()!=null && !company.getJournalItems().isEmpty())
					companyJournalDao.deleteAll(company.getJournalItems());

				companyInfoDao.delete(info);
			}
			
		}else{
			result="No company.";
		}
		return result;
	}

	
	public String delete(int id) {
		String result="";
		Company company=getCompanyById(id);
		if(company!=null){
			result=this.delete(company);
		}else{
			result="Can not find this company.";
		}
		
		return result;
	}	
	
}
