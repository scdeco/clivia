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

<div kendo-toolbar id="inventorytoolbar" k-options="inventoryToolbarOptions"></div>

<div kendo-splitter="inventorySplitter"
		k-orientation="'vertical'"
		k-panes="[{ collapsible: false, resizable: false, size: '30px',collapsed: false },
                  { collapsible: false,size:'500px'},
                  { collapsible: false, resizable: true}]"
		 style="height:900px;">
		 
	<div id="top-pane">
	</div>	<!-- top pane of outter splitter -->
	
	<div id="middle-pane">
	
		<div kendo-splitter="mainSplitter"
				k-orientation="'horizontal'"
				k-panes="[{ collapsible: true, resizable:true,size:'230px'},
                    	  { collapsible: false}]"
				style="height: 100%; width: 100%;">
				
			<div id="left-pane">
				<div ui-view="orderinfo"></div>
			</div> <!-- left pane -->
			
			<div id="right-pane">
				<div ui-view="orderitem"></div>
			</div>
			
		</div>
		
	</div> <!-- middle pane of outter splitter -->
	
	<div id="bottom-pane" style="height:300px;">
				<pre>
					dataSet:{{SO.dataSet|json}}
					buttons:{{SO.instance.itemButtons}}
					dictGarments:{{SO.dict.garments|json}}
					dictImages:{{SO.dict.images|json}}
					
	
				</pre>
	</div> <!-- bottom pane of outter splitter -->
	
</div>
</body>