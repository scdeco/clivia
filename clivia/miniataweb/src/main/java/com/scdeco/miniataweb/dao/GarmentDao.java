package com.scdeco.miniataweb.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.Garment;
import com.scdeco.miniataweb.model.GarmentInfo;

@Repository ("garmentDao")
public class GarmentDao extends GenericItemSetDao<Garment>{

	@Autowired
	GarmentInfoDao garmentInfoDao;
	
	protected void initItemSet() throws NoSuchFieldException, SecurityException{

		IdDependentItem mainItem=new IdDependentItem(super.mainEntityClass,"info","garmentInfo","garmentId");
		
		IdDependentItem upcItem=new IdDependentItem(super.mainEntityClass,"upcItems","garmentUpc","");
		IdDependentItem imageItem=new IdDependentItem(super.mainEntityClass,"imageItems","garmentImage","");
		
		mainItem.dependentItems.add(upcItem);
		mainItem.dependentItems.add(imageItem);
		
		super.setMainItem(mainItem);
		
	}
	
	
	public Garment getByStyleNumber(int seasonId,String styleNo) 
			throws InstantiationException, IllegalAccessException, NoSuchFieldException, SecurityException, IllegalArgumentException{
		
		Garment garment=null;
		GarmentInfo info=garmentInfoDao.findByStyleNumber(seasonId,styleNo);
		
		if (info!=null){
			garment=super.getById(info.getId());
		}
		return garment;
	}
	
	
}
