package com.scdeco.miniataweb.util;

import java.io.IOException;
import java.time.LocalDateTime;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.ObjectCodec;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.node.TextNode;

public class CliviaLocalDateTimeJsonDeserializer  extends JsonDeserializer<LocalDateTime> {
	
    @Override
    public LocalDateTime deserialize(JsonParser jp, DeserializationContext ctxt)
            throws IOException, JsonProcessingException {

    	ObjectCodec oc = jp.getCodec();
        TextNode node = (TextNode) oc.readTree(jp);
        String str = node.textValue();
        
        return LocalDateTime.parse(str);
    }
}
