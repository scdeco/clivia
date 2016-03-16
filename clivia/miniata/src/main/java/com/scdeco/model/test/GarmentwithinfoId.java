package test;

// Generated Mar 12, 2016 8:10:40 PM by Hibernate Tools 4.3.1

import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * GarmentwithinfoId generated by hbm2java
 */
@Embeddable
public class GarmentwithinfoId implements java.io.Serializable {

	@Column(name = "garmentId", nullable = false)
	private int garmentId;

	@Column(name = "styleNo", nullable = false, length = 20)
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

	@Column(name = "colourway", length = 250)
	private String colourway;

	@Column(name = "sizeRange", length = 150)
	private String sizeRange;

	@Column(name = "qoh")
	private Integer qoh;

	@Column(name = "sq")
	private Integer sq;

	@Column(name = "pq")
	private Integer pq;

	@Column(name = "rrp", precision = 22, scale = 0)
	private Double rrp;

	@Column(name = "wsp", precision = 22, scale = 0)
	private Double wsp;

	@Column(name = "description", length = 200)
	private String description;

	@Column(name = "feature", length = 200)
	private String feature;

	@Column(name = "keyword", length = 100)
	private String keyword;

	@Column(name = "used")
	private Boolean used;

	@Column(name = "remark", length = 500)
	private String remark;

	public GarmentwithinfoId() {
	}

	public GarmentwithinfoId(int garmentId, String styleNo) {
		this.garmentId = garmentId;
		this.styleNo = styleNo;
	}

	public GarmentwithinfoId(int garmentId, String styleNo, String styleName,
			Integer brandId, String brand, Integer seasonId, String season,
			String category, String colourway, String sizeRange, Integer qoh,
			Integer sq, Integer pq, Double rrp, Double wsp, String description,
			String feature, String keyword, Boolean used, String remark) {
		this.garmentId = garmentId;
		this.styleNo = styleNo;
		this.styleName = styleName;
		this.brandId = brandId;
		this.brand = brand;
		this.seasonId = seasonId;
		this.season = season;
		this.category = category;
		this.colourway = colourway;
		this.sizeRange = sizeRange;
		this.qoh = qoh;
		this.sq = sq;
		this.pq = pq;
		this.rrp = rrp;
		this.wsp = wsp;
		this.description = description;
		this.feature = feature;
		this.keyword = keyword;
		this.used = used;
		this.remark = remark;
	}

	public int getGarmentId() {
		return this.garmentId;
	}

	public void setGarmentId(int garmentId) {
		this.garmentId = garmentId;
	}

	public String getStyleNo() {
		return this.styleNo;
	}

	public void setStyleNo(String styleNo) {
		this.styleNo = styleNo;
	}

	public String getStyleName() {
		return this.styleName;
	}

	public void setStyleName(String styleName) {
		this.styleName = styleName;
	}

	public Integer getBrandId() {
		return this.brandId;
	}

	public void setBrandId(Integer brandId) {
		this.brandId = brandId;
	}

