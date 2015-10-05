package com.scdeco.miniataweb.dao;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.scdeco.miniataweb.model.LibImage;

@Repository ("libImageDao")
public class LibImageDao extends GenericDao<LibImage, Integer> {
	
	@Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
	public List<LibImage> findListByImageIdList(String[] imageIds){
		List<LibImage> list=new ArrayList<LibImage>();
		for(String imageId:imageIds){
			LibImage libImage=this.findById(Integer.parseInt(imageId));
			if(libImage!=null)
				list.add(libImage);
		}
		return list;
	}
	
	public List<LibImage> findListByImageIdList(String ids){
		String[] imageIds=ids.split(",");
		return findListByImageIdList(imageIds);
	}

}
