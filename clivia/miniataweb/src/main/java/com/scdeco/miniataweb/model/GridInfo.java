package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;


@Entity
public class GridInfo extends CliviaSuperModel{
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private int id;
	
	@Column(name = "GridNo",length=4,unique=true,nullable=false)
	private String gridNo;
	
	@Column(name = "Name",length=50)
	private String name;
	
	@Column(name = "DaoName",length=50)
	private String daoName;

	@Column(name = "dataUrl",length=50)
	private String dataUrl;
	
	@Column(name = "Remark",length=255)
	private String remark;
	
	@Column(name = "PageSize")
	private int pageSize=0;
	
	@Column(name="IsQuery")
	private Boolean IsQuery=true;
	
	@Column(name = "Sortable")
	private Boolean sortable=true;
	
	@Column(name = "Filterable")
	private Boolean filterable=true;

	@Column(name = "Editable")
	private Boolean editable=false;
	
	@Column(name="ColumnResizable")
	private Boolean columnResizable=true;
	
	@Column(name="ColumnMovable")
	private Boolean columnMovable=true;
	
	@Column(name = "",length=255)
	private String sortDescriptor;
	
	@Column(name = "BaseFilter",length=255)
	private String baseFilter;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getGridNo() {
		return gridNo;
	}

	public void setGridNo(String gridNo) {
		this.gridNo = gridNo;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDaoName() {
		return daoName;
	}

	public void setDaoName(String daoName) {
		this.daoName = daoName;
	}

	public String getDataUrl() {
		return dataUrl;
	}

	public void setDataUrl(String dataUrl) {
		this.dataUrl = dataUrl;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public Boolean getIsQuery() {
		return IsQuery;
	}

	public void setIsQuery(Boolean isQuery) {
		IsQuery = isQuery;
	}

	public Boolean getSortable() {
		return sortable;
	}

	public void setSortable(Boolean sortable) {
		this.sortable = sortable;
	}

	public Boolean getFilterable() {
		return filterable;
	}

	public void setFilterable(Boolean filterable) {
		this.filterable = filterable;
	}

	public Boolean getEditable() {
		return editable;
	}

	public void setEditable(Boolean editable) {
		this.editable = editable;
	}

	public Boolean getColumnResizable() {
		return columnResizable;
	}

	public void setColumnResizable(Boolean columnResizable) {
		this.columnResizable = columnResizable;
	}

	public Boolean getColumnMovable() {
		return columnMovable;
	}

	public void setColumnMovable(Boolean columnMovable) {
		this.columnMovable = columnMovable;
	}

	public String getSortDescriptor() {
		return sortDescriptor;
	}

	public void setSortDescriptor(String sortDescriptor) {
		this.sortDescriptor = sortDescriptor;
	}

	public String getBaseFilter() {
		return baseFilter;
	}

	public void setBaseFilter(String baseFilter) {
		this.baseFilter = baseFilter;
	}
	
}
