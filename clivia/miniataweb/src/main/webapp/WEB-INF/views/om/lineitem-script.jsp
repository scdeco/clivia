<script>

	
orderApp.controller("lineItemCtrl",["$scope","$state","SO",
         function($scope,$state,SO){

	if(SO.instance.currentItemId===0) return;
	
	$scope.SO=SO;

	var orderItem=SO.getCurrentOrderItem(); 
	
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
    

	$scope.brand=SO.getBrandFromSpec(orderItem.spec);
	$scope.season=SO.getSeasonFromSpec(orderItem.spec);
	$scope.seasonId=$scope.season.id;
	
	$scope.$watch("seasonId",function(newValue,oldValue){
		if(newValue && newValue!=oldValue){
			$scope.season=SO.dds.season.getSeasonL($scope.brand.id,parseInt(newValue));
			orderItem.spec=$scope.brand.id+":"+$scope.season.id;
		}
	});
	
 	$scope.garmentGridDataSource=new kendo.data.DataSource({
 		        	data:SO.dataSet.lineItems, 
		    	    schema: {
		    	    	model: { id: "id" }
		    	    },	//end of schema
		    	    
   		    	    filter: {
		    	        field: "orderItemId",
		    	        operator: "eq",
		    	        value: orderItem.id,
		    	    },    
		    	    
		    	    serverFiltering:false,
		    	    pageSize: 0,			//paging in pager

		        }); //end of dataSource,
	
	//pass to garmentGird directive to create new lineitem		        
	$scope.newItemFunction=function(){
		    return {
			    	orderId:SO.dataSet.info.orderId,
			    	orderItemId:orderItem.id, 
			    	brandId:$scope.brand.id,
			    	seasonId:$scope.season.id,
			    }
		}
		        
	//pass to garmentGird directive to register removed lineitem		        
	$scope.registerDeletedItemFunction=function(dataItem){
		SO.registerDeletedItem(orderItem.type,dataItem.id);
	}
				
}]); 



</script>