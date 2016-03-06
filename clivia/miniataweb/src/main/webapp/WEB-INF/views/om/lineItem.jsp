<div id="lineItem">
    <div kendo-splitter="lineItemSplitter"
				k-orientation="'vertical'"
				k-panes="[{ collapsible: false, resizable:false,size:'40px'},
						   { collapsible: false, resizable:true,size:'350px', min:'100px'},
                    	  { collapsible: true}]"
                k-Options="lineItemSplitterOptions"
				style="height: 550px; width: 100%;">    
				
		<div style="margin:6px;"><!-- top pane-->
			
			<b>
			<span ng-show="brand.hasInventory">
			    <label>{{brand.name}} <span ng-show="garmentGrid.hasRow()">--{{season.name}}</span></label> 
			    
		    	<label  style="margin-left:20px;" ng-hide="garmentGrid.hasRow()">Season: 
		    		<season-dropdownlist  
		    			c-options="{name:'seasonInput',brandId:brand.id}" 
		    			ng-model="seasonId">
		    			
		    		</season-dropdownlist>
		    	</label>
			</span>

		    <label style="margin-left:40px;">Total:&nbsp;{{garmentGrid.getTotal()}}&nbsp;pcs</label>

			</b>
		    <label ng-show="brand.hasInventory" style="margin-left:20px;"><input type="checkbox"  style="vertical-align:middle;"
		    	   ng-model="setting.showUsedSizeRangeOnly"
		    	   ng-click="onClickLineItemEditing()">Show used size range only</label>

	    </div> <!-- end of top pane-->
    
    	<div>  	
    		<div garment-grid="garmentGrid" 
    					c-editable="true" 
    					c-data-source="garmentGridDataSource" 
    					c-pageable="false" 
    					c-brand="brand"
    					c-season="season" 
    					c-new-item-function="newItemFunction"
    					c-register-deleted-item-function="registerDeletedItemFunction"></div> 
   		</div> 	
 		
 		
		<div>   <!--  bottom pane -->	
			<div id="lineitemdetail" ui-view></div>
		</div>  <!-- end of bottom pane -->	
    </div>
	
</div>



