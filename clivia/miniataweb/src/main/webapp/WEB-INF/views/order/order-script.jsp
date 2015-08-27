<script>

angular.module("app", ["kendo.directives"])	.controller("MyCtrl",["$scope","$http","$filter",function($scope,$http,$filter) {

	
    $scope.tabs =new kendo.data.ObservableArray([
                                                 { title: "tab1", content: "tab1" },
                                                 { title: "tab2", content: "tab2" },
                                               ]);
    
    $scope.addOrderItem = function() {
        $scope.tabs.push({
        	 title: "tab"+ ($scope.tabs.length+1), content: "tab"
        });
      };
	
      
     $scope.orderItemOptions={
    		 dataTextField: "title",
    	     dataContentField: "content",
    	     dataSource:$scope.tabs,
    	     animation:false,
    	     autoBind:false
    }; 
      
      
	$scope.mainSplitterOrientation="horizontal";

	var baseUrl="/miniataweb/order/";
	
	$scope.searchOrderNumber="";

	
	$scope.pageModel={};
	
	$scope.newOrder=function(){
		$scope.pageModel.order={};
		$scope.pageModel.order.orderNumber="";
		$scope.pageModel.order.customerId="";
		
	};

	$scope.newOrder();
	
	
	$scope.getOrder=function(){
		
		if(!!$scope.searchOrderNumber){
			$scope.newOrder();
			
			var url=baseUrl+"get-order?number="+$scope.searchOrderNumber;
			$http.get(url).
				success(function(data, status, headers, config) {
				    if(data){
				    	
				    	$scope.pageModel.product=data;
	
				    } else {
				    	alert("Can not found style:"+$scope.searchOrderNumber+".");
				    }
				    
			    	$scope.searchOrderNumber="";
				    
			   }).
  			   error(function(data, status, headers, config) {
				  alert( "failure message: " + JSON.stringify({data: data}));
			   });	

		}
		else{
			alert("Please input an Order# first.");
		}
		
	}

	

	
	$scope.getOrder=function(){
		
		if(!!$scope.searchOrderNumber){
			$scope.newOrder();
			
			var url=baseUrl+"get-order?number="+$scope.searchOrderNumber;
			$http.get(url).
				success(function(data, status, headers, config) {
				    if(data){
				    	
				    	$scope.pageModel.order=data;

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
			alert("Please input a style# first.");
		}
		
	}
	
	 
	$scope.saveOrder=function(){
			var url=baseUrl+"save-order";
			
			if(!$scope.pageModel.order.orderDate){
				$scope.pageModel.order.orderDate = $filter('date')(new Date(),'yyyy-MM-dd');	
			}

			$http.post(url,$scope.pageModel.order).
			  success(function(data, status, headers, config) {
			    	$scope.pageModel.order=data;
			  }).
			  error(function(data, status, headers, config) {
				  alert( "failure message: " + JSON.stringify({data: data}));
			  });		
	}
	
	$scope.deleteOrder=function(){
		if(!!$scope.pageModel.product.id && confirm("Please confirm to delete this order.")){
			var url=baseUrl+"delete-order";
			$http.post(url,$scope.pageModel.order).
			  success(function(data, status, headers, config) {
				  $scope.newGarment();
			  }).
			  error(function(data, start, headers, config) {
				  alert( "failure message: " + JSON.stringify({data: data}));
			  });		
		}
	}
	
	$scope.outterSplitterOptions={
            orientation: "vertical",
            panes: [
                    { collapsible: false, resizable: false, size: "50px"},
                    { collapsible: false},
                    { collapsible: false, resizable: true, size: "100px" }
                ]			
	};
		
	$scope.mainSplitterOptions={
            orientation: "horizontal",
            panes: [
                    { collapsible: true, resizable:true,size: "350px"},
                    { collapsible: false},
                ]			
	};
	
	$scope.customerOptions={
            dataTextField: "text",
            dataValueField: "value",			
			dataSource:{
 	    	    transport: {
	    	        read: {
	    	            url: '/miniataweb/dict/map?from=company&textField=businessName&valueField=id&orderBy=businessName',
	    	            type: 'get',
	    	            dataType: 'json',
 	    	            contentType: 'application/json'
	    	        }
			} }
			
	}
	
	
	$scope.requireTimeOptions={
			format: "hh:mm tt",
			parseFormats:["HH:mm:ss"],
			min: new Date(2000, 0, 1, 8, 0, 0), 
			max: new Date(2000, 0, 1, 17, 0, 0)
	}
	
	$scope.requireDateOptions={
			format: "yyyy-MM-dd",
		    parseFormats: ["yyyy-MM-dd"]
	}

	$scope.orderDateOptions={
			format: "yyyy-MM-dd",
		    parseFormats: ["yyyy-MM-dd"]
	}
}]);
	
</script>