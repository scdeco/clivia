package com.scdeco.miniataweb.model;

import java.util.List;
import java.util.Map;

public class Employee {
	EmployeeInfo info;
	List<Map<String,String>> deleteds;
	
	public List<Map<String, String>> getDeleteds() {
		return deleteds;
	}

	public void setDeleteds(List<Map<String, String>> deleteds) {
		this.deleteds = deleteds;
	}

	public EmployeeInfo getInfo() {
		return info;
	}

	public void setInfo(EmployeeInfo info) {
		this.info = info;
	}

}
