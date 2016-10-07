package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.LibEmbDesignInfo;

@Repository("libEmbDesignInfoDao")
public class LibEmbDesignInfoDao extends GenericDao<LibEmbDesignInfo> {
	
	public LibEmbDesignInfo findByDesignNumber(String designNumber) {
		List<LibEmbDesignInfo> list=this.findList(super.createCriteria().add(Restrictions.eq("designNumber", designNumber)));
		
		return list.isEmpty()?null:list.get(0);
	}

}
