package com.scdeco.miniataweb.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;


@Entity
public class Employee {

	@Id
	@GeneratedValue
	private int id;
	
	@Column(name="FirstName",length=50)
	private String firstName;
	
	@Column(name="LastName",length=50)
	private String lastName;
	
	@Column(name="Alias",length=20)
	private String alias;
	
	@Column(name="Sex",length=10)
	private String sex;
	
	@Column(name="BirthDate")
	private Date birthDate;
	
	@Column(name="Username",length=20)
	private String username;
	
	@Column(name="Password",length=20)
	private String password;
	
	@Column(name="Active")
	private Boolean active;
	
	
	public Employee(){
	}
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getAlias() {
		return alias;
	}
	public void setAlias(String alias) {
		this.alias = alias;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	
	@JsonSerialize(using=IsoDateJsonSerializer.class)
	public Date getBirthDate() {
		return birthDate;
	}
	public void setBirthDate(Date birthDate) {
		this.birthDate = birthDate;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}

	public Boolean isActive() {
		return active;
	}

	public void setActive(Boolean active) {
		this.active = active;
	}

	@Override
	public String toString() {
		return "Employee [id=" + id + ", firstName=" + firstName
				+ ", lastName=" + lastName + ", alias=" + alias + ", sex="
				+ sex + ", birthDate=" + birthDate + ", username=" + username
				+ ", password=" + password + ", active=" + active + "]";
	}

	
}
