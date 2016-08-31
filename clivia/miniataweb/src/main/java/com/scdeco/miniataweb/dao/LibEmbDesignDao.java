package com.scdeco.miniataweb.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.LibEmbDesign;
import com.scdeco.miniataweb.service.CliviaLibrary;

@Repository ("libEmbDesignDao")
public class LibEmbDesignDao extends GenericItemSetDao<LibEmbDesign> {
	
	@Autowired 
	CliviaLibrary cliviaLibrary;
	
	protected void initItemSet() throws NoSuchFieldException, SecurityException{
		
		IdDependentItem mainItem=new IdDependentItem(super.mainEntityClass,"info","libEmbDesignInfo","libEmbDesignId");
		
		IdDependentItem colourway=new IdDependentItem(super.mainEntityClass,"colourways","libEmbDesignColourway","");
		IdDependentItem sample=new IdDependentItem(super.mainEntityClass,"samples","libEmbDesignSample","");
		
		mainItem.dependentItems.add(colourway);
		mainItem.dependentItems.add(sample);
		
		super.setMainItem(mainItem);
	}
	
	//itemListNames:colourways,samples
	public LibEmbDesign getById(int id,String[] itemListNames,boolean needThumbnail) 
			throws InstantiationException, IllegalAccessException, NoSuchFieldException, SecurityException, IllegalArgumentException{
		
		LibEmbDesign design=super.getById(id, itemListNames);
		
		if(design!=null){
			if(!needThumbnail)
				design.getInfo().setThumbnail(null);
		}
		
		return design;
	}
}
