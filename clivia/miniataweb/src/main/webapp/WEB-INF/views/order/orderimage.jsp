<div>
	<div>
	    <label>Image:</label>
    </div>
    
   	<div kendo-toolbar="imageItemToolbar" id="imageItemToolbar" k-options="toolbarOptions"></div>
   	
    <div class="k-header wide">
	   <div kendo-list-view="imageItemListView" k-options="imageItemListViewOptions">
	          <div class="imageItem" k-template>
					<img ng-src="data:image/JPEG;base64,{{dict.getImage(dataItem.imageId).thumbnail}}" alt="{{dataItem.remark}} image">
	                <h3>{{dict.getImage(dataItem.imageId).originalFileName}}</h3>
	 	                <p>{{dict.getImageDetail(dataItem.imageId)}}</p> 
	          </div>
	   </div> 
	   
	   <div kendo-pager k-options="imagePagerOptions"></div>
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