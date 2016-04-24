
<form name="searchForm" ng-submit="getOrder()" novalidate >
	<div kendo-toolbar id="ordertoolbar" k-options="orderToolbarOptions"></div>
</form>		

<H3 style="margin-left:10px;">	
	<div ng-hide="SO.isNew()" >
		Order#:<span style="font-weight: bold;">{{SO.dataSet.info.orderNumber}}</span>&nbsp;&nbsp;&nbsp; Customer: <span style="font-weight: bold;">{{SO.company.info.businessName}}</span>
	</div>
	
	<div ng-show="SO.isNew()">
		  Customer: <map-combobox   style="width:300px;" c-options="companyOptions" ng-model="SO.dataSet.info.customerId" ng-blur="SO.getCompany()"/>
	</div>
</H3>
		<div kendo-splitter="mainSplitter"
				k-orientation="'horizontal'"
				k-panes="[{ collapsible: true, resizable:true,size:'230px'},
                    	  { collapsible: false}]"
				style="height:850px; width: 100%;">
				
			<div id="left-pane">
				<div order-info="orderInfo"></div>
			</div> <!-- left pane -->
			
			<div id="right-pane">
				<div ui-view="orderitem"></div>
			</div>
			
		</div>
		
 <pre>
<!--  printModel={{SO.printModel}} -->
 
<!-- 	dataSet:{{SO.dataSet|json}} -->
<!-- 	instance:{{SO.instance|json}} -->
<!-- 	dds:{{SO.dds|json}} -->
<!-- 	company:{{SO.company|json}} -->
</pre> 

<div kendo-window="queryWindow"			
		k-width="1000"
	 	k-height="680"
	 	k-position="{top: 45, left: 320 }"	
	 	k-resizable="true"
		k-draggable="true"
	 	k-title="'List'"
	 	k-visible="false" 
	 	k-actions="['Minimiz','Maximize','Close']"
	 	k-pinned="true"
	 	k-modal="false">

	<div  query-grid="queryGrid"  c-grid-no="'801'" c-options="queryGridOptions"></div>
</div>

<div kendo-window="companyWindow"
		k-width="1200"
	 	k-height="700"
	 	k-position="{top: 50, left: 100 }"	
	 	k-resizable="true"
		k-draggable="true"
	 	k-title="'Company'"
	 	k-visible="false" 
	 	k-actions="['Minimiz','Maximize','Close']"
	 	k-pinned="true"
	 	k-modal="true"
	 	k-options="companyWindowOptions">

	<div company="companyCard"></div>
</div>