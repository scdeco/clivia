package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.GarmentTransInfo;
@Repository("garmentTransInfoDao")
public class GarmentTransInfoDao extends GenericDao<GarmentTransInfo> {
	
	public GarmentTransInfo findByTransNumber(String transNumber) {
		List<GarmentTransInfo> list=this.findList(super.createCriteria().add(Restrictions.eq("transNumber",transNumber)));
		return list.isEmpty()?null:list.get(0);		
	}
}
