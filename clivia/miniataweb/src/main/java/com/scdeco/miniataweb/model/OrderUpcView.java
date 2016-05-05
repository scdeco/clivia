package com.scdeco.miniataweb.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalDateJsonSerializer;
import com.scdeco.miniataweb.util.CliviaLocalTimeJsonDeserializer;
import com.scdeco.miniataweb.util.CliviaLocalTimeJsonSerializer;

@Entity
public class OrderUpcView {
	
	@Id
	@Column(name="id")
	private Integer rowId;
	
	@Column(name = "upcId")
	private Integer upcId;

	@Column(name = "garmentId")
	private Integer garmentId;
	
	@Column(name="OrderId")
	private int orderId;	
	
	@Column(name = "canceledQty")
	private Integer canceledQty;

	@Column(name = "dilveredQty")
	private Integer dilveredQty;
	
	@Column(name = "orderQty")
	private Integer orderQty;

	@Column(name="ListPrice")
	private BigDecimal listPrice;

	//percentage off
	@Column(name="Discount")
	private BigDecimal discount;

	@Column(name="OrderPrice")
	private BigDecimal orderPrice;
	
	@Column(name = "styleNo", length = 20)
	private String styleNo;

	@Column(name = "styleName", length = 50)
	private String styleName;

	@Column(name = "brandId")
	private Integer brandId;

	@Column(name = "brand", length = 50)
	private String brand;

	@Column(name = "seasonId")
	private Integer seasonId;

	@Column(name = "season", length = 50)
	private String season;

	@Column(name = "category", length = 30)
	private String category;

	@Column(name = "upcNo", length = 12)
	private String upcNo;

	@Column(name = "colour", length = 50)
	private String colour;

	@Column(name = "size", length = 10)
	private String size;

	@Column(name = "qoh")
	private Integer qoh;

	@Column(name = "rrp", precision = 22, scale = 0)
	private Double rrp;

	@Column(name = "wsp", precision = 22, scale = 0)
	private Double wsp;

	@Column(name = "buyer", length = 50)
	private String buyer;

	@Column(name = "creatorId")
	private Integer creatorId;

	@Column(name = "customerId")
	private Integer customerId;

	@Column(name = "customerPO", length = 50)
	private String customerPo;

