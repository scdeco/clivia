package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.GarmentInfo;

@Repository ("garmentInfoDao")
public class GarmentInfoDao extends GenericDao<GarmentInfo> {
	
	public GarmentInfo findByStyleNumber(String styleNumber) {
		List<GarmentInfo> list=this.findList(super.createCriteria().add(Restrictions.eq("styleNumber", styleNumber)));
		return list.isEmpty()?null:list.get(0);
	}

}
