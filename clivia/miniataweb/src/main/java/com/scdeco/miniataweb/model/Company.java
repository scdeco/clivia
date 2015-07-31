package com.scdeco.miniataweb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

//@Entity
public class Company implements Serializable {

	private static final long serialVersionUID = -6878604579429621423L;

	@Id
	@GeneratedValue
	private int id;
	
	@Column(name="BusinessName",length=100,unique=true,nullable=false)
	private String businessName;
	
	
	

}
