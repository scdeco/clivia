package com.scdeco.miniataweb.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.model.GarmentInfo;
import com.scdeco.miniataweb.model.GarmentTrans;
import com.scdeco.miniataweb.model.GarmentTransDetail;
import com.scdeco.miniataweb.model.GarmentTransInfo;
import com.scdeco.miniataweb.model.GarmentUpc;

@Repository ("garmentTransDao")
public class GarmentTransDao {
	@Autowired 
	private GarmentTransInfoDao garmentTransInfoDao;
	
	@Autowired 
	private GarmentTransDetailDao garmentTransDetailDao;
	
	@Autowired
	private CliviaAutoNumberDao cliviaAutoNumberDao;
	
	@Autowired
	private GarmentInfoDao garmentInfoDao;
	
	@Autowired
	private GarmentUpcDao garmentUpcDao;

	
	public GarmentTrans getGarmentTransById(int id){
		GarmentTrans garmentTrans=null;
		GarmentTransInfo info=garmentTransInfoDao.findById(id);
		if (info!=null){
			garmentTrans=new GarmentTrans();
			garmentTrans.setInfo(info);
			
			List<GarmentTransDetail> items=garmentTransDetailDao.findListByTransId(id);
			garmentTrans.setItems(items);
		}
		return garmentTrans;
	}
	
	public GarmentTrans getGarmentTransByTransNumber(String transNumber){
		GarmentTrans garmentTrans=null;
		GarmentTransInfo info=garmentTransInfoDao.findByTransNumber(transNumber);
		if (info!=null){
			garmentTrans=this.getGarmentTransById(info.getId());
		}
		return garmentTrans;
	}
	
	
	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void save(GarmentTrans garmentTrans){
		
		GarmentTransInfo  info=garmentTrans.getInfo();
		if(!(info.getId()>0)){
			Integer transNumber=cliviaAutoNumberDao.getNextNumber("GarmentTransNumber");
			info.setTransNumber("GT"+transNumber.toString());
		}else{
			deleteGarmentTransDetailByTransId(info.getId());
		}
		
		garmentTransInfoDao.saveOrUpdate(info);
		
		for(GarmentTransDetail item:garmentTrans.getItems()){

			GarmentUpc garmentUpc=garmentUpcDao.findById(item.getUpcId());
			Integer qoh=garmentUpc.getQoh()==null?0:garmentUpc.getQoh();
			garmentUpc.setQoh(qoh+item.getQuantity());
			
			GarmentInfo garmentInfo=garmentInfoDao.findById(garmentUpc.getGarmentId());
			qoh=garmentInfo.getQoh()==null?0:garmentInfo.getQoh();
			garmentInfo.setQoh(qoh+item.getQuantity());
			
			item.setTransId(info.getId());
			
			garmentInfoDao.saveOrUpdate(garmentInfo);
			garmentUpcDao.saveOrUpdate(garmentUpc);
			garmentTransDetailDao.saveOrUpdate(item);
		}
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly=false)
	public void deleteGarmentTransDetailByTransId(int transId){
		List<GarmentTransDetail> items=garmentTransDetailDao.findListByTransId(transId);
		for(GarmentTransDetail item:items){
			
			GarmentUpc garmentUpc=garmentUpcDao.findById(item.getUpcId());
			Integer qoh=garmentUpc.getQoh()==null?0:garmentUpc.getQoh();
			garmentUpc.setQoh(qoh-item.getQuantity());
			
			GarmentInfo garmentInfo=garmentInfoDao.findById(garmentUpc.getGarmentId());
			qoh=garmentInfo.getQoh()==null?0:garmentInfo.getQoh();
			garmentInfo.setQoh(qoh-item.getQuantity());
			
			garmentInfoDao.saveOrUpdate(garmentInfo);
			garmentUpcDao.saveOrUpdate(garmentUpc);
			garmentTransDetailDao.delete(item);
		}
	}

	
	
}
