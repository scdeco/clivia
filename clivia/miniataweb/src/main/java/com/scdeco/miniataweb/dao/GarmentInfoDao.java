package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.GarmentInfo;

@Repository ("garmentInfoDao")
public class GarmentInfoDao extends GenericDao<GarmentInfo> {
	
	public GarmentInfo findByStyleNumber(int seasonId,String styleNo) {
		
		Criteria criteria=super.createCriteria()
					.add(Restrictions.eq("seasonId", seasonId))
					.add(Restrictions.eq("styleNo", styleNo));

		List<GarmentInfo> list=this.findList(criteria);

		return list.isEmpty()?null:list.get(0);
	}
}
