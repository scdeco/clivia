<div >
    <div kendo-splitter="lineItemSplitter"
				k-orientation="'vertical'"
				k-panes="[{ collapsible: false, resizable:false,size:'40px'},
						   { collapsible: false, resizable:true,size:'350px', min:'100px'},
                    	  { collapsible: true}]"
				style="height: 470px; width: 100%;">    
		<div style="margin:6px;">
		    <label>Brand:</label>
		    <input kendo-dropdownlist style="width:140px;" ng-model="lineItemBrand" k-options="lineitemBrandOptions">
		    <input type="checkbox" ng-model="setting.lineItemEditing"  style="vertical-align:middle;" ng-click="onClickLineItemEditing()"><label>Editing</label>

	    </div>
    
    	<div>
			<div  kendo-grid="lineItemGrid" id="lineItemGrid" k-options="lineItemGridOptions">
			</div>
		    <ul kendo-context-menu="lineItemGridContextMenu" id="lineItemGridContextMenu"
		        k-target="'#lineItemGrid'" 
		        k-options="lineItemGridContextMenuOptions">
		        
			  <li id="menuAdd">Add</li>
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
			
			
		</div>
		<div>
			<div id="lineitemdetail" ui-view></div>
		</div>
    </div>
	
</div>
