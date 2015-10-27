package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.type.LongType;
import org.hibernate.type.StringType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;


@Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
@Repository("dictDao")
public class DictDao {
	
	@Autowired
	protected SessionFactory sessionFactory;
	
	protected Session getSession(){
		return sessionFactory.getCurrentSession();
	}

	
	/*return a list[text,value]*/
	@SuppressWarnings("rawtypes")
	public List getDict(String from,String textField,String valueField,String orderBy){

		StringBuilder sb=new StringBuilder();
		
		sb.append("select "+textField+" as text");
		if(valueField!=null&&!valueField.isEmpty()) sb.append(","+valueField+" as value");
		
		sb.append(" from "+from);
		if(orderBy!=null&&!orderBy.isEmpty()) sb.append(" order by "+orderBy);
		SQLQuery query = (SQLQuery) getSession().createSQLQuery(sb.toString());
		if(valueField!=null&&!valueField.isEmpty()) {
			query.addScalar("text",new StringType()).addScalar("value",new LongType());
		}
		
		return query.list();
	}
}
