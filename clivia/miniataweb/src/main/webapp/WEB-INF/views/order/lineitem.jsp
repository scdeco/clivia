<!-- 	<div kendo-grid="lineitems" k-options="lineitemsOptions" k-rebind="lineitemsOptions.dataSource.filter"></div> -->

<div >
	<h4>This is a test Line Items: {{uu.orderItemId}}</h4>
	<div kendo-toolbar k-options="toolbarOptions"></div>
	<div kendo-grid="lineItemGrid" k-options="lineItemGridOptions"></div>
	
<pre>
	{{uu.datasource|json}}
</pre>
</div>

