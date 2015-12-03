<div kendo-window="{{name}}" id="{{id}}"
		k-visible="true"
		k-actions="[ 'Close', 'Maximize']"
		k-modal="false"	>	   	
					 
		<form name="addStyle" ng-submit="getGrid()" novalidate >
			<span class="k-textbox k-space-right" style="width: 140px;" >
				<input type="text"  class="k-textbox" placeholder="Search Style#" ng-model="styleNumber" />
				<label ng-click="getGrid()" class="k-icon k-i-search"></label>
			</span>
		</form>		
		
		<h4>{{garment.styleNumber}}:&nbsp;{{garment.styleName}}</h4>
		  
		<div  kendo-grid="styleGrid" id="styleGrid" 
			  k-options="gridOptions" 
			  k-rebind="gridRebind"
			  k-height=200>
		</div> 		
		
		<div>
			<input type="button" value="Add" ng-click="add()">
			<input type="button" value="OK" ng-click="ok()">
			<label style="margin-left: 100px; font-weight: bold;" >Total:{{total}}</label>
			<input type="button" value="Clear" ng-click="clear()" style="margin-left:100px;">
			<input type="button" value="Cancel" ng-click="cancel()">
		</div>		 
</div>