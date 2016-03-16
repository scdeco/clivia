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
	
	var dataSource = new kendo.data.DataSource({
		transport: {
		    read: {
		        url: url,
		        type: 'post',
		        dataType: 'json',
		        contentType: 'application/json'
		    },
		    parameterMap: function(options, operation) {
		            return JSON.stringify(options);
		    }
		},
		error: function(e) {
		    alert("Status:" + e.status + "; Error message: " + e.errorThrown);
		},
		pageSize: 25,
		serverPaging: true,
		serverFiltering: true,
		serverSorting: true,
	     	filter: queryGridFilter,
		    sort: queryGridSort,
		schema: {
		    data: "data",
		    total: "total",
		},
	});
	$scope.gridOptions={
		dataSource:gridDataSource,
		columns:gridColumns,
		selectable:"row",
		resizable:true,
		reorderable:true,
		filterable:true,
		sortable: { allowUnsort: true},
	    pageable: {
	    	pageSizes:["all",40,35,30,25,20,15,10,5],
	        refresh: true,
	        buttonCount: 5
	    },			
		
	    change:function(){
	    },
	    
	}	
	
	
	
	
}]);






</script>