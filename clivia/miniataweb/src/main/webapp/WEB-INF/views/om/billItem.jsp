<div id="billItem">
    <div kendo-splitter="billItemSplitter"
				k-orientation="'vertical'"
				k-panes="[{ collapsible: false, resizable:false,size:'40px'},
						   { collapsible: false, resizable:true,size:'600px', min:'100px'},
                    	  { collapsible: true}]"
                k-Options="billItemSplitterOptions"
				style="height: 800px; width: 100%;">    
				
		<div style="margin:6px;"><!-- top pane-->
			<label style="margin-left:40px;">Discount:&nbsp;
				<input kendo-numerictextbox name="discount" style="width:60px;"
					change-on-blur="setDiscount" 
					ng-model="orderItem.spec" 
					k-options="discountOptions"/> Off
			</label>
			
			<label style="margin-left:40px;">Total Amount:&nbsp;{{getTotalAmount()}}</label>
				
	    </div> <!-- end of top pane-->
    
    	<div>  	
    		<div bill-grid="billGrid" 
    					c-editable="true" 
    					c-data-source="billGridDataSource" 
    					c-pageable="false" 
    					c-new-item-function="newItemFunction"
    					c-register-deleted-item-function="registerDeletedItemFunction"
    					c-get-bill-detail-function="getBillDetailFunction(billItem)">
    		</div> 
   		</div> 	
 		
 		
		<div>   <!--  bottom pane -->	
				<div id="billitemdetail" ng-bind-html="htmlBillItemDetail"	></div>	
<!-- 			<div id="billitemdetail" ui-view></div> -->
		</div>  <!-- end of bottom pane -->	
    </div>
	 
</div>

<style>
 
#billitemdetail table, th, td {
    border: 1px dotted gray;
    border-collapse: collapse;
}
#billitemdetail table, th, td {
    padding: 5px;
}
#billitemdetail table tr:nth-child(even) {
    background-color: #eee;
}
#billitemdetail table tr:nth-child(odd) {
   background-color:#fff;
}
#billitemdetail table th	{
    background-color: black;
    color: white;
}

.billDetailQty{
	width:40px;
}
</style>