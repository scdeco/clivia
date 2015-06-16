package com.scdeco.miniataweb.dao;

import com.scdeco.miniataweb.model.GridInfo;

public interface GridInfoDao extends GenericDao<GridInfo, Integer> {

	GridInfo findByGridNo(String gridNo);
}
