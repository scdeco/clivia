<script>
'user strict';
var invtApp = angular.module("invtApp",
		[ "ui.router", "kendo.directives","clivia"]);

invtApp.factory("inventory",["GridWrapper","Product",function(GridWrapper,Product){
	
	var garmentGridColumns=[{
		        name:"lineNumber",
		        title: " ",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 25,
			}, {
				name:"styleNumber",
				title:"Style#",
				field:"styleNumber",
				width:80,
			}, {
				name:"styleName",
				title:"Style Name",
				field:"styleName",
				width:180,
			}, {
				name:"description",
				title:"Description",
				field:"description",
				width:200,
				hidden:true,
			}, {
				name:"category",
				title:"Category",
				field:"category",
				width:140
			}, {
				name:"qtyInStock",
				title:"Stock",
				field:"totalQtyInStock",
				width:80,
				attributes:{class:"numberColumn"},				
				format: "{0:##,#}",
			}, {
				name:"qtyInSO",
				title:"SO Qty",
				field:"totalQtyInSO",
				width:80,
				attributes:{class:"numberColumn"},				
				format: "{0:##,#}",
			}, {
				name:"qtyInPO",
				title:"PO Qty",
				field:"totalQtyInPO",
				width:80,
				attributes:{class:"numberColumn"},				
				format: "{0:##,#}",
			}, {
				name:"retailPrice",
				title:"RRP",
				field:"retailPrice",
				width:70,
				format: "{0:c}",
				attributes:{class:"numberColumn"}
			}, {
				name:"wholesalePrice",
				title:"WSP",
				field:"wholesalePrice",
				width:70,
				format: "{0:c}",
				attributes:{class:"numberColumn"}
			}, {
				name:"colourway",
				title:"Colourway",
				field:"colourway",
				width:180,
			}, {
				name:"sizeRange",
				title:"Size Range",
				field:"sizeRange",
				width:180,
			}, {
				name:"remark",
				title:"Remark",
				field:"remark",
		}];


	var garmentGridDataSource = new kendo.data.DataSource({
			transport: {
			    read: {
			        url: 'http://' + window.location.host + '/miniataweb/datasource/garmentDao/read',
			        type: 'post',
			        dataType: 'json',
			        contentType: 'application/json'
			    },
			    update: {
			        url: 'http://' + window.location.host + '/miniataweb/datasource/garmentDao/update',
			        type: 'post',
			        dataType: 'json',
			        contentType: 'application/json'
			    },
			    create: {
			        url: 'http://' + window.location.host + '/miniataweb/datasource/garmentDao/create',
			        type: 'post',
			        dataType: 'json',
			        contentType: 'application/json'
			    },
			    destroy: {
			        url: 'http://' + window.location.host + '/miniataweb/datasource/garmentDao/destroy',
			        type: 'post',
			        dataType: 'json',
			        contentType: 'application/json'
			    },
			    parameterMap: function(options, operation) {
			        if (operation === "read") {
			            return JSON.stringify(options);
			        } else {
			            return JSON.stringify(options.models);
			        }
			    }
			},
			error: function(e) {
			    alert("Status:" + e.status + "; Error message: " + e.errorThrown);
			},
			batch: true,
			pageSize: 15,
			serverPaging: true,
			serverFiltering: true,
			serverSorting: true,
 		    sort: [{
		         field: "styleNumber",
		         dir: "asc"
		     }], 
			schema: {
			    data: "data",
			    total: "total",
			    model: {id: "id"}
			},

			
		});

	var gwGarment=new GridWrapper("inventoryGarmentGrid",garmentGridColumns);
	
	var product=new Product();
	
	var inventory={
		detail:product,
		
		gwGarment:gwGarment,
		
		wrapGarmentGrid:function(){
			gwGarment.wrapGrid();
		},
		
		dict:{
			
		},
		
		garmentGridOptions:{
			columns:garmentGridColumns,
			selectable:"row",
			resizable:true,
			reorderable:true,
			filterable:true,
			sortable: { allowUnsort: true},
		    pageable: {
		    	pageSizes:["all",20,15,10,5],
		        refresh: true,
		        buttonCount: 5
		    },			
			
		    change:function(){
				var selectedItem=this.dataItem(this.select());
				inventory.detail.retrieveByGarmentId(selectedItem.id);
		    },
		    
			dataSource:garmentGridDataSource
		},
		
		toolbarOptions:{
		    items: [{
		            type: "button",
		            text: "New",
		            id:"btnNew",
		            click: function(e) {
		           		 }
		        }, {
		            type: "separator",
		        }, {	
		            type: "button",
		            text: "save",
		            id: "btnSave",
		            click: function(e){
		                }
		        }, {
		            type: "button",
		            text: "Print",
		            id:"btnPrint"
		        
		   }]
		 },
		 
		 splitterOptions:{
				orientation:"vertical",
				resize:function(e){

					var panes=e.sender.element.children(".k-pane"),
						gridHeight=$(panes[1]).innerHeight()-37;
 			      	window.setTimeout(function () {
			            gwGarment.resizeGrid(gridHeight);
			      	},1); 
			      	console.log("resize2:");
			 }
		 }
	
	};
	return inventory;
}]).

