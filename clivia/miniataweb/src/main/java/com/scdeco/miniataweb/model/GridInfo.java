package com.scdeco.miniataweb.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;


@Entity
public class GridInfo{
	
	@Id
	@GeneratedValue
	private int id;
	private String gridNo;
	private String gridName;
	private String daoName;
	private int fixedColumnCount;
	private String remark;
	private int pageSize;
	private boolean sortable;
	private boolean filterable;
	private boolean editable;
	

	public GridInfo(){
	}
	
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
	
	public String getGridName() {
		return gridName;
	}
	public void setGridName(String gridName) {
		this.gridName = gridName;
	}
	public String getDaoName() {
		return daoName;
	}

	public void setDaoName(String daoName) {
		this.daoName = daoName;
	}

	public int getFixedColumnCount() {
		return fixedColumnCount;
	}
	public void setFixedColumnCount(int fixedColumnCount) {
		this.fixedColumnCount = fixedColumnCount;
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
	public boolean isSortable() {
		return sortable;
	}
	public void setSortable(boolean sortable) {
		this.sortable = sortable;
	}
	public boolean isFilterable() {
		return filterable;
	}
	public void setFilterable(boolean filterable) {
		this.filterable = filterable;
	}
	public boolean isEditable() {
		return editable;
	}
	public void setEditable(boolean editable) {
		this.editable = editable;
	}
	@Override
	public String toString() {
		return "GridInfo [id=" + id + ", gridNo=" + gridNo + ", gridName="
				+ gridName + ", fixedColumnCount=" + fixedColumnCount
				+ ", remark=" + remark + ", pageable=" + pageSize
				+ ", sortable=" + sortable + ", filterable=" + filterable
				+ ", editable=" + editable + "]";
	}
	
}
