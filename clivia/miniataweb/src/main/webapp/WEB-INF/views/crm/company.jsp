	<form name="searchForm" ng-submit="getCompany()" novalidate >
		<div kendo-toolbar id="companytoolbar" k-options="companyToolbarOptions"></div>
	</form>

	<h3> 
		Business Name:&nbsp;<span ng-show="dataSet.info.id">{{dataSet.info.businessName}}</span> 
		<input type="text" id="businessName" name="businessName" class="k-textbox" style='width:400px;' 
			ng-model="dataSet.info.businessName" 
			ng-hide="dataSet.info.id" 
			ng-trim="true" required validationMessage="Enter {0}"/>
	</h3>

	<div kendo-splitter="mainSplitter"  
			k-orientation="'horozontal'"
			k-panes="[{ collapsible: true, resizable: true, size: '300px'},
            	      { collapsible: true, resizable: true}]"
            k-options="mainSplitterOptions"
			style="height:615px;">
			
		<div>		<!-- first pane -->
			<form name="companyForm" ng-submit="" novalidate class="simple-form">
				<ul id="fieldlist">
					
					<li>
				    	<label for="category" class="required">Category:</label>
						<input type="text" id="category" name="category" class="k-textbox" style="width:100%;"   
							ng-model="dataSet.info.category" 
							ng-trim="true"/>
					</li>

					<li>
						<label for="country">Country:</label>
						<kendo-combobox id="country" name="country"  style="width:100%;"   
							ng-model="dataSet.info.country" 
							ng-trim="true" 
							k-options="countryOptions"/>
					</li>

					<li>
						<label for="province">Province:</label>
						<kendo-combobox id="province" name="province"  style="width:100%;"   
							ng-model="dataSet.info.province" 
							ng-trim="true" 
							k-ng-delay="provinceOptions" 
							k-options="provinceOptions"/>
					</li>

					<li>
						<label for="city">City:</label>
						<kendo-combobox id="city" name="city"  style="width:100%;"   
							ng-model="dataSet.info.city" 
							ng-trim="true" 
							k-ng-delay="cityOptions" 
							k-options="cityOptions"/>
					</li>


					
					<li>
						<label for="website">Website:</label>
						<input type="text" id="website" name="remark" class="k-textbox" style="width:100%;"  
							ng-model="dataSet.info.website"/>
					</li>
					
				</ul>
				
			</form>
		</div>	<!--end of first pane -->
		
		<div>	<!--second pane -->
		 	<div kendo-tabstrip="detailTabStrip" k-options="detailTabStripOptions">
              <ul>
                <li class="k-state-active">Contact</li>
                <li>Address</li>
                <li>Instructions</li>
                <li>Journal</li>
              </ul>
          
              <div style="padding: 1em">
              	<div kendo-sortable k-options="contactGridSortableOptions">
			  		<div kendo-grid="contactGrid" id="contactGrid" k-options="contactGridOptions"></div>
			  	</div>
			  	<ul kendo-context-menu k-options="contactGridContextMenuOptions">
				  	<li id="contactAdd">Add</li>
				  	<li id="contactInsert">Insert</li>
				  	<li id="contactDelete">Delete</li>
				</ul>
              </div>
          
              <div style="padding: 1em">
              	<div kendo-sortable k-options="addressGridSortableOptions">
					<div kendo-grid="addressGrid" id="addressGrid" k-options="addressGridOptions"></div>
				</div>
			  	<ul kendo-context-menu k-options="addressGridContextMenuOptions">
				  	<li id="addressAdd">Add</li>
				  	<li id="addressInsert">Insert</li>
				  	<li id="addressDelete">Delete</li>
				</ul>
              </div>
              
              <div style="padding: 1em">	<!-- notes -->
              	<h3>Regular:</h3>
           	 	<textarea kendo-editor="regularEditor" ng-model="dataSet.info.html"></textarea>
              	<h3>Pricing:</h3>
            	<textarea kendo-editor="pricingEditor" ng-model="dataSet.info.priceInfo"></textarea>
              </div>
              
              <div style="padding: 1em">
				<div kendo-grid="journalGrid" id="journalGrid" k-options="journalGridOptions"></div>
			  	<ul kendo-context-menu k-options="journalGridContextMenuOptions">
				  	<li id="journalAdd">Add</li>
				  	<li id="journalInsert">Insert</li>
				  	<li id="journalDelete">Delete</li>
				</ul>
              </div>
            </div><!--end of tabstrip-->
	 	</div> 	<!--end of second pane-->

	</div>  <!--end of mainSplitter -->
 		
 		
 		
 		
