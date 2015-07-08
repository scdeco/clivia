package com.scdeco.miniataweb.dao;

import java.util.Collection;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.DetachedCriteria;

public interface GenericDao<T, PK extends java.io.Serializable>{

	Class<T> getEntityClass();

	T create();
	PK save(T entity);
    void saveOrUpdate(T entity);
    void update(T entity);  
    void merge(T entity); 
  
    void deleteById(PK id);
    void delete(T entity);
    void deleteAll(Collection<T> entities);
  
    boolean exists(PK id);

    T load(PK id);
    T findById(PK id);
	List<T> findList();
    List<T> findList(Criteria criteria);
    @SuppressWarnings("hiding")
	<T> List<T> findList(DetachedCriteria criteria);
    List<T> findList(String orderBy, boolean isAsc);
    List<T> findList(String propertyName, Object value);
    
    
    List<T> findList(Criterion criterion);
    List<T> findList(Criterion... criterions);   
    
    DataSourceResult findListByRequest(DataSourceRequest request);
    
    int findCount();
    int findCount(Criteria criteria);
  
    T findUniqueResult(String propertyName, Object value);
    T findUniqueResult(Criteria criteria);
    T findUniqueResult(Criterion... criterions);
    
    void flush();
 
    void clear();

    Criteria createCriteria();
    Criteria createCriteria(Criterion... criterions);
	
}
