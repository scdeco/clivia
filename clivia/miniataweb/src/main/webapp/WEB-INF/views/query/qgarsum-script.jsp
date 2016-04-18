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
	
	var dds={
		image:cliviaDDS.createDict("image",consts.baseUrl+"data/libImage/","onDemand"),
		
		garment:cliviaDDS.getDict("garment"),
		brand:cliviaDDS.getDict("brand"),
		season:cliviaDDS.getDict("season"),
		upc:cliviaDDS.getDict("upc"),
		}

	$scope.getData=function(){
		var url="../data/get-company?id="+companyId+"&list=contactItems,addressItems";
		$http.get(url).
			success(function(data, status, headers, config) {
				if(data){

				}
			});
	}
	
	$scope.garSumGridOptions={
			columns:"",
			dataSource:"",
	}
	
	var ggw=new GarmentGridWrapper("garsum");	
	ggw.setBrandSeason({},dds.season.getCurrentSeason(2));		//columns is set in setBrand,so ggw.setColumns(gridColumns) is not needed here.

	scope.$watch("cSeason",function(newValue,oldValue){
		if(newValue && newValue!==oldValue){
			ggw.setBrandSeason(scope.cBrand,scope.cSeason);		//columns is set in setBrand,so ggw.setColumns(gridColumns) is not needed here.
			ggw.grid.setOptions({columns:ggw.gridColumns});
		}
	});
	
    scope.$on("kendoWidgetCreated", function(event, widget){
        // the event is emitted for every widget; if we have multiple
        // widgets in this controller, we need to check that the event
        // is for the one we're interested in.
        //This happens after dataBound event
        if (widget ===scope[scope.gridName]) {
        	ggw.wrapGrid(widget);
        	ggw.calculateTotal();
        	if(scope.cName)
	        	scope.$parent[scope.cName]={
        			name:scope.cName,
        			grid:widget,
        			gridWrapper:ggw,
        			hasRow:function(){
        				return !!(ggw.getRowCount());
        			},
        			getTotal:function(){
        				return ggw.total
        				},
        			resize:function(gridHeight){
        				ggw.resizeGrid(gridHeight);
        			},
        			
/* 			        			create:function(brand){
        				ggw.setBrand(brand);
        				ggw.grid.setOptions({columns:ggw.gridColumns});
        			}, */
        			
        			
        	}
        }
    });	
	
	
}]);


</script>