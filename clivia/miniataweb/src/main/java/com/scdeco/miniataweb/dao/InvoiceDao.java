package com.scdeco.miniataweb.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.DependsOn;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.Invoice;
import com.scdeco.miniataweb.model.InvoiceInfo;

@Repository ("invoiceDao")
@DependsOn({"invoiceInfoDao", "invoiceItemDao"})
public class InvoiceDao extends GenericItemSetDao<Invoice> {
	
	@Autowired
	private InvoiceInfoDao invoiceInfoDao;
	
	protected void initItemSet() throws NoSuchFieldException, SecurityException{
		
		
		IdDependentItem mainItem=new IdDependentItem(super.mainEntityClass,"info","InvoiceInfo","invoiceId");
		
		IdDependentItem detail=new IdDependentItem(super.mainEntityClass,"items","invoiceItem","");
		
		mainItem.dependentItems.add(detail);
		
		super.setMainItem(mainItem);
	}
	
	public Invoice getByInvoiceNumber(String invoiceNumber) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		Invoice invoice=null;
		InvoiceInfo invoiceInfo=invoiceInfoDao.findByInvoiceNumber(invoiceNumber);
		if (invoiceInfo!=null){
			invoice=super.getById(invoiceInfo.getId());
		}
		
		return invoice;
	}

}
