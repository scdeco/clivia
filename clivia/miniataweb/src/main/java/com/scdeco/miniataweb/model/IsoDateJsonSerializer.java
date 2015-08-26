package com.scdeco.miniataweb.model;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

public class IsoDateJsonSerializer extends JsonSerializer<LocalDate> {  

 /*   @Override
    public void serialize(LocalDate date, JsonGenerator json, SerializerProvider provider) throws IOException {
        // The client side will handle presentation, we just want it accurate

    	DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
        df.setTimeZone(TimeZone.getTimeZone("UTC"));
        String out = df.format(date);
        json.writeString(out);
    }*/
        private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        
        @Override
        public void serialize(LocalDate date, JsonGenerator generator,
                SerializerProvider provider) throws IOException,
                JsonProcessingException {
     
            String dateString = date.format(formatter);
            generator.writeString(dateString);    	
    	
    	
    }
}