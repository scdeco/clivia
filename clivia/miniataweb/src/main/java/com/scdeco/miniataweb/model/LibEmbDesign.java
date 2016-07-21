package com.scdeco.miniataweb.model;

import java.util.List;

import com.scdeco.miniataweb.embdesign.EMBDesignM;

public class LibEmbDesign {

		LibEmbDesignInfo info;
		EMBDesignM  embDesignM;		//data from design dst file like stiches,stepCount,etc.
		List<LibEmbDesignColourway> colourways;
		List<LibEmbDesignSample> samples;
		
		public LibEmbDesignInfo getInfo() {
			return info;
		}
		public void setInfo(LibEmbDesignInfo info) {
			this.info = info;
		}
		public EMBDesignM getEmbDesignM() {
			return embDesignM;
		}
		public void setEmbDesignM(EMBDesignM embDesignM) {
			this.embDesignM = embDesignM;
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
		
		
}
