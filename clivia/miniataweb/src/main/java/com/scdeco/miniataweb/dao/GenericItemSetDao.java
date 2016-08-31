package com.scdeco.miniataweb.dao;

import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.model.CliviaSuperModel;
import com.scdeco.miniataweb.util.CliviaUtils;

@SuppressWarnings({"rawtypes","unchecked"})
public abstract class GenericItemSetDao<T> {
	
	protected Class<T> mainEntityClass;
	
	private IdDependentItem mainItem;
	
	public GenericItemSetDao(){
		
	       Type type = getClass().getGenericSuperclass();  
	       Type[] pt = ((ParameterizedType) type).getActualTypeArguments();  
	       mainEntityClass = (Class) pt[0]; 
	       
	}
	
	protected void setMainItem(IdDependentItem mainItem){
		mainItem.isMainItem=true;
		this.mainItem=mainItem;
	}

	
	protected abstract void initItemSet() throws NoSuchFieldException, SecurityException;
	
	
	public T  getById(int id) throws InstantiationException, IllegalAccessException, NoSuchFieldException, SecurityException, IllegalArgumentException{
		return getById(id,null);
	}

	public T getById(int id,String[] itemNames) 
			throws InstantiationException, IllegalAccessException, NoSuchFieldException, SecurityException, IllegalArgumentException{
		
		T newInstance=null;

		newInstance=mainEntityClass.newInstance();
		
		if(mainItem==null)
			initItemSet();
		
		mainItem.loadById(newInstance, mainItem.dependentIdFieldName,id,itemNames);
		return newInstance;
	}
	
	
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void save(T mainEntity) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		if(mainItem==null)
			initItemSet();
		
		//superId is mainId for Order, Company, Garment and Employee 
		removeDeletedItems(mainEntity);
		
		mainItem.save(mainEntity);
	}
		
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	protected void removeDeletedItems(T mainEntity) 
			throws IllegalArgumentException, IllegalAccessException, NoSuchFieldException, SecurityException{

		Field field=mainEntityClass.getDeclaredField("deleteds");
		field.setAccessible(true);
		List<Map<String,String>> deletedItems=(List<Map<String, String>>)field.get(mainEntity);
		
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

		if(mainItem==null)
			initItemSet();
		
		mainItem.delete(mainEntity);
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void delete(int id)
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException {
		
		T deleteInstance=getById(id);
		if(deleteInstance!=null)
			delete(deleteInstance);

	}		
}


@SuppressWarnings({ "unchecked", "rawtypes" })
class IdDependentItem {

	protected Class mainEntityClass;

	protected boolean isMainItem=false;

	protected String itemName;
	protected String daoName;
	protected GenericDao itemDao;

	protected Class itemEntityClass;
	
	protected String dependentIdFieldName;

	protected List<IdDependentItem> dependentItems=new ArrayList<IdDependentItem>();
	
	protected Field idField;

	public IdDependentItem(Class mainEntityClass,String itemName,String daoName,String dependentIdFieldName) 
			throws NoSuchFieldException, SecurityException{
		
		this.itemName=itemName;
		this.daoName=daoName;
		this.dependentIdFieldName=dependentIdFieldName;
		
		this.itemDao= CliviaUtils.getDao(daoName);
		this.itemEntityClass=itemDao.getEntityClass();
		this.mainEntityClass=mainEntityClass;
		
		this.idField=itemEntityClass.getDeclaredField("id");
		this.idField.setAccessible(true);
	}
	
