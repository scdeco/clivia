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
	<%@include file="orderimage-script.jsp"%> 
	
</head>

<body  ng-controller="orderCtrl">
  <div ui-view="main"></div>
</body>

<style>

 	.k-toolbar,k-grid {
		border-width: 0;
		} 
		
/* 	orderinfo */
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
      

 	

	
	
/* 	image item styles */
	#imageItemToolbar, #lineItemToolbar{
		background-color: white;
		}
	
	#imageItemlistView {
        padding: 10px 5px;
        margin-bottom: -1px;
        min-height: 510px;
	    }
    .imageItem {
            float: left;
            position: relative;
            width: 111px;
            height: 170px;
            margin: 0 5px;
            padding: 0;
        }
	.imageItem img {
            max-width: 90px;
            max-height: 90px;
            width: auto;
            height: auto;
            }
    .imageItem h3 {
            margin: 0;
            padding: 3px 5px 0 0;
            max-width: 96px;
            overflow: hidden;
            line-height: 1.1em;
            font-size: .9em;
            font-weight: normal;
            text-transform: uppercase;
            color: #999;
        }
        .imageItem p {
            visibility: hidden;
        }
        .imageItem:hover p {
            visibility: visible;
            position: absolute;
            width: 110px;
            height: 110px;
            top: 0;
            margin: 0;
            padding: 0;
            line-height: 110px;
            vertical-align: middle;
            text-align: center;
            color: #fff;
            background-color: rgba(0,0,0,0.75);
            transition: background .2s linear, color .2s linear;
            -moz-transition: background .2s linear, color .2s linear;
            -webkit-transition: background .2s linear, color .2s linear;
            -o-transition: background .2s linear, color .2s linear;
        }
        .k-listview:after {
            content: ".";
            display: block;
            height: 0;
            clear: both;
            visibility: hidden;
        }	
	
	

</style>


</html>