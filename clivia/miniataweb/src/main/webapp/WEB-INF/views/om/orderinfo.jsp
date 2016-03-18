
	<form name="headerForm" ng-submit="" novalidate class="simple-form" >
		<ul id="fieldlist">

			<li>
		    	<label for="Buyer">Buyer:</label>
				<input text-combobox name="buyer" style="width:100%;" c-options="buyerOptions" ng-model="SO.dataSet.info.buyer">
			</li>
			<li>
				<label for="orderName">Order Name:</label>
				<input type="text"  name="orderName" class="k-textbox" style="width:100%;"   ng-model="SO.dataSet.info.orderName"> 
			</li>
			<li>
		    	<label for="customerPO">Customer PO#:</label>
				<input type="text"  name="customerPO" class="k-textbox" style="width:100%;"   ng-model="SO.dataSet.info.customerPO" ng-trim="true"/>
			</li>
			<li ng-show="!!SO.dataSet.info.orderNumber">
                <label for="orderDate" class="requird">Issued :</label>
                <input kendo-datepicker name="orderDate" style="width:100px;" ng-readonly="true" k-options="orderDateOptions" ng-model="SO.dataSet.info.orderDate" />
				<input kendo-timepicker name="orderTime" style="width:100px;" ng-readonly="true" k-options="orderTimeOptions" ng-model="SO.dataSet.info.orderTime"/>
			</li>
			<li>
		    	<label for="requiredDate">Required By:</label>
				<input kendo-datepicker   name="requireDate"  style="width:100px;" k-options="requireDateOptions" ng-model="SO.dataSet.info.requireDate"/>
				<input kendo-timepicker   name="requireTime"  style="width:100px;" k-options="requireTimeOptions" ng-model="SO.dataSet.info.requireTime"/>
			</li>
			<li>
		    	<label for="rep">Representative:</label>
				<map-combobox name="rep"  style="width:100%;" c-options="repOptions" ng-model="SO.dataSet.info.repId">
			</li>
			<li ng-show="!!SO.dataSet.info.orderNumber">
		    	<label for="csr">Issued By:</label>
				<map-combobox name="csr" style="width:100%;" ng-readonly="true" c-options="csrOptions" ng-model="SO.dataSet.info.createBy">
			</li>
			
			<li>
				<label for="remark">Remark:</label>
			    <textarea  class="k-textbox" style="width:100%;height:100px;" ng-model="SO.dataSet.info.remark"></textarea>		
			</li>
			
			
		</ul>
		
	</form>
		