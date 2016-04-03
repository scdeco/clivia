package com.scdeco.miniataweb.controller;

import java.security.Principal;
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

import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.model.EmployeeInfo;
import com.scdeco.miniataweb.service.CliviaLibrary;

@Controller
@RequestMapping("/lib/*")
public class LibraryController {
	
	@Autowired
	private CliviaLibrary cliviaLibrary;
	
	@Autowired
	private EmployeeInfoDao employeeInfoDao;
	
	@RequestMapping(value = "{type}/upload", method = RequestMethod.POST)
	public  @ResponseBody Map<String, Object> uploadFile( @RequestParam("file") MultipartFile file,
															@PathVariable String type,
															Principal principal){

		String username=principal.getName();
		EmployeeInfo employeeInfo=employeeInfoDao.findByUsername(username);
		String uploadBy=employeeInfo.getFirstName();
	    System.out.println("Uploading--------------"+file.getOriginalFilename());

	    Map<String, Object> result=cliviaLibrary.saveFileToLib(type,file,uploadBy);
	    
	    System.out.println("Uploading complete-----"+result.get("status")+" message:"+result.get("message"));
	    
	    return result;
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
		
		byte[] result=cliviaLibrary.getBase64ByteArrayImage(type, id);
		if(result!=null){
	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(MediaType.IMAGE_JPEG); //or what ever type it is
	        headers.setContentLength(result.length);
	        return new HttpEntity<byte[]>(result, headers);
		} else {
			return null;
		}
		
	}
	
	@RequestMapping(value="{type}/getrawimage",method=RequestMethod.GET)
	public @ResponseBody Map<String, Object> getRawImage(@PathVariable String type, @RequestParam("id") Integer id){
		
		Map<String, Object> result=cliviaLibrary.getEmbDesignRawImageData(id);
		return result;
		
	}
	@RequestMapping(value="{type}/getstitches",method=RequestMethod.GET)
	public @ResponseBody Map<String, Object> getEmbDesignStitches(@PathVariable String type, @RequestParam("id") Integer id){
		
		Map<String, Object> result=cliviaLibrary.getEmbDesignStitches(id);
		return result;
		
	}
	
	
}
