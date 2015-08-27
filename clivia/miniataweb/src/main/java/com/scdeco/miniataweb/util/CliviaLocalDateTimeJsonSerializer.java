package com.scdeco.miniataweb.util;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

public class CliviaLocalDateTimeJsonSerializer extends JsonSerializer<LocalDateTime> {  

//    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    @Override
    public void serialize(LocalDateTime dateTime, JsonGenerator generator,
            SerializerProvider provider) throws IOException,
            JsonProcessingException {
 
        String str = dateTime.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        generator.writeString(str);    	
	
	
    }

}
