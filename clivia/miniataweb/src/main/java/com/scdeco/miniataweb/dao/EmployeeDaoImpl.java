package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;

import com.scdeco.miniataweb.model.Employee;

public class EmployeeDaoImpl extends GenericDaoImpl<Employee, Integer> implements EmployeeDao {

	@Override
	public Employee findByUsername(String username) {
		List<Employee> list=this.findList(super.createCriteria().add(Restrictions.eq("username", username)));
		
		return list.isEmpty()?null:list.get(0);
	}

}
