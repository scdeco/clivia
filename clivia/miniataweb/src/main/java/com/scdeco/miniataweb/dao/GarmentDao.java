package com.scdeco.miniataweb.dao;

import com.scdeco.miniataweb.model.Garment;

public interface GarmentDao extends GenericDao<Garment , Integer> {
	
	Garment FindByStyleNumber(String styleNumber);
	
	void DeleteGarment(Garment garment);
}
