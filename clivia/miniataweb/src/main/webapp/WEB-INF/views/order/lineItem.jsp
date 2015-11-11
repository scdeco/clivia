<div id="lineItem">
    <div kendo-splitter="lineItemSplitter"
				k-orientation="'vertical'"
				k-panes="[{ collapsible: false, resizable:false,size:'40px'},
						   { collapsible: false, resizable:true,size:'350px', min:'100px'},
                    	  { collapsible: true}]"
				style="height: 550px; width: 100%;">    
				
		<div style="margin:6px;"><!-- top pane-->
		    <label>Brand: {{lineItemBrand}}</label>

		    <input type="checkbox"  style="vertical-align:middle;"
		    	   ng-model="setting.lineItemEditing"
		    	   ng-click="onClickLineItemEditing()"><label>Editing</label>

	    </div> <!-- end of top pane-->
    
    	<div>  <!-- middle pane -->	
    		<div kendo-sortable="lineItemGridSortable"	k-options="lineItemGridSortableOptions">
				<div  kendo-grid="lineItemGrid" id="lineItemGrid" k-options="lineItemGridOptions" ></div>
			</div>
			
		    <ul kendo-context-menu="lineItemGridContextMenu" id="lineItemGridContextMenu"
		        k-target="'#lineItemGrid'" 
		        k-options="lineItemGridContextMenuOptions">
		        
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
   		</div>  <!-- end of middle pane -->	
 		
 		
		<div>   <!--  bottom pane -->	
			<div id="lineitemdetail" ui-view></div>
		</div>  <!-- end of bottom pane -->	
    </div>
	
</div>

<div kendo-window="styleWindow" id="styleWindow" 
	 k-width="850"
	 k-height="310"
	 k-position="{top: 50, left: 100 }"					
	 k-visible="false"
	 k-options="styleWin.options">
   				 
	<form name="addStyle" ng-submit="styleWin.getGrid()" novalidate >
		<span class="k-textbox k-space-right" style="width: 140px;" >
			<input type="text"  class="k-textbox" placeholder="Search Style#" ng-model="styleWin.styleNumber" />
			<label ng-click="styleWin.getGrid()" class="k-icon k-i-search"></label>
		</span>
	</form>		
	
	<h4>{{styleWin.garment.styleNumber}}:&nbsp;{{styleWin.garment.styleName}}</h4>  

	<div  kendo-grid="styleGrid" id="styleGrid" 
		  k-options="styleWin.gridOptions" 
		  k-rebind="styleWin.gridRebind"
		  k-height=200>
	</div> 		
	<div>
	
		<input type="button" value="Add" ng-click="styleWin.add()">
		<input type="button" value="OK" ng-click="styleWin.ok()">
		<label style="margin-left: 100px; font-weight: bold;" >Total:{{styleWin.total}}</label>
		<input type="button" value="Clear" ng-click="styleWin.clear()" style="margin-left:100px;">
		<input type="button" value="Cancel" ng-click="styleWin.cancel()">

	</div>		 
   				 
</div>	<!--end of styleWindow -->
