package test;

// Generated Mar 12, 2016 8:10:40 PM by Hibernate Tools 4.3.1

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * Garmentwithinfo generated by hbm2java
 */
@Entity
@Table(name = "garmentwithinfo", catalog = "world")
public class Garmentwithinfo implements java.io.Serializable {

	@EmbeddedId
	@AttributeOverrides({
			@AttributeOverride(name = "garmentId", column = @Column(name = "garmentId", nullable = false)),
			@AttributeOverride(name = "styleNo", column = @Column(name = "styleNo", nullable = false, length = 20)),
			@AttributeOverride(name = "styleName", column = @Column(name = "styleName", length = 50)),
			@AttributeOverride(name = "brandId", column = @Column(name = "brandId")),
			@AttributeOverride(name = "brand", column = @Column(name = "brand", length = 50)),
			@AttributeOverride(name = "seasonId", column = @Column(name = "seasonId")),
			@AttributeOverride(name = "season", column = @Column(name = "season", length = 50)),
			@AttributeOverride(name = "category", column = @Column(name = "category", length = 30)),
			@AttributeOverride(name = "colourway", column = @Column(name = "colourway", length = 250)),
			@AttributeOverride(name = "sizeRange", column = @Column(name = "sizeRange", length = 150)),
			@AttributeOverride(name = "qoh", column = @Column(name = "qoh")),
			@AttributeOverride(name = "sq", column = @Column(name = "sq")),
			@AttributeOverride(name = "pq", column = @Column(name = "pq")),
			@AttributeOverride(name = "rrp", column = @Column(name = "rrp", precision = 22, scale = 0)),
			@AttributeOverride(name = "wsp", column = @Column(name = "wsp", precision = 22, scale = 0)),
			@AttributeOverride(name = "description", column = @Column(name = "description", length = 200)),
			@AttributeOverride(name = "feature", column = @Column(name = "feature", length = 200)),
			@AttributeOverride(name = "keyword", column = @Column(name = "keyword", length = 100)),
			@AttributeOverride(name = "used", column = @Column(name = "used")),
			@AttributeOverride(name = "remark", column = @Column(name = "remark", length = 500)) })
	private GarmentwithinfoId id;

	public Garmentwithinfo() {
	}

	public Garmentwithinfo(GarmentwithinfoId id) {
		this.id = id;
	}

	public GarmentwithinfoId getId() {
		return this.id;
	}

	public void setId(GarmentwithinfoId id) {
		this.id = id;
	}

}