<script>
orderApp.controller("billItemCtrl",["$scope","$state","$sce","SO",
         function($scope,$state,$sce,SO){
	
	if(SO.instance.currentItemId===0) return;
	
	$scope.SO=SO;

	var orderItem=SO.getCurrentOrderItem(); 
	
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
 					orderQty:{type: "number"},
 					orderPrice:{type: "number", validation: {  min: 0} },
 					orderAmt:{type: "number"},
 				}}
 			
	    },	//end of schema
	    
   	    filter: {
	        field: "orderItemId",
	        operator: "eq",
	        value: orderItem.id,
	    },    
	    
	    serverFiltering:false,
	    pageSize: 0,			//paging in pager

    }); //end of dataSource,
	
	//pass to moneyGird directive to create new lineitem		        
	$scope.newItemFunction=function(){
		    return {
			    	orderId:SO.dataSet.info.orderId,
			    	orderItemId:orderItem.id, 
			    	snpId:0,
			    }
		}
		        
	//pass to moneyGird directive to register removed lineitem		        
	$scope.registerDeletedItemFunction=function(dataItem){
		SO.registerDeletedItem("billItem",dataItem.id);
	}
	
	//generate auto bill items from lineItems...
	SO.generateBillableItems(orderItem);
	
	$scope.getBillDetailFunction=function(billItem){
		var html;
		//if itemTypeId===2, the item is from lineItem and its billingKey is a string of garmentId
		if(billItem && billItem.itemTypeId===2){
			html=SO.getStyleGridHtml(billItem.billingKey);
		}
		
		if(!html)
			html="<div></div>";
		$scope.htmlBillItemDetail=$sce.trustAsHtml(html); 
	};
	

	
}]);
</script>