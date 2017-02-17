package com.scdeco.miniataweb.dao;

import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.Employee;

@Repository ("employeeDao")
public class EmployeeDao extends GenericItemSetDao<Employee>{
	
	protected void initItemSet() throws NoSuchFieldException, SecurityException{
		IdDependentItem mainItem=new IdDependentItem(super.mainEntityClass,"info","employeeInfo","employeeId");
		super.setMainItem(mainItem);
	}	
}
