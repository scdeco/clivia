package com.scdeco.miniataweb.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.Grid;
import com.scdeco.miniataweb.model.GridInfo;

@Repository("gridDao")
public class GridDao extends GenericItemSetDao<Grid> {
	
	@Autowired
	private GridInfoDao gridInfoDao;
	
	protected void initItemSet() throws NoSuchFieldException, SecurityException{
		
		IdDependentItem mainItem=new IdDependentItem(super.mainEntityClass,"info","gridInfo","gridId");
		
		IdDependentItem columnItem=new IdDependentItem(super.mainEntityClass,"columnItems","gridColumn","");
		
		mainItem.dependentItems.add(columnItem);
		
		super.setMainItem(mainItem);
	}

	public Grid getByGridNo(String gridNo) 
			throws InstantiationException, IllegalAccessException, NoSuchFieldException, SecurityException, IllegalArgumentException{
		
		Grid grid=null;
		GridInfo info=gridInfoDao.findByGridNo(gridNo);
		if(info!=null)
			grid=super.getById(info.getId());
		return grid;
	}
}
