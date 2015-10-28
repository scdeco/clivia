package com.scdeco.miniataweb.service;


import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import javax.imageio.ImageIO;

import org.apache.commons.io.FilenameUtils;
import org.imgscalr.Scalr;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.scdeco.miniataweb.dao.CliviaAutoNumberDao;
import com.scdeco.miniataweb.dao.LibEmbDesignDao;
import com.scdeco.miniataweb.dao.LibImageDao;
import com.scdeco.miniataweb.embdesign.EMBDesign;
import com.scdeco.miniataweb.model.LibEmbDesign;
import com.scdeco.miniataweb.model.LibImage;
import com.scdeco.miniataweb.util.CliviaUtils;

@Service
public class CliviaLibrary {
	@Autowired
	private LibImageDao libImageDao;
	
	@Autowired 
	private CliviaAutoNumberDao cliviaAutoNumberDao;
	
	@Autowired
	private LibEmbDesignDao libEmbDesignDao;
	
	private static String imageLibBaseDir="C:\\Clivia\\Images";
	private static String[] imgExtensions={"jpg","jpeg","png","bmp","gif"};
	private static int imgThumbnailSize=110;
	
	private static String embDesignLibBaseDir="C:\\Clivia\\EmbDesigns\\dst";
	private static String[] embExtensions={"dst"};
	
	
	private String[] getLibExtensions(String type){
		String[] result=null;
		switch(type){
			case "image":
				result=imgExtensions;
			case "embdesign":
				result=embExtensions;
		}
		return result;
	}
	
	public boolean isLibFile(String type,MultipartFile file){
		return FilenameUtils.isExtension( file.getOriginalFilename().toLowerCase(), getLibExtensions(type));
	}
	
	public String saveUploadFileToLib(MultipartFile file,String type,String uploadBy,Object libDataItem){

		if(!isLibFile(type,file)){
			return file.getOriginalFilename()+"----"+"Not a "+type+" file.";
		}
		
		String fileName;
		String filePath;
		String result="success";		
		
		switch(type){
			case "image":
				if(libDataItem==null){
					libDataItem=new LibImage();
					((LibImage)libDataItem).setUploadBy(uploadBy);
	
					int num=cliviaAutoNumberDao.getNextNumber("ImageId");
				
					String ext=FilenameUtils.getExtension(file.getOriginalFilename());
					fileName="img"+CliviaUtils.right("00000"+num,6)+"."+ext	;
					filePath=LocalDate.now().getYear()+
						"\\"+CliviaUtils.right("00"+LocalDate.now().getMonthValue(),2)+
						"\\"+CliviaUtils.right("00"+LocalDate.now().getDayOfMonth(),2);
					((LibImage)libDataItem).setFilePath(filePath);
					((LibImage)libDataItem).setFileName(fileName);
				} else {

					fileName=((LibImage)libDataItem).getFileName();
					filePath=((LibImage)libDataItem).getFilePath();
				}
			
				((LibImage)libDataItem).setOriginalFileName(file.getOriginalFilename());
				((LibImage)libDataItem).setUploadAt(LocalDateTime.now());
				((LibImage)libDataItem).setSize(file.getSize());
			
				filePath=imageLibBaseDir+"\\"+filePath;
		
				File libFile=new File(filePath+"\\"+fileName);
				File libDirectory=new File(filePath);
			
				if (!libDirectory.exists())
					libDirectory.mkdirs();					
					
				try {
					
					file.transferTo(libFile);
					
				} catch (IllegalStateException | IOException e) {
					
						System.out.println("errror:"+file.getOriginalFilename());
						System.out.println("message:"+e.getMessage());
						System.out.println("cause:"+e.getCause());
						return e.getMessage();
				}
		
				
				BufferedImage bf=null;
				BufferedImage thumbnail=null;
				ByteArrayOutputStream baos=null;
				
				//generate thumbnail of the image
				try {
					bf = ImageIO.read(libFile);
					thumbnail =  Scalr.resize(bf,imgThumbnailSize );
					baos = new ByteArrayOutputStream();
					ImageIO.write(thumbnail, "jpg", baos );
					baos.flush();
					((LibImage)libDataItem).setThumbnail(baos.toByteArray());
					
				} catch (IOException e) {
					
					//failed to read image file as the message sugessted,mostly because of cmyk format.
					//Since the image file has been saved, it still return as a success with a  null thumbnail.			
					//e.getMessage()=="Unsupported Image Type")
					result+=e.getMessage();
					//e.printStackTrace();
					
				}finally{
					if(baos!=null)
						try {
							baos.close();
						} catch (IOException e) {
						}
				}
				
				
				libImageDao.saveOrUpdate(((LibImage)libDataItem));
				System.out.println(((LibImage)libDataItem));
				break;
		}
		return result;
	
	}
	
	@SuppressWarnings("rawtypes")
	public List findListByIds(String type,String ids){
		List result=null;
		switch(type){
			case "image":
				result=libImageDao.findListByImageIdList(ids);
				break;
		}
		return result;
	}
	
	
	
	
	public BufferedImage getBufferedImage(String type,Integer id){
		BufferedImage bufferedImage=null;
		if("image".equals(type)){
			LibImage libImage=libImageDao.findById(id);
			if(libImage!=null){
				String fileName=imageLibBaseDir+"\\"+libImage.getFilePath()+"\\"+libImage.getFileName();
				File libFile=new File(fileName);
				try {
					bufferedImage = ImageIO.read(libFile);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}else{
			LibEmbDesign libEmbDesign=libEmbDesignDao.findById(id);
			if(libEmbDesign!=null){
				String fileName=embDesignLibBaseDir+"\\"+libEmbDesign.getDstFilePath()+"\\"+libEmbDesign.getDstFileName();
				
				EMBDesign embDesign=new EMBDesign(fileName);
				bufferedImage=embDesign.getEMBDesignImage();
			}
			
		}
		return bufferedImage;
	}
	
	public byte[] getByteArrayImage(String type,Integer id){
		BufferedImage bufferedImage=getBufferedImage(type, id);
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		byte[] result=null;
		try {
			ImageIO.write(bufferedImage, "jpg", baos );
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
		return result;
	}
	
/*	public byte[] getByteArray(String type, Integer id){
		byte[] result=null;
		if("image".equals(type)){
			result=getByteArrayImage(type,id);
		}
		return result;
	}
*/	
}
