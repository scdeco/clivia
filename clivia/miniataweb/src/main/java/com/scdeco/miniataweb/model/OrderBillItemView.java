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

	@Column(name = "creator", length = 511)
	private String creator;

	@Column(name = "rep", length = 511)
	private String rep;

	@Column(name = "snp", length = 50)
	private String snp;

	public int getRowId() {
		return rowId;
	}

	public String getDescription() {
		return description;
	}

	public BigDecimal getFinishAmt() {
		return finishAmt;
	}

	public BigDecimal getFinishQty() {
		return finishQty;
	}

	public BigDecimal getInvoiceAmt() {
		return invoiceAmt;
	}

	public BigDecimal getInvoicePrice() {
		return invoicePrice;
	}

	public BigDecimal getInvoiceQty() {
		return invoiceQty;
	}

	public String getItemNumber() {
		return itemNumber;
	}

	public Integer getLineNo() {
		return lineNo;
	}

	public BigDecimal getOrderAmt() {
		return orderAmt;
	}

	public Integer getOrderItemId() {
		return orderItemId;
	}

	public BigDecimal getOrderPrice() {
		return orderPrice;
	}

	public BigDecimal getOrderQty() {
		return orderQty;
	}

	public String getRemark() {
		return remark;
	}

	public Integer getSnpId() {
		return snpId;
	}

	public String getUnit() {
		return unit;
	}

	public String getBillingKey() {
		return billingKey;
	}

	public Integer getItemTypeId() {
		return itemTypeId;
	}

	public BigDecimal getDsicount() {
		return dsicount;
	}

	public BigDecimal getListPrice() {
		return listPrice;
	}

	public int getOrderId() {
		return orderId;
	}

	public String getBuyer() {
		return buyer;
	}

	public Integer getCreatorId() {
		return creatorId;
	}

	public Integer getCustomerId() {
		return customerId;
	}

	public String getCustomerPo() {
		return customerPo;
	}

	public Integer getFinishBy() {
		return finishBy;
	}

	public LocalDate getFinishDate() {
		return finishDate;
	}

	public Integer getInvoiceBy() {
		return invoiceBy;
	}

	public LocalDate getInvoiceDate() {
		return invoiceDate;
	}

	public LocalDate getOrderDate() {
		return orderDate;
	}

	public String getOrderName() {
		return orderName;
	}

	public String getOrderNumber() {
		return orderNumber;
	}

	public Integer getOrderStatus() {
		return orderStatus;
	}

	public LocalTime getOrderTime() {
		return orderTime;
	}

	public Integer getRepId() {
		return repId;
	}

	public LocalDate getRequireDate() {
		return requireDate;
	}

	public LocalTime getRequireTime() {
		return requireTime;
	}

	public String getBusinessName() {
		return businessName;
	}

	public String getCreator() {
		return creator;
	}

	public String getRep() {
		return rep;
	}

	public String getSnp() {
		return snp;
	}
}
