<script>
'user strict';
var queryApp = angular.module("queryApp",
		[ "ui.router", "kendo.directives","clivia"]);


queryApp.controller("queryCtrl",["$scope","cliviaDDS",function($scope,cliviaDDS){
	
	$scope.queryToolbarOptions={items: [{
		        type: "button",
		        text: "Export To Excel",
		        id: "btnExcel",
		        click: function(e){
		        	$scope.query.queryGW.grid.saveAsExcel();
		            }
		    }, {
		        type: "separator",
		    }, {
		        type: "button",
		        text: "Print",
		        id:"btnPrint"
		    
		}]};
	
	var url='../datasource/garmentWithInfoDao/read';
	
	$scope.queryGridNo="802";
}]);






</script>