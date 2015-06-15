<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>


<shared:header></shared:header>
<div id="version"><h2>Version:${version}</h2></div>

    <kendo:grid name="grid" >
    	<kendo:grid-scrollable />    	
        <kendo:grid-columns>
            <kendo:grid-column title="Username" field="username" />
            <kendo:grid-column title="FIrst Name" field="firstName" width="130px"/>
            <kendo:grid-column title="Last Name" field="lastName" width="130px"/>
            <kendo:grid-column title="Password" field="password" width="130px"/>
        </kendo:grid-columns>

    </kendo:grid>

    
    <style>
    #grid .k-grid-content{
    	height: 430px; 	
    }
    </style>
    
    <shared:footer></shared:footer>