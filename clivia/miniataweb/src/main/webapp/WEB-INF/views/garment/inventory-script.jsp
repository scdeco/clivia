<script>
'user strict';
var invtApp = angular.module("invtApp",
		[ "ui.router", "kendo.directives","clivia"]);
		

invtApp.directive('transactionEntry',["$http","cliviaDDS",function($http,cliviaDDS){
	
	var searchTemplate='<span class="k-textbox k-space-right" style="width: 140px;" >'+
	'<input type="text" name="searchTransNumber" class="k-textbox" placeholder="Search Transaction#" ng-model="searchTransNumber" />'+
	'<span ng-click="getTransaction()" class="k-icon k-i-search"></span>' ;
	
	
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@transactionEntry',
			},
			templateUrl:'transaction',
			link:function(scope,element,attrs){
				var baseUrl="";
				var dictUpcUrl="../data/garmentWithDetail/call/findListIn?param=s:styleNumber;s:s;s:";
				
          	 	scope.$watch('dataSet.info.brand',function(newValue,oldValue){
         	 		if(scope.garmentEntryGrid && newValue!==oldValue)
	         	 		scope.garmentEntryGrid.create(newValue);
         	 	});			
				
				scope.dds=cliviaDDS;
				scope.transToolbarOptions = {
					items: [{
							 template: '<label> <span ng-show="!!dataSet.info.transNumber"> Transaction#:</span> <span style="font-weight: bold;">{{dataSet.info.transNumber}}</span> </label>'
							},{ 
								 type: "separator" 
							},{
								type: "button",
								text: "New",
								id:"btnNew",
								click: function(e) {
									scope.clear();
									scope.$apply();
								}
							}, {
								type: "separator",
							}, {	
								type: "button",
								text: "save",
								id: "btnSave",
								click: function(e){
									scope.save();
								}
							}, {
								type: "separator",
							}, {	
								template:searchTemplate,		                
							}, {
								type: "button",
								text: "Print",
								id:"btnPrint"
					}]};		
				
				
				var populate=function(data,action){
					scope.dataSet.info=data.info;
					if(action==="LOAD"){
						scope.dataSet.items=data.items;
						scope.garmentEntryGrid.gridWrapper.parseToLineItems(data.items);
					}
				}
				
			 	scope.garmentEntryGridDataSource=new kendo.data.DataSource({
			     	data:scope.lineItems, 
				    schema: {
				    	model: { id: "id" }
				    },	//end of schema
				    
				    serverFiltering:false,
				    pageSize: 0,			//paging in pager

			    }); //end of dataSource,

				scope.newItemFunction=function(){
				    return {
					    	brand:scope.dataSet.info.brand,
					    };
				}
			    

			    scope.getTransaction=function(){
			    	var transNumber=scope.searchTransNumber;
			    	scope.searchTransNumber="";
			    	if(transNumber)
			    		transNumber=transNumber.trim();
			    	
			    	if(transNumber){
			    		scope.load(transNumber);
			    	}else{
						alert("Please input a Transaction# to search.");
			    	}
			    }
			    
			    scope.load=function(transNumber){
					var url=baseUrl+"get-transaction?number="+transNumber;
					
					$http.get(url).
						success(function(data, status, headers, config) {
					    	populate(data,"LOAD");
						}).
						error(function(data, status, headers, config) {
							scope.clear();
						});
							
			    }
			    
			    
			    
			    scope.save=function(){
					var url=baseUrl+"save-transaction";
					
					scope.garmentEntryGrid.gridWrapper.parseFromLineItems()
						.then(function(items){
							scope.dataSet.items=items;
							$http.post(url, scope.dataSet).
								success(function(data, status, headers, config) {
						    		populate(data,"SAVE");
								}).
								error(function(data, status, headers, config) {
								});
						},function(error){
							
						});
					
					
							
			    }
			    
			    scope.remove=function(){
					var url=baseUrl+"delete-transaction";
					var deferred = $q.defer();
					
					$http.post(url, dataSet.info.transactionNumber).
						success(function(data, status, headers, config) {
						    scope.clear();
							deferred.resolve(data);
						}).
						error(function(data, status, headers, config) {
							deferred.reject(data);
						});
							
					return deferred.promise;
			    }
			    
 			    scope.$on("kendoWidgetCreated", function(event, widget){
			        if (widget ===scope.garmentEntryGrid) {
			        	if(scope.cName)
				        	scope.$parent[scope.cName]=scope;
			        }
			    });			
			},
			
			controller:['$scope',"cliviaDDS","DataDict", function($scope,cliviaDDS,DataDict) {
				var scope=$scope;
				
				scope.dictGarment=cliviaDDS.getDict("garment");
				scope.dictUpc=new DataDict("garemnt-upc","","lazy");
				
				scope.dataSet={
						info:{},
						items:[],
						deleteds:[],
				}
				
				scope.lineItems=new kendo.data.ObservableArray([]);

				scope.clearDataSet=function(){
 					scope.dataSet.info={
							transId:0,
							isIn:1,
							type:0,
							batchNumber:'',
							description:'',
							brand:'DD',
							transDate:kendo.toString(kendo.parseDate(new Date()), 'yyyy-MM-dd')
					};
					
/* 					var info=scope.dataSet.info;
					info.id=null;
					info.transId=0;
					info.transNumber='';
					info.isIn=1;
					info.type=0;
					info.batchNumber='';
					info.description='';
					info.brand='DD';
					info.transDate='2015-12-10';
					info.packaging='p';
					info.location='L';
 */					
 					scope.dataSet.items.splice(0,scope.dataSet.items.length);
					scope.dataSet.deleteds.splice(0,scope.dataSet.deleteds.length);
					scope.lineItems.splice(0,scope.lineItems.length);
					
				}
				
			    scope.clear=function(){
			    	scope.searchTransNumber="";
			    	scope.clearDataSet();
			    }
				
         	 	scope.clear();
			}]
	}
	return directive;
}]);	


invtApp.factory("inventory",["GridWrapper","Product","cliviaDDS",function(GridWrapper,Product,cliviaDDS){
	
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
		
		wrapGarmentGrid:function(grid){
			gwGarment.wrapGrid(grid);
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
			wrapUpcGrid:function(grid){
				gwUpc.wrapGrid(grid);
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
			inventory.wrapGarmentGrid(widget);
		}
		if (widget ===$scope.inventoryUpcGrid) {
			inventory.detail.wrapUpcGrid(widget);
		}
		
	});	
	
	$scope.newTransaction=function(){
		$scope.transactionEntry.open();
	}
	
	
	

}]);
</script>