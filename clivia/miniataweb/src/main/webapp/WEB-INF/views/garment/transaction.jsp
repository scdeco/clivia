<div>
	<form name="searchForm" ng-submit="getTransaction()" novalidate >
	<div kendo-toolbar id="transtoolbar" k-options="transToolbarOptions"></div>
	</form>
	<table >
		<tr>
			<td class="header leftcolumn">Stock:</td>
			<td	class="conten leftcolumn">
	 			<ul class="options">
	 				<li>
				         <input type="radio" name="stock" id="stockIn" class="k-radio"  value="1"  ng-model="dataSet.info.isIn"/>
				         <label class="k-radio-label" for="stockIn">In</label>
	 				</li>
	 				<li>
				         <input type="radio" name="stock" id="stockOut" class="k-radio" value="0" ng-model="dataSet.info.isIn"/>
				         <label class="k-radio-label" for="stockOut">Out</label>
	 				</li>
	 			</ul>
			</td>
			<td class="header rightcolumn">Type:</td>
			<td class="content rightcolumn">
			    <ul class="options">
		    		<li>
				         <input type="radio" name="type" id="typeAdjust" class="k-radio"  value="0" ng-model="dataSet.info.type"/>
					     <label class="k-radio-label" for="typeAdjust">Manual</label>
					</li>
					<li>
				         <input type="radio" name="type" id="typeInvoce" class="k-radio" value="1" ng-model="dataSet.info.type"/>
				         <label class="k-radio-label" for="typeInvoce">Invoice</label>
					</li>
					<li>
				         <input type="radio" name="type" id="typeManual" class="k-radio" value="2" ng-model="dataSet.info.type"/>
				         <label class="k-radio-label" for="typeManual">Adjust</label>
					</li>
		    	</ul>
			</td>
		</tr>

		<tr>
			<td class="header leftcolumn">Batch#:</td>
			<td class="content leftcolumn">
				<input type="text"  class="k-textbox" ng-model="dataSet.info.batchNumber"/>
			</td>
			<td class="header rightcolumn">Description:</td>
			<td	class="conten rightcolumn">
				<input type="text"  class="k-textbox" ng-model="dataSet.info.description"/>
			</td>
		</tr>

		<tr>
			<td class="header leftcolumn">Brand:</td>
			<td class="content leftcolumn">
				<brand-input name="garmentBrandInput" ng-model="dataSet.info.brand" ></brand-input>
			</td>
			<td class="header rightcolumn">Date:</td>
			<td	class="conten rightcolumn">
				<input kendo-datepicker  k-format="'yyyy-MM-dd'" k-parseFormats="['yyyy-MM-dd']" ng-model="dataSet.info.transDate" />
			</td>
		</tr>

		<tr>
			<td class="header leftcolumn">Packaging:</td>
			<td class="content leftcolumn">
				<input type="text"  class="k-textbox" ng-model="dataSet.info.packaging"/>
			</td>
			<td class="header rightcolumn">Location:</td>
			<td	class="conten rightcolumn">
				<input type="text"  class="k-textbox" ng-model="dataSet.info.location"/>
			</td>
		</tr>
	
	</table>
	<div>
   		<div garment-grid="garmentEntryGrid" c-editable="true" c-data-source="garmentEntryGridDataSource" c-pageable="false" c-brand="dataSet.info.brand" c-new-item-function="newItemFunction"></div> 
	
	</div>
	
</div>