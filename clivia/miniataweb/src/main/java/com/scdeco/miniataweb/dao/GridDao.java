package com.scdeco.miniataweb.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.Grid;
import com.scdeco.miniataweb.model.GridInfo;

@Repository("gridDao")
public class GridDao extends GenericMainItemDao<Grid> {
	
	@Autowired
	private GridInfoDao gridInfoDao;
	public GridDao(){
		super();

		super.registeredItemListNames=new String[]{"columnItems"};
		super.registeredItemModelNames=new String[]{"gridColumn"};
		super.daoPrefix="grid";
		
		super.infoItemName="info";
		super.infoDaoName="gridInfo";

		super.mainIdFieldName="gridId";		
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
