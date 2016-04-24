	<form name="searchForm" ng-submit="getProduct()" novalidate >
		<div kendo-toolbar="producttoolbar" id="producttoolbar" k-options="productToolbarOptions"></div>
	</form>

	<h3> 
		<label style="margin-left:10px;">Style#:</label> 
		<span ng-show="dataSet.info.id">{{dataSet.info.styleNo}}</span> 
		<input type="text" id="styleNo" name="styleNo" class="k-textbox" ng-model="dataSet.info.styleNo" ng-hide="dataSet.info.id" capitalize ng-trim="true" required validationMessage="Enter {0}"/>
	</h3>

	<div kendo-splitter="mainSplitter"  
			k-orientation="'horozontal'"
			k-panes="[{ collapsible: true, resizable: true, size: '300px'},
            	      { collapsible: true, resizable: true}]"
            k-options="mainSplitterOptions"
			style="height:720px;">
			
		<div>		<!-- first pane -->
			<form name="productForm" ng-submit="" novalidate class="simple-form">
			
				<ul id="fieldlist">
					<li>
				    	<label for="styleName" class="required">Style Name:</label>
						<input type="text" id="styleName" name="styleName" class="k-textbox" style="width:100%;"
							ng-model="dataSet.info.styleName" capitalize ng-trim="true"/>
					</li>
					<li>
						<label for="description">Description:</label>
						<textarea id="description" name="description" class="k-textbox" style="width:100%;" 
							ng-model="dataSet.info.description" ></textarea> 
					</li>
					<li>
						<label for="colourway">Colourway:</label>
						<textarea id="colourway" name="colourway" class="k-textbox" style="width:100%;" 
							ng-model="dataSet.info.colourway" ></textarea>
					</li>
					<li>
						<label for="sizeRange">Size Range:</label>
						<input kendo-combobox="sizeRange" name="sizeRange" style="width:100%;" 
							ng-model="dataSet.info.sizeRange" k-options="sizeRangeOptions" capitalize />
					</li>
					<li>
						<label for="category">Category:</label>
						<input kendo-combobox="category" name="category"  style="width:100%;"  
							ng-model="dataSet.info.category" k-options="categoryOptions" capitalize />
					</li>
					
					<li>
						<label for="wholeSalePrice">WSP:</label>
						<input kendo-numerictextbox="wholeSalePrice" name="wholeSalePrice"  style="width:90px"
							ng-model="dataSet.info.wsp" k-options="priceOptions"/>US$&nbsp;
						<input kendo-numerictextbox="wholeSalePriceCAD" name="wholeSalePriceCAD" style="width:90px"
							ng-model="dataSet.info.wspCad" k-options="priceOptions"/>CA$
						
					</li>
					<li>
						<label for="retailPrice">RRP:</label>
						<input kendo-numerictextbox="recommandedRetailPrice" name="recommandedRetailPrice" style="width:90px"
							ng-model="dataSet.info.rrp" k-options="priceOptions"/>US$&nbsp;
						<input kendo-numerictextbox="recommandedRetailPriceCAD" name="recommandedRetailPriceCAD" style="width:90px"
							ng-model="dataSet.info.rrpCad" k-options="priceOptions"/>CA$
					</li>
					<li>
						<label for="qoh">QOH:</label>
						<input kendo-numerictextbox="qoh" name="qoh" 
							ng-model="dataSet.info.qoh" k-options="quantityOptions"/>
					</li>
					<li>
						<label for="sq">SQ:</label>
						<input kendo-numerictextbox="sq" name="sq" 
							ng-model="dataSet.info.sq" k-options="quantityOptions"/>
					</li>
					<li>
						<label for="pq">PQ:</label>
						<input kendo-numerictextbox="pq" name="pq" 
							ng-model="dataSet.info.pq" k-options="quantityOptions"/>
					</li>

					<li>
						<label for="keyword">Keywords:</label>
						<input type="text" id="keyword" name="keyword" class="k-textbox" style="width:100%;"   ng-model="dataSet.info.keyword" /> 
					</li>
					<li>
						<label for="remark">Remark:</label>
						<textarea id="remark" name="remark" class="k-textbox" style="width:100%;"  ng-model="dataSet.info.remark"></textarea>
					</li>
				</ul>
				
			</form>
		</div>	<!--end of first pane -->
		
		<div>	<!--second pane -->
			
			<div kendo-grid="productUpcGrid" ng-show="showUpcView" k-options="productUpcGridOptions"></div>
			
			<div image-view="imageGrid" ng-hide="showUpcView"
	    					c-editable="true" 
	    					c-data-source="imageGridDataSource" 
	    					c-pageable="false" 
	    					c-dict-image="dictImage"
	    					c-new-item-function="newImageItemFunction"
	    					c-register-deleted-item-function="registerDeletedImageItemFunction"
	    					style="height:800px;">
	    		</div> 
			
	 	</div> 	<!--end of second pane-->

	</div>  <!--end of mainSplitter -->
<pre>
dataSet:{{dataSet|json}}
</pre> 		
 		
 		
 		
