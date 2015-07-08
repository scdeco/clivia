package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.Employee;

@Repository ("employeeDao")
public class EmployeeDaoImpl extends GenericDaoImpl<Employee, Integer> implements EmployeeDao {

	@Override
	public Employee findByUsername(String username) {
		List<Employee> list=this.findList(super.createCriteria().add(Restrictions.eq("username", username)));
		
		return list.isEmpty()?null:list.get(0);
	}

}
