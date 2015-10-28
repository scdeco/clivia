package com.scdeco.miniataweb.controller;

import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.scdeco.miniataweb.service.CliviaLibrary;

@Controller
@RequestMapping("/library/*")
public class LibraryController {
	
	@Autowired
	private CliviaLibrary cliviaLibrary;
	
	@RequestMapping(value = "{type}/upload", method = RequestMethod.POST)
	public  @ResponseBody Map<String, Object> uploadFile( @RequestParam("file") MultipartFile file,
											@PathVariable String type,
	                                        @RequestParam("user") String uploadBy){
		
	    final HashMap<String, Object> ret = new HashMap<String, Object>();
	    String result="";
	    Object libDataItem=null;
		System.out.println("Uploading--------------"+file.getOriginalFilename());

		result=cliviaLibrary.saveUploadFileToLib(file,type,uploadBy,libDataItem);
		ret.put("data", libDataItem);

		if (result.startsWith("success")){
			System.out.println("Uploaded Succeed--------------"+file.getOriginalFilename());
			ret.put("status","success");
			ret.put("message",result.substring(7));
		}else{
			System.out.println("Uploaded failed--------------"+result);
			ret.put("status","error");
			ret.put("message", result);
		}
	    return ret;
	}
	
	
	//get a list of lib records
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="{type}/getlist",method=RequestMethod.GET)
	public @ResponseBody  List getList(@PathVariable String type, @RequestParam("ids") String ids){
		return cliviaLibrary.findListByIds(type,ids);
	}
	
	//get  real file 
	@RequestMapping(value="{type}/getimage",method=RequestMethod.GET)
	public @ResponseBody HttpEntity<byte[]> getFile(@PathVariable String type, @RequestParam("id") Integer id){
		
		byte[] result=cliviaLibrary.getByteArrayImage(type,id);
		if(result!=null){
			result=Base64.getEncoder().encode(result);
	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(MediaType.IMAGE_JPEG); //or what ever type it is
	        headers.setContentLength(result.length);
	        return new HttpEntity<byte[]>(result, headers);
		} else {
			return null;
		}
		
	}
	
	
}
