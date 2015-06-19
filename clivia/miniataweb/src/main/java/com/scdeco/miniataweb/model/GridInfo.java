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
	private int fixedColumnCount;
	private String remark;
	private boolean pageable;
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
	public boolean isPageable() {
		return pageable;
	}
	public void setPageable(boolean pageable) {
		this.pageable = pageable;
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
				+ ", remark=" + remark + ", pageable=" + pageable
				+ ", sortable=" + sortable + ", filterable=" + filterable
				+ ", editable=" + editable + "]";
	}
	
}
