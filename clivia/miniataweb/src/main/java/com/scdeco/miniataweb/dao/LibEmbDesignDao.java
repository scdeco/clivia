package com.scdeco.miniataweb.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.LibEmbDesign;
import com.scdeco.miniataweb.service.CliviaLibrary;

@Repository ("libEmbDesignDao")
public class LibEmbDesignDao extends GenericMainItemDao<LibEmbDesign> {
	
	@Autowired 
	CliviaLibrary cliviaLibrary;
	
	public  LibEmbDesignDao(){
		super();

		super.registeredItemListNames=new String[]{"colourways","samples"};
		super.registeredItemModelNames=new String[]{"libEmbDesignColourway","libEmbDesignSample"};
		super.daoPrefix="libEmbDesign";
		
		super.infoItemName="info";
		super.infoDaoName="libEmbDesignInfo";

		super.mainIdFieldName="libEmbDesignId";
	}
	
	//itemListNames:colourways,samples
	public LibEmbDesign getById(int id,String[] itemListNames,boolean needStitches,boolean needThumbnail) 
			throws InstantiationException, IllegalAccessException, NoSuchFieldException, SecurityException, IllegalArgumentException{
		
		LibEmbDesign design=super.getById(id, itemListNames);
		
		if(design!=null){
			
			if(needStitches)
				design.setEmbDesignM(cliviaLibrary.getEmbDesignM(design.getInfo()));

			if(!needThumbnail)
				design.getInfo().setThumbnail(null);
		}
		
		
		return design;
	}
}
