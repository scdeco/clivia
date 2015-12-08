package com.scdeco.miniataweb.controller;

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
import com.scdeco.miniataweb.util.DataSourceRequest;

@Controller
@RequestMapping("/data/*")
public class DataController {

	
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/get",method = RequestMethod.GET)
    public  @ResponseBody  List  get(@PathVariable String daoName){

        GenericDao dao=getDao(daoName);
    	List result=dao.findList();
    	return result;
    }
	
    
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/get",method = RequestMethod.POST)
    public  @ResponseBody  List  post(@PathVariable String daoName,
    								  @RequestBody SQLRequest sqlRequest){

        GenericDao dao=getDao(daoName);
    	List result=dao.findList();
    	return result;
    }
	
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/getitem",method = RequestMethod.GET)
    public  @ResponseBody  Object  get(@PathVariable String daoName,
    								   @RequestParam("name") String propertyName,
    								   @RequestParam("value") String value){
    
       GenericDao dao=getDao(daoName);
       Object result="id".equals(propertyName)?dao.findById(CliviaUtils.parseInt(value)):dao.findUniqueResult(propertyName, value);
       return result;
    }
	
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/getitems",method = RequestMethod.GET)
    public  @ResponseBody  List  getList(@PathVariable String daoName,
										 @RequestParam("name") String propertyName,
										 @RequestParam("value") String value){

        GenericDao dao=getDao(daoName);
    	List result="id".equals(propertyName)?dao.findListByIds(value):dao.findListByKeys(propertyName,value);
    	return result;
    }

    @SuppressWarnings("rawtypes")
	private GenericDao getDao(String daoName){
    	
    	if(!daoName.toLowerCase().endsWith("dao"))
    		daoName+="Dao";
    	return ((GenericDao)CliviaApplicationContext.getBean(daoName));
    }
    
	private class SQLRequest {
		private String sqSelect;
		private String sqlFrom;
		private String sqlWhere;
		private String sqlOrderBy;
				
		public String getSqSelect() {
			return sqSelect;
		}
		public void setSqSelect(String sqSelect) {
			this.sqSelect = sqSelect;
		}
		public String getSqlFrom() {
			return sqlFrom;
		}
		public void setSqlFrom(String sqlFrom) {
			this.sqlFrom = sqlFrom;
		}
		public String getSqlWhere() {
			return sqlWhere;
		}
		public void setSqlWhere(String sqlWhere) {
			this.sqlWhere = sqlWhere;
		}
		public String getSqlOrderBy() {
			return sqlOrderBy;
		}
		public void setSqlOrderBy(String sqlOrderBy) {
			this.sqlOrderBy = sqlOrderBy;
		}
	}

}
