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
	
	$scope.orderTimeOptions={
			format: "hh:mm tt",
			parseFormats:["HH:mm:ss"],
	}
	
	$scope.buyerOptions={
			dataSource:SO.company.contacts,
			filter:"startswith",
            dataTextField: "fullName",
            dataValueField: "fullName",
			autoBind:false,					//
	}
	
	$scope.repOptions={
			name:"repComboBox",
			dataTextField:"fullName",
			dataValueField:"id",
			minLength:1,
			filter:"isRep,eq,true",
			url:"../datasource/employeeInfoDao/read",
			dict:cliviaDDS.getDict("employeeInput"),
		}

	$scope.csrOptions={
			name:"csrComboBox",
			dataTextField:"fullName",
			dataValueField:"id",
			minLength:1,
			filter:"isCsr,eq,true",
			url:"../datasource/employeeInfoDao/read",
			dict:cliviaDDS.getDict("employeeInput"),
		}

	
}]);
</script>
	
	