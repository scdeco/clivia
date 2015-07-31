package com.scdeco.miniataweb.controller;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.GenericDao;
import com.scdeco.miniataweb.util.CliviaApplicationContext;


@Controller
@RequestMapping("/cliviagridvalues")
public class CliviaGridValuesController {
	
    @SuppressWarnings({ "rawtypes" })
	@RequestMapping(value="/{daoName}",method = RequestMethod.GET)
    public  @ResponseBody List<?>  read(@PathVariable String daoName,
    									@RequestParam("value") String value,
    									@RequestParam("text") String text){

    	System.out.println("-------GetDict-----:"+daoName);
		List<ReturnResult> list=new ArrayList<ReturnResult>();
    	
    	GenericDao genericDao=(GenericDao)CliviaApplicationContext.getBean(daoName);
		List<?> items=genericDao.findList();
    	
    	Class entityClass=genericDao.getEntityClass();
		
		try {
			Field valueField=entityClass.getDeclaredField(value);
			valueField.setAccessible(true);
			Field textField=entityClass.getDeclaredField(text);
			textField.setAccessible(true);
			for(Object item:items){
				
				try {
					list.add(new ReturnResult(valueField.get(item),textField.get(item)));
				} catch (IllegalArgumentException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
		} catch (NoSuchFieldException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
    	
        return list; 
    }
    
	@SuppressWarnings("unused")
    private class ReturnResult{
		Object value;
		Object text;
		public ReturnResult(Object value, Object text) {
			this.value = value;
			this.text = text;
		}
		public Object getValue() {
			return value;
		}
		public void setValue(Object value) {
			this.value = value;
		}
		public Object getText() {
			return text;
		}
		public void setText(Object text) {
			this.text = text;
		}
    }    
    
}