package test;

// Generated Mar 12, 2016 8:10:40 PM by Hibernate Tools 4.3.1

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * Companywithinfo generated by hbm2java
 */
@Entity
@Table(name = "companywithinfo", catalog = "world")
public class Companywithinfo implements java.io.Serializable {

	@EmbeddedId
	@AttributeOverrides({
			@AttributeOverride(name = "id", column = @Column(name = "id", nullable = false)),
			@AttributeOverride(name = "businessName", column = @Column(name = "businessName", nullable = false, length = 100)),
			@AttributeOverride(name = "category", column = @Column(name = "category", length = 50)),
			@AttributeOverride(name = "city", column = @Column(name = "city", length = 30)),
			@AttributeOverride(name = "province", column = @Column(name = "province", length = 20)),
			@AttributeOverride(name = "country", column = @Column(name = "country", length = 20)),
			@AttributeOverride(name = "website", column = @Column(name = "website", length = 80)),
			@AttributeOverride(name = "isCustomer", column = @Column(name = "isCustomer")),
			@AttributeOverride(name = "isSupplier", column = @Column(name = "isSupplier")),
			@AttributeOverride(name = "status", column = @Column(name = "status")),
			@AttributeOverride(name = "repId", column = @Column(name = "repId")),
			@AttributeOverride(name = "csrId", column = @Column(name = "csrId")),
			@AttributeOverride(name = "discount", column = @Column(name = "discount")),
			@AttributeOverride(name = "term", column = @Column(name = "term", length = 50)),
			@AttributeOverride(name = "useWsp", column = @Column(name = "useWsp")),
			@AttributeOverride(name = "repFirstName", column = @Column(name = "repFirstName")),
			@AttributeOverride(name = "repLastName", column = @Column(name = "repLastName")),
			@AttributeOverride(name = "csrFirstName", column = @Column(name = "csrFirstName")),
			@AttributeOverride(name = "csrLastName", column = @Column(name = "csrLastName")) })
	private CompanywithinfoId id;

	public Companywithinfo() {
	}

	public Companywithinfo(CompanywithinfoId id) {
		this.id = id;
	}

	public CompanywithinfoId getId() {
		return this.id;
	}

	public void setId(CompanywithinfoId id) {
		this.id = id;
	}

}
