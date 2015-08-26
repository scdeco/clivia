package com.scdeco.miniataweb.dao;

import com.scdeco.miniataweb.model.CliviaOrder;

public interface CliviaOrderDao extends GenericDao<CliviaOrder, Integer> {
	CliviaOrder findByOrderNumber(String orderNumber);
	void deleteOrder(CliviaOrder cliviaOrder);
}
