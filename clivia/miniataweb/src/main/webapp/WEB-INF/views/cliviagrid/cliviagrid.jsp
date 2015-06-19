<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>


<shared:header></shared:header>

<c:url var="readUrl" value="cliviagrid/read" />

<div id="version"><h2>Version:${version}1222436</h2></div>

    <kendo:grid name="grid" pageable="${gridInfo.pageable}" sortable="${gridInfo.sortable}" filterable="${gridInfo.filterable}" editable="${gridInfo.editable}"  resizable="true" >
    	<kendo:grid-scrollable/>
    	
        <kendo:grid-columns>
        	<c:forEach var="gridColumn" items="${gridColumnList}">
	            <kendo:grid-column field="${gridColumn.columnName}" title="${gridColumn.title}"  width="${gridColumn.width}px"  hidden="${!gridColumn.visible}" />
	        </c:forEach>
        </kendo:grid-columns>
        
        <kendo:dataSource pageSize="10"  batch="true">        
      
	        <kendo:dataSource-transport>
	            <kendo:dataSource-transport-read url="${readUrl}" dataType="json"  contentType="application/json" />
	        </kendo:dataSource-transport>      
        
            <kendo:dataSource-schema>
                <kendo:dataSource-schema-model id="id" >
                    <kendo:dataSource-schema-model-fields>
				        	<c:forEach var="gridColumn" items="${gridColumnList}">
					            <kendo:dataSource-schema-model-field name="${gridColumn.columnName}" type="${gridColumn.dataType}" />
					        </c:forEach>
                    </kendo:dataSource-schema-model-fields>
                </kendo:dataSource-schema-model>
            </kendo:dataSource-schema>

        </kendo:dataSource>
        
    </kendo:grid>

    <style>    
    #grid .k-grid-content{
    	height: 430px; 	
    }
    </style>
    
    <shared:footer></shared:footer>