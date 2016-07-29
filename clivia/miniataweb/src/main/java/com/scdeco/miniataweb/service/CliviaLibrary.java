package com.scdeco.miniataweb.service;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import org.apache.commons.io.FilenameUtils;
import org.imgscalr.Scalr;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.scdeco.miniataweb.dao.CliviaAutoNumberDao;
import com.scdeco.miniataweb.dao.GenericDao;
import com.scdeco.miniataweb.dao.LibEmbDesignInfoViewDao;
import com.scdeco.miniataweb.embdesign.EMBDesign;
import com.scdeco.miniataweb.embdesign.EMBDesignM;
import com.scdeco.miniataweb.embdesign.EMBDesignRawImageData;
import com.scdeco.miniataweb.model.LibEmbDesignInfo;
import com.scdeco.miniataweb.model.LibEmbDesignInfoView;
import com.scdeco.miniataweb.util.CliviaApplicationContext;
import com.scdeco.miniataweb.util.CliviaUtils;

@Service
public class CliviaLibrary {
	
	@Autowired 
	private CliviaAutoNumberDao cliviaAutoNumberDao;

	@Autowired 
	private LibEmbDesignInfoViewDao libEmbDesignInfoViewDao;
	
	private Library[] libs;
	
	private Library getLibrary(String type){
		if(this.libs==null){
			libs=new Library[2];
			libs[0]=new Library("image","C:\\Clivia\\Images\\","i",new String[]{"jpg","jpeg","png","bmp","gif"},110,"libImageDao");
			libs[1]=new Library("embdesign","C:\\Clivia\\EmbDesigns\\dst","d",new String[]{"dst"},110,"libEmbDesignInfoDao");
			
		}
		
		Library result=null;

		for(Library lib:libs){
			if (lib.type.equals(type)){
				result=lib;
				break;
			}
		}
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> saveFileToLib(String type, MultipartFile file, String uploadBy,String data){

		Map<String, Object> result=new HashMap<String, Object>();
		
		HashMap<String,String> model=null;
		if (data!=null){
			try {
				model= new ObjectMapper().readValue(data, HashMap.class);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		Library lib=getLibrary(type);
		
		if(!lib.isLibFile(file)){
			result.put("status", "error");
			result.put("message",file.getOriginalFilename()+" is not a "+type+" file.");
			return result;
		}
		
		String fileName=lib.getNewFileName()+"."+FilenameUtils.getExtension(file.getOriginalFilename());
		String filePath=LocalDate.now().getYear()+
				File.separator+CliviaUtils.right("00"+LocalDate.now().getMonthValue(),2)+
				File.separator+CliviaUtils.right("00"+LocalDate.now().getDayOfMonth(),2);

		Object dataItem=lib.getNewDataItem(model);
		
		
		lib.setFieldValue(dataItem,"fileName",fileName);
		lib.setFieldValue(dataItem,"filePath",filePath);
		lib.setFieldValue(dataItem,"originalFileName",file.getOriginalFilename());
		lib.setFieldValue(dataItem,"uploadBy",uploadBy);
		lib.setFieldValue(dataItem,"uploadAt",LocalDateTime.now());
		lib.setFieldValue(dataItem,"size",(int)(file.getSize()));
		
		filePath=lib.getBaseDir()+File.separator+filePath;
		File libFile=new File(filePath+File.separator+fileName);
		File libDirectory=new File(filePath);
	
		if (!libDirectory.exists())	libDirectory.mkdirs();					
			
		try {
			
			file.transferTo(libFile);
			
		} catch (IllegalStateException | IOException e) {
			
				result.put("status", "error");
				result.put("message",file.getOriginalFilename()+":"+e.getMessage());
				result.put("cause:", e.getCause());
				return result;
		}

		if(lib.needThumbnail()){
			BufferedImage thumbnail=null;
			try {
				thumbnail = lib.createThumbnail(libFile,dataItem);
				if(thumbnail!=null){
					ByteArrayOutputStream baos=new ByteArrayOutputStream();
					
					ImageIO.write(thumbnail, "jpg", baos );
					baos.flush();
					lib.setFieldValue(dataItem, "thumbnail", baos.toByteArray());
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}	
		
		lib.save(dataItem);
		result.put("status","success");
		result.put("message", "");
		result.put("data", dataItem);
	return result;

	}
	
	@SuppressWarnings("rawtypes")
	public List findListByIds(String type,String ids){
		return getLibrary(type).findListByIds(ids);
	}
	
	public byte[] getByteArrayImage(String type,Integer id, boolean thumbnail, boolean base64){
		
		byte[] result=getLibrary(type).getByteArrayImage(id, thumbnail, base64);
		return result;
	}

	public EMBDesignM getEmbDesignM(int id){
		return getEmbDesignM((LibEmbDesignInfo)(getLibrary("embdesign").findById(id)));
	}	
	
	public EMBDesignM getEmbDesignM(LibEmbDesignInfo info){
		EMBDesignM result=null;
		if(info!=null){
			Library lib=getLibrary("embdesign");
			String dstFile=lib.getBaseDir()+File.separator+info.getFilePath()+File.separator+info.getFileName();
			EMBDesign embDesign=new EMBDesign(dstFile);
			result=embDesign.getEMBDesignM();
		}
		return result;
	}
	
	public Map<String, Object> getEmbDesignRawImageData(int id){
		Map<String, Object> result=new HashMap<String, Object>();
		
		Library lib=getLibrary("embdesign");
		LibEmbDesignInfo di=(LibEmbDesignInfo)lib.findById(id);
		EMBDesignRawImageData imageData=new EMBDesignRawImageData();
		if(di!=null){
			String dstFile=lib.getBaseDir()+File.separator+di.getFilePath()+File.separator+di.getFileName();
			EMBDesign embDesign=new EMBDesign(dstFile);
			imageData.setWidth(embDesign.getDesignWidth());
			imageData.setHeight(embDesign.getDesignHeight());
			imageData.setStepCount(embDesign.getStepCount());
			imageData.setStitcheCount(embDesign.getStitchCount());
			imageData.setImageData(embDesign.getRawImageData());
			result.put("status","success");
			result.put("message", "");
			result.put("data", imageData);			
		}
		else{
			result.put("status","error");
			result.put("message", "");
			result.put("data", "");					
		}
		return result;
	}
	
	public Map<String, Object> getEmbDesign(int id){
		Map<String, Object> result=new HashMap<String, Object>();
		
		Library lib=getLibrary("embdesign");
		LibEmbDesignInfoView di=libEmbDesignInfoViewDao.findById(id);
		EMBDesignM embDesignM=null;
		if(di!=null){
			String dstFile=lib.getBaseDir()+File.separator+di.getFilePath()+File.separator+di.getFileName();
			EMBDesign embDesign=new EMBDesign(dstFile);
			embDesignM=embDesign.getEMBDesignM();
			result.put("status","success");
			result.put("message", "");
			result.put("di",di);
			result.put("data", embDesignM);	
			
		}
		else{
			result.put("status","error");
			result.put("message", "");
			result.put("data", "");					
		}
		return result;
	}
	
	
	
	@SuppressWarnings("rawtypes")
	class Library{

		private String type;
		private String baseDir;
		private String prefix;
		private String[] extensions;
		private int thumbnailSize;
		
		private GenericDao dao;
		private Class  entityClass;
		

		public Library(String type,String baseDir,String prefix,String[] extensions,int thumbnailSize,String daoName){
			this.type=type;
			this.baseDir=baseDir;
			this.prefix=prefix;
			this.extensions=extensions;
			this.thumbnailSize=thumbnailSize;
			this.dao=(GenericDao)CliviaApplicationContext.getBean(daoName);
			this.entityClass=dao.getEntityClass();		

		}
		
		public boolean isLibFile(MultipartFile file){
			return FilenameUtils.isExtension( file.getOriginalFilename().toLowerCase(), extensions);
		}

		public String getNewFileName(){
			int num=cliviaAutoNumberDao.getNextNumber(type+"Id");
			return prefix+CliviaUtils.right("00000"+num,6);
		}
		
		public void setFieldValue(Object dataItem,String fieldName,Object value){
			Field field=null;
			try {
				field=entityClass.getDeclaredField(fieldName);
			} catch (NoSuchFieldException | SecurityException e) {
				e.printStackTrace();
			}
			
	    	field.setAccessible(true);
	    	
			try {
				field.set(dataItem, value);
			} catch (IllegalArgumentException | IllegalAccessException e) {
				e.printStackTrace();
			}
		}		
		
		public Object getFieldValue(Object dataItem,String fieldName){
			Field field=null;
			Object value=null;
			try {
				field=entityClass.getDeclaredField(fieldName);
			} catch (NoSuchFieldException | SecurityException e) {
				e.printStackTrace();
			}
			
	    	field.setAccessible(true);
	    	
			try {
				 value=field.get(dataItem);
			} catch (IllegalArgumentException | IllegalAccessException e) {
				e.printStackTrace();
			}
			
			return value;
		}		
		
		
		public Object getNewDataItem(HashMap<String,String> model){
			Object dataItem=dao.create();
			switch(type){
				case "image":
					break;
				
				case "embdesign":
					this.setFieldValue(dataItem, "designNumber", model.get("designNumber"));
					this.setFieldValue(dataItem, "description", model.get("description"));
					this.setFieldValue(dataItem, "companyId", CliviaUtils.parseInt(model.get("companyId")));
					this.setFieldValue(dataItem, "remark", model.get("remark"));
					break;
			}

			return dataItem; 
		}
		
		public String getBaseDir(){
			return this.baseDir;
		}
		
		public boolean needThumbnail(){
			return this.thumbnailSize>0;
		}
		
		@SuppressWarnings("unchecked")
		public void save(Object dataItem){
			dao.saveOrUpdate(dataItem);
		}
		
		public BufferedImage createThumbnail(File file,Object dataItem) throws IOException{
			
			BufferedImage thumbnail=null; 
			BufferedImage bi=null;
			
			switch(type){
				case "image":
					bi = ImageIO.read(file);
					
					BufferedImage newBi=new BufferedImage(bi.getWidth(),
			                bi.getHeight(), BufferedImage.TYPE_INT_RGB);
					newBi.createGraphics().drawImage(bi, 0, 0, Color.WHITE, null);
					bi=newBi;
					break;
					
				case "embdesign":
					EMBDesign embDesign=new EMBDesign(file.getPath());
					this.setFieldValue(dataItem, "stitchCount", embDesign.getStitchCount());
					this.setFieldValue(dataItem, "stepCount",embDesign.getStepCount());
					this.setFieldValue(dataItem, "width",  BigDecimal.valueOf(embDesign.getDesignWidthInMM()));
					this.setFieldValue(dataItem, "height", BigDecimal.valueOf(embDesign.getDesignHeightInMM()));
					
					bi=embDesign.getEMBDesignImage(false);
					break;
			}

			if(bi!=null)
				thumbnail =  Scalr.resize(bi,thumbnailSize );
			
			return thumbnail;
		}
		
		public BufferedImage getBufferedImage(Integer id) throws IOException{
			BufferedImage bf=null;
			Object dataItem=dao.findById(id);
			if(dataItem!=null){

				String fileName=(String)getFieldValue(dataItem,"fileName");
				String filePath=(String)getFieldValue(dataItem,"filePath");
				
				if(fileName!=null && filePath!=null){
					fileName=baseDir+File.separator+filePath+File.separator+fileName;
						switch(this.type){
							case "image":
								File file=new File(fileName);
								bf = ImageIO.read(file);
								break;
							case "embdesign":
								EMBDesign embDesign=new EMBDesign(fileName);
								bf=embDesign.getEMBDesignImage(false);	//false:do not use rawImage 		
								break;
						}
				}
				
			}
			return bf;
		}		
			
		
		public byte[] getByteArrayImage(Integer id,boolean thumbnail,boolean base64){
			
			byte[] result=null;
			if(thumbnail){
				Object dataItem=dao.findById(id);
				if(dataItem!=null){
					result=(byte[]) getFieldValue(dataItem,"thumbnail");
				}
			}else{
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				try {
					BufferedImage bi=this.getBufferedImage(id);
					BufferedImage newBi=new BufferedImage(bi.getWidth(),
			                bi.getHeight(), BufferedImage.TYPE_INT_RGB);
					newBi.createGraphics().drawImage(bi, 0, 0, Color.WHITE, null);
					
					ImageIO.write(newBi, "jpg", baos );
					baos.flush();
					result=baos.toByteArray();
				} catch (IOException e) {
					e.printStackTrace();
				}finally{
					try {
						baos.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
				
			}
			return base64 && result!=null?  Base64.getEncoder().encode(result):result ;
		}		
		
		public List findListByIds(String strIds){
			return dao.findListByIds(strIds);			
		}
		
		public Object findById(int id){
			return dao.findById(id);
		}
		
	}
}
