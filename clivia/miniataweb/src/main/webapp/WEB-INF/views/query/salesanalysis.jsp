<div kendo-splitter="analysisSplitter"
		
		k-panes="[ { collapsible: false,size:'550px'},
                  { collapsible: true, resizable: true}]"
        k-options="analysisSplitterOptions"

		style="height:900px;">
		<div id="first-pane">
			<div kendo-toolbar id="analysisToolbar" k-options="analysisToolbarOptions"></div>
	  		<div kendo-grid="analysisGrid" k-options="analysisGridOptions" k-rebind="analysisGridOptions"></div>
		</div>
		
		<div id="second-pane">
			
		</div> 
		
</div>