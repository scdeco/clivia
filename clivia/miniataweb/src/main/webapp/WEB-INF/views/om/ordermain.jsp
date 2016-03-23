
<form name="searchForm" ng-submit="getOrder()" novalidate >
	<div kendo-toolbar id="ordertoolbar" k-options="orderToolbarOptions"></div>
</form>			

<div ng-show="!!SO.dataSet.info.orderNumber">
	Order#:<span style="font-weight: bold;">{{SO.dataSet.info.orderNumber}}</span>&nbsp;&nbsp;&nbsp; Account: <span style="font-weight: bold;">{{SO.company.info.businessName}}</span>
</div>
<div ng-hide="!!SO.dataSet.info.orderNumber">
	  Customer: <map-combobox   style="width:300px;" c-options="companyOptions" ng-model="SO.dataSet.info.customerId" ng-blur="SO.getCompany()"/>
</div>

<div kendo-splitter="outterSplitter"
		k-orientation="'vertical'"
		k-panes="[{ collapsible: false, resizable: false, size: '30px',collapsed: false },
                  { collapsible: false,size:'900px'},
                  { collapsible: false, resizable: true}]"
		 style="height:1000px;">
		 
	<div id="top-pane">
		
	</div>	<!-- top pane of outter splitter -->
	
	<div id="middle-pane">
	
		<div kendo-splitter="mainSplitter"
				k-orientation="'horizontal'"
				k-panes="[{ collapsible: true, resizable:true,size:'230px'},
                    	  { collapsible: false}]"
				style="height: 100%; width: 100%;">
				
			<div id="left-pane">
<!-- 				<div ui-view="orderinfo"></div> -->
				<div order-info="orderInfo"></div>
			</div> <!-- left pane -->
			
			<div id="right-pane">
				<div ui-view="orderitem"></div>
			</div>
			
		</div>
		
	</div> <!-- middle pane of outter splitter -->
	
	<div id="bottom-pane" >
	</div> <!-- bottom pane of outter splitter -->
</div>
 <pre>
	dataSet:{{SO.dataSet|json}}
<!-- 	instance:{{SO.instance|json}} -->
<!-- 	dds:{{SO.dds|json}} -->

</pre> 
