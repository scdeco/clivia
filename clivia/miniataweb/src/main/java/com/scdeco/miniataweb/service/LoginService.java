package com.scdeco.miniataweb.service;

import com.scdeco.miniataweb.model.EmployeeInfo;

public interface LoginService {

	//make sure both username and password are not empty before calling this method. 
	EmployeeInfo authenticate(String username,String password);
}
