package com.scdeco.miniataweb.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class OrderBillItemView {
	
	@Id
	@Column(name = "rowId", nullable = false)
	private int rowId;

	@Column(name = "description")
	private String description;

	@Column(name = "finishAmt")
	private BigDecimal finishAmt;

	@Column(name = "finishQty")
	private BigDecimal finishQty;

	@Column(name = "invoiceAmt")
	private BigDecimal invoiceAmt;

	@Column(name = "invoicePrice")
	private BigDecimal invoicePrice;

	@Column(name = "invoiceQty")
	private BigDecimal invoiceQty;

	@Column(name = "itemNumber", length = 20)
	private String itemNumber;

	@Column(name = "lineNo")
	private Integer lineNo;

	@Column(name = "orderAmt")
	private BigDecimal orderAmt;

	@Column(name = "orderItemId")
	private Integer orderItemId;

	@Column(name = "orderPrice")
	private BigDecimal orderPrice;

	@Column(name = "orderQty")
	private BigDecimal orderQty;

	@Column(name = "remark")
	private String remark;

	@Column(name = "snpId")
	private Integer snpId;

	@Column(name = "unit", length = 20)
	private String unit;

	@Column(name = "billingKey", length = 20)
	private String billingKey;

	@Column(name = "itemTypeId")
	private Integer itemTypeId;

	@Column(name = "dsicount")
	private BigDecimal dsicount;

	@Column(name = "listPrice")
	private BigDecimal listPrice;

	@Column(name = "orderId", nullable = false)
	private int orderId;

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

	@Column(name = "finishDate", length = 10)
	private LocalDate finishDate;

	@Column(name = "invoiceBy")
	private Integer invoiceBy;

	@Column(name = "invoiceDate", length = 10)
	private LocalDate invoiceDate;

	@Column(name = "orderDate", length = 10)
	private LocalDate orderDate;

	@Column(name = "orderName", length = 100)
	private String orderName;

	@Column(name = "orderNumber", nullable = false, length = 20)
	private String orderNumber;

	@Column(name = "orderStatus")
	private Integer orderStatus;

	@Column(name = "orderTime", length = 8)
	private LocalTime orderTime;

	@Column(name = "repId")
	private Integer repId;

	@Column(name = "requireDate", length = 10)
	private LocalDate requireDate;

	@Column(name = "requireTime", length = 8)
	private LocalTime requireTime;

	@Column(name = "businessName", length = 100)
	private String businessName;

	@Column(name="Country",length=20)
	private String country;	
	
	@Column(name = "creator", length = 511)
	private String creator;

	@Column(name = "rep", length = 511)
	private String rep;

	@Column(name = "snp", length = 50)
	private String snp;

	public int getRowId() {
		return rowId;
	}

	public void setRowId(int rowId) {
		this.rowId = rowId;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public BigDecimal getFinishAmt() {
		return finishAmt;
	}

	public void setFinishAmt(BigDecimal finishAmt) {
		this.finishAmt = finishAmt;
	}

	public BigDecimal getFinishQty() {
		return finishQty;
	}

	public void setFinishQty(BigDecimal finishQty) {
		this.finishQty = finishQty;
	}

	public BigDecimal getInvoiceAmt() {
		return invoiceAmt;
	}

	public void setInvoiceAmt(BigDecimal invoiceAmt) {
		this.invoiceAmt = invoiceAmt;
	}

	public BigDecimal getInvoicePrice() {
		return invoicePrice;
	}

	public void setInvoicePrice(BigDecimal invoicePrice) {
		this.invoicePrice = invoicePrice;
	}

	public BigDecimal getInvoiceQty() {
		return invoiceQty;
	}

	public void setInvoiceQty(BigDecimal invoiceQty) {
		this.invoiceQty = invoiceQty;
	}

	public String getItemNumber() {
		return itemNumber;
	}

	public void setItemNumber(String itemNumber) {
		this.itemNumber = itemNumber;
	}

	public Integer getLineNo() {
		return lineNo;
	}

	public void setLineNo(Integer lineNo) {
		this.lineNo = lineNo;
	}

	public BigDecimal getOrderAmt() {
		return orderAmt;
	}

	public void setOrderAmt(BigDecimal orderAmt) {
		this.orderAmt = orderAmt;
	}

	public Integer getOrderItemId() {
		return orderItemId;
	}

	public void setOrderItemId(Integer orderItemId) {
		this.orderItemId = orderItemId;
	}

	public BigDecimal getOrderPrice() {
		return orderPrice;
	}

	public void setOrderPrice(BigDecimal orderPrice) {
		this.orderPrice = orderPrice;
	}

	public BigDecimal getOrderQty() {
		return orderQty;
	}

	public void setOrderQty(BigDecimal orderQty) {
		this.orderQty = orderQty;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Integer getSnpId() {
		return snpId;
	}

	public void setSnpId(Integer snpId) {
		this.snpId = snpId;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public String getBillingKey() {
		return billingKey;
	}

	public void setBillingKey(String billingKey) {
		this.billingKey = billingKey;
	}

	public Integer getItemTypeId() {
		return itemTypeId;
	}

	public void setItemTypeId(Integer itemTypeId) {
		this.itemTypeId = itemTypeId;
	}

	public BigDecimal getDsicount() {
		return dsicount;
	}

	public void setDsicount(BigDecimal dsicount) {
		this.dsicount = dsicount;
	}

	public BigDecimal getListPrice() {
		return listPrice;
	}

	public void setListPrice(BigDecimal listPrice) {
		this.listPrice = listPrice;
	}

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
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

	public String getBusinessName() {
		return businessName;
	}

	public void setBusinessName(String businessName) {
		this.businessName = businessName;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
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

	public String getSnp() {
		return snp;
	}

	public void setSnp(String snp) {
		this.snp = snp;
	}
}
