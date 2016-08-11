		<div kendo-splitter="designViewSplitter"  
		 		k-orientation="'horizontal'" 
				k-panes="[{ collapsible: true, resizable:true,size:'60%x', min:'100px'},
				    	  { collapsible: true, resizable:true}]"  
				style="height: 100%; width: 100%;"   	>
		     	
		     	<div id="designitem-first-pane">
		     		
		     		<div kendo-sortable k-options="gridSortableOptions">
							<div  kendo-grid="{{gridName}}" id="{{gridName}}" k-options="gridOptions"></div>
					</div>

					<ul kendo-context-menu="{{gridContextMenuName}}" id="{{gridContextMenuName}}" k-options="gridContextMenuOptions">
					       
					  	<li >Add</li>
					  	<li >Insert</li>
					  	<li >Delete</li>
					
					</ul>
		     		
				</div>	<!-- first-pane-->
				
				
		     	<div id="designitem-second-pane">
				</div>	<!-- second-pane-->
				
			
		</div>
		
			
			