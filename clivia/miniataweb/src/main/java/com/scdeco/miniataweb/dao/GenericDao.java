package com.scdeco.miniataweb.dao;

import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.util.CliviaAliasToEntityMapResultTransformer;
import com.scdeco.miniataweb.util.CliviaUtils;
import com.scdeco.miniataweb.util.DataSourceRequest;
import com.scdeco.miniataweb.util.DataSourceResult;
import com.scdeco.miniataweb.util.SqlRequest;

@Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
public abstract class GenericDao<T> {
	
	private  Class<T> entityClass;
	
	public Class<T> getEntityClass(){
		return entityClass;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public GenericDao(){
	       Type type = getClass().getGenericSuperclass();  
	       Type[] pt = ((ParameterizedType) type).getActualTypeArguments();  
	       entityClass = (Class) pt[0]; 
	}

	@Autowired
	protected SessionFactory sessionFactory;
	
	protected Session getSession(){
		return sessionFactory.getCurrentSession();
	}
	
	public T create(){
		T newPojo=null;
		try {
			newPojo=entityClass.newInstance();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return newPojo;
	}
	

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public Integer save(T entity) {
		return (Integer)getSession().save(entity);
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void saveOrUpdate(T entity) {
		getSession().saveOrUpdate(entity);
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void update(T entity) {
		getSession().update(entity); 
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void merge(T entity) {
		getSession().merge(entity); 
		
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void deleteById(Integer id) {
		getSession().delete(this.findById(id));

	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void delete(T entity) {
		getSession().delete(entity);
		
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void deleteAll(Collection<T> entities) {
	       if (entities == null)  
	            return;  
	        for (T entity : entities) {  
	            getSession().delete(entity);  
	        }  		
	}

	public boolean exists(Integer id) {
	       return findById(id) != null; 
	}

	public T load(Integer id) {
        return (T) getSession().load(this.entityClass, id);  
	}

	public T findById(Integer id) {
		 return (T) getSession().get(this.entityClass, id); 
	}
	

	@SuppressWarnings("unchecked")
	public List<T> findList() {
		return createCriteria().list();
	}

	@SuppressWarnings("unchecked")
	public List<T> findList(SqlRequest sqlRequest) {
		
		String sql="Select * From "+entityClass.getSimpleName();
		if(sqlRequest.getWhere()!=null)
			sql+=" where "+sqlRequest.getWhere();

		if(sqlRequest.getOrderby()!=null)
			sql+=" Order By "+sqlRequest.getOrderby();
		
		SQLQuery sqlQuery=getSession().createSQLQuery(sql);
		sqlQuery.addEntity(entityClass);
		List<T> result=sqlQuery.list();
		return result;
	}
	
	
	@SuppressWarnings("rawtypes")
	public  List findListBySQL(SqlRequest sqlRequest){
		
		StringBuilder sql=new StringBuilder();
		
		if(sqlRequest.getSelect()!=null)
			sql.append("select "+sqlRequest.getSelect());
		
		if(sqlRequest.getFrom()!=null)
			sql.append(" from "+sqlRequest.getFrom());
		
		if(sqlRequest.getWhere()!=null)
			sql.append(" where "+sqlRequest.getWhere());

		if(sqlRequest.getOrderby()!=null)
			sql.append(" Order By "+sqlRequest.getOrderby());

		SQLQuery sqlQuery=getSession().createSQLQuery(sql.toString());
		
		if(sqlRequest.getMapResult()!=null && sqlRequest.getMapResult())
			sqlQuery.setResultTransformer(CliviaAliasToEntityMapResultTransformer.INSTANCE);
		
		return sqlQuery.list();
	}
	
	@SuppressWarnings("rawtypes")
	public  List findListBySQL(String sql,Boolean mapResult){
		SQLQuery sqlQuery=getSession().createSQLQuery(sql);
		
		if(mapResult!=null && mapResult)
			sqlQuery.setResultTransformer(CliviaAliasToEntityMapResultTransformer.INSTANCE);
				
		return sqlQuery.list();
	}
	
	@SuppressWarnings("unchecked")
	public List<T> findList(Criteria criteria) {
		return criteria.list();
	}

	@SuppressWarnings({ "unchecked", "hiding" })
	public <T> List<T> findList(DetachedCriteria criteria) {
		return (List<T>) findList(criteria.getExecutableCriteria(getSession()));  
	}

	@SuppressWarnings("unchecked")
	public List<T> findList(String orderBy, boolean isAsc) {
        Criteria criteria = createCriteria();  
        if (isAsc) {  
            criteria.addOrder(Order.asc(orderBy));  
        } else {  
            criteria.addOrder(Order.desc(orderBy));  
        }  
        return criteria.list();  
	}

	public List<T> findList(String propertyName, Object value) {
        Criterion criterion = Restrictions  
                .like(propertyName, "%" + value + "%");  
        return findList(criterion);  
	}

	@SuppressWarnings("unchecked")
	public List<T> findListIn(String propertyName,Object[] values){
		List<T> result=null;
        Criteria criteria = createCriteria();  
		criteria.add(Restrictions.in(propertyName, values));
		result=criteria.list();
		return result;
	}
	
	public List<T> findListIn(String propertyName,String propertyType,String valueSet){
		List<T> result=null;
		String[] strSet=valueSet.split(",");
		if(propertyType.toLowerCase().startsWith("i")){
			Integer[] intSet=new Integer[strSet.length];
			for(int i=0;i<strSet.length;i++){
				intSet[i]=CliviaUtils.parseInt(strSet[i]);
			}
			result=findListIn(propertyName,intSet);
		} else {
			result=findListIn(propertyName,strSet);
		}
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public List<T> findList(Criterion criterion) {
        Criteria criteria = createCriteria();  
        criteria.add(criterion);  
        return criteria.list();  
	}

	@SuppressWarnings("unchecked")
	public List<T> findList(Criterion... criterions) {
        return createCriteria(criterions).list();  
	}
	
	public List<T> findListByIds(String[] ids){
		List<T> list=new ArrayList<T>();
		for(String id:ids){
			T dataItem=findById(Integer.parseInt(id));
			if(dataItem!=null)
				list.add(dataItem);
		}
		return list;
	}
	
	public List<T> findListByIds(String strIds){
		String[] ids=strIds.split(",");
		return  findListByIds(ids);
	}
	
	public List<T> findListByKeys(String keyName, String[] keyValues){
		List<T> list=new ArrayList<T>();
		for(String keyValue:keyValues){
			T dataItem=findUniqueResult(keyName,keyValue);
			if(dataItem!=null)
				list.add(dataItem);
		}
		return list;
	}
	
	public List<T> findListBySuperId(String superIdFieldName,int mainId) {
		
		Criteria criteria=createCriteria().add(Restrictions.eq(superIdFieldName, mainId));
		try{
			entityClass.getDeclaredField("lineNo");
			criteria.addOrder(Order.asc("lineNo"));
		} catch (NoSuchFieldException | SecurityException e) {
		}

		return findList(criteria);
	}
	
	
	public List<T> findListByKeys(String keyName,String strKeyValues){
		String[] keyValues=strKeyValues.split(",");
		return  findListByKeys(keyName,keyValues);
	}
	
    public DataSourceResult findListByDataSourceRequest(DataSourceRequest request) {
        return request.toDataSourceResult(getSession(), this.entityClass);
    }
	
	@SuppressWarnings("unchecked")
	public T findUniqueResult(String propertyName, Object value) {
        Criterion criterion = Restrictions.eq(propertyName, value);  
        return (T) createCriteria(criterion).uniqueResult();  
	}

	@SuppressWarnings("unchecked")
	public T findUniqueResult(Criteria criteria) {
		return (T) criteria.uniqueResult();
	}

	public T findUniqueResult(Criterion... criterions) {
	    Criteria criteria = createCriteria(criterions);  
        return findUniqueResult(criteria);  
	}
	
	public int findCount() {
        Criteria criteria = createCriteria();  
        return Integer.valueOf(criteria.setProjection(Projections.rowCount())  
                .uniqueResult().toString());  
	}

	public int findCount(Criteria criteria) {
        return Integer.valueOf(criteria.setProjection(Projections.rowCount())  
                .uniqueResult().toString());  
	}


	public void flush() {
	      getSession().flush();  
		
	}

	public void clear() {
	       getSession().clear();  
		
	}

	public Criteria createCriteria() {
	    return getSession().createCriteria(entityClass);  
	}

	public Criteria createCriteria(Criterion... criterions) {
	    Criteria criteria = createCriteria();  
        for (Criterion c : criterions) {  
            criteria.add(c);  
        }  
        return criteria;  
	}
	
	public Field[] getFieldList(){
		Field[] fields=entityClass.getDeclaredFields();
		return fields;
	}

}
