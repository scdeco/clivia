package com.scdeco.miniataweb.dao;
 
import com.scdeco.miniataweb.model.Employee;

public interface EmployeeDao extends GenericDao<Employee, Integer> {
	Employee findByUsername(String username);  
}
