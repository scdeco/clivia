<script>
orderApp.controller("billItemCtrl",["$scope","$state","$sce","SO",
         function($scope,$state,$sce,SO){
	
	if(SO.instance.currentItemId===0) return;
	
	$scope.SO=SO;

	$scope.orderItem=SO.getCurrentOrderItem();
	
	if($scope.orderItem.spec==="")
		$scope.orderItem.spec=SO.company.info.discount;
	
    $scope.billItemSplitterOptions={
        	resize:function(e){

        		var panes=e.sender.element.children(".k-pane"),
    			gridHeight=$(panes[1]).innerHeight();
    	      	window.setTimeout(function(){
    	      		if($scope.billGrid)
    		      		$scope.billGrid.resize(gridHeight);
    		    },1);    
    	      	console.log("resize2:");
        	}		
        }
	
 	$scope.billGridDataSource=new kendo.data.DataSource({
     	data:SO.dataSet.billItems, 
	    schema: {
	    	model: { 
	    		id: "id" ,
	    		fields:{
	    			snpId: {type: "number"},
 					listPrice:{type: "number"},
 					orderQty:{type: "number"},
 					orderPrice:{type: "number", validation: {  min: 0} },
 					orderAmt:{type: "number"},
 				}}
 			
	    },	//end of schema
	    
   	    filter: {
	        field: "orderItemId",
	        operator: "eq",
	        value: $scope.orderItem.id,
	    },    
	    
	    serverFiltering:false,
	    pageSize: 0,			//paging in pager

    }); //end of dataSource,
    
    
	$scope.discountOptions={
			min: 0,
         	max: 1,
            step: 0.01,
            format: "{0:p0}",
            decimals:2
	}    
	
	//pass to moneyGird directive to create new lineitem		        
	$scope.newItemFunction=function(){
		    return {
			    	orderId:SO.dataSet.info.orderId,
			    	orderItemId:$scope.orderItem.id, 
			    	snpId:0,
			    	orderAmt:0,
			    }
		}
		        
	//pass to billGrid directive to register removed billitem		        
	$scope.registerDeletedItemFunction=function(dataItem){
		SO.registerDeletedItem("orderBillItem",dataItem.id);
	}
	
	//generate auto bill items from lineItems...
	SO.generateBillableItems($scope.orderItem);
	
	$scope.getBillDetailFunction=function(billItem){
		var html;
		//if itemTypeId===2, the item is from lineItem and its billingKey is a string of garmentId
		if(billItem && billItem.itemTypeId===2){
			html=SO.getStyleGridHtml(parseInt(billItem.billingKey),true);
		}
		
		if(!html)
			html="<div></div>";
		$scope.htmlBillItemDetail=$sce.trustAsHtml(html); 
	};
	

	$scope.getTotalAmount=function(){
		if(!$scope.billGrid) return "";
		var totalAmt=$scope.billGrid.getTotal(),
			c=SO.company.info.country==="Canada"?"CA":"US",
			result=c+(totalAmt?kendo.toString(totalAmt,"c"):"");
		return result;
	}
	
	$scope.setDiscount=function(oldValue,newValue){
		oldValue=parseFloat(oldValue);
		newValue=parseFloat(newValue);
		if(oldValue===newValue) 
			return;
		
		$scope.orderItem.isDirty=true;
		$scope.billGrid.gridWrapper.setDiscount(newValue);
		$scope.billGrid.grid.refresh();
	}
}]);
</script>