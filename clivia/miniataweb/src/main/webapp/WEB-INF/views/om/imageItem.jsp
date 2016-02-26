<div >
	<div>
	    <label>Image:</label>
    </div>
    
   	<div kendo-toolbar="imageItemToolbar" id="imageItemToolbar" k-options="toolbarOptions"></div>
   	
    <div class="k-header wide" >
      	<div kendo-splitter="imageItemSplitter"  k-orientation="'horizontal'" >
      	
      		<div id="imageitem-first-pane">
      			<div kendo-list-view="imageItemListView" k-options="imageItemListViewOptions">
	         		<div class="imageItem" k-template>
						<img ng-src="data:image/JPEG;base64,{{SO.dds.image.getLocalItem('id',dataItem.imageId).thumbnail}}" alt="{{dataItem.remark}} image">
	                		<h3>{{SO.dds.image.getLocalItem("id",dataItem.imageId).originalFileName}}</h3>
	 	                	<p ng-click="showOriginalImage(dataItem.imageId)">{{SO.dict.getImageDetail(dataItem.imageId)}}</p> 
	        		</div>
	   			</div> 
			    <div kendo-pager k-options="imagePagerOptions"></div>
			</div>	<!-- first-pane-->
			
      		<div id="imageitem-second-pane">
      			<div stype="height:100%;width:100%;">
					<img ng-src="data:image/JPEG;base64,{{previewOriginalImage}}" alt="image" style="width:100%;height:100%;">      		
      			</div>
			</div>	<!-- second-pane-->
			
		</div>
			
	   
	</div>
   
<!-- 	<div kendo-grid="imageItemGrid" k-options="imageItemGridOptions" > -->


   <pre>
   
   {{order.imageItems}}
   
   </pre>
   
   <div kendo-window="newUploadWindow" k-title="'Upload Images'"
            k-width="600" k-height="300" k-visible="false" k-options="newUploadWindowOptions">
		<input kendo-upload  name="file"  type="file" k-options="newUploadOptions" />
	</div>
        
</div>