	public String getBrand() {
		return this.brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public Integer getSeasonId() {
		return this.seasonId;
	}

	public void setSeasonId(Integer seasonId) {
		this.seasonId = seasonId;
	}

	public String getSeason() {
		return this.season;
	}

	public void setSeason(String season) {
		this.season = season;
	}

	public String getCategory() {
		return this.category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getColourway() {
		return this.colourway;
	}

	public void setColourway(String colourway) {
		this.colourway = colourway;
	}

	public String getSizeRange() {
		return this.sizeRange;
	}

	public void setSizeRange(String sizeRange) {
		this.sizeRange = sizeRange;
	}

	public Integer getQoh() {
		return this.qoh;
	}

	public void setQoh(Integer qoh) {
		this.qoh = qoh;
	}

	public Integer getSq() {
		return this.sq;
	}

	public void setSq(Integer sq) {
		this.sq = sq;
	}

	public Integer getPq() {
		return this.pq;
	}

	public void setPq(Integer pq) {
		this.pq = pq;
	}

	public Double getRrp() {
		return this.rrp;
	}

	public void setRrp(Double rrp) {
		this.rrp = rrp;
	}

	public Double getWsp() {
		return this.wsp;
	}

	public void setWsp(Double wsp) {
		this.wsp = wsp;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getFeature() {
		return this.feature;
	}

	public void setFeature(String feature) {
		this.feature = feature;
	}

	public String getKeyword() {
		return this.keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public Boolean getUsed() {
		return this.used;
	}

	public void setUsed(Boolean used) {
		this.used = used;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof GarmentwithinfoId))
			return false;
		GarmentwithinfoId castOther = (GarmentwithinfoId) other;

		return (this.getGarmentId() == castOther.getGarmentId())
				&& ((this.getStyleNo() == castOther.getStyleNo()) || (this
						.getStyleNo() != null && castOther.getStyleNo() != null && this
						.getStyleNo().equals(castOther.getStyleNo())))
				&& ((this.getStyleName() == castOther.getStyleName()) || (this
						.getStyleName() != null
						&& castOther.getStyleName() != null && this
						.getStyleName().equals(castOther.getStyleName())))
				&& ((this.getBrandId() == castOther.getBrandId()) || (this
						.getBrandId() != null && castOther.getBrandId() != null && this
						.getBrandId().equals(castOther.getBrandId())))
				&& ((this.getBrand() == castOther.getBrand()) || (this
						.getBrand() != null && castOther.getBrand() != null && this
						.getBrand().equals(castOther.getBrand())))
				&& ((this.getSeasonId() == castOther.getSeasonId()) || (this
						.getSeasonId() != null
						&& castOther.getSeasonId() != null && this
						.getSeasonId().equals(castOther.getSeasonId())))
				&& ((this.getSeason() == castOther.getSeason()) || (this
						.getSeason() != null && castOther.getSeason() != null && this
						.getSeason().equals(castOther.getSeason())))
				&& ((this.getCategory() == castOther.getCategory()) || (this
						.getCategory() != null
						&& castOther.getCategory() != null && this
						.getCategory().equals(castOther.getCategory())))
				&& ((this.getColourway() == castOther.getColourway()) || (this
						.getColourway() != null
						&& castOther.getColourway() != null && this
						.getColourway().equals(castOther.getColourway())))
				&& ((this.getSizeRange() == castOther.getSizeRange()) || (this
						.getSizeRange() != null
						&& castOther.getSizeRange() != null && this
						.getSizeRange().equals(castOther.getSizeRange())))
				&& ((this.getQoh() == castOther.getQoh()) || (this.getQoh() != null
						&& castOther.getQoh() != null && this.getQoh().equals(
						castOther.getQoh())))
				&& ((this.getSq() == castOther.getSq()) || (this.getSq() != null
						&& castOther.getSq() != null && this.getSq().equals(
						castOther.getSq())))
				&& ((this.getPq() == castOther.getPq()) || (this.getPq() != null
						&& castOther.getPq() != null && this.getPq().equals(
						castOther.getPq())))
				&& ((this.getRrp() == castOther.getRrp()) || (this.getRrp() != null
						&& castOther.getRrp() != null && this.getRrp().equals(
						castOther.getRrp())))
				&& ((this.getWsp() == castOther.getWsp()) || (this.getWsp() != null
						&& castOther.getWsp() != null && this.getWsp().equals(
						castOther.getWsp())))
				&& ((this.getDescription() == castOther.getDescription()) || (this
						.getDescription() != null
						&& castOther.getDescription() != null && this
						.getDescription().equals(castOther.getDescription())))
				&& ((this.getFeature() == castOther.getFeature()) || (this
						.getFeature() != null && castOther.getFeature() != null && this
						.getFeature().equals(castOther.getFeature())))
				&& ((this.getKeyword() == castOther.getKeyword()) || (this
						.getKeyword() != null && castOther.getKeyword() != null && this
						.getKeyword().equals(castOther.getKeyword())))
				&& ((this.getUsed() == castOther.getUsed()) || (this.getUsed() != null
						&& castOther.getUsed() != null && this.getUsed()
						.equals(castOther.getUsed())))
				&& ((this.getRemark() == castOther.getRemark()) || (this
						.getRemark() != null && castOther.getRemark() != null && this
						.getRemark().equals(castOther.getRemark())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + this.getGarmentId();
		result = 37 * result
				+ (getStyleNo() == null ? 0 : this.getStyleNo().hashCode());
		result = 37 * result
				+ (getStyleName() == null ? 0 : this.getStyleName().hashCode());
		result = 37 * result
				+ (getBrandId() == null ? 0 : this.getBrandId().hashCode());
		result = 37 * result
				+ (getBrand() == null ? 0 : this.getBrand().hashCode());
		result = 37 * result
				+ (getSeasonId() == null ? 0 : this.getSeasonId().hashCode());
		result = 37 * result
				+ (getSeason() == null ? 0 : this.getSeason().hashCode());
		result = 37 * result
				+ (getCategory() == null ? 0 : this.getCategory().hashCode());
		result = 37 * result
				+ (getColourway() == null ? 0 : this.getColourway().hashCode());
		result = 37 * result
				+ (getSizeRange() == null ? 0 : this.getSizeRange().hashCode());
		result = 37 * result
				+ (getQoh() == null ? 0 : this.getQoh().hashCode());
		result = 37 * result + (getSq() == null ? 0 : this.getSq().hashCode());
		result = 37 * result + (getPq() == null ? 0 : this.getPq().hashCode());
		result = 37 * result
				+ (getRrp() == null ? 0 : this.getRrp().hashCode());
		result = 37 * result
				+ (getWsp() == null ? 0 : this.getWsp().hashCode());
		result = 37
				* result
				+ (getDescription() == null ? 0 : this.getDescription()
						.hashCode());
		result = 37 * result
				+ (getFeature() == null ? 0 : this.getFeature().hashCode());
		result = 37 * result
				+ (getKeyword() == null ? 0 : this.getKeyword().hashCode());
		result = 37 * result
				+ (getUsed() == null ? 0 : this.getUsed().hashCode());
		result = 37 * result
				+ (getRemark() == null ? 0 : this.getRemark().hashCode());
		return result;
	}

}