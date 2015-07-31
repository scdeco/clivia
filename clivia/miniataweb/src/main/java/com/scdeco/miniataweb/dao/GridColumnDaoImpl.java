package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.GridColumn;


@Repository ("gridColumnDao")
public class GridColumnDaoImpl extends GenericDaoImpl<GridColumn, Integer> implements GridColumnDao {
	
	@Override
	public List<GridColumn> findColumnListByGridId(Integer gridId){
		
		List<GridColumn> list=this.findList(super.createCriteria().add(Restrictions.eq("gridId", gridId)).addOrder(Order.asc("orderBy")));
		
		return list;
	}

}