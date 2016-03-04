<div id="billItem">
    <div kendo-splitter="billItemSplitter"
				k-orientation="'vertical'"
				k-panes="[{ collapsible: false, resizable:false,size:'40px'},
						   { collapsible: false, resizable:true,size:'350px', min:'100px'},
                    	  { collapsible: true}]"
                k-Options="billItemSplitterOptions"
				style="height: 550px; width: 100%;">    
				
		<div style="margin:6px;"><!-- top pane-->

	    </div> <!-- end of top pane-->
    
    	<div>  	
    		<div bill-grid="billGrid" 
    					c-editable="true" 
    					c-data-source="billGridDataSource" 
    					c-pageable="false" 
    					c-new-item-function="newItemFunction"
    					c-register-deleted-item-function="registerDeletedItemFunction">
    		</div> 
   		</div> 	
 		
 		
		<div>   <!--  bottom pane -->	
			<div id="billitemdetail" ui-view></div>
		</div>  <!-- end of bottom pane -->	
    </div>
	 
</div>

