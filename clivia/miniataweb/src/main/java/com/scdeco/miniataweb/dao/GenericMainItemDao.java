package com.scdeco.miniataweb.dao;

import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.model.CliviaSuperModel;
import com.scdeco.miniataweb.util.CliviaUtils;

@SuppressWarnings({"rawtypes","unchecked"})
public class GenericMainItemDao<T> {
	
	protected String[] registeredItemListNames;
	protected String[] registeredItemModelNames;
	protected String daoPrefix;
	
	protected String infoItemName;
	protected String infoDaoName;
	
	protected Class<T> mainEntityClass;

	protected String mainIdFieldName;
	
	public GenericMainItemDao(){
	       Type type = getClass().getGenericSuperclass();  
	       Type[] pt = ((ParameterizedType) type).getActualTypeArguments();  
	       mainEntityClass = (Class) pt[0]; 
	}
	
	public T getById(int id) 
			throws InstantiationException, IllegalAccessException, NoSuchFieldException, SecurityException, IllegalArgumentException{
		
		T newInstance=null;
		
		newInstance=mainEntityClass.newInstance();
		loadInfoItemById(newInstance,id);
		loadSubItemListById(newInstance,id);
		
		return newInstance;
	}
	
	protected void loadInfoItemById(T mainEntity,int id) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{

		GenericDao infoDao=CliviaUtils.getDao(infoDaoName);
		Field field= getItemField(infoItemName);
		field.setAccessible(true);
		field.set(mainEntity, infoDao.findById(id));
	}
	
	protected void loadSubItemListById(T mainEntity,int mainId) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
			for(int i=0;i<registeredItemListNames.length;i++){
				Field itemListField = mainEntityClass.getDeclaredField(registeredItemListNames[i]);
				itemListField.setAccessible(true);
				
				GenericSubItemDao dao=(GenericSubItemDao) CliviaUtils.getDao(registeredItemModelNames[i]);
				
				List itemList=dao.findListBySuperId(mainIdFieldName,mainId);
				itemListField.set(mainEntity, itemList);
			}
	}	
	
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void save(T mainEntity) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		//superId is mainId for Company,Garment and Employee 
		removeDeletedItems(mainEntity);
		saveInfoItem(mainEntity);
		setSuperId(mainEntity,mainIdFieldName,getSuperId(mainEntity),0);
		saveSubItemList(mainEntity);
	}
		
	protected void saveInfoItem(T mainEntity) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		CliviaSuperModel info=getInfoItem(mainEntity);
		
		if(info.getIsDirty()){
			GenericDao infoDao=CliviaUtils.getDao(infoDaoName);
			infoDao.saveOrUpdate(info);
			info.setIsDirty(false);
		}
		
	}
	
	protected CliviaSuperModel getInfoItem(T mainEntity) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		Field field= getItemField(infoItemName);
		field.setAccessible(true);
		return (CliviaSuperModel)field.get(mainEntity);
		
	}
	
	
	protected void saveSubItemList(T mainEntity) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{

		for(int i=0;i<registeredItemListNames.length;i++){
			
			List itemList=(List)getItemList(mainEntity,registeredItemListNames[i]);
			if(itemList!=null){
				
				GenericDao dao=CliviaUtils.getDao(registeredItemModelNames[i]);
				
				for(Object item:itemList){
					CliviaSuperModel mItem=(CliviaSuperModel)item;
					if(mItem.getIsDirty())
						dao.saveOrUpdate(item);
						mItem.setIsDirty(false);
				}
			}
		}		
	}
	
	
	protected void setSuperId(T mainEntity,String superIdFieldName,int tmpId,int newId) 
					throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		for(int i=0;i<registeredItemListNames.length;i++){
			Field itemListField = mainEntityClass.getDeclaredField(registeredItemListNames[i]);
			itemListField.setAccessible(true);
			List itemList=(List) itemListField.get(mainEntity);
			
			if(itemList!=null){
				GenericSubItemDao dao=(GenericSubItemDao)CliviaUtils.getDao(registeredItemModelNames[i]);
				dao.setSuperId(itemList, superIdFieldName, tmpId,newId);
			}
		}
	}	
	
	protected int getSuperId(T mainEntity) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{

		int id=0;
		
		Field infoItemField= getItemField(infoItemName);
		infoItemField.setAccessible(true);
		Object info=infoItemField.get(mainEntity);
		
		if(info!=null){
			Field idField=info.getClass().getDeclaredField("id");
			idField.setAccessible(true);
			id=idField.getInt(info);
		}
		
		return id;
	}
	
	protected void removeDeletedItems(T mainEntity) 
			throws IllegalArgumentException, IllegalAccessException, NoSuchFieldException, SecurityException{

		List<Map<String,String>> deletedItems=(List<Map<String, String>>) getItemList(mainEntity,"deleteds");
		
		if(!deletedItems.isEmpty()){
	
			for(Map<String,String> item:deletedItems){
		        	int id=Integer.parseInt(item.get("id"));

		        	GenericDao dao=CliviaUtils.getDao(item.get("entity"));
		        	dao.deleteById(id);
		        	
		     }				
		}
	}    
	
	
	//all dependencies of company and itself will be deleted
	protected void delete(T mainEntity ) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException {
		GenericDao dao=null;
		for(int i=0;i<registeredItemListNames.length;i++){

			List itemList=getItemList(mainEntity,registeredItemListNames[i]);
			
			if(itemList!=null){
				dao=CliviaUtils.getDao(registeredItemModelNames[i]);
				dao.deleteAll(itemList);
			}
		}
		
		dao=CliviaUtils.getDao(infoDaoName);
		dao.delete(getInfoItem(mainEntity));
		

	}

	public String delete(int id)
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException {
		
		String result="";
		T deleteInstance=getById(id);
		if(deleteInstance!=null)
			delete(deleteInstance);

		return result;
	}		
	
	protected List getItemList(T mainEntity,String fieldName) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		Field field=getItemField(fieldName);
		field.setAccessible(true);
		return (List) field.get(mainEntity); 
	}
	
	protected Field getItemField(String fieldName) throws NoSuchFieldException, SecurityException{
		Field field= mainEntityClass.getDeclaredField(fieldName);
		return field;
	}
	
}
