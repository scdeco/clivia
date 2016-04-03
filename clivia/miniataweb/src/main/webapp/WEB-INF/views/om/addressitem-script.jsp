<script>

orderApp.controller("addressItemCtrl",["$scope","$http","$stateParams","SO" ,function($scope,$http,$stateParams,SO){
	if(SO.instance.currentItemId===0) return;
	
	$scope.SO=SO;
	
	var orderItem=SO.getCurrentOrderItem(); 


    $scope.addressGridDataSource=new kendo.data.DataSource({
    	    	data:SO.dataSet.addressItems,
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
	
	//pass to addressView directive to create new addressitem		        
	$scope.newItemFunction=function(dataItem){
			var newItem= {
			    	orderId:SO.dataSet.info.id,
			    	orderItemId:orderItem.id,
			    	billing:false,
			    	shipping:true
			    }
			if(SO.company && SO.company.info && SO.company.info.id===SO.dataSet.info.customerId){
				
				newItem.country=SO.company.info.country;
				newItem.province=SO.company.info.province;
				newItem.city=SO.company.info.city;
			}
			return newItem;
		}


	
	$scope.registerDeletedItemFunction=function(dataItem){
		SO.registerDeletedItem("address",dataItem.id);
	}
	
	
}]);
</script>