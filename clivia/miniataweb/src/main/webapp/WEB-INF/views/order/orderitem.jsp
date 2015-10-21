<div>
	<div kendo-sortable="itemToolbarSortable" id="itemToolbarSortable" 
	     k-options="itemToolbarSortableOptions">
	     
		<div  kendo-toolbar="itemToolbar" id="itemToolbar" 
			  k-options="itemToolbarOptions"  
			  k-rebind="itemButtons"></div>
	</div>
	
    <ul kendo-context-menu="itemToolbarContextMenu" id="itemToolbarContextMenu"
        k-target="'#itemToolbar'" 
        k-options="itemToolbarContextMenuOptions" 
        k-rebind="itemButtons">
      
		  <li id="menuRename">Change Title</li>
		  <li class="k-separator"></li>		          
	      <li id="menuRemove">Delete</li> 
	</ul> 
</div>

<div id="itemcontent" ui-view ></div>
