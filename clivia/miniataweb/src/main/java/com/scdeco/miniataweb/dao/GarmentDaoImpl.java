package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.Garment;

@Repository ("garmentDao")
public class GarmentDaoImpl extends GenericDaoImpl<Garment , Integer> implements GarmentDao {

	@Override
	public Garment FindByStyleNumber(String styleNumber) {
		List<Garment> list=this.findList(super.createCriteria().add(Restrictions.eq("styleNumber", styleNumber)));
		return list.isEmpty()?null:list.get(0);
	}
	

}
