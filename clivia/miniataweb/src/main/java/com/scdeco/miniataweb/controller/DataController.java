package com.scdeco.miniataweb.controller;

/*no get name need to be changed*/

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.GenericDao;
import com.scdeco.miniataweb.util.CliviaApplicationContext;
import com.scdeco.miniataweb.util.CliviaUtils;
import com.scdeco.miniataweb.util.SqlRequest;

@Controller
@RequestMapping("/data/*")
public class DataController {

    //get all records from table
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/get",method = RequestMethod.GET)
    public  @ResponseBody  List  get(@PathVariable String daoName){
 
        GenericDao dao=getDao(daoName);
    	List result=dao.findList();
    	return result;
    }

    //get all fields of model from dao
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/getfieldlist",method = RequestMethod.GET)
    public  @ResponseBody  Field[]  getFieldList(@PathVariable String daoName){
 
        GenericDao dao=getDao(daoName);
    	
    	return dao.getFieldList();
    }
    
    
	//get unique record by value of id or key property202507
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/getitem",method = RequestMethod.GET)
    public  @ResponseBody  Object  getItem(@PathVariable String daoName,
    								   @RequestParam("name") String propertyName,
    								   @RequestParam("value") String value){
    
       GenericDao dao=getDao(daoName);
       Object result="id".equals(propertyName)?dao.findById(CliviaUtils.parseInt(value)):dao.findUniqueResult(propertyName, value);
       return result;
    }
	
    //get set of unique records by set of vaule of id or key property
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/getitems",method = RequestMethod.GET)
    public  @ResponseBody  List  getItems(@PathVariable String daoName,
										 @RequestParam("name") String propertyName,
										 @RequestParam("value") String value){

        GenericDao dao=getDao(daoName);
    	List result="id".equals(propertyName)?dao.findListByIds(value):dao.findListByKeys(propertyName,value);
    	return result;
    }

    //get  records from table by sql
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/sql",method = RequestMethod.GET)
    public  @ResponseBody  List  sql(@PathVariable String daoName,
    								 @RequestParam("cmd") String sql, @RequestParam(value="map",required=false) Boolean mapResult){

    	List result=null;
    	
    	if("generic".equals(daoName.toLowerCase().trim())){
    		GenericDao dao=getDao("dictGarmentBrand");
    		result=dao.findListBySQL(sql,mapResult);
    	}
    	
    	return result;
    }
    
    
    //get  records from table by sql
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/sql",method = RequestMethod.POST)
    public  @ResponseBody  List  sql(@PathVariable String daoName,
    								  @RequestBody SqlRequest sqlRequest){

    	List result=null;
    	
    	if("generic".equals(daoName.toLowerCase().trim())){
    		GenericDao dao=getDao("dictGarmentBrand");
    		result=dao.findListBySQL(sqlRequest);
    	}else{
    		GenericDao dao=getDao(daoName);
    		result=dao.findList(sqlRequest);
    	}
    	
    	return result;
    }
    
    //get data from table by calling method that starts with "find"
    //findList(),findCount(),findListByGarmentId for garmentUpcDao...
    //param="i:23;s:1SO19"
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/call/{methodName}",method = RequestMethod.GET)
    public  @ResponseBody  Object  call(@PathVariable String daoName,
    								  	@PathVariable String methodName,
    									@RequestParam(value="param",required=false) String param){
    	
    	Object result=null;
    	
    	if(!methodName.startsWith("find")){
    		return result;
    	}
    	
        GenericDao dao=getDao(daoName);
        
        Class[] paramTypes ={};
        Object[] args={};
        if (param!=null && !param.isEmpty()) {
             String[] params=param.split(";");
             paramTypes=new Class[params.length];
             args=new Object[params.length];
             for(int i=0;i<params.length;i++){
            	 String[] p=params[i].split(":");
            	 if(p.length==2){
            		 paramTypes[i]=(p[0].toLowerCase().startsWith("i"))?Integer.class:String.class;
            		 args[i]=(p[0].toLowerCase().startsWith("i"))?CliviaUtils.parseInt(p[1]):p[1];
            	 }
             }
        }
        	
		try {
			Method method = dao.getClass().getMethod(methodName, paramTypes);
			result=method.invoke(dao, args);
		} catch (NoSuchMethodException | SecurityException e) {		//cause by getMethod()
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException | IllegalArgumentException| InvocationTargetException e){	//cause by invoke()
			e.printStackTrace();
    	}
		
    	return result;
    }
    
    
    
    @SuppressWarnings("rawtypes")
	private GenericDao getDao(String daoName){
    	
    	if(!daoName.toLowerCase().endsWith("dao"))
    		daoName+="Dao";
    	return ((GenericDao)CliviaApplicationContext.getBean(daoName));
    }

}
