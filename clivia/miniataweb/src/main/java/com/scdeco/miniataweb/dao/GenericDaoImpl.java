package com.scdeco.miniataweb.dao;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.Collection;
import java.util.List;

import org.hibernate.Criteria;
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

import com.scdeco.miniataweb.util.DataSourceRequest;
import com.scdeco.miniataweb.util.DataSourceResult;

@Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
public abstract class GenericDaoImpl<T, PK extends java.io.Serializable> implements GenericDao<T, PK> {
	
	private  Class<T> entityClass;
	
	@Override
	public Class<T> getEntityClass(){
		return entityClass;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public GenericDaoImpl(){
	       Type type = getClass().getGenericSuperclass();  
	       Type[] pt = ((ParameterizedType) type).getActualTypeArguments();  
	       entityClass = (Class) pt[0]; 
	}

	@Autowired
	protected SessionFactory sessionFactory;
	
	protected Session getSession(){
		return sessionFactory.getCurrentSession();
	}
	
	@Override
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
	
	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	@Override
	public PK save(T entity) {
		return (PK) getSession().save(entity);
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	@Override
	public void saveOrUpdate(T entity) {
		getSession().saveOrUpdate(entity);
		
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	@Override
	public void update(T entity) {
		getSession().update(entity); 
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	@Override
	public void merge(T entity) {
		getSession().merge(entity); 
		
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	@Override
	public void deleteById(PK id) {
		getSession().delete(this.findById(id));

	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	@Override
	public void delete(T entity) {
		getSession().delete(entity);
		
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	@Override
	public void deleteAll(Collection<T> entities) {
	       if (entities == null)  
	            return;  
	        for (T entity : entities) {  
	            getSession().delete(entity);  
	        }  		
	}

	@Override
	public boolean exists(PK id) {
	       return findById(id) != null; 
	}

	@SuppressWarnings("unchecked")
	@Override
	public T load(PK id) {
        return (T) getSession().load(this.entityClass, id);  
	}

	@SuppressWarnings("unchecked")
	@Override
	public T findById(PK id) {
		 return (T) getSession().get(this.entityClass, id); 
	}
	

	@SuppressWarnings("unchecked")
	@Override
	public List<T> findList() {
		return createCriteria().list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<T> findList(Criteria criteria) {
		return criteria.list();
	}

	@SuppressWarnings({ "unchecked", "hiding" })
	@Override
	public <T> List<T> findList(DetachedCriteria criteria) {
		return (List<T>) findList(criteria.getExecutableCriteria(getSession()));  
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<T> findList(String orderBy, boolean isAsc) {
        Criteria criteria = createCriteria();  
        if (isAsc) {  
            criteria.addOrder(Order.asc(orderBy));  
        } else {  
            criteria.addOrder(Order.desc(orderBy));  
        }  
        return criteria.list();  
	}

	@Override
	public List<T> findList(String propertyName, Object value) {
        Criterion criterion = Restrictions  
                .like(propertyName, "%" + value + "%");  
        return findList(criterion);  
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<T> findList(Criterion criterion) {
        Criteria criteria = createCriteria();  
        criteria.add(criterion);  
        return criteria.list();  
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<T> findList(Criterion... criterions) {
        return createCriteria(criterions).list();  
	}
	
    @Override
    public DataSourceResult findListByRequest(DataSourceRequest request) {
        return request.toDataSourceResult(getSession(), this.entityClass);
    }
	

	@SuppressWarnings("unchecked")
	@Override
	public T findUniqueResult(String propertyName, Object value) {
        Criterion criterion = Restrictions.eq(propertyName, value);  
        return (T) createCriteria(criterion).uniqueResult();  
	}

	@SuppressWarnings("unchecked")
	@Override
	public T findUniqueResult(Criteria criteria) {
		return (T) criteria.uniqueResult();
	}

	@Override
	public T findUniqueResult(Criterion... criterions) {
	    Criteria criteria = createCriteria(criterions);  
        return findUniqueResult(criteria);  
	}
	
	@Override
	public int findCount() {
        Criteria criteria = createCriteria();  
        return Integer.valueOf(criteria.setProjection(Projections.rowCount())  
                .uniqueResult().toString());  
	}

	@Override
	public int findCount(Criteria criteria) {
        return Integer.valueOf(criteria.setProjection(Projections.rowCount())  
                .uniqueResult().toString());  
	}


	@Override
	public void flush() {
	      getSession().flush();  
		
	}

	@Override
	public void clear() {
	       getSession().clear();  
		
	}

	@Override
	public Criteria createCriteria() {
	    return getSession().createCriteria(entityClass);  
	}

	@Override
	public Criteria createCriteria(Criterion... criterions) {
	    Criteria criteria = createCriteria();  
        for (Criterion c : criterions) {  
            criteria.add(c);  
        }  
        return criteria;  
	}

}
