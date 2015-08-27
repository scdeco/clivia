package com.scdeco.miniataweb.util;

import java.io.IOException;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.ObjectCodec;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.node.TextNode;

public class CliviaLocalTimeJsonDeserializer extends JsonDeserializer<LocalTime> {
	
   private final DateTimeFormatter formatter1 = DateTimeFormatter.ofPattern("hh:mm a");
   private final DateTimeFormatter formatter2 = DateTimeFormatter.ofPattern("HH:mm:ss");

   DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM.yyyy");
   
    @Override
    public LocalTime deserialize(JsonParser jp, DeserializationContext ctxt)
            throws IOException, JsonProcessingException {

    	ObjectCodec oc = jp.getCodec();
        TextNode node = (TextNode) oc.readTree(jp);
        String str = node.textValue();
 
        return LocalTime.parse(str, str.contains("M")?formatter1:formatter2);
    }
}
