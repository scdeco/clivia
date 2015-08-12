<!DOCTYPE html>
<html>
<head>
	<title>Garment</title>
	<%@taglib prefix="ex" uri="/WEB-INF/miniataweb-tags.tld"%>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
	<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
	<shared:header/> 
	<%@include file="edit-product-script.jsp"%>
</head>

<body>
	<div data-ng-app="app" ng-controller="MyCtrl">
		
      <select kendo-drop-down-list ng-model="mainSplitterOrientation">
        <option value="horizontal">Horizontal</option>
        <option value="vertical">Vertical</option>
      </select>
		
		<div kendo-splitter="mainSplitter"   k-orientation="mainSplitterOrientation"   k-rebind="mainSplitterOrientation" style="height: 500px;">
			<div>
				<h3>Product</h3>
				<form novalidate class="simple-form">
					<ul id="fieldlist">
						<li>
	                        <label for="styleNumber" class="required">Style#:</label>
	                        <input type="text" id="styleNumber" name="styleNumber" class="k-textbox" ng-model="pageModel.product.styleNumber" />
							<button kendo-button ng-click="getGarment()">Find</button> 
						</li>
						<li>
							Style Name:
							<input style="width:100%;"  kendo-autocomplete ng-model="pageModel.product.styleName"/>
						</li>
						<li>
							Description:
							<textarea style="width:100%;height:60px;" kendo-autocomplete ng-model="pageModel.product.description"> </textarea>
						</li>
						<li>
							Brand:
							<select kendo-dropdownlist k-data-source="brandOptions" ng-model="pageModel.product.brand"></select>
				 		</li>
						<li>
							Colourway:
							<textarea style="width:100%;" kendo-autocomplete k-options="colourwayOptions" ng-model="pageModel.product.colourway"></textarea>
						</li>
						<li>
							Size Range:
							<textarea style="width:100%;"  kendo-autocomplete k-options="sizeRangeOptions" ng-model="pageModel.product.sizeRange"></textarea>
						</li>
						<li>
							Retail Price:
							<input kendo-numerictextbox k-options="priceSettings" ng-model="pageModel.product.retailPrice"/>
						</li>
						<li>
							Whole Sale Price:
							<input kendo-numerictextbox k-options="priceSettings" ng-model="pageModel.product.wholeSalePrice"/>
						</li>
					</ul>
					
					<div>
						<button kendo-button ng-click="saveGarment()">Save</button>
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
			
				{{pageModel|json}}<br/>Colourway:{{dictColourway|json}}<br/>Size Range:{{dictSizeRange|json}}<br/>
				
			</pre>
		</div>		
 		
 		
	</div> //end of controller
</body>
<style>
     #fieldlist li {
         list-style: none;
         padding-bottom: .7em;
         text-align: left;
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