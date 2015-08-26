<!DOCTYPE html>
<html>
<head>
	<title>Garment</title>
	<%@taglib prefix="ex" uri="/WEB-INF/miniataweb-tags.tld"%>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
	<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
	<shared:header/> 
	<%@include file="product-script.jsp"%>
</head>

<body>
	<div data-ng-app="app" ng-controller="MyCtrl">
 		<form name="searchForm" ng-submit="getGarment()" novalidate >
 				

				<input kendo-comboBox name="searchStyleNumber" placeholder="'Search style#'" ng-model="searchStyleNumber" k-options="searchOptions" />
            	<button class="k-icon k-i-search" type="submit">&nbsp;</button>	

				
<!--             <span class="k-textbox k-space-left" style="width: 140px;" > -->
<!-- 				<a href="#" ng-click="getGarment()" class="k-icon k-i-search">&nbsp;</a> -->
<!--             </span> -->
 		</form>
<br/>
		<div kendo-splitter="mainSplitter"  k-orientation="mainSplitterOrientation"  style="height:615px;">
			<div>
				<h3>Product</h3>
				<form name="productForm" ng-submit="" novalidate class="simple-form">
					<ul id="fieldlist">
						<li>
	                        <label for="styleNumber" class="required">Style#:</label>
	                        <input type="text" id="styleNumber" name="styleNumber" class="k-textbox" ng-model="pageModel.product.styleNumber" ng-trim="true" required validationMessage="Enter {0}"/>
						</li>
						<li>
					    	<label for="styleName" class="required">Style Name:</label>
							<input type="text" id="styleName" name="styleName" class="k-textbox" style="width:100%;"   ng-model="pageModel.product.styleName" ng-trim="true"/>
						</li>
						<li>
							<label for="description">Description:</label>
							<textarea id="description" name="description" class="k-textbox" style="width:100%;"   ng-model="pageModel.product.description"></textarea> 
						</li>
						<li>
							<label for="brand" class="required">Brand:</label>
							<select kendo-dropdownlist="brand" name="brand" k-data-source="brandOptions" ng-model="pageModel.product.brand"></select>
				 		</li>
						<li>
							<label for="colourway">Colourway:</label>
							<textarea id="colourway" name="colourway" class="k-textbox" style="width:100%;"  
								ng-model="pageModel.product.colourway" ng-model-options="{ updateOn: 'blur' }">
							</textarea>
						</li>
						<li>
							<label for="sizeRange">Size Range:</label>
							<textarea id="sizeRange" name="sizeRange" class="k-textbox" style="width:100%;" 
							 	ng-model="pageModel.product.sizeRange" ng-model-options="{ updateOn: 'blur' }">
							</textarea>
						</li>
						<li>
							<label for="retailPrice">Retail Price:</label>
							<input kendo-numerictextbox="retailPrice" name="retailPrice" k-options="priceSettings" ng-model="pageModel.product.retailPrice"/>
						</li>
						<li>
							<label for="wholeSalePrice">Whole Sale Price:</label>
							<input kendo-numerictextbox="wholeSalePrice" name="wholeSalePrice" k-options="priceSettings" ng-model="pageModel.product.wholeSalePrice"/>
						</li>
						<li>
							<label for="remark">Remark:</label>
							<textarea id="remark" name="remark" class="k-textbox" style="width:100%;"  ng-model="pageModel.product.remark"></textarea>
						</li>
					</ul>
					
					<div>
						<button kendo-button ng-disabled="productForm.$pristine" ng-click="saveGarment()">Save</button>
						<button kendo-button ng-click="newGarment()">Cancel</button>
						<button kendo-button ng-show="!!pageModel.product.id" ng-click="deleteGarment()"> Delete</button>
					</div>
				</form>
 			</div>	<!--end of paneOne -->
			<div>
				<h3>Detail Info:</h3>
		 		<div ng-show="!!pageModel.product.id"> 
		 			
					<div kendo-grid="upcGrid" k-options="upcGridOptions" k-rebind="upcGridOptions.dataSource.filter"></div>
		 		</div>
		 	</div> 	<!--end of paneTwo -->
		</div>  <!--end of mainSplitter -->
 		
 		
 		
		<div>
			<pre>
				Pristine: {{productForm.$pristine}}				search#:{{searchStyleNumber}}				styles:{{searchStyleNumberOptions}}
			
				{{pageModel|json}}<br/>Colourway:{{dictColourway|json}}<br/>Size Range:{{dictSizeRange|json}}<br/>
			</pre>
		</div>		
 		
 		
	</div> //end of controller
</body>
<style>
     #fieldlist {
        margin: 10px;
        padding: 0;
     }
     #fieldlist li {
         list-style: none;
         padding-bottom: .7em;
         text-align: left;
     }
     
     #fieldlist label {
          display: block;
          padding-bottom: .2em;
          font-weight: bold;
      }
      
      textarea { 
      	resize: vertical; 
      }
      
    .k-grid-delete.k-button {
    min-width: 28px !important;
    padding: 0!important;
}
      
</style>
<!-- <style>

	#mainSplitter{
		height:800px;
	}
	.field-label {
		width:80px;
	}
	
	textarea{
		height:100px;
	}
</style> -->

</html>