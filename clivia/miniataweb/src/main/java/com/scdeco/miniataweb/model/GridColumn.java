package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;


@Entity
public class GridColumn extends CliviaSuperModel{
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="id")
	private int id;
	
	@Column(name="GridId")
	private int gridId;
	
	@Column(name="LineNo")
	private Integer lineNo;
	
	@Column(name="Name",length=255)
	private String name;
	
	@Column(name="Title",length=255)
	private String title;
	
	@Column(name="Width")
	private int width;
	
	@Column(name="Hidden")
	private Boolean hidden;
	
	@Column(name="ColEditable")
	private Boolean colEditable;	//editable is used by kendo model.editable, so editable can not be used here
	
	@Column(name="Choosable")
	private Boolean choosable;
	
	@Column(name="Sortable")
	private Boolean sortable;
	
	@Column(name="Filterable",length=50)
	private String filterable;
	
	@Column(name="Locked")
	private Boolean locked;
	
	@Column(name="Lockable")
	private Boolean lockable;
	
	@Column(name="DataType",length=15)
	private String dataType;
	
	@Column(name="TextAlignFixed",length=15)
	private String textAlignFixed;
	
	@Column(name="TextAlign",length=15)
	private String textAlign;
	
	@Column(name="DisplayFormat",length=50)
	private String displayFormat;
	
	@Column(name="EditMask",length=50)
	private String editMask;
	
	@Column(name="Editor",length=50)
	private String editor;
	
	@Column(name="EditorDescriptor",length=50)
	private String editorDescriptor;

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

	public Integer getLineNo() {
		return lineNo;
	}

	public void setLineNo(Integer lineNo) {
		this.lineNo = lineNo;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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

	public Boolean getHidden() {
		return hidden;
	}

	public void setHidden(Boolean hidden) {
		this.hidden = hidden;
	}

	public Boolean getColEditable() {
		return colEditable;
	}

	public void setColEditable(Boolean colEditable) {
		this.colEditable = colEditable;
	}

	public Boolean getChoosable() {
		return choosable;
	}

	public void setChoosable(Boolean choosable) {
		this.choosable = choosable;
	}

	public Boolean getSortable() {
		return sortable;
	}

	public void setSortable(Boolean sortable) {
		this.sortable = sortable;
	}

	public String getFilterable() {
		return filterable;
	}

	public void setFilterable(String filterable) {
		this.filterable = filterable;
	}

	public Boolean getLocked() {
		return locked;
	}

	public void setLocked(Boolean locked) {
		this.locked = locked;
	}

	public Boolean getLockable() {
		return lockable;
	}

	public void setLockable(Boolean lockable) {
		this.lockable = lockable;
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

	public String getEditor() {
		return editor;
	}

	public void setEditor(String editor) {
		this.editor = editor;
	}

	public String getEditorDescriptor() {
		return editorDescriptor;
	}

	public void setEditorDescriptor(String editorDescriptor) {
		this.editorDescriptor = editorDescriptor;
	}

}
