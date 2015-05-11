package com.scdeco.dao;

import com.scdeco.model.Employee;

public interface EmployeeDao extends GenericDao<Employee, Integer> {
	Employee findByUsername(String username);  
}
