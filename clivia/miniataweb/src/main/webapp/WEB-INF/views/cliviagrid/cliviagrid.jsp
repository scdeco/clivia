
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
<shared:header></shared:header>

<%-- pass daoName as a path parameter--%>
<c:url var="readUrl" value="cliviagrid/read/${cliviaGridInfo.gridDaoName}" />
<c:url var="createUrl" value="cliviagrid/create/${cliviaGridInfo.gridDaoName}" />
<c:url var="updateUrl" value="cliviagrid/update/${cliviaGridInfo.gridDaoName}" />
<c:url var="destroyUrl" value="cliviagrid/destroy/${cliviaGridInfo.gridDaoName}" />

<c:if test="${cliviaGridInfo.gridPageSize>0}" var="gridPageable"  scope="page"/>

<div id="version"><h2>Version:${version}1222432</h2></div>

    <kendo:grid name="grid" pageable="${gridPageable}" sortable="${cliviaGridInfo.gridSortable}" filterable="${cliviaGridInfo.gridFilterable}"  scrollable="true" resizable="true" >
    	<c:if test="${cliviaGridInfo.gridEditable}">
    		<kendo:grid-editable mode="incell"/>
    	</c:if>
        <kendo:grid-toolbar>
            <kendo:grid-toolbarItem name="create"/>
            <kendo:grid-toolbarItem name="save"/>
            <kendo:grid-toolbarItem name="cancel"/>
        </kendo:grid-toolbar> 	
        <kendo:grid-columns>
        	<c:forEach var="cliviaGridColumn" items="${cliviaGridColumnList}">
	       		<c:choose>
	       			<c:when test="${cliviaGridColumn.columnDataType=='boolean'}">
				            <kendo:grid-column field="${cliviaGridColumn.columnName}" 
				            				   title="${cliviaGridColumn.title}"  
				            				   width="${cliviaGridColumn.width}px"  
				            				   hidden="${!cliviaGridColumn.columnVisible}"
				            				   locked="${cliviaGridColumn.columnLocked}"
				            				   lockable="${cliviaGridColumn.columnLockable}"
				            				   >
				            </kendo:grid-column>
	       			</c:when>
	       			<c:otherwise>
			            <kendo:grid-column field="${cliviaGridColumn.columnName}" 
			            				   title="${cliviaGridColumn.title}"  
			            				   width="${cliviaGridColumn.width}px"  
			            				   hidden="${!cliviaGridColumn.columnVisible}"
			            				   locked="${cliviaGridColumn.columnLocked}"
			            				   lockable="${cliviaGridColumn.columnLockable}"
			            				   format="${fn:trim(cliviaGridColumn.displayFormat)}"> 
			            </kendo:grid-column>
	       			</c:otherwise>
	       			 
		        </c:choose> 
        		
	        </c:forEach>
	        <kendo:grid-column title="&nbsp;" width="50px" >
            	<kendo:grid-column-command>
            		<kendo:grid-column-commandItem name="destroy" text=""/>
            	</kendo:grid-column-command>
            </kendo:grid-column>
        </kendo:grid-columns>
        
        <kendo:dataSource batch="true" pageSize="${cliviaGridInfo.gridPageSize}"  serverFiltering="true" serverSorting="true" >         
      
	        <kendo:dataSource-transport>
	            <kendo:dataSource-transport-read url="${readUrl}" type="post" dataType="json" contentType="application/json" />
	            <kendo:dataSource-transport-create url="${createUrl}" type="post" dataType="json" contentType="application/json" />
	            <kendo:dataSource-transport-update url="${updateUrl}" type="post" dataType="json" contentType="application/json" />
	            <kendo:dataSource-transport-destroy url="${destroyUrl}" type="post" dataType="json" contentType="application/json" />
				<kendo:dataSource-transport-parameterMap>
 						function(options,type){
 	                		if(type==="read"){
	                			return JSON.stringify(options);
	                		} else {
	                			return JSON.stringify(options.models);
	                		}
	                	}
                </kendo:dataSource-transport-parameterMap>
            </kendo:dataSource-transport>
            
            <c:if test="${not empty dataFilter}">
            	<c:set var="filterItems" value="${fn:split(dataFilter,';')}"/>
		        <kendo:dataSource-filter >
		   				<c:set var="filterItem0" value="${fn:split(filterItems[0],',')}"/>
	   					<kendo:dataSource-filterItem field="${filterItem0[0]}" operator="${filterItem0[1]}" value="${filterItem0[2]}"/>
		   				<c:set var="filterItem1" value="${fn:split(filterItems[1],',')}"/>
	   					<kendo:dataSource-filterItem field="${filterItem1[0]}" operator="${filterItem1[1]}" value="${filterItem1[2]}"/>
		        </kendo:dataSource-filter>
			</c:if>
	        
	        <c:if test="${not empty cliviaGridInfo.gridSortDescriptor}" >
			   	<kendo:dataSource-sort>
			   		<c:forTokens  items="${cliviaGridInfo.gridSortDescriptor}" delims=";" var="itemSort">
			   			<c:set var="strSort" value="${fn:split(itemSort,',')}"/>
		   				<kendo:dataSource-sortItem field="${strSort[0]}" dir="${strSort[1]}"/>
					</c:forTokens>
			   	</kendo:dataSource-sort>
			</c:if>
	        
            <kendo:dataSource-schema data="data" total="total">
                <kendo:dataSource-schema-model id="id" >
                    <kendo:dataSource-schema-model-fields>
				        	<c:forEach var="cliviaGridColumn" items="${cliviaGridColumnList}">
					            <kendo:dataSource-schema-model-field 
					            	name="${cliviaGridColumn.columnName}" 
					            	type="${cliviaGridColumn.columnDataType}" 
					            	editable="${cliviaGridColumn.columnEditable}"/>
					        </c:forEach>
                    </kendo:dataSource-schema-model-fields>
                </kendo:dataSource-schema-model>
            </kendo:dataSource-schema>

        </kendo:dataSource>
        
    </kendo:grid>
	
    <style>  
	    #grid {
	    	height: 500px; 	
	    }
		.k-grid td{
    		padding: 0.2em 0.2 em;
    		white-space: nowrap;
		}
		.k-grid-header th.k-header {
    		padding: 0.2em 0.2em;
		}
    	.k-grid-header-wrap th {
    		font-size: 12px;
    	}  
    </style>
    
<shared:footer></shared:footer>    
   