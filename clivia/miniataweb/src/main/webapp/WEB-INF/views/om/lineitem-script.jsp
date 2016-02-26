<script>

	
orderApp.controller("lineItemCtrl",["$scope","$state","SO",
         function($scope,$state,SO){

	if(SO.instance.currentItemId===0) return;
	
	$scope.SO=SO;

	var orderItem=SO.getCurrentOrderItem(); 
	var orderItemId =orderItem.id;
	
    $scope.lineItemSplitterOptions={
    	resize:function(e){
			var panes=e.sender.element.children(".k-pane"),
			gridHeight=$(panes[1]).innerHeight();
	      	window.setTimeout(function(){
	      		if($scope.garmentGrid)
		      		$scope.garmentGrid.resize(gridHeight);
		    },1);    
	      	console.log("resize2:");
    	}		
    }
    
   	var specs=orderItem.spec.split(":");
	$scope.garmentBrandId=parseInt(specs[0]);
	$scope.garmentBrandName=SO.dds.brand.getBrandNameL($scope.garmentBrandId);
	
	if(specs.length>1)
		$scope.garmentSeasonId=parseInt(specs[1]);
	else{
		var season=SO.dds.season.getCurrentSeasonL($scope.garmentBrandId);
		$scope.garmentSeasonId=season.id;
	}
	
	$scope.totalQty=0;
	
 	$scope.garmentGridDataSource=new kendo.data.DataSource({
 		        	data:SO.dataSet.lineItems, 
		    	    schema: {
		    	    	model: { id: "id" }
		    	    },	//end of schema
		    	    
   		    	    filter: {
		    	        field: "orderItemId",
		    	        operator: "eq",
		    	        value: orderItem.id
		    	    },    
		    	    
		    	    serverFiltering:false,
		    	    pageSize: 0,			//paging in pager

		        }); //end of dataSource,
		    	
	$scope.newItemFunction=function(){
		    return {
			    	orderId:SO.dataSet.info.orderId,
			    	orderItemId:orderItemId, 
			    	brandId:$scope.garmentBrandId,
			    	seasonId:$scope.garmentSeasonId
			    }
		}
				

}]); 



</script>