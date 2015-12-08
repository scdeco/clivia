package com.scdeco.miniataweb.controller;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.DictDao;

@Controller
@RequestMapping("/dict/*")
public class DictController {

	
	@Autowired
	DictDao dictDao;
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="get",method=RequestMethod.GET)
	public @ResponseBody List getList(@RequestParam(value = "from", required = true) String from,
										@RequestParam(value = "textField", required = true) String textField,
										@RequestParam(value = "orderBy", required = false) String orderBy){
										
		List list=dictDao.getDict(from,textField,"",orderBy);
		System.out.println(list);
		return list;
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value="map",method=RequestMethod.GET)
	public @ResponseBody List<DictItem> getDictMap(@RequestParam(value = "from", required = true) String from,
										@RequestParam(value = "textField", required = true) String textField,
										@RequestParam(value = "valueField", required = false) String valueField,
										@RequestParam(value = "orderBy", required = false) String orderBy){
										
		List list=dictDao.getDict(from,textField,valueField,orderBy);
		Iterator it = list.iterator(); 
		List<DictItem> result=new ArrayList<DictItem>();
		while(it.hasNext()) {  
			Object[] tuple= (Object[]) it.next();
		 	result.add(new DictItem(tuple));
		}  
		return result;
	}
	
	private class DictItem {
		@SuppressWarnings("unused")
		public String text;
		@SuppressWarnings("unused")
		public Integer value;
		public DictItem(Object[] item){
			this.text=item[0].toString();
			this.value=Integer.parseInt(item[1].toString());
		}
	}
	
}
