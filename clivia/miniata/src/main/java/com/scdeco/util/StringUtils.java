package com.scdeco.util;

public class StringUtils {
	public static boolean isBlank(String str){
		return str!=null && !str.trim().isEmpty()?false:true;
	}

}
