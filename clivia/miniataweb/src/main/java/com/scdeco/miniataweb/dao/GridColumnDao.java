package com.scdeco.miniataweb.dao;

import java.util.List;

import com.scdeco.miniataweb.model.GridColumn;

public interface GridColumnDao extends GenericDao<GridColumn, Integer> {

	List<GridColumn> findColumnListByGridId(Integer gridId);

}
