	<form name="searchForm" ng-submit="getCompany()" novalidate >
		<div kendo-toolbar id="companytoolbar" k-options="companyToolbarOptions"></div>
	</form>

	<h3> 
		&nbsp;&nbsp;
		<span ng-show="dataSet.info.id">{{dataSet.info.businessName}}</span> 
		<span ng-hide="dataSet.info.id">Business Name:&nbsp;</span>
		<input type="text" id="businessName" name="businessName" class="k-textbox" style='width:400px;' 
			ng-model="dataSet.info.businessName" 
			ng-hide="dataSet.info.id" 
			ng-trim="true" required validationMessage="Enter {0}"/>
	</h3>

	<div kendo-splitter="mainSplitter"  
			k-orientation="'horozontal'"
			k-panes="[{ collapsible: true, resizable: true, size: '180px'},
            	      { collapsible: true, resizable: true}]"
            k-options="mainSplitterOptions"
			style="height:600px;">
			
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
						<kendo-dropdownlist id="country" name="country"  style="width:100%;"   
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
					
					<li>
		    			<label for="rep">Sales Rep.:</label>
						<map-combobox name="rep"  style="width:100%;"  c-options="repOptions" ng-model="dataSet.info.repId">
					</li>

					<li>
		    			<label for="csr">CSR:</label>
						<map-combobox name="csr"  style="width:100%;" c-options="csrOptions" ng-model="dataSet.info.csrId">
					</li>

					<li>
						<label for="discount">Discount:</label>
						<input kendo-numerictextbox name="discount" style="width:60px;"  
							ng-model="dataSet.info.discount" k-options="discountOptions"/> &nbsp;&nbsp;Off
					</li>

					<li>
						<label for="term">Term:</label>
						<input kendo-dropdownlist name="term" style="width:100%;"  
							ng-model="dataSet.info.term" k-options="termOptions"/>
					</li>

					<li> 
						<label for="useWsp">
        				<input type="checkbox" name="useWsp"   
							ng-model="dataSet.info.useWsp"/>Use WSP for DD
						</label>
					</li>
					
					<li> 
						<label for="isCustomer">
        				<input type="checkbox" name="isCustomer"   
							ng-model="dataSet.info.isCustomer"/>Is Customer
						</label>
					</li>
					
					<li>
						<label for="isSupplier">
        				<input type="checkbox" name="isSupplier"   
							ng-model="dataSet.info.isSupplier"/>Is Supplier
						</label>
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
              		<div clivia-grid="contactGrid" 
              			c-grid-wrapper-name="'ContactGridWrapper'"
    					c-editable="true" 
    					c-data-source="contactsGridDataSource" 
    					c-pageable="false" 
    					c-new-item-function="newContactItemFunction"
    					c-register-deleted-item-function="registerDeletedContactItemFunction">
    				</div>
              </div>
          
              <div style="padding: 1em">
              		<div clivia-grid="addressGrid" 
              			c-grid-wrapper-name="'AddressGridWrapper'"
    					c-editable="true" 
    					c-data-source="addressesGridDataSource" 
    					c-pageable="false" 
    					c-new-item-function="newAddressItemFunction"
    					c-register-deleted-item-function="registerDeletedAddressItemFunction">
    				</div>
              </div>
	          <div style="padding: 1em">	<!-- notes -->
				  <form name="instructionsForm" ng-submit="" novalidate class="simple-form">          
	              
	              	<h3>Regular:</h3>
	           	 	<textarea  class="k-textbox" style="width:100%;height:100px;" ng-model="dataSet.info.regularInstructions"></textarea>		<!-- not use for now kendo-editor="regularEditor" -->
	              	<h3>Pricing:</h3>
	            	<textarea  class="k-textbox" style="width:100%;height:100px;" ng-model="dataSet.info.pricingInstructions"></textarea>		<!--not use for now kendo-editor="pricingEditor" -->
      			</form>
	          </div>
	          
              <div style="padding: 1em">
              		<div clivia-grid="journalGrid" 
              			c-grid-wrapper-name="'JournalGridWrapper'"
    					c-editable="true" 
    					c-data-source="journalsGridDataSource" 
    					c-pageable="false" 
    					c-new-item-function="newJournalItemFunction"
    					c-register-deleted-item-function="registerDeletedJournalItemFunction">
    				</div>
              </div>
            </div><!--end of tabstrip-->
	 	</div> 	<!--end of second pane-->

	</div>  <!--end of mainSplitter -->
 		
<pre>
dataSet:{{dataSet|json}}
</pre> 		
 		
 		
