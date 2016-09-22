		<div kendo-splitter="imageViewSplitter"  
		 		k-orientation="'horizontal'" 
				k-panes="[{ collapsible: true, resizable:true,size:'60%x', min:'100px'},
				    	  { collapsible: true, resizable:true}]"  
				style="height: 100%; width: 100%;"   	>
		     	
		     	<div id="imageitem-first-pane">
		     		
		     		<div kendo-sortable k-options="gridSortableOptions">
							<div  kendo-grid="{{gridName}}" id="{{gridName}}" k-options="gridOptions"></div>
					</div>

					<ul kendo-context-menu="{{gridContextMenuName}}" id="{{gridContextMenuName}}" k-options="gridContextMenuOptions">
					       
					  	<li>Add</li>
					  	<li>Upload</li>
					  	<li>Delete</li>
					
					</ul>
		     		
				</div>	<!-- first-pane-->
				
				
		     	<div id="imageitem-second-pane">
						<input type="text" ng-paste="handlePaste($event)" value='Press "Ctrl+V" or right click here and choose "paste" to paste an image.'>
		     			<div stype="height:100%;width:100%;">
							<img ng-src="data:image/JPEG;base64,{{previewOriginalImage}}" alt="preview image" style="width:100%;height:100%;">      		
		     			</div>
				</div>	<!-- second-pane-->
				
			
		</div>
		
		<div kendo-window="newUploadWindow" k-title="'Upload Images'"
		           k-width="600" k-height="500" k-visible="false" k-options="newUploadWindowOptions">
			<input kendo-upload  name="file"  type="file" k-options="newUploadOptions" />
		</div>			
			
			