<!DOCTYPE html>
<html ng-app="imApp">
<head>

	<title>IM</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>

	<shared:header/> 
	<%@include file="../common/factories.jsp"%>
	<%@include file="../common/directives.jsp"%>
	<%@include file="im-script.jsp"%>
	
</head>

<body  ng-controller="inventoryCtrl" spellcheck="false">

<div kendo-splitter="inventorySplitter"
	
		k-panes="[{ collapsible: false, resizable:false, size: '35px'},
                  { collapsible: false,size:'550px'},
                  { collapsible: true, resizable: true}]"
        k-options="inventory.splitterOptions"
		style="height:900px;">
		 
	<div id="top-pane">
			Brand: <brand-input name="garmentBrandInput" ng-model="inventory.brand"></brand-input>
	</div>	<!-- top pane of outter splitter -->
	
	<div id="middle-pane">
		<div kendo-toolbar id="inventoryToolbar" k-options="inventoryToolbarOptions"></div>
		<div  kendo-grid="inventoryGarmentGrid"  k-options="inventory.garmentGridOptions"></div>
	</div> <!-- middle pane of outter splitter -->
	
	<div id="bottom-pane" style="height:300px;">
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
	 	k-height="810"
	 	k-position="{top: 50, left: 100 }"	
	 	k-resizable="true"
		k-draggable="true"
	 	k-title="'Transaction'"
	 	k-visible="false" 
	 	k-actions="['Minimiz','Maximize','Close']"
	 	k-pinned="true"
	 	k-modal="false">

	<div transaction-entry="transactionEntry"	c-brand="inventory.brand" ></div>
</div>

<div kendo-window="garmentProductWindow"
		k-width="600"
	 	k-height="400"
	 	k-position="{top: 50, left: 100 }"	
	 	k-resizable="true"
		k-draggable="true"
	 	k-title="'Product'"
	 	k-visible="false" 
	 	k-actions="['Minimiz','Maximize','Close']"
	 	k-modal="false"
	 	k-pinned="true"
	 	k-options="garmentProductWindowOptions">

	<div garment-product="garmentProduct" c-brand="inventory.brand"></div>
</div>


</body>
<style>
	.k-dirty {
  		border-width:0;
	}
	
	html,body{
	    margin:0;
	    padding:0;
	    height:100%;
	}

	.k-splitter {
		border-width: 0;
		height: 100%;
	}
	
	
 	.k-toolbar{
 		border-width:0;
		padding: 0;
		margin: 0;
		height:36px;
        border-bottom:1px solid silver;
		}
		
	.k-grid{
		font-size: 12px;
        margin: 0;
        padding: 0;
        border-width: 0;
      	}

	/* 	do not show background color of grid editing cell */
	.k-grid .k-edit-cell { 
		background: transparent; 
		
		}
		
	/*highlight line number of editing row, might not be the first column 	td:first-child  */
	.k-grid .k-grid-edit-row td.gridLineNumber{
		color:blue;
		font-weight: bold;
		
	}

 	/* show horizontal grid line		 */

	.k-grid-content tr:not(:last-child) td{
 	   border-bottom: 1px dotted gray;
		}		
	.k-grid-content tr:last-child td{
 	   border-bottom: 1px solid silver;
		}		
		
	.k-grid .gridLineNumber{
	}		 

	.k-grid td
	{
		white-space: nowrap;
	}

	.k-grid .numberColumn,.gridLineNumber{
		text-align: right;
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
      }
      
      textarea { 
      	resize: vertical; 
      }     
     
	

</style>
</html>