<div >
	<div>
	    <label>Brand:</label>
	    <input kendo-dropdownlist style="width:140px;" ng-model="lineItemBrand" k-options="lineitemBrandOptions">
    </div>
    
    <div kendo-toolbar="lineItemToolbar" id="lineItemToolbar" k-options="lineItemToolbarOptions"></div>
	<div kendo-grid="lineItemGrid" k-options="lineItemGridOptions" 
				k-on-change="onLineItemGridChange(dataItem,columns)"
				k-on-save="onLineItemGridSave(kendoEvent)">
	</div>
</div>