factory("Product",["GridWrapper","$http",function(GridWrapper,$http){
	var upcGridColumns=[{
	        name:"lineNumber",
	        title: " ",
	        attributes:{class:"gridLineNumber"},
	        headerAttributes:{class:"gridLineNumberHeader"},
	        width: 25,
		}, {
	         name: "upcNumber",
	         field: "upcNumber",
	         title: "UPC#",
	         width: 140
	     }, {
	         name: "colour",
	         field: "colour",
	         title: "Colour",
	         width: 120
	     }, {
	         name: "size",
	         field: "size",
	         title: "Size",
	         width: 80,
	     }, {
	         name: "qtyInStock",
	         field: "qtyInStock",
	         title: "Stock",
	         width: 80,
			 attributes:{class:"numberColumn"},				
			 format: "{0:##,#}",
	     }, {
	         name: "qtyInSO",
	         field: "qtyInSO",
	         title: "Qty In SO",
	         width: 80,
			 attributes:{class:"numberColumn"},				
			 format: "{0:##,#}",
	     }, {
	         name: "qtyInPO",
	         field: "qtyInPO",
	         title: "Qty In PO",
	         width: 80,
			 attributes:{class:"numberColumn"},				
			 format: "{0:##,#}",
	     }, {
	    	 name:"remark",
	         field: "remark",
	         title: "Remark",
	}];
	
	var gwUpc=new GridWrapper("inventoryUpcGrid",upcGridColumns);
	
	var upcGridFilter=[{
	        field: "garmentId",
	        operator: "eq",
	        value: -1
	    }];
	
	var upcGridDataSource = new kendo.data.DataSource({
	     transport: {
	         read: {
	             url: 'http://' + window.location.host + '/miniataweb/datasource/garmentUpcDao/read',
	             type: 'post',
	             dataType: 'json',
	             contentType: 'application/json'
	         },
	         update: {
	             url: 'http://' + window.location.host + '/miniataweb/datasource/garmentUpcDao/update',
	             type: 'post',
	             dataType: 'json',
	             contentType: 'application/json'
	         },
	         create: {
	             url: 'http://' + window.location.host + '/miniataweb/datasource/garmentUpcDao/create',
	             type: 'post',
	             dataType: 'json',
	             contentType: 'application/json'
	         },
	         destroy: {
	             url: 'http://' + window.location.host + '/miniataweb/datasource/garmentUpcDao/destroy',
	             type: 'post',
	             dataType: 'json',
	             contentType: 'application/json'
	         },
	         parameterMap: function(options, operation) {
	             if (operation === "read") {
	                 return JSON.stringify(options);
	             } else {
	                 return JSON.stringify(options.models);
	             }
	         }
	     },
	     error: function(e) {
	         alert("Status:" + e.status + "; Error message: " + e.errorThrown);
	     },
	     filter: upcGridFilter,
	     sort: [{
	         field: "upcNumber",
	         dir: "asc"
	     }],
	     batch: true,
	     pageSize: 10,
	     serverPaging: true,
	     serverFiltering: true,
	     serverSorting: true,
	     schema: {
	         data: "data",
	         total: "total",
	         model: { id: "id"}
         }
	 });	
	
	
	
	var Product=function(){

	}
	Product.prototype={
			gwUpc:gwUpc,
			wrapUpcGrid:function(){
				gwUpc.wrapGrid();
			},
			upcGridOptions:{
				columns:upcGridColumns,
				selectable:"row",
				resizable:true,
				reorderable:true,

				dataSource:upcGridDataSource,
				
				change:function(e){
				}
			},
			
			retrieveByGarmentId:function(garmentId){
				upcGridFilter[0].value=garmentId;
				upcGridDataSource.filter(upcGridFilter);
			}
	}
	return Product;
}]);




invtApp.controller("inventoryCtrl",["$scope","inventory" ,function($scope,inventory){
	$scope.inventory=inventory;

	$scope.$on("kendoWidgetCreated", function(event, widget){
	// the event is emitted for every widget; if we have multiple
	// widgets in this controller, we need to check that the event
	// is for the one we're interested in.
		if (widget ===$scope.inventoryGarmentGrid) {
			inventory.wrapGarmentGrid();
		}
		if (widget ===$scope.inventoryUpcGrid) {
			inventory.detail.wrapUpcGrid();
		}
	});	
	

}]);
</script>