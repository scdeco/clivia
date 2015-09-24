package com.scdeco.miniataweb.util;

public class StringUtils {
	public static boolean isBlank(String str){
		return str!=null && !str.trim().isEmpty() ? false:true;
	}
	
	public static String right(String str,int length){
		return (length>=str.length()) ? str:str.substring(str.length()-length);
	}

}
