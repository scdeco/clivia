package com.scdeco.miniataweb.dao;

import java.util.List;
import java.util.Map;

public class DataSourceResult {
	
    private long total;
    
    private List<?> data;
    
    private Map<String, Object> aggregates;

    public DataSourceResult(){
    	System.out.println("2222222222222222222222222222222222"); 
    }
    public long getTotal() {
        return total;
    }

    public void setTotal(long total) {
        this.total = total;
    }

    public List<?> getData() {
        return data;
    }

    public void setData(List<?> data) {
        this.data = data;
    }

    public Map<String, Object> getAggregates() {
        return aggregates;
    }

    public void setAggregates(Map<String, Object> aggregates) {
        this.aggregates = aggregates;
    }
}
