		<div kendo-splitter="designMainSplitter"  
		 		k-orientation="'horizontal'" 
				k-panes="[{ collapsible: true, resizable:true,size:'60%x', min:'100px'},
				    	  { collapsible: true, resizable:true}]"  
				style="height: 100%; width: 100%;"   	>
		     	
		     	
			<div kendo-splitter="designSplitter"  
			 		k-orientation="'vertical'" 
					k-panes="[{ collapsible: true, resizable:true,size:'60%x', min:'100px'},
					    	  { collapsible: true, resizable:true}]"  
					style="height: 100%; width: 100%;"   	>
		     	
		     	<div>
		     		
		     		<div kendo-sortable k-options="embGridSortableOptions">
							<div  kendo-grid="{{embGridName}}" k-options="embGridOptions"></div>
					</div>

					<ul kendo-context-menu k-options="embGridContextMenuOptions">
					  	<li >Add</li>
					  	<li >Insert</li>
					  	<li >Delete</li>
					</ul>
		     		
				</div>	<!-- first-pane-->
				
		     	<div>
		     		<div kendo-sortable k-options="colourwayGridSortableOptions">
							<div  kendo-grid="{{colourwayGridName}}"  k-options="colourwayGridOptions"></div>
					</div>
					<ul kendo-context-menu k-options="colourwayGridContextMenuOptions">
					  	<li >Add</li>
					  	<li >Insert</li>
					  	<li >Delete</li>
					</ul>
		     	
				</div>	<!-- second-pane-->
				
				
			</div>
				
		    <div>
			</div>	<!-- second-pane-->
				
			
		</div>
		
			
			