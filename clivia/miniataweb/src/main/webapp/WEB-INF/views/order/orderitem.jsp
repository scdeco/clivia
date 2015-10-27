<div>


	<div kendo-sortable="itemToolbarSortable" id="itemToolbarSortable" 
	     k-options="itemToolbarSortableOptions">
	     
		<div  kendo-toolbar="itemToolbar" id="itemToolbar" 
			  k-options="itemToolbarOptions"  
			  k-rebind="itemButtons">
		</div>
 	</div>  
	
 	 <ul  kendo-context-menu="itemToolbarContextMenu" id="itemToolbarContextMenu"  style="width:150px;"	 
        k-target="'#itemToolbarSortable'" 
        k-options="itemToolbarContextMenuOptions" >
     </ul>
</div>

<div id="itemcontent" ui-view ></div>
