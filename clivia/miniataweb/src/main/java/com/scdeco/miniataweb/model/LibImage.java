package com.scdeco.miniataweb.model;

import java.time.LocalDateTime;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.scdeco.miniataweb.util.CliviaLocalDateTimeJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalDateTimeJsonSerializer;

@Entity
public class LibImage {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	@Column(name="OriginalFileName",length=255)
	private String originalFileName;
	
	@Column(name="Description",length=255)
	private String description;
	
	@Column(name="Size")
	private long size;
	
	@JsonSerialize(using=CliviaLocalDateTimeJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateTimeJsonDeserializer.class)
	@Column(name="UploadAt")
	private LocalDateTime uploadAt;
	
	@Column(name="UploadBy")
	private String uploadBy;
	
	
	@Column(name="Remark", length=255)
	private String remark;
	
	@Lob @Basic(fetch=FetchType.EAGER)
	@Column(name="thumbnail")
	private byte[] thumbnail;
	
	@Column(name="FileName")
	private String fileName;
	
	@Column(name="FilePath")
	private String filePath;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getOriginalFileName() {
		return originalFileName;
	}

	public void setOriginalFileName(String originalFileName) {
		this.originalFileName = originalFileName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public long getSize() {
		return size;
	}

	public void setSize(long size) {
		this.size = size;
	}

	public LocalDateTime getUploadAt() {
		return uploadAt;
	}

	public void setUploadAt(LocalDateTime uploadAt) {
		this.uploadAt = uploadAt;
	}

	public String getUploadBy() {
		return uploadBy;
	}

	public void setUploadBy(String uploadBy) {
		this.uploadBy = uploadBy;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public byte[] getThumbnail() {
		return thumbnail;
	}

	public void setThumbnail(byte[] thumbnail) {
		this.thumbnail = thumbnail;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	@Override
	public String toString() {
		return "LibImage [id=" + id + ", originalFileName=" + originalFileName
				+ ", description=" + description + ", size=" + size
				+ ", uploadAt=" + uploadAt + ", uploadBy=" + uploadBy
				+ ", remark=" + remark + ", thumbnail="
				+ (thumbnail==null?"null":"blob") + ", fileName=" + fileName
				+ ", filePath=" + filePath + "]";
	}

}
