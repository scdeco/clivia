package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.GarmentUpc;

@Repository("garmentUpcDao")
public class GarmentUpcDaoImpl extends GenericDaoImpl<GarmentUpc, Integer> implements GarmentUpcDao {

	@Override
	public List<GarmentUpc> FindListByGarmentId(Integer garmentId) {
		List<GarmentUpc> list=this.findList(super.createCriteria().add(Restrictions.eq("garmentId", garmentId)));
		return list;
	}

	@Override
	public GarmentUpc FindByUpcNumber(String upcNumber) {
		List<GarmentUpc> list=this.findList(super.createCriteria().add(Restrictions.eq("upcNumber", upcNumber)));
		return list.isEmpty()?null:list.get(0);
	}

}
