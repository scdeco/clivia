package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.CompanyJournal;

@Repository("companyJournalDao")
public class CompanyJournalDao extends GenericDao<CompanyJournal> {
	public List<CompanyJournal> findListByCompanyId(Integer companyId) {
		List<CompanyJournal> list=this.findList(super.createCriteria().add(Restrictions.eq("companyId", companyId)));
		return list;
	}
}
