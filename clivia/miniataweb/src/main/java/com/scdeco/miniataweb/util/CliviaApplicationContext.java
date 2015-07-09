package com.scdeco.miniataweb.util;


import org.springframework.beans.BeansException;
import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

@Component("cliviaApplicationContext")
public class CliviaApplicationContext implements ApplicationContextAware {
	private  static ApplicationContext ctx; 
    
	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		ctx = applicationContext;
	}

	public static ApplicationContext getApplicationContext() {
		return ctx;
	}
	public  static Object getBean(String name) throws BeansException {
		return ctx.getBean(name);
	}

/*
	public Object getBean(String name, Class requiredType) throws BeansException {
		return applicationContext.getBean(name, requiredType);
	}

*/
	public  static boolean containsBean(String name) {
		return ctx.containsBean(name);
	}


	public  static boolean isSingleton(String name) throws NoSuchBeanDefinitionException {
		return ctx.isSingleton(name);
	}

/*
	public  Class getType(String name) throws NoSuchBeanDefinitionException {
		return applicationContext.getType(name);
	}
*/

	public  static String[] getAliases(String name) throws NoSuchBeanDefinitionException {
		return ctx.getAliases(name);
	}
}
