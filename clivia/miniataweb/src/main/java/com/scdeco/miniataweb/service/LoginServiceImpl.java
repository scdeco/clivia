package com.scdeco.miniataweb.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.scdeco.miniataweb.dao.EmployeeDao;
import com.scdeco.miniataweb.model.Employee;
import com.scdeco.miniataweb.util.CliviaUtils;

@Service ("loginService")
public class LoginServiceImpl implements LoginService {
	
	@Autowired
	private EmployeeDao employeeDao;

	@Override
	public Employee authenticate(String username, String password){

		Employee user=null;
		if (!CliviaUtils.isBlank(username)){
			user=employeeDao.findByUsername(username);
			if(user==null || !password.equals(user.getPassword()))
				user=null;
		}
		return user;
	}
	
}
