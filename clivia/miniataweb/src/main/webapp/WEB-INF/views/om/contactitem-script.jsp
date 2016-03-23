<script>

orderApp.controller("contactItemCtrl",["$scope","$http","$stateParams","SO" ,function($scope,$http,$stateParams,SO){
	if(SO.instance.currentItemId===0) return;
	
	$scope.SO=SO;
	
	var orderItem=SO.getCurrentOrderItem(); 


    $scope.contactGridDataSource=new kendo.data.DataSource({
    	    	data:SO.dataSet.contactItems,
			    schema: {
			        model: {
			            id: "id"
			        }
			    },
			    
			    filter: {
			        field: "orderItemId",
			        operator: "eq",
			        value: orderItem.id
			    },    
			    
			    serverFiltering:false,
			    pageSize: 0,

	        });
	
	//pass to contactView directive to create new contactitem		        
	$scope.newItemFunction=function(dataItem){
		    return {
			    	orderId:SO.dataSet.info.id,
			    	orderItemId:orderItem.id, 
			    	isBuyer:true,
			    	isActive:true
			    }
		}


	
	$scope.registerDeletedItemFunction=function(dataItem){
		SO.registerDeletedItem("contact",dataItem.id);
	}
	
	
}]);
</script>