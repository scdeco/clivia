package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.CompanyAddress;

@Repository("companyAddressDao")
public class CompanyAddressDao extends GenericDao<CompanyAddress> {
	
	public List<CompanyAddress> findListByCompanyId(Integer companyId) {
		List<CompanyAddress> list=this.findList(super.createCriteria().add(Restrictions.eq("companyId", companyId)));
		return list;
	}

	
}
