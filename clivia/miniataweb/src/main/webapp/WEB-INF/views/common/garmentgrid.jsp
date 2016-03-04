<div kendo-sortable k-options="gridSortableOptions">
	<div  kendo-grid="{{gridName}}" id="{{gridName}}" k-options="gridOptions"></div>
</div>

<ul kendo-context-menu k-options="gridContextMenuOptions">
       
  	<li id="menuAdd">Add</li>
  	<li id="menuAddWindow">Add With dialog...</li>
  	<li id="menuInsert">Insert</li>
  	<li id="menuDelete">Delete</li>
  	<li class="k-separator"></li>		          
    <li>Subitem 1.3
         <ul>
		      <li>Item 2</li>
		      <li>Item 3</li>
         </ul>
  	<li> 
</ul>
			
			
<div kendo-window="garmentInputWindow" 
		k-width="850"
	 	k-height="310"
	 	k-position="{top: 50, left: 100 }"	
	 	k-resizable="true"
		k-draggable="true"
	 	k-title="'Add Line Items'"
	 	k-visible="false" 
	 	k-actions="['Maximize']"
	 	k-modal="false">
	 	
	 <div garment-input	c-season-id="cSeason.id" c-dict-garment="dictGarment" c-add-function="inputWindowAddFunction"></div>
	 
</div>
