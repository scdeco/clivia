package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.Garment;
import com.scdeco.miniataweb.model.GarmentUpc;

@Repository ("garmentDao")
public class GarmentDaoImpl extends GenericDaoImpl<Garment , Integer> implements GarmentDao {

	@Autowired
	GarmentUpcDao garmentUpcDao;
	
	@Override
	public Garment FindByStyleNumber(String styleNumber) {
		List<Garment> list=this.findList(super.createCriteria().add(Restrictions.eq("styleNumber", styleNumber)));
		return list.isEmpty()?null:list.get(0);
	}

	//all dependencies of garment and itself will be deleted
	@Override
	public void DeleteGarment(Garment garment) {
		List<GarmentUpc> list=garmentUpcDao.FindListByGarmentId(garment.getId());
		if (!list.isEmpty())
			garmentUpcDao.deleteAll(list);
		this.delete(garment);
	}
	
	
	

}
