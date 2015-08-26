package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.CliviaOrder;

@Repository ("orderDao")
public class CliviaOrderDaoImpl extends GenericDaoImpl<CliviaOrder, Integer> implements CliviaOrderDao {

	@Override
	public CliviaOrder findByOrderNumber(String orderNumber) {
		List<CliviaOrder> list=this.findList(super.createCriteria().add(Restrictions.eq("orderNumber",orderNumber)));
		
		return list.isEmpty()?null:list.get(0);		
	}

	@Override
	public void deleteOrder(CliviaOrder cliviaOrder) {
		this.delete(cliviaOrder);		
		
	}

}
