package com.scdeco.miniataweb.model;

import java.util.List;
import java.util.Map;

public class LibEmbDesign {

		LibEmbDesignInfo info;
		List<LibEmbDesignColourway> colourways;
		List<LibEmbDesignSample> samples;
		List<Map<String,String>> deleteds;
		public LibEmbDesignInfo getInfo() {
			return info;
		}
		public void setInfo(LibEmbDesignInfo info) {
			this.info = info;
		}
		public List<LibEmbDesignColourway> getColourways() {
			return colourways;
		}
		public void setColourways(List<LibEmbDesignColourway> colourways) {
			this.colourways = colourways;
		}
		public List<LibEmbDesignSample> getSamples() {
			return samples;
		}
		public void setSamples(List<LibEmbDesignSample> samples) {
			this.samples = samples;
		}
		public List<Map<String, String>> getDeleteds() {
			return deleteds;
		}
		public void setDeleteds(List<Map<String, String>> deleteds) {
			this.deleteds = deleteds;
		}
		

}
