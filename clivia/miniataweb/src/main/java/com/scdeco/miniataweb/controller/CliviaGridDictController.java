package com.scdeco.miniataweb.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.GenericDao;
import com.scdeco.miniataweb.util.CliviaApplicationContext;

@Controller
@RequestMapping("/cliviagriddict")
public class CliviaGridDictController {

    @SuppressWarnings({ "rawtypes" })
	@RequestMapping(value="/{daoName}",method = RequestMethod.GET)
    public  @ResponseBody List<?>  read(@PathVariable String daoName,Model model){
    	List<?> list=((GenericDao)CliviaApplicationContext.getBean(daoName)).findList();
        return list; 
    }
/*
	@SuppressWarnings("unused")
    private class ReturnResult{
    	List<?> dict;
    	ReturnResult(List<?> result){
    		this.dict=result;
    	}
		public List<?> getDict() {
			return dict;
		}
		public void setDict(List<?> dict) {
			this.dict = dict;
		}
    }
*/
}
