package com.scdeco.miniataweb.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.scdeco.miniataweb.model.LibImage;
import com.scdeco.miniataweb.service.CliviaLibrary;

@Controller
@RequestMapping("/upload/*")
public class UploadController {
	
	@Autowired
	private CliviaLibrary cliviaLibraryUtils;
	
	@RequestMapping(value = "newimage", method = RequestMethod.POST)
	public  @ResponseBody Map<String, Object> uploadFile( @RequestParam("file") MultipartFile file,
	                                        @RequestParam("user") String uploadBy){
		
	    final HashMap<String, Object> ret = new HashMap<String, Object>();
		
		System.out.println("Uploading--------------"+file.getOriginalFilename());
		LibImage libImage=new LibImage();
		libImage.setUploadBy(uploadBy);
		String result=cliviaLibraryUtils.saveUploadImageToLib(file,libImage);
		ret.put("data", libImage);
		if (result.startsWith("success")){
			System.out.println("Uploaded Succeed--------------"+libImage.getOriginalFileName());
			ret.put("status","success");
			ret.put("message",result.substring(7));
		}else{
			System.out.println("Uploaded failed--------------"+result);
			ret.put("status","error");
			ret.put("message", result);
		}
	    return ret;
	}
	
	
	
}
