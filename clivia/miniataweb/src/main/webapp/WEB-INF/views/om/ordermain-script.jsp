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
	                id:"btnPrint",
	                click: function(e) {
	                	$scope.printOrder();
	                }	                
	            }, {
	                type: "separator",
 	            }, {
	                type: "button",
	                text: "Upc",
	                id:"btnUpc",
	                click: function(e) {
		                	$scope.generateUpcs();
		                }
 	                
	       }]
	    };	
	$scope.companyOptions={
		name:"companyComboBox",
		dataTextField:"businessName",
		dataValueField:"id",
		minLength:1,
		url:'../datasource/companyInfoDao/read',
	}

	$scope.generateUpcs=function(){
		SO.generateUpcs();
		$scope.$apply();
	};	
	
	$scope.generateBillableItems=function(){
		
		var currentOrderItem=SO.getCurrentOrderItem();
		SO.generateBillableItems(currentOrderItem);
		$scope.$apply();
	};	
	
	$scope.newOrder=function(){
		SO.clear();
		SO.setCurrentOrderItem(0);		//$state.go('main.blankitem');
	};	
	
	
	$scope.printOrder=function(){
		var orderItem=SO.getCurrentOrderItem();
		if(orderItem.typeId===1){	//billItem
			var dataSource=new kendo.data.DataSource({
						     	data:SO.dataSet.billItems, 
						   	    filter: {field: "orderItemId", operator: "eq",value: orderItem.id },    
							    sort:{field:"lineNo"},
						    }); //end of dataSource,
						    
			dataSource.fetch(function() {
				  var billItems = dataSource.view();
				  SO.printBill(billItems,true)		//print billItems that from lineitem(typeid===2) only
				});
		}
		
	}

	$scope.repeatOrder=function(){
		SO.repeat();
		$scope.$apply();
	}

	$scope.getOrder=function(){
		
		if(!!$scope.searchOrderNumber){
			SO.clear();
			SO.retrieve($scope.searchOrderNumber)
				.then(function(data){
				    if(data){
				    	var items=SO.dataSet.items;
			    		for(var i=0;i<items.length;i++)
			    			SO.addOrderItemButton(items[i]);

			    		//retrieve all items here
			    		//SO.dict.getRemoteImages();
			    		
			    		var orderItemId=items.length>0?items[0].id:0;
				    	SO.setCurrentOrderItem(orderItemId);
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
			    	//adjust new orderitem button orderItemId value
			    	
			    	var items=SO.dataSet.items;
			    	var currentId=0;
			    	for(var i=0,item,button;i<items.length;i++){
			    		item=items[i];
			    		button=SO.instance.itemButtons[item.lineNo-1];
			    		button.orderItemId=item.id;
			    		if(button.selected)
			    			currentId=button.orderItemId;
			    	}		
		    		SO.setCurrentOrderItem(currentId);
			    	
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