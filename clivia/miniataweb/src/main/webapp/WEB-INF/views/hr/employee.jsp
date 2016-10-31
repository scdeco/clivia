	<form name="searchForm" ng-submit="getEmployee()" novalidate >
		<div kendo-toolbar id="employeetoolbar" k-options="employeeToolbarOptions"></div>
	</form>

	<h3> 
		&nbsp{{dataSet.info.firstName}}&nbsp;&nbsp;{{dataSet.info.lastName}}
	</h3>

	<div kendo-splitter="mainSplitter"  
			k-orientation="'horozontal'"
			k-panes="[{ collapsible: true, resizable: true, size: '200px'},
            	      { collapsible: true, resizable: true}]"
            k-options="mainSplitterOptions"
			style="height:450px;">
			
		<div>		<!-- first pane -->
			<form name="employeeForm" ng-submit="" novalidate class="simple-form">
				<ul class="fieldlist">

					<li>
				    	<label for="firstName" class="required">First Name:</label>
						<input type="text" id="firstName" name="firstName" class="k-textbox" style="width:100%;"   
							ng-model="dataSet.info.firstName" 
							ng-trim="true"/>
					</li>
					<li>
				    	<label for="lastName" class="required">Last Name:</label>
						<input type="text" id="lastName" name="lastName" class="k-textbox" style="width:100%;"   
							ng-model="dataSet.info.lastName" 
							ng-trim="true"/>
					</li>
					
					<li>
						<label for="hireDate">Hired Since:</label>
						<input kendo-datepicker id="hireDate" name="hireDate" style="width:100%;"   
							ng-model="dataSet.info.hireDate" 
							k-options="hireDateOptions"/>
					</li>

					<li>
						<label for="department">Department:</label>
						<kendo-combobox id="department" name="department"  style="width:100%;"   
							ng-model="dataSet.info.department" 
							k-options="departmentOptions"/>
					</li>

					<li>
						<label for="position">Position:</label>
						<kendo-combobox id="position" name="position"  style="width:100%;"   
							ng-model="dataSet.info.position" 
							k-options="positionOptions"/>
					</li>

					
					<li>
						<label for="isRep">
        				<input type="checkbox" name="isRep"   
							ng-model="dataSet.info.isRep"/>Representive
						</label>
					</li>
					<li>
						<label for="isCsr">
        				<input type="checkbox" name="isCsr"   
							ng-model="dataSet.info.isCsr"/>CSR
						</label>
					</li>
					
					<li>
						<label for="isActive">
        				<input type="checkbox" name="isActive"   
							ng-model="dataSet.info.isActive"/>Active
						</label>
					</li>

					<li>
						<label for="remark">Remark:</label>
						<textarea id="remark" name="remark" class="k-textbox" style="width:100%;"  
							ng-model="dataSet.info.remark"></textarea>
					</li>
					
				</ul>
				
			</form>
		</div>	<!--end of first pane -->
		
		<div>	<!--second pane -->
		
		 	<div kendo-tabstrip="detailTabStrip" k-options="detailTabStripOptions">
              <ul>
                <li class="k-state-active">Contact Info</li>
                <li>App User</li>
                <li>Notes</li>
                <li>Journal</li>
              </ul>
          
              <div style="padding: 1em">
              
			<form name="contactForm" ng-submit="" novalidate class="simple-form">              
              	<ul class="fieldlist">
					<li>
						<label for="address">Address:</label>
						<input type="text" id="address" name="address" class="k-textbox" style="width:100%;"   
							ng-model="dataSet.info.address"/>
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
				    	<label for="postalCode">Postal Code:</label>
						<input type="text" id="postalCode" name="postalCode" class="k-textbox" style="width:100%;"   
							ng-model="dataSet.info.postalCode"  capitalize/>
					</li>

					<li>
						<label for="phone">Phone:</label>
						<input type="text" id="phone" name="phone" class="k-textbox" style="width:100%;"  
							ng-model="dataSet.info.phone"/>
					</li>
					
					<li>
						<label for="email">Email:</label>
						<input type="text" id="email" name="email" class="k-textbox" style="width:100%;"  
							ng-model="dataSet.info.email"/>
					</li>
				</ul>
			</form>
              </div>
          
              <div style="padding: 1em">
              	<form name="appUserForm" ng-submit="" novalidate class="simple-form">  
		              	<ul class="fieldlist">
		              		<li>
						    	<label for="username">Username:</label>
								<input type="text" id="username" name="username" class="k-textbox" style="width:100px;"   
									ng-model="dataSet.info.username"  ng-trim="true" />
							</li>
		              		<li>
						    	<label for="password">Password:</label>
								<input type="text" id="password" name="password" class="k-textbox" style="width:100px;"   
									ng-model="dataSet.info.password"  ng-trim="true" />
							</li>
						</ul>
					</form>
              </div>
              
              <div style="padding: 1em">	<!-- notes -->
           	 	<textarea name="note" style="width:100%;height:300px;" ng-model="dataSet.info.note"></textarea>			<!-- kendo-editor="noteEditor" -->
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
 		
 		
 		
 		
