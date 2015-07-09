package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;


@Entity
public class GridInfo{
	
	@Id
	@GeneratedValue
	@Column(name = "id")
	private int id;
	
	@Column(name = "GridNo",length=4)
	private String gridNo;
	
	@Column(name = "GridName",length=255)
	private String gridName;
	
	@Column(name = "GridDaoName",length=255)
	private String gridDaoName;
	
	@Column(name = "Remark",length=255)
	private String remark;
	
	@Column(name = "GridPageSize")
	private int gridPageSize;
	
	@Column(name = "GridSortable")
	private boolean gridSortable;
	
	@Column(name = "GridFilterable")
	private boolean gridFilterable;
	
	@Column(name = "GridEditable")
	private boolean gridEditable;
	
	@Column(name="ColumnResizable")
	private boolean columnResizable;
	
	@Column(name="ColumnMovable")
	private boolean columnMovable;
	
	
	
	@Column(name = "GridSortDescriptor",length=255)
	private String gridSortDescriptor;
	 

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
	public String getGridDaoName() {
		return gridDaoName;
	}

	public void setGridDaoName(String gridDaoName) {
		this.gridDaoName = gridDaoName;
	}

	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public int getGridPageSize() {
		return gridPageSize;
	}
	public void setGridPageSize(int gridPageSize) {
		this.gridPageSize = gridPageSize;
	}
	public boolean isGridSortable() {
		return gridSortable;
	}
	public void setGridSortable(boolean gridSortable) {
		this.gridSortable = gridSortable;
	}
	public boolean isGridFilterable() {
		return gridFilterable;
	}
	public void setGridFilterable(boolean gridFilterable) {
		this.gridFilterable = gridFilterable;
	}
	public boolean isGridEditable() {
		return gridEditable;
	}
	public void setGridEditable(boolean gridEditable) {
		this.gridEditable = gridEditable;
	}
	
	public boolean isColumnResizable() {
		return columnResizable;
	}
	public void setColumnResizable(boolean columnResizable) {
		this.columnResizable = columnResizable;
	}
	
	public boolean isColumnMovable() {
		return columnMovable;
	}
	public void setColumnMovable(boolean columnMovable) {
		this.columnMovable = columnMovable;
	}
	
	public String getGridSortDescriptor() {
		return gridSortDescriptor;
	}

	public void setGridSortDescriptor(String gridSortDescriptor) {
		this.gridSortDescriptor = gridSortDescriptor;
	}

	@Override
	public String toString() {
		return "GridInfo [id=" + id + ", gridNo=" + gridNo + ", gridName="
				+ gridName + ", daoName=" + gridDaoName + ", remark=" + remark + ", pageSize="
				+ gridPageSize + ", sortable=" + gridSortable + ", filterable="
				+ gridFilterable + ", editable=" + gridEditable + ", sortDescriptor=" + gridSortDescriptor + "]";
	}
	
}
