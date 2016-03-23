package com.scdeco.miniataweb.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.Garment;
import com.scdeco.miniataweb.model.GarmentInfo;

@Repository ("garmentDao")
public class GarmentDao extends GenericMainItemDao<Garment>{

	@Autowired
	GarmentInfoDao garmentInfoDao;
	
	public GarmentDao(){
		super();

		super.registeredItemListNames=new String[]{"upcItems","imageItems"};
		super.registeredItemModelNames=new String[]{"garmentUpc","garmentImage"};
		super.daoPrefix="garment";
		
		super.infoItemName="info";
		super.infoDaoName="garmentInfo";
		
		super.mainIdFieldName="garmentId";
		
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
