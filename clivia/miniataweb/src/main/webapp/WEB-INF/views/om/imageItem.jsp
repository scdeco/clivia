
	    		<div image-view="imageGrid" 
	    					c-editable="true" 
	    					c-data-source="imageGridDataSource" 
	    					c-pageable="false" 
	    					c-dict-image="SO.dds.image"
	    					c-new-item-function="newItemFunction"
	    					c-register-deleted-item-function="registerDeletedItemFunction"
	    					style="height:800px;">

	    		</div> 

<!-- <div >
   	
    <div class="k-header wide" >
      	<div kendo-splitter="imageItemSplitter"  
      			k-orientation="'horizontal'" 
				k-panes="[{ collapsible: true, resizable:true,size:'60%x', min:'100px'},
						   { collapsible: true, resizable:true}]"  
				style="height: 800px; width: 100%;"   	>
      	
      		<div id="imageitem-first-pane">
      		
				<div ng-show='false'>      		
	      		   	<div kendo-toolbar="imageItemToolbar" id="imageItemToolbar" k-options="toolbarOptions"></div>
				    <div kendo-pager k-options="imagePagerOptions"></div>
	      			<div kendo-list-view="imageItemListView" k-options="imageItemListViewOptions" >
		         		<div class="imageItem" k-template>
							<img ng-src="data:image/JPEG;base64,{{SO.dds.image.getLocalItem('id',dataItem.imageId).thumbnail}}" alt="{{dataItem.remark}} image">
		                		<h3>{{SO.dds.image.getLocalItem("id",dataItem.imageId).originalFileName}}</h3>
		 	                	<p ng-click="showOriginalImage(dataItem.imageId)">{{SO.dict.getImageDetail(dataItem.imageId)}}</p> 
		        		</div>
		   			</div> 
		   		</div>
		   		
	    		<div image-grid="imageGrid" 
	    					c-editable="true" 
	    					c-data-source="imageGridDataSource" 
	    					c-pageable="false" 
	    					c-dict-image="SO.dds.image"
	    					c-new-item-function="newItemFunction"
	    					c-register-deleted-item-function="registerDeletedItemFunction"
	    					c-show-image-detail-function="showImageDetailFunction(imageItem)">
	    		</div> 
		   		
			</div>	first-pane
			
      		<div id="imageitem-second-pane">
      			<div stype="height:100%;width:100%;">
					<img ng-src="data:image/JPEG;base64,{{previewOriginalImage}}" alt="image" style="width:100%;height:100%;">      		
      			</div>
			</div>	second-pane
			
		</div>
			
	   
	</div>
   
	<div kendo-grid="imageItemGrid" k-options="imageItemGridOptions" >

   
   <div kendo-window="newUploadWindow" k-title="'Upload Images'"
            k-width="600" k-height="300" k-visible="false" k-options="newUploadWindowOptions">
		<input kendo-upload  name="file"  type="file" k-options="newUploadOptions" />
	</div>
        
</div> -->