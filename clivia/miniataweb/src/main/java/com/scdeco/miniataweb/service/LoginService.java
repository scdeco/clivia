package com.scdeco.miniataweb.service;

import com.scdeco.miniataweb.model.Employee;

public interface LoginService {

	//make sure both username and password are not empty before calling this method. 
	Employee authenticate(String username,String password);
}
