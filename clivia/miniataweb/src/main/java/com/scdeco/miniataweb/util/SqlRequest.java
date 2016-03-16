package com.scdeco.miniataweb.util;

public class SqlRequest {
	
		private String select;
		private String from;
		private String where;
		private String orderby;
		private Boolean mapResult;
		public String getSelect() {
			return select;
		}
		public void setSelect(String select) {
			this.select = select;
		}
		public String getFrom() {
			return from;
		}
		public void setFrom(String from) {
			this.from = from;
		}
		public String getWhere() {
			return where;
		}
		public void setWhere(String where) {
			this.where = where;
		}
		public String getOrderby() {
			return orderby;
		}
		public void setOrderby(String orderby) {
			this.orderby = orderby;
		}
		public Boolean getMapResult() {
			return mapResult;
		}
		public void setMapResult(Boolean mapResult) {
			this.mapResult = mapResult;
		}
		
}