	public Object getItemEntity(Object mainEntity) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		Field itemField=mainEntityClass.getDeclaredField(itemName);
		itemField.setAccessible(true);
		return itemField.get(mainEntity);
	}
	
	public void setItemEntity(Object mainEntity, Object itemEntity) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		Field itemField=mainEntityClass.getDeclaredField(itemName);
		itemField.setAccessible(true);
		itemField.set(mainEntity, itemEntity);
	}
	
	

	protected void loadById(Object mainEntity,String superIdFieldName,int superId,String[] itemNames) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		Object itemEntity=(isMainItem)?itemDao.findById(superId)
				:isContainedInItemNameList(itemNames)?itemDao.findListBySuperId(superIdFieldName,superId):null;
						
		setItemEntity(mainEntity,itemEntity);
		
		for(IdDependentItem dependentItem:dependentItems){
			dependentItem.loadById(mainEntity, superIdFieldName, superId,itemNames);
		}		
			
	}	

	
	public void save(Object mainEntity) 
						throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		if(isMainItem){
			CliviaSuperModel info=(CliviaSuperModel)getItemEntity(mainEntity);
			if(info.getIsDirty()){
				itemDao.saveOrUpdate(info);
				info.setIsDirty(false);
			}
			
			int newId=idField.getInt(info);
			
			for(IdDependentItem dependentItem:dependentItems){
				dependentItem.setSuperId(mainEntity, dependentIdFieldName, 0, newId);
			}
			
		}else{
			List<CliviaSuperModel> itemEntityList=(List<CliviaSuperModel>)getItemEntity(mainEntity);
			if(itemEntityList!=null){
				for(CliviaSuperModel itemEntity:itemEntityList){
					int tmpId=0;
					
					if(itemEntity.getIsNewDi()){
						tmpId=idField.getInt(itemEntity);
						idField.set(itemEntity, 0);
					}
					
					if(itemEntity.getIsDirty()||itemEntity.getIsNewDi()){
						itemDao.saveOrUpdate(itemEntity);
						itemEntity.setIsDirty(false);
						itemEntity.setIsNewDi(false);
					}
					
					if(tmpId>0){
						int newId=idField.getInt(itemEntity);
						for(IdDependentItem dependentItem:dependentItems){
							dependentItem.setSuperId(mainEntity,dependentIdFieldName,tmpId,newId);
						}
					}
	
				}
			}
			
		}
		
		for(IdDependentItem dependentItem:dependentItems){
			dependentItem.save(mainEntity);
		}		
		
	}
	
	//if tmpId==0, all entites will be set to newId, otherwise only entities that match the tmpId will replace with  new Id
	protected void setSuperId(Object mainEntity,String superIdFieldName,int tmpId,int newId) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		if(!isMainItem){
			List<CliviaSuperModel> itemEntityList=(List<CliviaSuperModel>)getItemEntity(mainEntity);
			if(itemEntityList!=null){
				Field superIdField=itemEntityClass.getDeclaredField(superIdFieldName);
				superIdField.setAccessible(true);
				for(Object item:itemEntityList){
					if(tmpId>0){
						if(tmpId==superIdField.getInt(item))
							superIdField.setInt(item, newId);
					}else{
						superIdField.setInt(item, newId);
					}
				}				
			}
		}
			
		for(IdDependentItem dependentItem:dependentItems){
			dependentItem.setSuperId(mainEntity,superIdFieldName,tmpId,newId);
		}		
	}
	
	
	protected void delete(Object mainEntity) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		
		for(IdDependentItem dependentItem:dependentItems)
			dependentItem.delete(mainEntity);
		
		if(isMainItem)
			itemDao.delete(getItemEntity(mainEntity));
		else
			itemDao.deleteAll((List)getItemEntity(mainEntity));
	}
		
	protected IdDependentItem findIdDependentItem(String itemName){
		IdDependentItem item=null;
		for(IdDependentItem subitem:dependentItems){
			if(subitem.itemName==itemName){
				item=subitem;
				break;
			}
			item=subitem.findIdDependentItem(itemName);
			if(item!=null)
				break;
			
		}
		return item;
	}
	
	private boolean isContainedInItemNameList(String[] itemNames){
		
		boolean found=false;
		if(itemNames==null)
			found=true;
		else
			for(int i=0;i<itemNames.length;i++){
				if(itemName.equals(itemNames[i])){
					found=true;
					break;
				}
			}
			
		return found;
	}

}	
	

