package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;


@Entity
public class GridColumn{
	

	@Id
	@GeneratedValue
	@Column(name="id")
	private int id;
	
	@Column(name="GridId")
	private int gridId;
	
	@Column(name="OrderBy",length=4)
	private String orderBy;
	
	@Column(name="ColumnName",length=255)
	private String columnName;
	
	@Column(name="Title",length=255)
	private String title;
	
	@Column(name="width")
	private int width;
	
	@Column(name="ColumnVisible")
	private boolean columnVisible;
	
	@Column(name="ColumnEditable")
	private boolean columnEditable;
	
	@Column(name="ColumnChooseable")
	private boolean columnChooseable;
	
	@Column(name="ColumnSortable")
	private boolean columnSortable;
	
	@Column(name="ColumnFilterable")
	private boolean columnFilterable;
	
	@Column(name="ColumnLocked")
	private boolean columnLocked;
	
	@Column(name="Columnlockable")
	private boolean columnLockable;
	
	@Column(name="ColumnDataType",length=15)
	private String columnDataType;
	
	@Column(name="TextAlignFixed",length=15)
	private String textAlignFixed;
	
	@Column(name="TextAlign",length=15)
	private String textAlign;
	
	@Column(name="DisplayFormat",length=50)
	private String displayFormat;
	
	@Column(name="EditMask",length=50)
	private String editMask;
	
	@Column(name="ColumnEditor",length=50)
	private String columnEditor;
	
	@Column(name="EditorDescriptor",length=50)
	private String editorDescriptor;
	
	
	public GridColumn(){
	}

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
		return title;
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

	public boolean isColumnVisible() {
		return columnVisible;
	}

	public void setColumnVisible(boolean columnVisible) {
		this.columnVisible = columnVisible;
	}

	public boolean isColumnEditable() {
		return columnEditable;
	}

	public void setColumnEditable(boolean columnEditable) {
		this.columnEditable = columnEditable;
	}

	public boolean isColumnChooseable() {
		return columnChooseable;
	}

	public void setColumnChooseable(boolean columnChooseable) {
		this.columnChooseable = columnChooseable;
	}

	public boolean isColumnFilterable() {
		return columnFilterable;
	}

	public void setColumnFilterable(boolean columnFilterable) {
		this.columnFilterable = columnFilterable;
	}

	public boolean isColumnLocked() {
		return columnLocked;
	}

	public void setColumnLocked(boolean columnLocked) {
		this.columnLocked = columnLocked;
	}

	public boolean isColumnLockable() {
		return columnLockable;
	}

	public void setColumnLockable(boolean columnLockable) {
		this.columnLockable = columnLockable;
	}

	public String getColumnDataType() {
		return columnDataType;
	}

	public void setColumnDataType(String columnDataType) {
		this.columnDataType = columnDataType;
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

	public String getColumnEditor() {
		return columnEditor;
	}

	public void setColumnEditor(String columnEditor) {
		this.columnEditor = columnEditor;
	}
	
	public String getEditorDescriptor() {
		return editorDescriptor;
	}

	public void setEditorDescriptor(String editorDescriptor) {
		this.editorDescriptor = editorDescriptor;
	}

	public boolean isColumnSortable() {
		return columnSortable;
	}

	public void setColumnSortable(boolean columnSortable) {
		this.columnSortable = columnSortable;
	}

	
	@Override
	public String toString() {
		return "GridColumn [id=" + id + ", gridId=" + gridId + ", orderBy="
				+ orderBy + ", columnName=" + columnName + ", title=" + title
				+ ", width=" + width + ", columnVisible=" + columnVisible
				+ ", columnEditable=" + columnEditable + ", columnChooseable="
				+ columnChooseable + ", columnSortable=" + columnSortable
				+ ", columnFilterable=" + columnFilterable + ", columnLocked="
				+ columnLocked + ", columnLockable=" + columnLockable
				+ ", columnDataType=" + columnDataType + ", textAlignFixed="
				+ textAlignFixed + ", textAlign=" + textAlign
				+ ", displayFormat=" + displayFormat + ", editMask=" + editMask
				+ ", columnEditor=" + columnEditor + ", editorDescriptor=" + editorDescriptor + "]";
	}


}
