<!DOCTYPE html>
<html ng-app="imApp">
<head>

	<title>IM</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>

	<shared:header/> 
<%--included in header tag 	
	<%@include file="../common/factories.jsp"%>
	<%@include file="../common/directives.jsp"%>
	<%@include file="../common/gridwrappers.jsp"%> 
--%>
	<%@include file="im-script.jsp"%>
	
</head>

<body  ng-controller="inventoryCtrl" spellcheck="false">

<div kendo-splitter="inventorySplitter"
	
		k-panes="[{ collapsible: false, resizable:false, size: '35px'},
                  { collapsible: false,size:'550px'},
                  { collapsible: true, resizable: true}]"
        k-options="inventory.splitterOptions"
		style="height:950px;">
		 
	<div id="top-pane">
			Brand: <brand-dropdownlist c-options="{name:'brandInput'}"  ng-model="inventory.brandId" ></brand-dropdownlist>
			<a href="http://192.6.2.204:8080/admin/login.php"><button class="k-button">Home</button></a>
	</div>	<!-- top pane of outter splitter -->
	
	<div id="middle-pane">
		<div kendo-toolbar id="inventoryToolbar" k-options="inventoryToolbarOptions"></div>
 		<div  kendo-grid="inventoryGarmentGrid"  k-options="inventory.garmentGridOptions"></div> 

		
	</div> <!-- middle pane of outter splitter -->
	
	<div id="bottom-pane">
		<div kendo-tab-strip k-animation="false">
   			<ul>
   				<li class="k-state-active">UPC</li>
   				<li>Transaction</li>
   			</ul>
   			<div>
   				<div kendo-grid="inventoryUpcGrid"  k-options="inventory.upcGridOptions"></div>
   			</div>
   			<div>
   				Transaction
   			</div>
   		</div>
		
	</div> <!-- bottom pane of outter splitter -->
	
</div>	<!-- end of inventorySplitter -->

<div kendo-window="transactionEntryWindow"
		k-width="850"
	 	k-height="720"
	 	k-position="{top: 50, left: 100 }"	
	 	k-resizable="true"
		k-draggable="true"
	 	k-title="'Transaction'"
	 	k-visible="false" 
	 	k-actions="['Minimiz','Maximize','Close']"
	 	k-pinned="true"
	 	k-modal="false">

	 <div transaction-entry="transactionEntry"	c-brand-id="inventory.brandId" ></div>
</div>

<div kendo-window="garmentProductWindow"
		k-width="1200"
	 	k-height="790"
	 	k-position="{top: 50, left: 100 }"	
	 	k-resizable="true"
		k-draggable="true"
	 	k-title="'Product'"
	 	k-visible="false" 
	 	k-actions="['Minimiz','Maximize','Close']"
	 	k-modal="false"
	 	k-pinned="true"
	 	k-options="garmentProductWindowOptions">

	<div garment-product="garmentProduct" c-brand-id="inventory.brandId" ></div>
</div>
<div kendo-toolbar id="endFrom" style="top:960px;width:100%;position:fixed;height:25px;display:block;"></div> 
</body>
<style>
	.k-grid td
	{
		white-space: nowrap;
	}

	/*re-size TabStrip to 100% of the Pane width/height.*/
	.k-tabstrip{
	   	position: absolute;
     	top: 0;
    	bottom: 0;
    	left: 0;
    	right: 0;
    	width: auto;
    	height: auto;
	}
 
	.k-tabstrip > .k-content {
    	position: absolute;
    	top: 31px;
    	bottom: 0;
    	left: 0;
    	right: 0;
	}	
	
	/*re-size Grid that has no pager to 100% of it's container's width/height.*/
	#inventoryUpcGrid{
	  	position: absolute;
	    top: 0;
	    bottom: 0;
	    left: 0;
	    right: 0;
	    width: auto;
	    height: auto;	
	}
	
	#inventoryUpcGrid > .k-grid-content {
	    position: absolute;
	    top: 25px;
	    bottom: 0;
	    left: 0;
	    right: 0;  
	    width: auto;
	    height: auto;	
	}
	
	table {
		table-layout:fixed;
	}
	
	table td.header {
		text-align:right;
	}
	
	.options{
		padding: 0;
	}
     .options li {
         list-style: none;
         padding-right: 1em;
         display: inline;
     }	
     
 
	

</style>
</html>
