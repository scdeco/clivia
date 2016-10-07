<div kendo-grid="queryGrid" k-options="query.gridOptions" k-rebind="query.rebind" ></div>

<div kendo-window="chooseColumnWindow" 
			k-width="300"
		 	k-height="550"
		 	k-position="{top: 50, left: 100 }"	
		 	k-resizable="true"
			k-draggable="true"
		 	k-title="'Choose Column'"
		 	k-pinned="true"
		 	k-visible="false"
		 	k-modal="true">

		<button ng-click="chooseColumnOk()" style="margin-left: 45px; margin-right: 10px; width:50px;">Ok</button>
		<button ng-click="chooseColumnCancel()" style="margin-right: 10px; width:50px;">Cancel</button>

		<ul style="list-style-type: none;">
			<li>
				<input type="checkbox" ng-model="allColumnsChecked" ng-change='chooseAllColumns(allColumnsChecked)'>Check/Uncheck all
			</li>
			<li>
				<hr/>
			</li>
			
			<li ng-repeat="column in columns">
	 			<input type="checkbox" checklist-model="choosedColumns" checklist-value="column"> {{column.title}}
			</li>
		</ul>	
</div>