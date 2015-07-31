package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.GridInfo;
 

@Repository ("gridInfoDao")
public class GridInfoDaoImpl extends GenericDaoImpl<GridInfo,Integer> implements GridInfoDao {
	
	@Override
	public GridInfo findByGridNo(String gridNo){
		List<GridInfo> list=this.findList(super.createCriteria().add(Restrictions.eq("gridNo", gridNo)));
		
		return list.isEmpty()?null:list.get(0);		
	}

}