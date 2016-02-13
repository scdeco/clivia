package com.scdeco.miniataweb.dao;

import java.util.List;


import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.CompanyContact;

@Repository("companyContactDao")
public class CompanyContactDao extends GenericDao<CompanyContact> {
	public List<CompanyContact> findListByCompanyId(Integer companyId) {
		List<CompanyContact> list=this.findList(super.createCriteria().add(Restrictions.eq("companyId", companyId)));
		return list;
	}
}
