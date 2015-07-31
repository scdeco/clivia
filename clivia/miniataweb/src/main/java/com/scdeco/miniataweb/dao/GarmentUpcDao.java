package com.scdeco.miniataweb.dao;

import java.util.List;

import com.scdeco.miniataweb.model.GarmentUpc;

public interface GarmentUpcDao extends GenericDao<GarmentUpc, Integer> {
	List<GarmentUpc> FindListByGarmentId(Integer garmentId);
	GarmentUpc FindByUpcNumber(String styleNumber);
}
