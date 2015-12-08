package com.scdeco.miniataweb.util;


public class CliviaUtils {
	public static int parseInt(String numStr){
		int result=0;
		try{
			result=Integer.parseInt(numStr);
		}catch (NumberFormatException e) {
			result=0;
		}
		return result;
	}
	public static boolean isBlank(String str){
		return str!=null && !str.trim().isEmpty() ? false:true;
	}
	
	public static String right(String str,int length){
		return (length>=str.length()) ? str:str.substring(str.length()-length);
	}
	

}
