<script>
orderApp.controller("imageItemCtrl",["$scope","$http","$stateParams","SO" ,function($scope,$http,$stateParams,SO){
	if(SO.instance.currentItemId===0) return;
	
	$scope.SO=SO;
	
	var orderItem=SO.getCurrentOrderItem(); 

	
	var getImages=function(dataItems){
		var imageString="";
		for(var i=0,imageId;i<dataItems.length;i++){
			imageId=dataItems[i].imageId;
			if( imageId && !SO.dds.image.getLocalItem("id",imageId)){
				imageString+=","+imageId;
			}
		}
		if(imageString!==""){
			imageString=imageString.substring(1);
			SO.dds.image.getItems("id",imageString)
				.then(function(){
					
				},function(){
					
				});
			
		}
	}
	
    $scope.imageGridDataSource=new kendo.data.DataSource({
    	    	data:SO.dataSet.imageItems,
			    schema: {
			        model: {
			            id: "id",
		                fields: {
		                    imageId:{type: "number"}
		                }
			        }
			    },
			    
			    filter: {
			        field: "orderItemId",
			        operator: "eq",
			        value: orderItem.id
			    },    
			    
			    serverFiltering:false,
			    pageSize: 0,

			    change: function(e) {
			    	var i=0;
			        //check the "response" argument to skip the local operations
		           getImages(e.items);
			    }
	        });
    
	
	//pass to imageView directive to create new imageitem		        
	$scope.newItemFunction=function(dataItem){
		    return {
			    	orderId:SO.dataSet.info.id,
			    	orderItemId:orderItem.id, 
			    	imageId:dataItem.id,
			    	isDirty:true,
			    }
		}


	
	$scope.registerDeletedItemFunction=function(dataItem){
		SO.registerDeletedItem("image",dataItem.id);
	}
	
	
}]);
</script>