package com.scdeco.miniataweb.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.model.Garment;
import com.scdeco.miniataweb.model.GarmentInfo;
import com.scdeco.miniataweb.model.GarmentUpc;

@Repository ("garmentDao")
public class GarmentDao {

	@Autowired
	GarmentInfoDao garmentInfoDao;
	
	@Autowired
	GarmentUpcDao garmentUpcDao;
	
	
	public Garment getGarmentProductById(int id){
		Garment garment=null;
		GarmentInfo info=garmentInfoDao.findById(id);
		if (info!=null){
			garment=new Garment();
			garment.setInfo(info);
			
			List<GarmentUpc> upcItems=garmentUpcDao.findListByGarmentId(id);
			garment.setUpcItems(upcItems);
		}
		return garment;
	}
	
	public Garment getGarmentProductByStyleNumber(String styleNumber){
		Garment garment=null;
		GarmentInfo info=garmentInfoDao.findByStyleNumber(styleNumber);
		
		if (info!=null){
			garment=this.getGarmentProductById(info.getId());
		}
		return garment;
	}
	
	
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void save(Garment garment){
		
		GarmentInfo  info=garment.getInfo();
		
		garmentInfoDao.saveOrUpdate(info);
		
		int garmentId=info.getId();
		
		for(int upcId:garment.getDeletedUpcItems()){
			garmentUpcDao.deleteById(upcId);
		}
		
		for(GarmentUpc upcItem:garment.getUpcItems()){
			upcItem.setGarmentId(garmentId);
			garmentUpcDao.saveOrUpdate(upcItem);
		}
	}
	
	//all dependencies of garment and itself will be deleted
	public String delete(Garment garment) {
		String result="";
		if(garment!=null){
			GarmentInfo info=garment.getInfo();
			if(info.getId()<=0){
				result="New garment.";
			}else if(info.getUsed()){
				result="This garment is used and can not delete.";
			}else{
				List<GarmentUpc> list=garment.getUpcItems();
				if (!list.isEmpty())
					garmentUpcDao.deleteAll(list);
				garmentInfoDao.delete(info);
			}
		}else{
			result="No garment.";
		}
		return result;
	}

	
	public String delete(int id) {
		String result="";
		Garment garment=getGarmentProductById(id);
		if(garment!=null){
			result=this.delete(garment);
		}else{
			result="Can not find this style.";
		}
		
		return result;
	}
}
