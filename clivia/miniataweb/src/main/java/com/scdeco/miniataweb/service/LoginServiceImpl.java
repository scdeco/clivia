package com.scdeco.miniataweb.service;

import org.springframework.beans.factory.annotation.Autowired;

import com.scdeco.miniataweb.dao.EmployeeDao;
import com.scdeco.miniataweb.model.Employee;
import com.scdeco.miniataweb.util.StringUtils;

public class LoginServiceImpl implements LoginService {
	
	@Autowired
	private EmployeeDao employeeDao;

	@Override
	public Employee authenticate(String username, String password){

		Employee user=null;
		if (!StringUtils.isBlank(username)){
			user=employeeDao.findByUsername(username);
			if(user==null || !password.equals(user.getPassword()))
				user=null;
		}
		return user;
	}
	
}
