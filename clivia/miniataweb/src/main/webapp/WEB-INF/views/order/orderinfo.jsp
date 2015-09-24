
	<form name="headerForm" ng-submit="" novalidate class="simple-form" >
		<ul id="fieldlist">
			<li>
                      <label for="orderNumber" class="requird">Order#:</label>
                      <input type="text" name="customer" class="k-textbox"  style="width:100%;" ng-model="order.orderInfo.orderNumber"/>
			</li>
			<li ng-show="order.orderInfo.orderDate">
                      <label for="orderDate" class="requird">Order Date:</label>
                      <input  kendo-datepicker name="orderDate" style="width:110px;"  style="width:100%;" k-options="orderDateOptions"   ng-model="order.orderInfo.orderDate" />
			</li>
			
			<li>
                 <label for="Customer" class="required">Customer:</label>
                 <input kendo-combobox name="customer"  style="width:100%;" ng-model="order.orderInfo.customerId" k-options="customerOptions" required validationMessage="Enter {0}"/>
			</li>
			<li>
		    	<label for="Buyer">Buyer:</label>
				<input type="text"  name="buyer" class="k-textbox" style="width:120px;" ng-model="order.orderInfo.buyer">
			</li>
			<li>
				<label for="orderName">Order Name:</label>
				<input type="text"  name="orderName" class="k-textbox" style="width:100%;"   ng-model="order.orderInfo.orderName"> 
			</li>
			<li>
		    	<label for="customerPO">Customer PO#:</label>
				<input type="text"  name="customerPO" class="k-textbox" style="width:150px;"   ng-model="order.orderInfo.customerPO" ng-trim="true"/>
			</li>
			<li>
		    	<label for="requiredDate">Required By:</label>
				<input kendo-datepicker   name="requireDate"  style="width:110px;"  k-options="requireDateOptions" ng-model="order.orderInfo.requireDate"/>
				<input kendo-timepicker   name="requireTime"  style="width:110px;"  k-options="requireTimeOptions" ng-model="order.orderInfo.requireTime"/>
			</li>
			
		</ul>


		
	</form>
		