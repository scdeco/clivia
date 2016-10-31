			
	<form name="searchForm"  novalidate >
		<div kendo-toolbar id="invoicetoolbar" k-options="invoiceToolbarOptions"></div>
	</form>		
	
	<span kendo-notification="saveResult" k-options="saveResultOptions"></span>
	<br>
   	<label for="invoiceNumber">Invoice#:</label>
	<input type="text"  name="invoiceNumber" class="k-textbox" style="width:120px;"   ng-model="dataSet.info.invoiceNumber"/>
	
    <label for="invoiceDate" class="requird">Invoice Date :</label>
    <input kendo-datepicker name="invocieDate" style="width:120px;" k-options="dateOptions" ng-model="dataSet.info.invoiceDate" />	
	
	
	
	<div kendo-splitter="mainSplitter"
				k-orientation="'horizontal'"
				k-panes="[{ collapsible: true, resizable:false,size:'360px'},
                    	  { collapsible: false}]"
				style="height:850px; width: 100%;">
				
		<div id="left-pane">

			<form name="infoForm" ng-submit="" novalidate class="simple-form" >
				<ul id="fieldlist">
									
					<li>
				    	<label for="rep">Rep.:</label>
						<input type="text"  name="rep" class="k-textbox" style="width:100%;"   ng-model="dataSet.info.rep"/>
					</li>
					
					<li>
				    	<label for="cardNo">Card#:</label>
						<input type="text"  name="cardNo" class="k-textbox" style="width:100%;"   ng-model="dataSet.info.cardNumber"/>
					</li>
					<li>
				    	<label for="expiry">Expiry:</label>
						<input type="text"  name="expiry" class="k-textbox" style="width:100%;"   ng-model="dataSet.info.expiry"/>
					</li>
					
					<li>
						<label for="term">Term:</label>
						<input kendo-combobox name="term" style="width:100%;"  
							ng-model="dataSet.info.term" k-options="termOptions"/>
					</li>
		
					<li>
						<label for="billTo">Bill To:</label>
					    <textarea name="billTo"
					    	class="k-textbox" style="width:100%;height:100px;" 
					    	ng-model="dataSet.info.billTo">
					    </textarea>		
					</li>
					<li>
						<label for="shipTo">Ship To:</label>
					    <textarea name="shipTo"
					    	class="k-textbox" style="width:100%;height:100px;" 
					    	ng-model="dataSet.info.shipTo">
					    </textarea>		
					</li>
					
					<li>
						<label for="comments">Comments:</label>
					    <textarea name="comments"
					    	class="k-textbox" style="width:100%;height:100px;" 
					    	ng-model="dataSet.info.comments">
					    </textarea>		
					</li>
					
					<li>
				    	<label for="creator">Created By:</label>
						<input type="text"  name="creator" class="k-textbox" style="width:100%;"   ng-model="dataSet.info.creator"/>
					</li>
					
				</ul>
				
			</form>			
		</div> <!-- left pane -->

		
		<div id="right-pane">
				
			  	<div clivia-grid="invoiceGrid"
					c-grid-wrapper-name="'InvoiceGridWrapper'"
					c-data-source="invoiceGridDataSource"
					c-editable="true" 
					c-pageable="false" 
					c-new-item-function="newItemFunction"
					c-register-deleted-item-function="registerDeletedItemFunction">
				</div> 
		</div>
			
	</div>
	

