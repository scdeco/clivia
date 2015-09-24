package com.scdeco.miniataweb.dao;

import org.hibernate.Criteria;
import org.hibernate.LockMode;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.model.CliviaAutoNumber;

@Repository("cliviaAutoNumberDao")
public class CliviaAutoNumberDao {
	
	@Autowired
	private SessionFactory sessionFactory;
	
	private Session getSession(){
		return sessionFactory.getCurrentSession();
	}

	@Transactional(propagation = Propagation.REQUIRES_NEW,readOnly=false)
	public Integer getNextNumber(String moduleName){
	
		Criteria criteria=getSession().createCriteria(CliviaAutoNumber.class);
		criteria.add(Restrictions.eq("name", moduleName));
		criteria.setLockMode(LockMode.PESSIMISTIC_WRITE);
		CliviaAutoNumber autoNumber=(CliviaAutoNumber)criteria.uniqueResult();

		Integer nextNumber=autoNumber.getNextNumber();
		autoNumber.setNextNumber(nextNumber+1);
		getSession().update(autoNumber);

		return nextNumber;
	}

}
