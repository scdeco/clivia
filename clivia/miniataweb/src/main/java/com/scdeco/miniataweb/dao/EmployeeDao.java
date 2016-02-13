package com.scdeco.miniataweb.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.model.Employee;
import com.scdeco.miniataweb.model.EmployeeInfo;

@Repository ("employeeDao")
public class EmployeeDao {
	@Autowired
	private EmployeeInfoDao employeeInfoDao;
	
	public Employee getEmployeeById(int id){
		Employee employee=null;
		EmployeeInfo info=employeeInfoDao.findById(id);
		if(info!=null){
			employee=new Employee();
			employee.setInfo(info);
		}
		return employee;
	}
	
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void save(Employee employee){
		
		EmployeeInfo  info=employee.getInfo();
		
		employeeInfoDao.saveOrUpdate(info);
		
		//int employeeId=info.getId();	
	}
	
	//all dependencies of employee and itself will be deleted
	public String delete(Employee employee) {
		String result="";
		if(employee!=null){
			EmployeeInfo info=employee.getInfo();
			if(info.getId()<=0){
				result="New employee.";
/*			}else if(false){
				result="This company is used and can not delete.";
*/			}else{
				employeeInfoDao.delete(info);
			}
			
		}else{
			result="No company.";
		}
		return result;
	}

	public String delete(int id) {
		String result="";
		Employee employee=getEmployeeById(id);
		if(employee!=null){
			result=this.delete(employee);
		}else{
			result="Can not find this employee.";
		}
		
		return result;
	}	

	
}
