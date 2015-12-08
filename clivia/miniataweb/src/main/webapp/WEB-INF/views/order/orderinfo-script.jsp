<script>
orderApp.controller("orderInfoCtrl", ["$scope","SO","cliviaDDS",function($scope,SO,cliviaDDS) {

	$scope.SO=SO;
	
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
	
	