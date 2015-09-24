<script>
orderApp.controller("orderInfoCtrl", ["$scope",function($scope) {

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
	
	