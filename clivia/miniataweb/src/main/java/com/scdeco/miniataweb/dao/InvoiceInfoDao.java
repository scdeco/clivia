package com.scdeco.miniataweb.dao;

import java.util.List;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.InvoiceInfo;

@Repository ("invoiceInfoDao")
public class InvoiceInfoDao extends GenericDao<InvoiceInfo> {
	
	public InvoiceInfo findByInvoiceNumber(String invoiceNumber) {
		List<InvoiceInfo> list=this.findList(super.createCriteria().add(Restrictions.eq("invoiceNumber",invoiceNumber)));
		
		return list.isEmpty()?null:list.get(0);		
	}

}
