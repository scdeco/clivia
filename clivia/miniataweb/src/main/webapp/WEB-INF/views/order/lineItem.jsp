<div id="lineItem">
    <div kendo-splitter="lineItemSplitter"
				k-orientation="'vertical'"
				k-panes="[{ collapsible: false, resizable:false,size:'40px'},
						   { collapsible: false, resizable:true,size:'350px', min:'100px'},
                    	  { collapsible: true}]"
                k-Options="lineItemSplitterOptions"
				style="height: 550px; width: 100%;">    
				
		<div style="margin:6px;"><!-- top pane-->
		    <label>Brand: {{lineItemBrand}}</label>

		    <input type="checkbox"  style="vertical-align:middle;"
		    	   ng-model="setting.lineItemEditing"
		    	   ng-click="onClickLineItemEditing()"><label>Editing</label>

	    </div> <!-- end of top pane-->
    
    	<div>  <!-- middle pane -->	
    		<div class="lineItem">
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
	   			
		 		<garment-input-window name="garmentInputWindow" id="garmentInputWindow"
		 				dict-garment="SO.dds.garment"
		 				add-function="garmentInputWindowAddFunction"
		 				k-append-to="'div#lineItem'"
		 				k-width="850"
					 	k-height="310"
					 	k-position="{top: 50, left: 100 }"	
					 	k-resizable="true"
						k-draggable="true"
					 	k-title="'Add Line Items'">
				</garment-input-window>		

	   			

	   		</div> <!-- end of lineItem -->
   		</div>  <!-- end of middle pane -->	
 		
 		
		<div>   <!--  bottom pane -->	
			<div id="lineitemdetail" ui-view></div>
		</div>  <!-- end of bottom pane -->	
    </div>
	
</div>



