package com.scdeco.miniataweb.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.model.EmployeeInfo;
import com.scdeco.miniataweb.util.CliviaUtils;

@Service ("loginService")
public class LoginServiceImpl implements LoginService {
	
	@Autowired
	private EmployeeInfoDao employeeDao;

	@Override
	public EmployeeInfo authenticate(String username, String password){
		EmployeeInfo user=null;
		if (!CliviaUtils.isBlank(username)){
			user=employeeDao.findByUsername(username);
			if(user==null || !password.equals(user.getPassword()))
				user=null;
		}
		return user;
	}
	
}
