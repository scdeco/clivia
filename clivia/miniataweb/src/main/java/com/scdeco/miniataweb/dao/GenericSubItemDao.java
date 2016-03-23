package com.scdeco.miniataweb.dao;

import java.lang.reflect.Field;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

public class GenericSubItemDao<T> extends GenericDao<T> {

	public List<T> findListBySuperId(String mainIdFieldName,Integer mainId) {
		return findListBySuperId(mainIdFieldName, mainId==null?0:mainId);
	}

	public List<T> findListBySuperId(String mainIdFieldName,int mainId) {
		
		Criteria criteria=super.createCriteria().add(Restrictions.eq(mainIdFieldName, mainId));
		
		try {
			
			super.getEntityClass().getDeclaredField("lineNo");
			criteria.addOrder(Order.asc("lineNo"));

		} catch (NoSuchFieldException | SecurityException e) {
		}
		
		List<T> list=super.findList(criteria);
		return list;
	}
	
	@SuppressWarnings({ "rawtypes" })
	public void setSuperId(List itemList,String superIdFieldName,int newId,int tmpId) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{ 

		if(itemList!=null){

				Class itemClass=super.getEntityClass();
				
				Field superIdField=itemClass.getDeclaredField(superIdFieldName);
				superIdField.setAccessible(true);
				for(Object item:itemList){
					if(tmpId>0){
						if(tmpId==superIdField.getInt(item))
							superIdField.setInt(item, newId);
					}else{
						superIdField.setInt(item, newId);
					}
					
						
				}

		}
	}		
}
