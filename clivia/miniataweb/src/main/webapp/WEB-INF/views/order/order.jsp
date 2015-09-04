<!DOCTYPE html>
<html ng-app="orderApp">
<head>
	<title>Order</title>
	<%@taglib prefix="ex" uri="/WEB-INF/miniataweb-tags.tld"%>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
	<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
	<shared:header/> 
	<%@include file="order-script.jsp"%>
 	<%@include file="ordermain-script.jsp"%>
	<%@include file="orderinfo-script.jsp"%>
	<%@include file="orderitem-script.jsp"%>
	<%@include file="lineitem-script.jsp"%> 
	
</head>
<body  ng-controller="orderCtrl">
  <div ui-view="main"></div>
</body>
<style>
     #fieldlist {
        margin: 10px;
        padding: 0;
     }
     #fieldlist li {
         list-style: none;
         padding-bottom: .7em;
         text-align: left;
     }
     
     #fieldlist label {
          display: block;
          padding-bottom: .2em;
          font-weight: bold;
      }
      
      textarea { 
      	resize: vertical; 
      }
      
    .k-grid-delete.k-button {
    min-width: 28px !important;
    padding: 0!important;
    }
    
	#orderitemnav {
	    list-style-type: none;
	    margin: 0;
	    padding:0.2em;
	    overflow: hidden;
	}
	
	ul#orderitemnav li {
	    float: left;
	}	
	
	
</style>


</html>