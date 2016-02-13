
<form name="searchForm" ng-submit="getOrder()" novalidate >
	<div kendo-toolbar id="ordertoolbar" k-options="orderToolbarOptions"></div>
</form>			

<div ng-show="!!SO.dataSet.info.orderNumber">
	Order#:<span style="font-weight: bold;">{{SO.dataSet.info.orderNumber}}</span>&nbsp;&nbsp;&nbsp; Account: <span style="font-weight: bold;">{{SO.company.info.businessName}}</span>
</div>
<div ng-hide="!!SO.dataSet.info.orderNumber">
	  Customer: <company-combobox name="customer"  style="width:300px;" ng-model="SO.dataSet.info.customerId" ng-blur="SO.getCompany()"></company-combobox>
</div>

<div kendo-splitter="outterSplitter"
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
