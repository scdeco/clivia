package com.scdeco.daotest;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.scdeco.dao.EmployeeDao;
import com.scdeco.model.Employee;
import com.scdeco.service.LoginService;

public class GenericDaoTest {

	private static EmployeeDao employeeDao;
	private static ClassPathXmlApplicationContext context;
	
	//use @BeforeClass to manage expensive resource,run once only
	@BeforeClass
	public static void setUpClass() throws Exception {
		context=new ClassPathXmlApplicationContext("spring-miniata.xml") ;//CliviaUtils.getContext();
		employeeDao=(EmployeeDao) context.getBean("employeeDao");
//		List<Employee> list=employeeDao.findList();
//		employeeDao.deleteAll(list);
	}
	
	//use @Before to setup, repeat for every @Test method
	@Before
	public void setUp(){
	}
	
	@Test
	public void testSaveEmployee() {
		
		Employee emp1=new Employee();
		
		emp1.setFirstName("Jingguo");
		emp1.setLastName("Zhang");
		emp1.setAlias("Jacob.Z");
		emp1.setSex("Male");
		emp1.setUsername("zhang");
		emp1.setPassword("123456");
		Calendar date=new GregorianCalendar(1988, 7, 30); 
		emp1.setBirthDate(date.getTime());
		employeeDao.saveOrUpdate(emp1);

		Employee emp2=new Employee();
		emp2.setFirstName("Wingman");
		emp2.setLastName("Chang");
		emp2.setAlias("Ada");
		emp2.setSex("Female");
		emp2.setUsername("ada");
		emp2.setPassword("123");
		date=new GregorianCalendar(1982, 6, 10); 
		emp2.setBirthDate(date.getTime());
		employeeDao.saveOrUpdate(emp2);

		emp1.setAlias("jacob");
		employeeDao.saveOrUpdate(emp1);
		
		List<Employee> list=employeeDao.findList();
		for(Employee emp:list){
			System.out.println(emp);
		}
		assertTrue(employeeDao.findByUsername("zhang").getId()>0);
		assertNull(employeeDao.findByUsername("zhan"));
		
		LoginService loginService=(LoginService) context.getBean("loginService");
		Employee emp=loginService.authenticate("zhang","123456");
		assertNotNull(emp);
	}

	@After
	public void tearDown() {
        context.close();
  }	

}
