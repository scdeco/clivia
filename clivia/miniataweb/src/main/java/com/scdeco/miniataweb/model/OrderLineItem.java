package com.scdeco.miniataweb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class OrderLineItem extends CliviaSuperModel{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	@Column(name="OrderId")
	private int orderId;
	
	@Column(name="OrderItemId")
	private int orderItemId;
	
	@Column(name="LineNo")
	private int lineNo;
	
	@Column(name="BrandId")
	private int brandId;
	
	@Column(name="SeasonId")
	private int seasonId;
	
	@Column(name="GarmentId")
	private int garmentId;

	@Column(name="StyleNo",length=20)
	private String styleNo;
	
	@Column(name="Description",length=255)
	private String description;
	
	@Column(name="Colour",length=50)
	private String colour;
	
	@Column(name="Size",length=20)
	private String size;

	@Column(name="Qty00")
	private Integer qty00;
	
	@Column(name="Qty01")
	private Integer qty01;

	@Column(name="Qty02")
	private Integer qty02;
	
	@Column(name="Qty03")
	private Integer qty03;
	
	@Column(name="Qty04")
	private Integer qty04;
	
	@Column(name="Qty05")
	private Integer qty05;
	
	@Column(name="Qty06")
	private Integer qty06;
	
	@Column(name="Qty07")
	private Integer qty07;
	
	@Column(name="Qty08")
	private Integer qty08;
	
	@Column(name="Qty09")
	private Integer qty09;
	
	@Column(name="Qty10")
	private Integer qty10;
	
	@Column(name="Qty11")
	private Integer qty11;
	
	@Column(name="Qty12")
	private Integer qty12;
	
	@Column(name="Qty13")
	private Integer qty13;

	@Column(name="Qty14")
	private Integer qty14;

	@Column(name="Qty15")
	private Integer qty15;
	
	@Column(name="Qty16")
	private Integer qty16;
	
	@Column(name="Qty17")
	private Integer qty17;
	
	@Column(name="Qty18")
	private Integer qty18;
	
	@Column(name="Qty19")
	private Integer qty19;
	
	@Column(name="Qty20")
	private Integer qty20;

	@Column(name="Qty21")
	private Integer qty21;
	
	@Column(name="Quantity")
	private Integer quantity;
		
	@Column(name="Remark",length=50)
	private String remark;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public int getOrderItemId() {
		return orderItemId;
	}

	public void setOrderItemId(int orderItemId) {
		this.orderItemId = orderItemId;
	}

	public int getLineNo() {
		return lineNo;
	}

	public void setLineNo(int lineNo) {
		this.lineNo = lineNo;
	}

	public int getBrandId() {
		return brandId;
	}

	public void setBrandId(int brandId) {
		this.brandId = brandId;
	}

	public int getSeasonId() {
		return seasonId;
	}

	public void setSeasonId(int seasonId) {
		this.seasonId = seasonId;
	}

	public int getGarmentId() {
		return garmentId;
	}

	public void setGarmentId(int garmentId) {
		this.garmentId = garmentId;
	}

	public String getStyleNo() {
		return styleNo;
	}

	public void setStyleNo(String styleNo) {
		this.styleNo = styleNo;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
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

	public Integer getQty00() {
		return qty00;
	}

	public void setQty00(Integer qty00) {
		this.qty00 = qty00;
	}

	public Integer getQty01() {
		return qty01;
	}

	public void setQty01(Integer qty01) {
		this.qty01 = qty01;
	}

	public Integer getQty02() {
		return qty02;
	}

	public void setQty02(Integer qty02) {
		this.qty02 = qty02;
	}

	public Integer getQty03() {
		return qty03;
	}

	public void setQty03(Integer qty03) {
		this.qty03 = qty03;
	}

	public Integer getQty04() {
		return qty04;
	}

	public void setQty04(Integer qty04) {
		this.qty04 = qty04;
	}

	public Integer getQty05() {
		return qty05;
	}

	public void setQty05(Integer qty05) {
		this.qty05 = qty05;
	}

	public Integer getQty06() {
		return qty06;
	}

	public void setQty06(Integer qty06) {
		this.qty06 = qty06;
	}

	public Integer getQty07() {
		return qty07;
	}

	public void setQty07(Integer qty07) {
		this.qty07 = qty07;
	}

	public Integer getQty08() {
		return qty08;
	}

	public void setQty08(Integer qty08) {
		this.qty08 = qty08;
	}

	public Integer getQty09() {
		return qty09;
	}

	public void setQty09(Integer qty09) {
		this.qty09 = qty09;
	}

	public Integer getQty10() {
		return qty10;
	}

	public void setQty10(Integer qty10) {
		this.qty10 = qty10;
	}

	public Integer getQty11() {
		return qty11;
	}

	public void setQty11(Integer qty11) {
		this.qty11 = qty11;
	}

	public Integer getQty12() {
		return qty12;
	}

	public void setQty12(Integer qty12) {
		this.qty12 = qty12;
	}

	public Integer getQty13() {
		return qty13;
	}

	public void setQty13(Integer qty13) {
		this.qty13 = qty13;
	}

	public Integer getQty14() {
		return qty14;
	}

	public void setQty14(Integer qty14) {
		this.qty14 = qty14;
	}

	public Integer getQty15() {
		return qty15;
	}

	public void setQty15(Integer qty15) {
		this.qty15 = qty15;
	}

	public Integer getQty16() {
		return qty16;
	}

	public void setQty16(Integer qty16) {
		this.qty16 = qty16;
	}

	public Integer getQty17() {
		return qty17;
	}

	public void setQty17(Integer qty17) {
		this.qty17 = qty17;
	}

	public Integer getQty18() {
		return qty18;
	}

	public void setQty18(Integer qty18) {
		this.qty18 = qty18;
	}

	public Integer getQty19() {
		return qty19;
	}

	public void setQty19(Integer qty19) {
		this.qty19 = qty19;
	}

	public Integer getQty20() {
		return qty20;
	}

	public void setQty20(Integer qty20) {
		this.qty20 = qty20;
	}

	public Integer getQty21() {
		return qty21;
	}

	public void setQty21(Integer qty21) {
		this.qty21 = qty21;
	}

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}
