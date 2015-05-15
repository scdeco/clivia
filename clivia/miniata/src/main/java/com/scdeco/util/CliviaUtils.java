package com.scdeco.util;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class CliviaUtils {
	private static ClassPathXmlApplicationContext context=new ClassPathXmlApplicationContext("spring-dao.xml");
	
	public static ClassPathXmlApplicationContext getContext(){
		
		return context;
	}

}
