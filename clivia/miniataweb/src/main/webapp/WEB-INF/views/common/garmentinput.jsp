<div>	   	
	<form name="addStyle" ng-submit="getGrid()" novalidate>
		<span class="k-textbox k-space-right" style="width: 140px;" >
		<input type="text"  class="k-textbox" placeholder="Search Style#" ng-model="styleNo"/>
		<label ng-click="getGrid()" class="k-icon k-i-search"></label>
		</span>
	</form>
			
	<h4>{{garment.styleNo}}:&nbsp;{{garment.styleName}}</h4>
	
	<div  kendo-grid="styleGrid" id="styleGrid"  k-options="gridOptions"  k-rebind="gridRebind" k-height=300></div> 		
	
	<div> 

	  	<input type="button" value="Clear" ng-click="clear()" style="margin-left:10px;">
	  	<input type="button" value="Cancel" ng-click="cancel()" >	
	  	
	  	<input type="button" value="OK" ng-click="ok()" style="margin-left:180px;">
		<input type="button" value="Add" ng-click="add()">	  	
	</div>
</div> 