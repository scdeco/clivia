package com.scdeco.miniataweb.service;


import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;

import javax.imageio.ImageIO;

import org.apache.commons.io.FilenameUtils;
import org.imgscalr.Scalr;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.scdeco.miniataweb.dao.CliviaAutoNumberDao;
import com.scdeco.miniataweb.dao.LibImageDao;
import com.scdeco.miniataweb.model.LibImage;
import com.scdeco.miniataweb.util.StringUtils;

@Service
public class CliviaLibrary {
	@Autowired
	private LibImageDao libImageDao;
	
	@Autowired 
	private CliviaAutoNumberDao cliviaAutoNumberDao;
	
	private static String imageLibBaseDir="C:\\Clivia\\Images";
	private static String[] imgExtensions={"jpg","jpeg","png","bmp","gif"};
	private static int imgThumbnailSize=150;
	
	public String saveUploadImageToLib(MultipartFile file,LibImage libImage){
		
		if(!isImageFile(file)){
			return file.getOriginalFilename()+"----"+"Not a image file.";
		}
		
		
		String fileName;
		String filePath;
		
		if(libImage.getId()==0){	//upload

			int num=cliviaAutoNumberDao.getNextNumber("ImageId");
			
			String ext=FilenameUtils.getExtension(file.getOriginalFilename());
			fileName="img"+StringUtils.right("00000"+num,6)+"."+ext	;
			filePath=LocalDate.now().getYear()+
					"\\"+StringUtils.right("00"+LocalDate.now().getMonthValue(),2)+
					"\\"+StringUtils.right("00"+LocalDate.now().getDayOfMonth(),2);
			libImage.setFilePath(filePath);
			libImage.setFileName(fileName);
		} else {

			fileName=libImage.getFileName();
			filePath=libImage.getFilePath();
		}
			
		libImage.setOriginalFileName(file.getOriginalFilename());
		libImage.setUploadAt(LocalDateTime.now());
		libImage.setSize(file.getSize());
			
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
//				e.printStackTrace();
		}

		
		BufferedImage bf=null;
		BufferedImage thumbnail=null;
		ByteArrayOutputStream baos=null;
		String result="success";
		
		//generate thumbnail of the image
		try {
			bf = ImageIO.read(libFile);
			thumbnail =  Scalr.resize(bf,imgThumbnailSize );
			baos = new ByteArrayOutputStream();
			ImageIO.write(thumbnail, "jpg", baos );
			baos.flush();
			libImage.setThumbnail(baos.toByteArray());
			
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
		
		
		libImageDao.saveOrUpdate(libImage);
		System.out.println(libImage);
		return result;
	
	}
	
	public static boolean isImageFile(MultipartFile file){
	    return FilenameUtils.isExtension( file.getOriginalFilename().toLowerCase(), imgExtensions);
	}
	

}
