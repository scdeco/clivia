package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.GarmentTransDetail;

@Repository ("garmentTransDetailDao")
public class GarmentTransDetailDao extends GenericDao<GarmentTransDetail> {
	
	public List<GarmentTransDetail> findListByTransId(Integer transId){
		List<GarmentTransDetail> list=this.findList(super.createCriteria().add(Restrictions.eq("transId",transId)));
		return list;
	};

}
