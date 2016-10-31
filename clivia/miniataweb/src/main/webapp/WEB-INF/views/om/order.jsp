<!DOCTYPE html>
<html ng-app="orderApp">
<head>

	<title>Order</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>

	<shared:header/> 

<%--included in header tag 	
	<%@include file="../common/factories.jsp"%>
	<%@include file="../common/directives.jsp"%>
	<%@include file="../common/gridwrappers.jsp"%> 
--%>
	
	<%@include file="../crm/crm-script.jsp"%>
	<%@include file="order-script.jsp"%>
	<%@include file="aconsts.jsp"%>
	<%@include file="aconfig.jsp"%>
 	<%@include file="ordermain-script.jsp"%>
 	<%@include file="../dm/embdesign.jsp"%>
 	

</head>

<body  class="k-content" ng-controller="orderCtrl" spellcheck="false">
  <div ui-view="main"></div>
</body>

<style>


	/* 	the grid in garmentInput Window	 */
	#styleGrid .k-grid-content tr td:not(:last-child){
 	   text-align: right;
	  }		
	#styleGrid .k-grid-content tr td:first-child{
 	   font-weight: bold;
	  }		
				
	
	/* no wrap */	
	.k-grid td{
   		white-space: nowrap;
	}
		
	#top-pane label{
        display: block;
        padding: .3em;
        font-weight: bold;
        }
		
	#billitemdetail table, th, td {
	    border: 1px dotted gray;
	    border-collapse: collapse;
	}
	#billitemdetail table, th, td {
	    padding: 5px;
	}
	
	
	.billDetailQty{
		width:40px;
	}      
	
/* 	image item styles */
	#imageItemToolbar, #lineItemToolbar{
		background-color: white;
		}
	
	#imageItemlistView {
        padding: 10px 5px;
        margin-bottom: -1px;
        min-height: 510px;
        border-width: 0;
        background-color:red;
	    }
	    
    .imageItem {
            float: left;
            position: relative;
            width: 111px;
            height: 170px;
            margin: 3 5px;
            padding: 0;
        }
	.imageItem img {
            max-width: 110px;
            max-height: 110px;
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
        	
/* 	.k-tabstrip{
	   	position: absolute;
     	top: 0;
    	bottom: 0;
    	left: 0;
    	right: 0;
    	width: auto;
    	height: auto;
    	border-width: 0;
	}
 
	.k-tabstrip > .k-content {
    	position: absolute;
    	top: 31px;
    	bottom: 0;
    	left: 0;
    	right: 0;
	}	         */

</style>


</html>