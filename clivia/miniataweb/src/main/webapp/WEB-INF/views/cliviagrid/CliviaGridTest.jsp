<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>


<shared:header></shared:header>
<div id="version"><h2>Version:${version}122244</h2></div>

    <kendo:grid name="grid"  resizable="true" >
    	<kendo:grid-scrollable/>
        <kendo:grid-columns>
        	<c:forEach var="gridColumn" items="${gridColumnList}">
	            <kendo:grid-column field="${gridColumn.columnName}" title="${gridColumn.title}"  width="${gridColumn.width}px" />
	        </c:forEach>
        </kendo:grid-columns>
    
	    <kendo:dataSource data="${gridData}" pageSize="10" batch="true">        

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