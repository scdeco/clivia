package com.scdeco.miniataweb.model;

import java.util.List;
import java.util.Map;


public class Grid {
	private GridInfo info;
	private List<GridColumn> columnItems;
	List<Map<String,String>> deleteds;
	
	public GridInfo getInfo() {
		return info;
	}
	public void setInfo(GridInfo info) {
		this.info = info;
	}
	public List<GridColumn> getColumnItems() {
		return columnItems;
	}
	public void setColumnItems(List<GridColumn> columnItems) {
		this.columnItems = columnItems;
	}
	public List<Map<String, String>> getDeleteds() {
		return deleteds;
	}
	public void setDeleteds(List<Map<String, String>> deleteds) {
		this.deleteds = deleteds;
	}

}