	@Column(name = "finishBy")
	private Integer finishBy;

	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name = "finishDate")
	private LocalDate finishDate;

	@Column(name = "invoiceBy")
	private Integer invoiceBy;

	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name = "invoiceDate")
	private LocalDate invoiceDate;

	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name = "orderDate")
	private LocalDate orderDate;

	@Column(name = "orderName", length = 100)
	private String orderName;

	@Column(name = "orderNumber", nullable = false, length = 20)
	private String orderNumber;

	@Column(name = "orderStatus")
	private Integer orderStatus;

	@JsonSerialize(using=CliviaLocalTimeJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalTimeJsonDeserializer.class)
	@Column(name = "orderTime")
	private LocalTime orderTime;

	@Column(name = "repId")
	private Integer repId;

	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name = "requireDate")
	private LocalDate requireDate;

	@JsonSerialize(using=CliviaLocalTimeJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalTimeJsonDeserializer.class)
	@Column(name = "requireTime")
	private LocalTime requireTime;
	
	@JsonSerialize(using=CliviaLocalDateJsonSerializer.class)
	@JsonDeserialize(using = CliviaLocalDateJsonDeserializer.class)
	@Column(name="CancelDate")
	private LocalDate cancelDate;

	@Column(name = "businessName", length = 100)
	private String businessName;

	@Column(name = "creator", length = 511)
	private String creator;

	@Column(name = "rep", length = 511)
	private String rep;

	public Integer getRowId() {
		return rowId;
	}

	public void setRowId(Integer rowId) {
		this.rowId = rowId;
	}

	public Integer getUpcId() {
		return upcId;
	}

	public void setUpcId(Integer upcId) {
		this.upcId = upcId;
	}

	public Integer getGarmentId() {
		return garmentId;
	}

	public void setGarmentId(Integer garmentId) {
		this.garmentId = garmentId;
	}

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public Integer getCanceledQty() {
		return canceledQty;
	}

	public void setCanceledQty(Integer canceledQty) {
		this.canceledQty = canceledQty;
	}

	public Integer getDilveredQty() {
		return dilveredQty;
	}

	public void setDilveredQty(Integer dilveredQty) {
		this.dilveredQty = dilveredQty;
	}

	public Integer getOrderQty() {
		return orderQty;
	}

	public void setOrderQty(Integer orderQty) {
		this.orderQty = orderQty;
	}

	public BigDecimal getListPrice() {
		return listPrice;
	}

	public void setListPrice(BigDecimal listPrice) {
		this.listPrice = listPrice;
	}

	public BigDecimal getDiscount() {
		return discount;
	}

	public void setDiscount(BigDecimal discount) {
		this.discount = discount;
	}

	public BigDecimal getOrderPrice() {
		return orderPrice;
	}

	public void setOrderPrice(BigDecimal orderPrice) {
		this.orderPrice = orderPrice;
	}

	public String getStyleNo() {
		return styleNo;
	}

	public void setStyleNo(String styleNo) {
		this.styleNo = styleNo;
	}

	public String getStyleName() {
		return styleName;
	}

	public void setStyleName(String styleName) {
		this.styleName = styleName;
	}

	public Integer getBrandId() {
		return brandId;
	}

	public void setBrandId(Integer brandId) {
		this.brandId = brandId;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public Integer getSeasonId() {
		return seasonId;
	}

	public void setSeasonId(Integer seasonId) {
		this.seasonId = seasonId;
	}

	public String getSeason() {
		return season;
	}

	public void setSeason(String season) {
		this.season = season;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getUpcNo() {
		return upcNo;
	}

	public void setUpcNo(String upcNo) {
		this.upcNo = upcNo;
	}

	public String getColour() {
		return colour;
	}

	public void setColour(String colour) {
		this.colour = colour;
	}

	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
	}

	public Integer getQoh() {
		return qoh;
	}

	public void setQoh(Integer qoh) {
		this.qoh = qoh;
	}

	public Double getRrp() {
		return rrp;
	}

	public void setRrp(Double rrp) {
		this.rrp = rrp;
	}

	public Double getWsp() {
		return wsp;
	}

	public void setWsp(Double wsp) {
		this.wsp = wsp;
	}

	public String getBuyer() {
		return buyer;
	}

	public void setBuyer(String buyer) {
		this.buyer = buyer;
	}

	public Integer getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(Integer creatorId) {
		this.creatorId = creatorId;
	}

	public Integer getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}

	public String getCustomerPo() {
		return customerPo;
	}

	public void setCustomerPo(String customerPo) {
		this.customerPo = customerPo;
	}

	public Integer getFinishBy() {
		return finishBy;
	}

	public void setFinishBy(Integer finishBy) {
		this.finishBy = finishBy;
	}

	public LocalDate getFinishDate() {
		return finishDate;
	}

	public void setFinishDate(LocalDate finishDate) {
		this.finishDate = finishDate;
	}

	public Integer getInvoiceBy() {
		return invoiceBy;
	}

	public void setInvoiceBy(Integer invoiceBy) {
		this.invoiceBy = invoiceBy;
	}

	public LocalDate getInvoiceDate() {
		return invoiceDate;
	}

	public void setInvoiceDate(LocalDate invoiceDate) {
		this.invoiceDate = invoiceDate;
	}

	public LocalDate getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(LocalDate orderDate) {
		this.orderDate = orderDate;
	}

	public String getOrderName() {
		return orderName;
	}

	public void setOrderName(String orderName) {
		this.orderName = orderName;
	}

	public String getOrderNumber() {
		return orderNumber;
	}

	public void setOrderNumber(String orderNumber) {
		this.orderNumber = orderNumber;
	}

	public Integer getOrderStatus() {
		return orderStatus;
	}

	public void setOrderStatus(Integer orderStatus) {
		this.orderStatus = orderStatus;
	}

	public LocalTime getOrderTime() {
		return orderTime;
	}

	public void setOrderTime(LocalTime orderTime) {
		this.orderTime = orderTime;
	}

	public Integer getRepId() {
		return repId;
	}

	public void setRepId(Integer repId) {
		this.repId = repId;
	}

	public LocalDate getRequireDate() {
		return requireDate;
	}

	public void setRequireDate(LocalDate requireDate) {
		this.requireDate = requireDate;
	}

	public LocalTime getRequireTime() {
		return requireTime;
	}

	public void setRequireTime(LocalTime requireTime) {
		this.requireTime = requireTime;
	}

	public LocalDate getCancelDate() {
		return cancelDate;
	}

	public void setCancelDate(LocalDate cancelDate) {
		this.cancelDate = cancelDate;
	}

	public String getBusinessName() {
		return businessName;
	}

	public void setBusinessName(String businessName) {
		this.businessName = businessName;
	}

	public String getCreator() {
		return creator;
	}

	public void setCreator(String creator) {
		this.creator = creator;
	}

	public String getRep() {
		return rep;
	}

	public void setRep(String rep) {
		this.rep = rep;
	}


}
