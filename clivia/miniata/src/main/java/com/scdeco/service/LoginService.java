package com.scdeco.service;

import com.scdeco.model.Employee;

public interface LoginService {

	void authenticate(String username,String password);
	Employee getUser();
	boolean isAuthenticated();
}
