package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Id;

public class GridWithInfo {
	@Id
	@Column(name = "id")
	private int id;
	
	@Column(name = "GridNo",length=4,unique=true,nullable=false)
	private String gridNo;
	
	@Column(name = "GridName",length=50,nullable=false)
	private String gridName;
	
	@Column(name = "GridDaoName",length=50,nullable=false)
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

	public int getId() {
		return id;
	}

	public String getGridNo() {
		return gridNo;
	}

	public String getGridName() {
		return gridName;
	}

	public String getGridDaoName() {
		return gridDaoName;
	}

	public String getRemark() {
		return remark;
	}

	public int getGridPageSize() {
		return gridPageSize;
	}

	public boolean isGridSortable() {
		return gridSortable;
	}

	public boolean isGridFilterable() {
		return gridFilterable;
	}

	public boolean isGridEditable() {
		return gridEditable;
	}

	public boolean isColumnResizable() {
		return columnResizable;
	}

	public boolean isColumnMovable() {
		return columnMovable;
	}

	public String getGridSortDescriptor() {
		return gridSortDescriptor;
	}
}
