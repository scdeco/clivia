package com.scdeco.miniataweb.dao;

import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.DictGarmentSize;

@Repository("dictGarmentSizeDao")
public class DictGarmentSizeDaoImpl extends GenericDaoImpl<DictGarmentSize, Integer> implements
		DictGarmentSizeDao {

}
