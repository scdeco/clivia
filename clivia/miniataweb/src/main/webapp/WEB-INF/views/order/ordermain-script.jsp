<script>
orderApp.controller("orderMainCtrl", ["$scope","$state", "$filter","$http",function($scope,$state, $filter,$http) {

	$scope.mainSplitterOrientation="horizontal";
    $scope.setting.orderItemButtons=[];
	
	function populateModel(data){
    	$scope.order.orderInfo=data.orderInfo;
    	$scope.order.orderItems=data.orderItems;
		$scope.order.lineItems.splice(0,$scope.order.lineItems.length);
		$scope.order.imageItems.splice(0,$scope.order.imageItems.length);
  
    	for(var i=0;i<data.lineItems.length;i++){
	   		$scope.order.lineItems.push(data.lineItems[i]);
    	}
    	
    	for(var i=0;i<data.imageItems.length;i++){
	   		$scope.order.imageItems.push(data.imageItems[i]);
    	}
    	$scope.order.deletedItems=[];
	}
	
	$scope.newOrder=function(){
		$scope.dict.garments=[];
		$scope.dict.images=[];

		$scope.order.orderInfo={};
		$scope.order.orderInfo.orderId=0;
		$scope.order.orderInfo.orderNumber="";
		$scope.order.orderInfo.customerId="";

		$scope.order.orderItems=[];
		$scope.selectedOrderItemId=null;
		
		$scope.setting.orderItemButtons.splice(0,$scope.setting.orderItemButtons.length);
		
		$scope.order.lineItems.splice(0,$scope.order.lineItems.length);
		$scope.order.imageItems.splice(0,$scope.order.imageItems.length);
		
		$scope.order.deletedItems=[];
		
		$state.go('main.blankitem');
	};	
	
	$scope.repeatOrder=function(){
		var customerId=$scope.order.orderInfo.customerId;
		var buyer=$scope.order.orderInfo.buyer;
		var orderName=$scope.order.orderInfo.OrderName;
		
		$scope.order.orderInfo={};

		$scope.order.orderInfo.orderId=0;
		$scope.order.orderInfo.orderNumber="";
		$scope.order.orderInfo.customerId=customerId;
		$scope.order.orderInfo.buyer=buyer;
		$scope.order.orderInfo.orderName=orderName;		


    	for(var i=0;i<$scope.order.orderItems.length;i++){
	   		$scope.order.orderItems.id="";
	   		$scope.order.orderItems.orderId=0;
    	}		
		
    	for(i=0;i<$scope.order.lineItems.length;i++){
	   		$scope.order.lineItems.id="";
	   		$scope.order.lineItems.orderId=0;
    	}

    	for(i=0;i<$scope.order.imageItems.length;i++){
	   		$scope.order.imageItems.id="";
	   		$scope.order.imageItems.orderId=0;
    	}
    	
    	$scope.order.deletedItems=[];
    	
		alert(angular.toJson($scope.order.orderInfo));  	
		
	}
	
	$scope.newOrder();
	
	$scope.getOrder=function(){
		
		if(!!$scope.searchOrderNumber){
			$scope.newOrder();
					
			var url=$scope.setting.orderUrl+"get-order?number="+$scope.searchOrderNumber;

			$http.get(url).
				success(function(data, status, headers, config) {
				    if(data){
				    	populateModel(data);
				    	if($scope.order.orderItems.length>0){
				    		$scope.dict.getRemoteImages();
				    		for(var i=0;i<$scope.order.orderItems.length;i++){
				    			var item=$scope.order.orderItems[i];
				    			var button={text:item.title, id: "btn"+item.orderItemId, togglable: true, group: "OrderItem" };
				    			if(i===0){
				    				button.selected=true;
				    			}
				    				
				    			$scope.setting.orderItemButtons.push(button);
				    		}
				    		
				    		$scope.selectedOrderItemId=$scope.order.orderItems[0].orderItemId;
				    		$state.go('main.'+$scope.order.orderItems[0].type,{orderItemId:$scope.selectedOrderItemId});
				    	}
				    } else {
				    	alert("Can not found order:"+$scope.searchOrderNumber+".");
				    }
				    
			    	$scope.searchOrderNumber="";
				    
			   }).
  			   error(function(data, status, headers, config) {
				  alert( "failure message: " + JSON.stringify({data: data}));
			   });	
		}
		else{
			alert("Please input a Order# to search.");
		}
		
	}
	

	 
	$scope.saveOrder=function(){

		var url=$scope.setting.orderUrl+"save-order";
		
/*implement on server isde 		if(!$scope.order.orderInfo.orderDate){
			$scope.order.orderInfo.orderDate = $filter('date')(new Date(),'yyyy-MM-dd');	
		} 
 */
		$http.post(url,$scope.order).
		  success(function(data, status, headers, config) {
			  populateModel(data);
			  
		  }).
		  error(function(data, status, headers, config) {
			  alert( "failure message: " + JSON.stringify({data: data}));
 		  });		
	}
	
	$scope.deleteOrder=function(){
		if(!!$scoped.order.orderMain.id && confirm("Please confirm to delete this order.")){
			var url=$scope.setting.orderUrl+"delete-order";
			$http.post(url,$scope.order).
			  success(function(data, status, headers, config) {
				  $scope.newGarment();
			  }).
			  error(function(data, start, headers, config) {
				  alert( "failure message: " + JSON.stringify({data: data}));
			  });		
		}
	}





	var searchTemplate='<span class="k-textbox k-space-right" style="width: 140px;" >'+
						'<input type="text" name="searchOrderNumber" class="k-textbox" placeholder="Search Order#" ng-model="searchOrderNumber" />'+
						'<label ng-click="getOrder()" class="k-icon k-i-search"></span>' ;
						
    $scope.orderToolbarOptions = {
	        items: [{
		        	 template: '<label> <span ng-show="!!order.orderInfo.orderNumber"> Order#:</span> <span style="font-weight: bold;">{{order.orderInfo.orderNumber}}</span> </label>'
	        	 },{ 
	        		 type: "separator" 
               	 },{
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
    
    
	//called from parenet resize event
	$scope.resizeItemGrids=function(){
		if(!!$scope.common.itemGrid){
//what's the difference between $scope.common.itemGrid and $("#lineItemGrid")?
		    var gridElement =$("#lineItemGrid"), 
		        dataArea = gridElement.find(".k-grid-content"),
		        gridHeight = gridElement.innerHeight(),
		        otherElements = gridElement.children().not(".k-grid-content"),
		        otherElementsHeight = 0;
		    otherElements.each(function(){
		        otherElementsHeight += $(this).outerHeight();
			    });
	   		dataArea.height(400 - otherElementsHeight);
		}
	};

}]);
</script>