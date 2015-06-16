<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>


<shared:header></shared:header>
<div id="version"><h2>Version:${version}122222</h2></div>

    <kendo:grid name="grid" pageable="${gridInfo.pageable}" sortable="${gridInfo.sortable}" filterable="${gridInfo.filterable}" editable="${gridInfo.editable}" resizable="true" >
    	<kendo:grid-scrollable/>
        <kendo:grid-columns>
        	<c:forEach var="gridColumn" items="${gridColumnList}">
	            <kendo:grid-column field="${gridColumn.columnName}" title="${gridColumn.title}"  width="${gridColumn.width}" />
	        </c:forEach>
        </kendo:grid-columns>
    
	    <kendo:dataSource data="${gridData}" pageSize="10" batch="true">        
	        <kendo:dataSource-schema>
	            <kendo:dataSource-schema-model>
	                <kendo:dataSource-schema-model-fields>
			        	<c:forEach var="gridColumn" items="${gridColumnList}">
				            <kendo:dataSource-schema-model-field name="${gridColumn.columnName}" type="${gridColumn.dataType}" />
				        </c:forEach>
	                </kendo:dataSource-schema-model-fields>
	            </kendo:dataSource-schema-model>
	        </kendo:dataSource-schema>
	    </kendo:dataSource>
    </kendo:grid>
    "${gridColumnList}" <br/>
    
    "${gridData}" <br/>
    
    "${users}"
    
    <style>    
    #grid .k-grid-content{
    	height: 430px; 	
    }
    </style>
    
    <shared:footer></shared:footer>