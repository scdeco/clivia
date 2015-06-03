package com.scdeco.service;

import com.scdeco.model.Employee;

public interface LoginService {

	Employee authenticate(String username,String password);
}
