package com.scdeco.miniataweb.model;


public class GridColumn{
	
	public GridColumn(){
	}
	
	private int id;
	private int gridId;
	private String orderBy;
	private String columnName;
	private String title;
	private int width;
	private boolean visible;
	private boolean editable;
	private boolean chooseable;
	private boolean sortable;
	private boolean filterable;
	private String dataType;
	private String textAlignFixed;
	private String textAlign;
	private String displayFormat;
	private String editMask;
	private String comboList;
	private String dataMap;
	
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getGridId() {
		return gridId;
	}
	public void setGridId(int gridId) {
		this.gridId = gridId;
	}
	public String getOrderBy() {
		return orderBy;
	}
	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}
	public String getColumnName() {
		return columnName;
	}
	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}
	public String getTitle() {
		return this.title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getWidth() {
		return width;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public boolean isVisible() {
		return visible;
	}
	public void setVisible(boolean visible) {
		this.visible = visible;
	}
	public boolean isEditable() {
		return editable;
	}
	public void setEditable(boolean editable) {
		this.editable = editable;
	}
	public boolean isChooseable() {
		return chooseable;
	}
	public void setChooseable(boolean chooseable) {
		this.chooseable = chooseable;
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
	public String getDataType() {
		return dataType;
	}
	public void setDataType(String dataType) {
		this.dataType = dataType;
	}
	public String getTextAlignFixed() {
		return textAlignFixed;
	}
	public void setTextAlignFixed(String textAlignFixed) {
		this.textAlignFixed = textAlignFixed;
	}
	public String getTextAlign() {
		return textAlign;
	}
	public void setTextAlign(String textAlign) {
		this.textAlign = textAlign;
	}
	public String getDisplayFormat() {
		return displayFormat;
	}
	public void setDisplayFormat(String displayFormat) {
		this.displayFormat = displayFormat;
	}
	public String getEditMask() {
		return editMask;
	}
	public void setEditMask(String editMask) {
		this.editMask = editMask;
	}
	public String getComboList() {
		return comboList;
	}
	public void setComboList(String comboList) {
		this.comboList = comboList;
	}
	public String getDataMap() {
		return dataMap;
	}
	public void setDataMap(String dataMap) {
		this.dataMap = dataMap;
	}

	
	@Override
	public String toString() {
		return "GridColumn [id=" + id + ", gridId=" + gridId + ", orderBy="
				+ orderBy + ", columnName=" + columnName + ", title="
				+ title + ", width=" + width + ", visible=" + visible
				+ ", editable=" + editable + ", chooseable=" + chooseable
				+ ", sortable=" + sortable + ", filterable=" + filterable
				+ ", dataType=" + dataType + ", textAlignFixed="
				+ textAlignFixed + ", textAlign=" + textAlign
				+ ", displayFormat=" + displayFormat + ", editMask=" + editMask
				+ ", comboList=" + comboList + ", dataMap=" + dataMap + "]";
	}

	
}
