package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.GarmentImage;

@Repository("garmentImageDao")
public class GarmentImageDao extends GenericDao<GarmentImage> {
	public List<GarmentImage> findListByGarmentId(Integer garmentId) {
		List<GarmentImage> list=this.findList(super.createCriteria().add(Restrictions.eq("garmentId", garmentId)));
		return list;
	}

}
