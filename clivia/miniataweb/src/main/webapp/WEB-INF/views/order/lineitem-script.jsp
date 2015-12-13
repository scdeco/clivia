<script>

	
orderApp.controller("lineItemCtrl",["$scope","$state","SO",
         function($scope,$state,SO){

	if(SO.instance.currentItemId===0) return;
	
	$scope.SO=SO;

	var orderItem=SO.getCurrentOrderItem(); 
	var orderItemId =orderItem.orderItemId;
	

    $scope.lineItemSplitterOptions={
    	resize:function(e){
			var panes=e.sender.element.children(".k-pane"),
			gridHeight=$(panes[1]).innerHeight();
	      	window.setTimeout(function(){$scope.garmentGrid.resize(gridHeight)},1);    
	      	console.log("resize2:");
    	}		
    }
    
	$scope.garmentBrand=orderItem.spec;
	
 	$scope.garmentGridDataSource=new kendo.data.DataSource({
 		        	data:SO.dataSet.lineItems, 
		    	    schema: {
		    	    	model: { id: "id" }
		    	    },	//end of schema
		    	    
   		    	    filter: {
		    	        field: "orderItemId",
		    	        operator: "eq",
		    	        value: orderItemId
		    	    },    
		    	    
		    	    serverFiltering:false,
		    	    pageSize: 0,			//paging in pager

		        }); //end of dataSource,
		    	
	$scope.newItemFunction=function(){
		    return {
			    	orderId:SO.dataSet.info.orderId,
			    	orderItemId:orderItemId, 
			    	brand:$scope.garmentBrand
			    }
		}
				

}]); 



</script>