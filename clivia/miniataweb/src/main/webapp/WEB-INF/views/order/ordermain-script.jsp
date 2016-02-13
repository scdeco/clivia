<script>
orderApp.controller("orderMainCtrl", ["$scope","$state", "$filter","SO",function($scope,$state, $filter, SO) {
	$scope.SO=SO;
	
	var searchTemplate='<span class="k-textbox k-space-right" style="width: 140px;" >'+
						'<input type="text" name="searchOrderNumber" class="k-textbox" placeholder="Search Order#" ng-model="searchOrderNumber" />'+
						'<span ng-click="getOrder()" class="k-icon k-i-search"></span></span>' ;
						
    $scope.orderToolbarOptions = {
	        items: [{
	                type: "button",
	                text: "New",
	                id:"btnNew",
	                click: function(e) {
	                	$scope.newOrder();
	                }
	            }, {
	                type: "button",
	                text: "Repeat",
	                id:"btnRepeat",
	                click: function(e) {
	                	$scope.repeatOrder();
	                }
	            }, {
	                type: "separator",
	            }, {	
	                type: "button",
	                text: "save",
	                id: "btnSave",
	                click: function(e){
	                	$scope.saveOrder();
	                }
	            }, {
	                type: "separator",
	            }, {	
	                template:searchTemplate,		                
	            }, {
	                type: "button",
	                text: "Print",
	                id:"btnPrint"
	            
	       }]
	    };	
    
	$scope.newOrder=function(){
		SO.clear();
		$state.go('main.blankitem');
	};	
	
	
	$scope.getOrder=function(){
		SO.clear();
		if(!!$scope.searchOrderNumber){
			
			SO.retrieve($scope.searchOrderNumber)
				.then(function(data){
				    if(data){
			    		for(var i=0;i<SO.dataSet.items.length;i++)
			    			SO.addOrderItemButton(SO.dataSet.items[i]);

			    		//retrieve all items here
			    		//SO.dict.getRemoteImages();
			    		
			    		
			    		
				    	SO.setCurrentOrderItem(0);
				    }else{
				    	alert("Can not find order:"+$scope.searchOrderNumber+".");
				    }
				    $scope.searchOrderNumber="";
				},function(data){
					alert( "failure message: " + JSON.stringify({data: data}));
					$scope.searchOrderNumber="";
				});
		}
		else{
			alert("Please input a Order# to search.");
			
		}
	}
	
	$scope.saveOrder=function(){

		SO.save()
			.then(function(data){
			    if(data){
		    	
			    }else{
		    		alert("Can not find order:"+$scope.searchOrderNumber+".");
			    }
			},function(data){
				alert( "failure message: " + JSON.stringify({data: data}));
			});
	}
	
	$scope.deleteOrder=function(){
		
		if(SO.isNew() && confirm("Please confirm to delete this order.")){
			SO.remove()
			.then(function(data){
			    if(data){
		    	
			    }else{
		    		alert("Can not delete this order:"+OrderModel.info.orderNumber+".");
			    }
			},function(data){
				alert( "failure message: " + JSON.stringify({data: data}));
			});
		}
	}
	
	$scope.newOrder();
	
}]);
</script>