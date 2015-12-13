<div id="lineItem">
    <div kendo-splitter="lineItemSplitter"
				k-orientation="'vertical'"
				k-panes="[{ collapsible: false, resizable:false,size:'40px'},
						   { collapsible: false, resizable:true,size:'350px', min:'100px'},
                    	  { collapsible: true}]"
                k-Options="lineItemSplitterOptions"
				style="height: 550px; width: 100%;">    
				
		<div style="margin:6px;"><!-- top pane-->
		
		    <label>Brand: {{garmentBrand}}</label>

		    <input type="checkbox"  style="vertical-align:middle;"
		    	   ng-model="setting.lineItemEditing"
		    	   ng-click="onClickLineItemEditing()"><label>Editing</label>

	    </div> <!-- end of top pane-->
    
    	<div>  	
    		<div garment-grid="garmentGrid" c-editable="true" c-data-source="garmentGridDataSource" c-pageable="false" c-brand="garmentBrand" c-new-item-function="newItemFunction"></div> 
   		</div> 	
 		
 		
		<div>   <!--  bottom pane -->	
			<div id="lineitemdetail" ui-view></div>
		</div>  <!-- end of bottom pane -->	
    </div>
	
</div>



