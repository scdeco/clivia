<!DOCTYPE html>
<html>
<head>
	<title>Order</title>
	<%@taglib prefix="ex" uri="/WEB-INF/miniataweb-tags.tld"%>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
	<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
	<shared:header/> 
	<%@include file="order-script.jsp"%>
</head>

<body>
	<div data-ng-app="app" ng-controller="MyCtrl">
		<div kendo-splitter="outterSplitter"  k-options="outterSplitterOptions"  style="height:900px;">
			<div id="top-pane">
			</div>	<!-- top pane of outter splitter -->
			
			<div id="middle-pane">
				<div kendo-splitter="mainSplitter" k-options="mainSplitterOptions"  style="height: 100%; width: 100%;">
					<div id="left-pane">
						<form name="headerForm" ng-submit="" novalidate class="simple-form" >
							<ul id="fieldlist">
								<li>
			                        <label for="orderNumber" class="requird">Order#:</label>
			                        <input type="text" name="customer" class="k-textbox"  style="width:100%;" ng-model="pageModel.order.orderNumber"/>
								</li>
								<li>
			                        <label for="Customer" class="required">Customer:</label>
			                        <input kendo-combobox name="customer"  style="width:100%;" ng-model="pageModel.order.customerId" k-options="customerOptions" required validationMessage="Enter {0}"/>
								</li>
								<li>
							    	<label for="Buyer">Buyer:</label>
									<input type="text"  name="buyer" class="k-textbox" style="width:120px;" ng-model="pageModel.order.buyer">
								</li>
								<li>
									<label for="orderName">Order Name:</label>
									<input type="text"  name="orderName" class="k-textbox" style="width:100%;"   ng-model="pageModel.order.orderName"> 
								</li>
								<li>
							    	<label for="customerPO">Customer PO#:</label>
									<input type="text"  name="customerPO" class="k-textbox" style="width:150px;"   ng-model="pageModel.order.customerPO" ng-trim="true"/>
								</li>
								<li>
							    	<label for="requiredBy">Required By:</label>
									<input kendo-datepicker   name="requiredBy"  style="width:200px;"  k-options="requiredTimeOptions" ng-model="pageModel.order.requiredDate"/>
<!-- 									<input kendo-datepicker   name="requiredDate"  style="width:110px;"   ng-model="pageModel.order.requiredDate"/>
									<input kendo-timepicker   name="requiredTime"  style="width:110px;"  k-options="requiredTimeOptions" ng-model="pageModel.order.requiredTime"/>
 -->								</li>
								
							</ul>

							<div>
								<button kendo-button ng-disabled="headerForm.$pristine" ng-click="saveOrder()">Save</button>
								<button kendo-button ng-click="newOrder()">Cancel</button>
								<button kendo-button ng-show="!!pageModel.order.id" ng-click="delete()"> Delete</button>
							</div>
							
							
						</form>
					</div> <!-- left pane -->
					<div id="right-pane">
					</div>
				</div>
			</div> <!-- middle pane of outter splitter -->
			<div id="bottom-pane">
				<pre>
model:{{pageModel.order|json}}
				</pre>
			</div> <!-- bottom pane of outter splitter -->
		</div>
	</div>
	
</body>
<style>
     #fieldlist {
        margin: 10px;
        padding: 0;
     }
     #fieldlist li {
         list-style: none;
         padding-bottom: .7em;
         text-align: left;
     }
     
     #fieldlist label {
          display: block;
          padding-bottom: .2em;
          font-weight: bold;
      }
      
      textarea { 
      	resize: vertical; 
      }
      
    .k-grid-delete.k-button {
    min-width: 28px !important;
    padding: 0!important;
}
      
</style>


</html>