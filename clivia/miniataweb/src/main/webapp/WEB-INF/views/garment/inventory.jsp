<!DOCTYPE html>
<html ng-app="invtApp">
<head>

	<title>Inventory</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>

	<shared:header/> 

	<%@include file="../common/gridwrapper.jsp"%>
	<%@include file="inventory-script.jsp"%>
	
</head>

<body  ng-controller="inventoryCtrl">

	

<div kendo-splitter="inventorySplitter"
	
		k-panes="[{ collapsible: false, resizable:true, size: '30px',collapsed: false },
                  { collapsible: false,size:'500px'},
                  { collapsible: false, resizable: true}]"
        k-options="inventory.splitterOptions"
		style="height:900px;">
		 
	<div id="top-pane">
		<label>Brand:</label>
	</div>	<!-- top pane of outter splitter -->
	
	<div id="middle-pane">
		<div kendo-toolbar id="inventoryToolbar" k-options="inventory.toolbarOptions"></div>
		<div  kendo-grid="inventoryGarmentGrid" id="inventoryGarmentGrid" k-options="inventory.garmentGridOptions"></div>
	</div> <!-- middle pane of outter splitter -->
	
	<div id="bottom-pane" style="height:300px;">
		<div kendo-tab-strip k-animation="false">
   			<ul>
   				<li class="k-state-active">UPC</li>
   				<li>Transaction</li>
   			</ul>
   			<div>
   				<div kendo-grid="inventoryUpcGrid" id="inventoryUpcGrid" k-options="inventory.detail.upcGridOptions"></div>
   			</div>
   			<div>
   				Transaction
   			</div>
   		</div>
		
	</div> <!-- bottom pane of outter splitter -->
	
</div>	<!-- end of inventorySplitter -->




</body>
<style>
html,
body
{
    margin:0;
    padding:0;
    height:100%;
}

	.k-splitter {
		border-width: 1;
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

</style>
</html>
