package com.scdeco.miniataweb.model;

import javax.persistence.MappedSuperclass;
import javax.persistence.Transient;

@MappedSuperclass
public class CliviaSuperModel {
	
	@Transient
	private boolean isDirty=false;

	@Transient
	private boolean isNewDi=false;

	public boolean getIsDirty() {
		return isDirty;
	}

	public void setIsDirty(boolean isDirty) {
		this.isDirty = isDirty;
	}

	public boolean getIsNewDi() {
		return isNewDi;
	}

	public void setIsNewDi(boolean isNewDi) {
		this.isNewDi = isNewDi;
	}

	

}
