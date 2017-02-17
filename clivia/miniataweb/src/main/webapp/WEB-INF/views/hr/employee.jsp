	<form name="searchForm" ng-submit="getEmployee()" novalidate >
		<div kendo-toolbar id="employeetoolbar" k-options="employeeToolbarOptions"></div>
	</form>

	<h3> 
		&nbsp{{dataSet.info.firstName}}&nbsp;&nbsp;{{dataSet.info.lastName}}&nbsp;&nbsp;ID: {{dataSet.info.id}}
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
				    	<label for="empNum" class="required">Emplyee No:</label>
						<input type="text" id="empNum" name="empNum" class="k-textbox" style="width:100%;"   
							ng-model="dataSet.info.empNum" 
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
                <li>Salary</li>
                <li>Permission</li>
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
           	 	<textarea id="note" name="note" style="width:100%;height:300px;" ng-model="dataSet.info.note"></textarea>			<!-- kendo-editor="noteEditor" -->
              </div>
              
              
              <div style="padding: 1em">
				<form name="salaryForm" ng-submit="" novalidate class="simple-form">
			  		<ul class="fieldlist">
				  		<li>
				  			<label for="workType">Work Type:</label>
				  			<kendo-combobox id="workType" name="workType" style="width:100px;"   
									ng-model="dataSet.info.workType"  ng-trim="true" k-options="workTypeOptions"/>
				  		</li>
				  	
				  		<li>
						    <label for="salaryAmount">Amount:</label>
							<input type="text" id="salaryAmount" name="salaryAmount" class="k-textbox" style="width:100px;"   
									ng-model="dataSet.info.salaryAmount"  ng-trim="true" />
							<p style=" display:inline">/Hour <b>Or</b> /Month</p>
						</li>
						
						<li>
						    <label for="startWork">Working Time:</label>
							<input kendo-timepicker id="startWorkTime" name="startWrokTime" style="width:100px;" 
							k-options="startTimeOptions" ng-model="dataSet.info.startWorkTime"/>		
							<p style="display: inline">&nbsp To &nbsp</p>
							<input kendo-timepicker id="endWorkTime" name="endWrokTime" style="width:100px;" 
							k-options="endTimeOptions" ng-model="dataSet.info.endWorkTime"/>					
						</li>
						
						<li>
						    <label for="breakTime">Break Time:</label>
							<input type="text" id="breakTime" name="breakTime" class="k-textbox" style="width:100px;text-align: right;"   
									ng-model="dataSet.info.breakTime"  ng-trim="true" />
							<p style="display: inline"> Mins </p>
						</li>
				  	
					</ul>
            	</form>
            </div>
            		
            <div style="padding: 1em">
				<form name="permissionForm" ng-submit="" novalidate class="simple-form">
			  		<ul class="fieldlist">
			  			<li>
            		  		<label for="permissionExp0">0: Disable</label>
            				<label for="permissionExp1">1: Read</label>
            				<label for="permissionExp2">2: Edit/Delete</label>
            			</li>
            			<li>
            				<table width='100%'>
            					<tr>
            						<td>Customer Management:</td>
            						<td>
            							<kendo-combobox id="crmPremission" name="crmPremission" style="width:60px;"   
									ng-model="dataSet.info.crmPremission"  ng-trim="true" k-options="premissionOptions"/>
									</td>
				  				</tr>
				  				<tr>
				  					<td>Order Management:</td>
				  					<td>
				  						<kendo-combobox id="omPremission" name="omPremission" style="width:60px;"   
									ng-model="dataSet.info.omPremission"  ng-trim="true" k-options="premissionOptions"/>
				  					</td>
				  				</tr>
				  				<tr>
				  					<td>Item Management:</td>
				  					<td>
				  						<kendo-combobox id="imPremission" name="imPremission" style="width:60px;"   
									ng-model="dataSet.info.imPremission"  ng-trim="true" k-options="premissionOptions"/>
									</td>
				  				</tr>
				  				<tr>
				  					<td>Design Management:</td>
				  					<td>
				  						<kendo-combobox id="dstPremission" name="dstPremission" style="width:60px;"   
									ng-model="dataSet.info.dstPremission"  ng-trim="true" k-options="premissionOptions"/>
									</td>
				  				</tr>
				  				<tr>
				  					<td>Employee Management:</td>
				  					<td>
				  						<kendo-combobox id="hrPremission" name="hrPremission" style="width:60px;"   
									ng-model="dataSet.info.hrPremission"  ng-trim="true" k-options="premissionOptions"/>
									</td>
				  				</tr>
				  				<tr>
				  					<td>Invoice Management:</td>
				  					<td>
				  						<kendo-combobox id="ivPremission" name="ivPremission" style="width:60px;"   
									ng-model="dataSet.info.ivPremission"  ng-trim="true" k-options="premissionOptions"/>
									</td>
				  				</tr>
				  				<tr>
				  					<td>Shipping Management:</td>
				  					<td>
				  						<kendo-combobox id="spiPremission" name="spiPremission" style="width:60px;"   
									ng-model="dataSet.info.spiPremission"  ng-trim="true" k-options="premissionOptions"/>
									</td>
				  				</tr>
				  				<tr>
				  					<td>Production Management:</td>
				  					<td>
				  						<kendo-combobox id="pduPremission" name="pduPremission" style="width:60px;"   
									ng-model="dataSet.info.pduPremission"  ng-trim="true" k-options="premissionOptions"/>
									</td>
				  				</tr>
				  				<tr>
				  					<td>Salary Management:</td>
				  					<td>
				  						<kendo-combobox id="salPremission" name="salPremission" style="width:60px;"   
									ng-model="dataSet.info.salPremission"  ng-trim="true" k-options="premissionOptions"/>
				  					</td>
				  				</tr>
				  				<tr>
				  					<td>Company Summary:</td>
				  					<td>
				  						<kendo-combobox id="querryPremission" name="querryPremission" style="width:60px;"   
									ng-model="dataSet.info.querryPremission"  ng-trim="true" k-options="premissionOptions"/>
									</td>
				  				</tr>
				  			</table>
				  		</li>
				  	</ul>
            	</form>
           	</div> 
           	
	 	</div> 	<!--end of second pane-->

	</div>  <!--end of mainSplitter -->
 		
 		
 		
 		
