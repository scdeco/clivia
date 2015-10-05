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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.scdeco.miniataweb.dao.LibImageDao;
import com.scdeco.miniataweb.model.LibImage;
import com.scdeco.miniataweb.service.CliviaLibrary;

@Controller
@RequestMapping("/library/*")
public class LibraryController {
	
	@Autowired
	private CliviaLibrary cliviaLibraryUtils;
	
	@Autowired
	private LibImageDao libImageDao;
	
	@RequestMapping(value = "upload/newimage", method = RequestMethod.POST)
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
	
	@RequestMapping(value="get-images",method=RequestMethod.GET)
	public @ResponseBody  List<LibImage> getImages(@RequestParam("ids") String ids){
		return libImageDao.findListByImageIdList(ids);
	}
	
	@RequestMapping(value="get-imagefile",method=RequestMethod.GET)
	public @ResponseBody HttpEntity<byte[]> getImageFile(@RequestParam("id") Integer id){
		
		byte[] result=cliviaLibraryUtils.getByteArrayImage(id);
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
