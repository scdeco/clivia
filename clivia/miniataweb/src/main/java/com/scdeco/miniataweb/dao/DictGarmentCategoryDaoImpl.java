package com.scdeco.miniataweb.dao;

import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.DictGarmentCategory;

@Repository("dictGarmentCategoryDao")
public class DictGarmentCategoryDaoImpl extends GenericDaoImpl<DictGarmentCategory, Integer> implements
		DictGarmentCategoryDao {

}
