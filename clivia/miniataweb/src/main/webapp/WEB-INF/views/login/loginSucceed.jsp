<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>


<shared:header></shared:header>
    <kendo:grid name="grid" pageable="true" sortable="true" filterable="true">
    	<kendo:grid-scrollable />    	
        <kendo:grid-columns>
            <kendo:grid-column title="Username" field="username" />
            <kendo:grid-column title="FIrst Name" field="firstName" width="130px"/>
            <kendo:grid-column title="Last Name" field="lastName" width="130px"/>
            <kendo:grid-column title="Password" field="password" width="130px"/>
        </kendo:grid-columns>
        <kendo:dataSource data="${users}" pageSize="10" batch="true">        
            <kendo:dataSource-schema>
                <kendo:dataSource-schema-model>
                    <kendo:dataSource-schema-model-fields>
                        <kendo:dataSource-schema-model-field name="username" type="string" />
                        <kendo:dataSource-schema-model-field name="firstName" type="string" />
                        <kendo:dataSource-schema-model-field name="lastName" type="string" />
                        <kendo:dataSource-schema-model-field name="password" type="string" />
                    </kendo:dataSource-schema-model-fields>
                </kendo:dataSource-schema-model>
            </kendo:dataSource-schema>
        </kendo:dataSource>
        <kendo:grid-pageable input="true" numeric="false" />
    </kendo:grid>
    <style>
    #grid .k-grid-content{
    	height: 430px; 	
    }
    </style>
    
    <shared:footer></shared:footer>