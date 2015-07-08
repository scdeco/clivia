package com.scdeco.miniataweb.controller;

import java.lang.reflect.Field;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.DataSourceRequest;
import com.scdeco.miniataweb.dao.DataSourceResult;
import com.scdeco.miniataweb.dao.GenericDao;
import com.scdeco.miniataweb.dao.GridColumnDao;
import com.scdeco.miniataweb.dao.GridInfoDao;
import com.scdeco.miniataweb.model.GridColumn;
import com.scdeco.miniataweb.model.GridInfo;
import com.scdeco.miniataweb.util.CliviaApplicationContext;

@Controller
@RequestMapping("/cliviagrid")
public class CliviaGridController {

	@Autowired
	GridInfoDao gridInfoDao;
	
	@Autowired
	GridColumnDao gridColumnDao;
	
	@Autowired
	CliviaApplicationContext cliviaApplicationContext;
	
	@RequestMapping(method=RequestMethod.GET)
	public String get(Model model,
			@RequestParam(value="gridNo",required=true) String gridNo,
			@RequestParam(value="filter",required=false) String filter){

		System.out.println("Grid#:"+gridNo+"   filter:"+filter);
		GridInfo gridInfo=gridInfoDao.findByGridNo(gridNo);
		List<GridColumn> gridColumnList=gridColumnDao.findColumnListByGridId(gridInfo.getId()); 
		
		model.addAttribute("cliviaGridInfo",gridInfo);
		model.addAttribute("cliviaGridColumnList",gridColumnList);
		model.addAttribute("dataFilter",filter);
		model.addAttribute("version","10008js");
		
		
		return 	"cliviagrid/cliviagrid";
	}
	
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/{daoName}/read",method = RequestMethod.POST)
    public  @ResponseBody  DataSourceResult  read(@RequestBody DataSourceRequest request,@PathVariable String daoName){
    	System.out.println("request:"+request);
    	DataSourceResult result=((GenericDao)cliviaApplicationContext.getBean(daoName)).findListByRequest(request);
       return result;
    }
    
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value={"/{daoName}/create","/{daoName}/update"},method = RequestMethod.POST)
    public  @ResponseBody  List<?> create(@RequestBody ArrayList<Map<String, Object>> models,@PathVariable String daoName){
		
		GenericDao genericDao=(GenericDao)cliviaApplicationContext.getBean(daoName);
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
        		if(model.containsKey(fieldName)){
        			System.out.println(fieldName+"--"+field.getType().getSimpleName()+"--");
                	field.setAccessible(true);
                	
					try {
						if("Date".equals(field.getType().getSimpleName())){
							SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
							Date date=formatter.parse((String) model.get(fieldName));
							field.set(item,date);
						}
						else
							field.set(item, model.get(fieldName));
						System.out.println(model.get(fieldName)+",");
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
        }
	        
        return items;
    }
        
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/{daoName}/destroy",method = RequestMethod.POST)
    public @ResponseBody List<?> destroy(@RequestBody ArrayList<Map<String, Object>> models,@PathVariable String daoName) {
		System.out.println("Delete started");
		GenericDao genericDao=(GenericDao)cliviaApplicationContext.getBean(daoName);
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
        return items;
    }    
	
}

