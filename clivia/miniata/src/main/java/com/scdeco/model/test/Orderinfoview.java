package test;

// Generated Mar 12, 2016 8:10:40 PM by Hibernate Tools 4.3.1

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * Orderinfoview generated by hbm2java
 */
@Entity
@Table(name = "orderinfoview", catalog = "world")
public class Orderinfoview implements java.io.Serializable {

	@EmbeddedId
	@AttributeOverrides({
			@AttributeOverride(name = "orderId", column = @Column(name = "orderId", nullable = false)),
			@AttributeOverride(name = "buyer", column = @Column(name = "buyer", length = 50)),
			@AttributeOverride(name = "creatorId", column = @Column(name = "creatorId")),
			@AttributeOverride(name = "customerId", column = @Column(name = "customerId")),
			@AttributeOverride(name = "customerPo", column = @Column(name = "customerPO", length = 50)),
			@AttributeOverride(name = "finishBy", column = @Column(name = "finishBy")),
			@AttributeOverride(name = "finishDate", column = @Column(name = "finishDate", length = 10)),
			@AttributeOverride(name = "invoiceBy", column = @Column(name = "invoiceBy")),
			@AttributeOverride(name = "invoiceDate", column = @Column(name = "invoiceDate", length = 10)),
			@AttributeOverride(name = "orderDate", column = @Column(name = "orderDate", length = 10)),
			@AttributeOverride(name = "orderName", column = @Column(name = "orderName", length = 100)),
			@AttributeOverride(name = "orderNumber", column = @Column(name = "orderNumber", nullable = false, length = 20)),
			@AttributeOverride(name = "orderStatus", column = @Column(name = "orderStatus")),
			@AttributeOverride(name = "orderTime", column = @Column(name = "orderTime", length = 8)),
			@AttributeOverride(name = "repId", column = @Column(name = "repId")),
			@AttributeOverride(name = "requireDate", column = @Column(name = "requireDate", length = 10)),
			@AttributeOverride(name = "requireTime", column = @Column(name = "requireTime", length = 8)),
			@AttributeOverride(name = "businessName", column = @Column(name = "businessName", length = 100)),
			@AttributeOverride(name = "creator", column = @Column(name = "creator", length = 511)),
			@AttributeOverride(name = "rep", column = @Column(name = "rep", length = 511)) })
	private OrderinfoviewId id;

	public Orderinfoview() {
	}

	public Orderinfoview(OrderinfoviewId id) {
		this.id = id;
	}

	public OrderinfoviewId getId() {
		return this.id;
	}

	public void setId(OrderinfoviewId id) {
		this.id = id;
	}

}