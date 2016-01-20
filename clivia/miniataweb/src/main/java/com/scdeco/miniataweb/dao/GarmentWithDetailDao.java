package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.GarmentWithDetail;

@Repository ("garmentWithDetailDao")
public class GarmentWithDetailDao extends GenericDao<GarmentWithDetail> {
	
	public List<GarmentWithDetail> findListByGarmentId(Integer garmentId) {
		List<GarmentWithDetail> list=this.findList(super.createCriteria().add(Restrictions.eq("garmentId", garmentId)));
		return list;
	}
	
	public List<GarmentWithDetail> findListByGarmentIds(Integer[] garmentIds) {
		List<GarmentWithDetail> list=this.findList(super.createCriteria().add(Restrictions.in("garmentId", garmentIds)));
		return list;
	}
	
	public List<GarmentWithDetail> findListByUpcIds(Integer[] upcIds) {
		List<GarmentWithDetail> list=this.findList(super.createCriteria().add(Restrictions.in("upcId", upcIds)));
		return list;
	}

	
}
