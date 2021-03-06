package com.scdeco.miniataweb.controller;

/*have get name and already changed*/

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
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
import com.scdeco.miniataweb.dao.LibEmbDesignDao;
import com.scdeco.miniataweb.model.EmployeeInfo;
import com.scdeco.miniataweb.service.CliviaLibrary;

@Controller
@Scope("session")
@RequestMapping("/lib/*")
public class LibraryController {
	
	@Autowired
	private CliviaLibrary cliviaLibrary;
	
	@Autowired
	LibEmbDesignDao libEmbDesignDao;
	
	@Autowired
	private EmployeeInfoDao employeeInfoDao;
	
	@RequestMapping(value = "{type}/upload", method = RequestMethod.POST)
	public  @ResponseBody Map<String, Object> uploadFile( @RequestParam("file") MultipartFile file,
														  @RequestParam(value="data",required=false) String data, 
														  @PathVariable String type,HttpServletRequest request){
		String loginuser = (String) request.getSession().getAttribute("loginuser");
		String username=loginuser;
		EmployeeInfo employeeInfo=employeeInfoDao.findByUsername(username);
		String uploadBy=employeeInfo.getFirstName();
		System.out.println("-------------------------->>>>DesignController------" + username);
	    Map<String, Object> result=cliviaLibrary.saveFileToLib(type,file,uploadBy, data);
	    
	    return result;
	}
	
	
	
	
	//get a list of lib records
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="{type}/getlist",method=RequestMethod.GET)
	public @ResponseBody  List getList(@PathVariable String type, @RequestParam("ids") String ids){
		return cliviaLibrary.findListByIds(type,ids);
	}
	
	//get  real file of image
	@RequestMapping(value="{type}/getimage",method=RequestMethod.GET)
	public @ResponseBody HttpEntity<byte[]> getImage(@PathVariable String type, 
													 @RequestParam("id") Integer id, 
													 @RequestParam(value="thumbnail",required=false) boolean thumbnail,
													 @RequestParam(value="base64",required=false) boolean base64){
		
		byte[] result=null;
		result=cliviaLibrary.getByteArrayImage(type, id, thumbnail, base64);

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
	
	@RequestMapping(value="{type}/getdesign",method=RequestMethod.GET)
	public @ResponseBody Map<String, Object> getEmbDesign(@PathVariable String type, @RequestParam("id") Integer id){
		
		Map<String, Object> result=cliviaLibrary.getEmbDesign(id);
		return result;
	}
	
	@RequestMapping(value="{type}/getdesignbynumber",method=RequestMethod.GET)
	public @ResponseBody Map<String, Object> getEmbDesignByNumber(@PathVariable String type, @RequestParam("number") String designNumber){
		
		Map<String, Object> result=cliviaLibrary.getEmbDesign(designNumber);
		return result;
	}
	
}
