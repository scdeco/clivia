package com.scdeco.miniataweb.util;


import org.springframework.beans.BeansException;
import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

public class CliviaApplicationContext implements ApplicationContextAware {
	private  ApplicationContext applicationContext; 
    
	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		this.applicationContext = applicationContext;
	}

	public  ApplicationContext getApplicationContext() {
		return this.applicationContext;
	}
	public  Object getBean(String name) throws BeansException {
		return applicationContext.getBean(name);
	}

/*
	public Object getBean(String name, Class requiredType) throws BeansException {
		return applicationContext.getBean(name, requiredType);
	}

*/
	public  boolean containsBean(String name) {
		return applicationContext.containsBean(name);
	}


	public  boolean isSingleton(String name) throws NoSuchBeanDefinitionException {
		return applicationContext.isSingleton(name);
	}

/*
	public  Class getType(String name) throws NoSuchBeanDefinitionException {
		return applicationContext.getType(name);
	}
*/

	public  String[] getAliases(String name) throws NoSuchBeanDefinitionException {
		return applicationContext.getAliases(name);
	}
}
