package com.scdeco.miniataweb.util;

import java.io.IOException;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

public class CliviaLocalTimeJsonSerializer extends JsonSerializer<LocalTime>{
	
	   private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
	    
	    @Override
	    public void serialize(LocalTime time, JsonGenerator generator,
	            SerializerProvider provider) throws IOException,
	            JsonProcessingException {
	 
	        String str = time.format(formatter);
	        
	        generator.writeString(str);    	
	    }
}
