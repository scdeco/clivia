package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.EmployeeInfo;

@Repository ("employeeInfoDao")
public class EmployeeInfoDao extends GenericDao<EmployeeInfo> {

	public EmployeeInfo findByUsername(String username) {
		List<EmployeeInfo> list=this.findList(super.createCriteria().add(Restrictions.eq("username", username)));
		
		return list.isEmpty()?null:list.get(0);
	}

}
