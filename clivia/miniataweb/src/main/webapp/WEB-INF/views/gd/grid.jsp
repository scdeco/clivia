	<form name="searchForm" ng-submit="getGrid()" novalidate >
		<div kendo-toolbar="gridtoolbar" id="gridtoolbar" k-options="gridToolbarOptions"></div>
	</form>

	<div kendo-splitter="mainSplitter"  
			k-orientation="'horozontal'"
			k-panes="[{ collapsible: true, resizable: true, size: '220px'},
            	      { collapsible: true, resizable: true}]"
            k-options="mainSplitterOptions"
			style="height:630px;">
			
		<div>		<!-- first pane -->
			<form name="gridForm" ng-submit="" novalidate class="simple-form">
			
				<ul id="fieldlist">
					<li>
				    	<label for="GridNo" class="required">Grid#:</label>
						<input type="text" id="gridNo" name="gridNo" class="k-textbox" style="width:100%;"
							ng-model="dataSet.info.gridNo" capitalize ng-trim="true"/>
					</li>
					<li>
				    	<label for="gridName" class="required">Grid Name:</label>
						<input type="text" id="gridName" name="gridName" class="k-textbox" style="width:100%;"
							ng-model="dataSet.info.name" capitalize ng-trim="true"/>
					</li>
					<li>
						<label for="daoName">Dao:</label>
						<textarea id="daoName" name="daoName" class="k-textbox" style="width:100%;" 
							ng-model="dataSet.info.daoName" ></textarea> 
					</li>
					<li>
						<label for="dataUrl">Dara Url:</label>
						<textarea id="dataUrl" name="dataUrl" class="k-textbox" style="width:100%;" 
							ng-model="dataSet.info.dataUrl" ></textarea> 
					</li>
					<li>
						<label for="sortDescriptor">Sort Descriptor:</label>
						<textarea id="sortDescriptor" name="sortDescriptor" class="k-textbox" style="width:100%;" 
							ng-model="dataSet.info.sortDescriptor" ></textarea>
					</li>
					<li>
						<label for="baseFilter">Base Filter:</label>
						<textarea id="baseFilter" name="baseFilter" class="k-textbox" style="width:100%;" 
							ng-model="dataSet.info.baseFilter" ></textarea>
					</li>
					
					<li>
						<label for="pageSize">Page Size:</label>
						<input kendo-numerictextbox="pageSize" name="pageSize" 
							ng-model="dataSet.info.pageSize" k-options="pageSizeOptions" />
					</li>
					<li> 
						<label for="editable">
		        				<input type="checkbox" name="editable"   
									ng-model="dataSet.info.editable"/>editable
						</label>
					</li>					
					<li> 
						<label for="sortable">
		        				<input type="checkbox" name="sortable"   
									ng-model="dataSet.info.sortable"/>Sortable
						</label>
					</li>					
					<li> 
						<label for="filterable">
		        				<input type="checkbox" name="filterable"   
									ng-model="dataSet.info.filterable"/>Filterable
						</label>
					</li>					
					<li> 
						<label for="columnMovable">
		        				<input type="checkbox" name="columnMovable"   
									ng-model="dataSet.info.columnMovable"/>Column Movable
						</label>
					</li>					
					<li> 
						<label for="columnResizable">
		        				<input type="checkbox" name="columnResizable"   
									ng-model="dataSet.info.columnResizable"/>Column Resizable
						</label>
					</li>					
					<li>
						<label for="remark">Remark:</label>
						<textarea id="remark" name="remark" class="k-textbox" style="width:100%;"  ng-model="dataSet.info.remark"></textarea>
					</li>
				</ul>
				
			</form>
		</div>	<!--end of first pane -->
		
		<div>	<!--second pane -->
				<div id="columnItem" style="padding: 1em">
				    	<div clivia-grid="columnGrid"
				   					c-grid-wrapper-name="'ColumnGridWrapper'"
				   					c-editable="true" 
				   					c-data-source="columnGridDataSource" 
				   					c-pageable="false" 
				   					c-new-item-function="newItemFunction"
				   					c-register-deleted-item-function="registerDeletedItemFunction">
				    	</div> 
				</div>			
	 	</div> 	<!--end of second pane-->

	</div>  <!--end of mainSplitter -->
	
	<div kendo-window="previewWindow"			
			k-width="1000"
		 	k-height="900"
		 	k-position="{top: 30, left: 10 }"	
		 	k-resizable="true"
			k-draggable="true"
		 	k-title="'Preview'"
		 	k-actions="['Minimiz','Maximize','Close']"
		 	k-pinned="false"
		 	k-modal="true">

		<div  query-grid="queryGrid"  c-grid-data="dataSet"></div>
	</div>
	
	<div kendo-window="selectFieldWindow" 
			k-width="300"
		 	k-height="500"
		 	k-position="{top: 50, left: 100 }"	
		 	k-resizable="true"
			k-draggable="true"
		 	k-title="'select fields'"
		 	k-pinned="true"
		 	k-modal="true">

		<button ng-click="Ok()" style="margin-left: 45px; margin-right: 10px; width:50px;">Ok</button>
		<button ng-click="Cancel()" style="margin-right: 10px; width:50px;">Cancel</button>

		<ul style="list-style-type: none;">
			<li>
				<input type="checkbox" >Toggle check of all
			</li>
			<li>
				<hr/>
			</li>
			
			<li ng-repeat="field in fields">
	 			<input type="checkbox" checklist-model="selectedFields" checklist-value="field"> {{field}}
			</li>
		</ul>	
	</div>
	
<pre>
dataSet:{{dataSet|json}}
</pre> 		
 		
 		
 		
