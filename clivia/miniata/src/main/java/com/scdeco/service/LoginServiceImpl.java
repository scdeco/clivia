package com.scdeco.service;

import com.scdeco.dao.EmployeeDao;
import com.scdeco.model.Employee;
import com.scdeco.util.StringUtils;

public class LoginServiceImpl implements LoginService {
	
	private EmployeeDao employeeDao;

	public void setEmployeeDao(EmployeeDao employeeDao) {
		this.employeeDao = employeeDao;
	}

	private Employee user;
	private boolean isAuthenticated;

	@Override
	public void authenticate(String username, String password) throws RuntimeException{
		
		if (StringUtils.isBlank(username)) throw(new RuntimeException("Username can not be empty."));
		user=employeeDao.findByUsername(username);
		isAuthenticated=user!=null && user.getPassword()==password;
		if(!isAuthenticated) throw(new RuntimeException("Can not find usename or password doesn't match."));
	}
	
	@Override
	public Employee getUser(){
		
		return user;
	}
	
	@Override
	public boolean isAuthenticated(){
		
		return isAuthenticated;
	}

}
