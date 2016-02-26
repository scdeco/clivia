<div id="lineItem">
    <div kendo-splitter="lineItemSplitter"
				k-orientation="'vertical'"
				k-panes="[{ collapsible: false, resizable:false,size:'40px'},
						   { collapsible: false, resizable:true,size:'350px', min:'100px'},
                    	  { collapsible: true}]"
                k-Options="lineItemSplitterOptions"
				style="height: 550px; width: 100%;">    
				
		<div style="margin:6px;"><!-- top pane-->
		
		    <label>{{garmentBrandName}} <span>--{{seasonInput.getSeasonName()}}</span></label> 
		    <label style="margin-left:20px;">Season:</label>
		    	<!-- ng-show="garmentGrid.getRowCount()" -->
		    
		    <season-dropdownlist  c-options="{name:'seasonInput',brandId:garmentBrandId}" ng-model="garmentSeasonId" ng-hide="garmentGrid.getRowCount()"></season-dropdownlist>

		    <label style="margin-left:20px;"><input type="checkbox"  style="vertical-align:middle;"
		    	   ng-model="setting.showUsedSizeRangeOnly"
		    	   ng-click="onClickLineItemEditing()">Show used size range only</label>
		    <label style="margin-left:40px;">Total:&nbsp;{{garmentGrid.getTotal()}}&nbsp;pcs</label>

	    </div> <!-- end of top pane-->
    
    	<div>  	
    		<div garment-grid="garmentGrid" 
    					c-editable="true" 
    					c-data-source="garmentGridDataSource" 
    					c-pageable="false" 
    					c-brand-id="garmentBrandId"
    					c-season-id="garmentSeasonId" 
    					c-new-item-function="newItemFunction"></div> 
   		</div> 	
 		
 		
		<div>   <!--  bottom pane -->	
			<div id="lineitemdetail" ui-view></div>
		</div>  <!-- end of bottom pane -->	
    </div>
	
</div>



