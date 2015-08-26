package com.scdeco.miniataweb.controller;

import java.lang.reflect.Field;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.GenericDao;
import com.scdeco.miniataweb.util.CliviaApplicationContext;
import com.scdeco.miniataweb.util.DataSourceRequest;
import com.scdeco.miniataweb.util.DataSourceResult;

@Controller
@RequestMapping("/data/*")
public class DataController {

	
	
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/read",method = RequestMethod.GET)
    public  @ResponseBody  List  get(@PathVariable String daoName){
    	
    	
       return ((GenericDao)CliviaApplicationContext.getBean(daoName)).findList();
    }
	
	
	
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/read",method = RequestMethod.POST)
    public  @ResponseBody  DataSourceResult  read(@RequestBody DataSourceRequest request,@PathVariable String daoName){
    	System.out.println("request:"+request);
    	DataSourceResult result=((GenericDao)CliviaApplicationContext.getBean(daoName)).findListByRequest(request);
       return result;
    }

    
    
    
    
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value={"/{daoName}/create","/{daoName}/update"},method = RequestMethod.POST)
    public  @ResponseBody  DataSourceResult create(@RequestBody ArrayList<Map<String, Object>> models,@PathVariable String daoName){
		
		GenericDao genericDao=(GenericDao)CliviaApplicationContext.getBean(daoName);
		Class entityClass=genericDao.getEntityClass();
		
	    List<Object> items=new ArrayList<Object>(); 
        for (Map<String, Object> model : models) {
        	
        	System.out.println(model);
        	Object item=null;
            int id=(int)model.get("id");
            if(id>0)
            	item=genericDao.findById(id);
            else
            	item = genericDao.create();
            Field[] fields=entityClass.getDeclaredFields();
            
            System.out.println("Fields:");
            for(Field field:fields){
        		String fieldName = field.getName();
				String fieldType=field.getType().getSimpleName();

        		if(model.containsKey(fieldName)){
        			
        			System.out.print(fieldName+":"+fieldType+":"+	model.get(fieldName)+",");
        			
                	field.setAccessible(true);
					try {
						switch(fieldType){
							case "Date":
									SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
									Date date=formatter.parse((String) model.get(fieldName));
									field.set(item,date);
									break;
							case "Double":
									System.out.println("Double------------"+Double.valueOf(model.get(fieldName).toString()));
									field.set(item, Double.valueOf(model.get(fieldName).toString()));
									break;
							default:
								field.set(item, model.get(fieldName));
						}
					} catch (IllegalArgumentException e) {
						e.printStackTrace();
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
        		}
            }
            
            System.out.println("");
            
            genericDao.saveOrUpdate(item);
            items.add(item);
            System.out.println("After Add or Update:"+item);
        }
        DataSourceResult result = new DataSourceResult();
        result.setData(items);
        return result;
    }
        
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/{daoName}/destroy",method = RequestMethod.POST)
    public @ResponseBody DataSourceResult destroy(@RequestBody ArrayList<Map<String, Object>> models,@PathVariable String daoName) {
		System.out.println("Delete started");
		GenericDao genericDao=(GenericDao)CliviaApplicationContext.getBean(daoName);
	    List<Object> items=new ArrayList<Object>(); 
        for (Map<String, Object> model : models) {
        	int id=(int)model.get("id");
        	Object item=genericDao.findById(id);
        	System.out.print("Delete:----------id="+id+"   found=");
        	System.out.println(item!=null);
        	if(item!=null){
        		genericDao.delete(item);
        		items.add(item);
        	}
        }
        DataSourceResult result = new DataSourceResult();
        result.setData(items);
        return result;
    }
	
}
