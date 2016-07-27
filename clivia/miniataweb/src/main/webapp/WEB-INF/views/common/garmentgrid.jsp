<div kendo-sortable k-options="gridSortableOptions">
	<div  kendo-grid="{{gridName}}" id="{{gridName}}" k-options="gridOptions"></div>
</div>

<ul kendo-context-menu="{{gridContextMenuName}}" k-options="gridContextMenuOptions">
       
	<li >Add</li>
  	<li ng-show="cBrand.hasInventory">Add With dialog...</li>
  	<li >Insert</li>
  	<li >Delete</li>
</ul>
			
			
<div kendo-window="{{garmentInputWindowName}}" id="{{garmentInputWindowName}}"    
		k-width="850"
	 	k-height="410"
	 	k-position="{top: 50, left: 100 }"	
	 	k-resizable="true"
		k-draggable="true"
	 	k-title="'Add Line Items'"
	 	k-visible="false" 
	 	k-actions="['Maximize']"
	 	k-modal="false">
	 <div garment-input	c-season-id="cSeason.id" c-dict-garment="dictGarment" c-add-function="inputWindowAddFunction"></div>
	 
</div>
