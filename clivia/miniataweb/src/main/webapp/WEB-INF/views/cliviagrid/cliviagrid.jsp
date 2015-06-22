<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>


<shared:header></shared:header>

<c:url var="readUrl" value="cliviagrid/read/${gridInfo.daoName}" />

<c:if test="${gridInfo.pageSize>0}" var="gridPageable"  scope="page"/>

<div id="version"><h2>Version:${version}1222436</h2></div>


    <kendo:grid name="grid" pageable="${gridPageable}" sortable="${gridInfo.sortable}" filterable="${gridInfo.filterable}" editable="${gridInfo.editable}" scrollable="true" resizable="true" >
    	
        <kendo:grid-columns>
        	<c:forEach var="gridColumn" items="${gridColumnList}">
	            <kendo:grid-column field="${gridColumn.columnName}" title="${gridColumn.title}"  width="${gridColumn.width}px"  hidden="${!gridColumn.visible}" />
	        </c:forEach>
        </kendo:grid-columns>
        
        <kendo:dataSource pageSize="${gridInfo.pageSize}"  batch="true"  serverFiltering="true">         
      
	        <kendo:dataSource-transport>
	            <kendo:dataSource-transport-read url="${readUrl}" type="post" dataType="json" contentType="application/json" />
				<kendo:dataSource-transport-parameterMap>
 						function(options){return JSON.stringify(options);}
                </kendo:dataSource-transport-parameterMap>
            </kendo:dataSource-transport>      
	        <kendo:dataSource-filter >

		        	<kendo:dataSource-filterItem logic="and">

			        	<kendo:dataSource-filterItem logic="or">
				        	<kendo:dataSource-filterItem field="gridId" operator="eq" value="3"/>
				        	<kendo:dataSource-filterItem field="gridId" operator="eq" value="2"/>
			        	</kendo:dataSource-filterItem>
		    	    	<kendo:dataSource-filterItem field="columnName" operator="startswith" value="f"/>

		        	</kendo:dataSource-filterItem>

	        </kendo:dataSource-filter>
            <kendo:dataSource-schema data="data" total="total">
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