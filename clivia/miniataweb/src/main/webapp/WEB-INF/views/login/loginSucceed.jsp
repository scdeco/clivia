<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<shared:header></shared:header>
<div id="version"><h2>Version:${version}1232143</h2></div>

<c:url var="readUrl" value="login/read" />

    <kendo:grid name="grid" pageable="true" >
    	<kendo:grid-scrollable />    	
        <kendo:grid-columns>
            <kendo:grid-column title="Username" field="username" />
            <kendo:grid-column title="FIrst Name" field="firstName" width="130px"/>
            <kendo:grid-column title="Last Name" field="lastName" width="130px"/>
            <kendo:grid-column title="Password" field="password" width="130px"/>
			<kendo:grid-column title="Birth Date" field="birthDate" format="{0:d}" width="130px"  />            
        </kendo:grid-columns>
        <kendo:dataSource   pageSize="10"  serverPaging="true" >   
            <kendo:dataSource-schema  data="data" total="total" >
                <kendo:dataSource-schema-model  id="id">
                    <kendo:dataSource-schema-model-fields>
                        <kendo:dataSource-schema-model-field name="firstName" type="string" />
                        <kendo:dataSource-schema-model-field name="lastName" type="string" />
                        <kendo:dataSource-schema-model-field name="username" type="string" />
                        <kendo:dataSource-schema-model-field name="password" type="string" />
                        <kendo:dataSource-schema-model-field name="alias" type="string" />
                        <kendo:dataSource-schema-model-field name="sex" type="string" />
                        <kendo:dataSource-schema-model-field name="birthDate" type="date"  />
                    </kendo:dataSource-schema-model-fields>
                </kendo:dataSource-schema-model>
            </kendo:dataSource-schema>
            <kendo:dataSource-transport>
	            <kendo:dataSource-transport-read url="${readUrl}"  type="post" dataType="json" contentType="application/json"/>
                <kendo:dataSource-transport-parameterMap>
                	function(options){return JSON.stringify(options);}
                </kendo:dataSource-transport-parameterMap>  
           </kendo:dataSource-transport>      
            
        </kendo:dataSource>
    </kendo:grid>

    <style>
    #grid .k-grid-content{
    	height: 430px; 	
    }
    </style>
    <shared:footer></shared:footer>