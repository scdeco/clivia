package com.scdeco.service;

import org.springframework.beans.factory.annotation.Autowired;

import com.scdeco.dao.EmployeeDao;
import com.scdeco.model.Employee;
import com.scdeco.util.StringUtils;

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
