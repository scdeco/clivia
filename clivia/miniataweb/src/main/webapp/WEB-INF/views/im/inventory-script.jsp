<script>
'user strict';
var invtApp = angular.module("invtApp",
		[ "ui.router", "kendo.directives","clivia"]);
		
invtApp.directive('garmentProduct',["$http","cliviaDDS","util",function($http,cliviaDDS,util){
	
	var searchTemplate='<span class="k-textbox k-space-right" style="width: 140px;" >'+
	'<input type="text" name="searchStyleNumber" class="k-textbox" placeholder="Search Style#" ng-model="searchStyleNumber" capitalize ng-trim="true"/>'+
	'<span ng-click="getProduct()" class="k-icon k-i-search"></span>' ;
	
	var upcNextItemRefTemplate='Next Item Ref#:<input type="text" name="upcNextItemRef" class="k-textbox"  ng-model="upcNextItemRef" style="width: 140px;"/>';
	
	var baseUrl="";

	
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@garmentProduct',
				cBrand:'=',
				},
			templateUrl:'product',
			
			link:function(scope,element,attrs){
				
				scope.clearDataSet=function(){
 					scope.dataSet.info={
							brand:scope.cBrand,
					};
 					scope.dataSet.upcItems.splice(0,scope.dataSet.upcItems.length);
 					scope.dataSet.deletedUpcItems.splice(0,scope.dataSet.deletedUpcItems.length);
				}			    
			    
			    scope.clear=function(){
			    	scope.searchTransNumber="";
			    	scope.clearDataSet();
			    }
			    

				scope.getProduct=function(){
			    	var styleNumber=scope.searchStyleNumber;
			    	scope.searchStyleNumber="";
			    	if(styleNumber)
			    		styleNumber=styleNumber.trim().toUpperCase();
			    	
			    	if(styleNumber){
			    		scope.load(styleNumber);
			    	}else{
						alert("Please input a Style# to search.");
			    	}
				}

			    scope.load=function(styleNumber){
					var url=baseUrl+"get-product?styleNumber="+styleNumber;
					scope.clear();

					$http.get(url).
						success(function(data, status, headers, config) {
					    	populate(data);
						}).
						error(function(data, status, headers, config) {
						});
			    }

			    scope.save=function(){
			    	if(!validGarment()) return;
			    	
					var url=baseUrl+"save-product";
					
					$http.post(url,scope.dataSet).
						  success(function(data, status, headers, config) {
							  populate(data)
						  }).
						  error(function(data, status, headers, config) {
							  alert( "failure message: " + JSON.stringify({data: data}));
						  });		
			    }
			    
			    scope.remove=function(){
			    	
			    }
			    
				var populate=function(data){
					scope.clearDataSet();
					scope.dataSet.info=data.info;
					
					if(data.upcItems && data.upcItems.length>0)
						scope.sortUpcItems(data.upcItems);
					
					for(var i=0,items=data.upcItems;i<items.length;i++){
						scope.dataSet.upcItems.push(items[i]);
					}
					
				}
				
			 	var validGarment=function(){
					var isValid=true;
					var errors="";

					if(!!!scope.dataSet.info.styleNumber){
						errors+="Style# can not be empty.";
					}
					if(!!!scope.dataSet.info.styleName){
						errors+="Style name can not be empty.";
					}
					if (errors!=""){
						alert(errors);
						isValid=false;
					}
					
					return isValid;
				}
			 	
			 	scope.sortUpcItems=function(upcItems){
				    var colours=util.split(scope.dataSet.info.colourway);
			    	var sizes=util.split(scope.dataSet.info.sizeRange);
			 		
			 		upcItems.sort(function(a,b){
			 			var cia=colours.indexOf(a.colour);
			 			var cib=colours.indexOf(b.colour);
			 			if(cia===cib){
			 				var sia=sizes.indexOf(a.size);
			 				var sib=sizes.indexOf(b.size);
			 				return sia-sib;
			 			}else{
			 				return cia-cib;
			 			}
			 		});
			 	}
			 	
			 	scope.generateUpcItems=function(){
				    var colours=util.split(scope.dataSet.info.colourway);
			    	var sizes=util.split(scope.dataSet.info.sizeRange);
			    	var oldItems=scope.dataSet.upcItems;
			    	var newItems=[];
			    	
			    	
			    	for(var i=0,colour,ci,oldSizes;i<colours.length;i++){
			    		colour=colours[i];
			    		ci=util.findIndex(oldItems,"colour",colour);
			    		if(ci<0){	//not found this colour, add all sizes
				    		for(var j=0,size,item;j<sizes.length;j++){
				    			size=sizes[j];
				    			item={
					    				colour:colour,
					    				size:size,
					    			};
				    			newItems.push(item);
				    		}
			    		}else{
			    			oldSizes=","
			    			while(ci<oldItems.length && oldItems[ci].colour===colour){
			    				oldSizes+=oldItems[ci++].size+",";
			    			}
				    		for(var j=0,size,item;j<sizes.length;j++){
				    			size=sizes[j];
				    			if(oldSizes.indexOf(","+size+",")<0){
					    			item={
						    				colour:colour,
						    				size:size,
						    			};
					    			newItems.push(item);
				    			}
				    		}

			    		}
			    	}
			    	
			    	
			    	//append new added items to old items
			    	if(newItems.length>0){
			    		
			    		//join arrays, concat() can not be used here since oldItems is kendo.data.ObservableArray  
			    		var items=[];		
			    		Array.prototype.push.apply(items,oldItems);
			    		Array.prototype.push.apply(items,newItems);
			    		scope.sortUpcItems(items);

			    		oldItems.splice(0,oldItems.length)
			    		
			    		for(var i=0;i<items.length;i++)
			    			oldItems.push(items[i]);
			    	}
			    	
			 	}
			 	
			 	scope.generateUpcNumber=function(items){
			 		for(var i=0,upcItemRef,n;i<items.length;i++){
			 			item=items[i]
			 			if(item && item.upcNumber){
			 				if(item.upcNumber.length===11){
			 					item.upcNumber+=scope.ugw.eanCheckDigit(item.upcNumber);
			 				}
			 			}else{
			 				n=parseInt(scope.upcNextItemRef);
			 				upcItemRef=("0000"+n++).slice(-5);
			 				scope.upcNextItemRef=("0000"+n).slice(-5);
			 				
			 				item.upcNumber=scope.upcPrefix+upcItemRef;
		 					item.upcNumber+=scope.ugw.eanCheckDigit(item.upcNumber);
			 			}
			 			
			 		}
			 		scope.$apply();
			 	}

			},
			
			controller: ['$scope',"cliviaDDS","DataDict","UpcGridWrapper", function($scope,cliviaDDS,DataDict,UpcGridWrapper) {
				
				$scope.productToolbarOptions ={items:[{
							type: "button",
							text: "New",
							id:"btnNew",
							click: function(e) {
								$scope.clear();
								$scope.$apply();
							}
						}, {
							type: "separator",
						}, {	
							type: "button",
							text: "Save",
							id: "btnSave",
							click: function(e){
								$scope.save();
							}
						}, {
							type: "separator",
						}, {	
							template:searchTemplate,		                
						}, {
							type: "button",
							text: "Print",
							id:"btnPrint"
						}, {
							type: "separator",
						}, {	
							type: "button",
							text: "Generate Items",
							id: "btnGenItem",
							click: function(e){
								$scope.generateUpcItems();
							}
						}, {
							type: "separator",
						}, {	
							template:upcNextItemRefTemplate,		                
						}, {	
							type: "button",
							text: "Generate UPC#",
							id: "btnGenUpc",
							click: function(e){
								$scope.generateUpcNumber($scope.dataSet.upcItems);
							}
						}]};
				
				
				$scope.upcPrefix="671309";
				$scope.upcNextItemRef="02087";
				
				$scope.dataSet={
							info:{brand:$scope.cBrand},
							upcItems:new kendo.data.ObservableArray([]),
							deletedUpcItems:[],
						}
				

				$scope.dictGarmentBrand=cliviaDDS.getDict("garmentBrand");
				
				$scope.brandCategories=new kendo.data.ObservableArray([]);
				$scope.brandSizes=new kendo.data.ObservableArray([]);
				
				$scope.ugw=new UpcGridWrapper("productUpcGrid");
         	 	
	        	$scope.$parent[$scope.cName]=$scope;		//expose this scope to parent scope with cName

				$scope.$on("kendoWidgetCreated", function(event, widget){
						if (widget ===$scope.productUpcGrid) {
							$scope.ugw.wrapGrid(widget);
						}
					});	
	        	
          	 	$scope.$watch('cBrand',function(newValue,oldValue){
     	 			if(newValue){
     					$scope.dictGarmentBrand.getItem("name",newValue)
     						.then(function(item){
     							if(item && item.categories){
     								var categories=item.categories.split(";");
    								$scope.brandCategories.splice(0,$scope.brandCategories.length);
     								for(var i=0;i<categories.length;i++){
     									$scope.brandCategories.push(categories[i]);
     								}
     								
     								var sizeFields=item.sizeFields.split(',');
     								var sizeTypeFields=item.sizeTypeFields.split(';');
     								
     								$scope.brandSizes.splice(0,$scope.brandSizes.length);
     								for(var i=0,indices;i<sizeTypeFields.length;i++){
     									indices=sizeTypeFields[i].split(',');
     									for(j=0,s=[];j<indices.length;j++){
     										s.push(sizeFields[indices[j]].trim());
     									}
     									$scope.brandSizes.push(s.join(' ,'));
     								}
     							}
     						})
     	 			}
         	 			
     	 		});			
	        	$scope.categoryOptions={
	        				dataSource: $scope.brandCategories
	        			};
			
	        	$scope.sizeRangeOptions={
        					dataSource: $scope.brandSizes
        				};

	        	$scope.quantityOptions={
							format:"{0:##,#}",
							decimals:0,
						};
				
				$scope.priceOptions={
							min:"0",
							upArrowText:"Increment",
							downArrowText:"Decrement"
						};
				
			 	$scope.upcGridDataSource=new kendo.data.DataSource({
					     	data:$scope.dataSet.upcItems,
						    schema: {
						    	model: { id: "id" }
						    },	//end of schema
						    
						    serverFiltering:false,
						    pageSize: 0,			//paging in pager
		
					    }); //end of dataSource,
         	 	
         	 	
				$scope.productUpcGridOptions={
							autoSync: true,
							
							columns:$scope.ugw.gridColumns,
							dataSource:$scope.upcGridDataSource,
							
					        editable: true,
					        selectable: "cell",
					        navigatable: true,
					        resizable: true,
						};
					    
				$scope.mainSplitterOptions={
						resize:function(e){
							var panes=e.sender.element.children(".k-pane"),
							upcGridHeight=$(panes[1]).innerHeight()-37;
							
		 			      	window.setTimeout(function () {
					            $scope.ugw.resizeGrid(upcGridHeight);
					      	},1); 
						}
				}
				
				
			}],
	}
	
	return directive;	
}]); //end of garmentProduct





invtApp.directive('transactionEntry',["$http","cliviaDDS",function($http,cliviaDDS){
	
	var searchTemplate='<span class="k-textbox k-space-right" style="width: 140px;" >'+
	'<input type="text" name="searchTransNumber" class="k-textbox" placeholder="Search Transaction#" ng-model="searchTransNumber" />'+
	'<span ng-click="getTransaction()" class="k-icon k-i-search"></span>' ;
	
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@transactionEntry',
				cBrand:'=',
			},
			templateUrl:'transaction',
			link:function(scope,element,attrs){
				var baseUrl="";
				var dictUpcUrl="../data/garmentWithDetail/call/findListIn?param=s:styleNumber;s:s;s:";
				
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
					
					scope.clear();

					$http.get(url).
						success(function(data, status, headers, config) {
							if(data){
						    	populate(data,"LOAD");
							}else{
								alert("Can not find this transaction("+transNumber+")."); 
							}
						}).
						error(function(data, status, headers, config) {
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

			    
				scope.clearDataSet=function(){
 					scope.dataSet.info={
 							transNumber:'',
							transId:0,
							isIn:true,
							type:0,
							batchNumber:'',
							description:'',
							brand:scope.cBrand,
							transDate:kendo.toString(kendo.parseDate(new Date()), 'yyyy-MM-dd')
					};
 					scope.dataSet.items.splice(0,scope.dataSet.items.length);
					scope.lineItems.splice(0,scope.lineItems.length);
					
				}			    
			    
			    scope.clear=function(){
			    	scope.searchTransNumber="";
			    	scope.clearDataSet();
			    }

				scope.dataSet={
						info:{},
						items:[],
				}
			    
         	 	scope.clear();
			},
			
			controller:['$scope',"cliviaDDS","DataDict", function($scope,cliviaDDS,DataDict) {
				var scope=$scope;
				
				scope.transToolbarOptions = {items:[{
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
				
				scope.dictGarment=cliviaDDS.getDict("garment");
				scope.dictUpc=new DataDict("garemnt-upc","","lazy");
				
				scope.lineItems=new kendo.data.ObservableArray([]);

          	 	scope.$watch('dataSet.info.brand',function(newValue,oldValue){
	     	 			if(scope.garmentEntryGrid && newValue!==oldValue)
	         	 			scope.garmentEntryGrid.create(newValue);
	     	 		});			

          	 	scope.$on("kendoWidgetCreated", function(event, widget){
			        if (scope.garmentEntryGrid && widget ===scope.garmentEntryGrid.grid) {
			        	if(scope.cName)
				        	scope.$parent[scope.cName]=scope;
			        }
			    });			
				
			}]
	}
	return directive;
}]);	//end of transactionEntry



invtApp.factory("InventoryGridWrapper",["GridWrapper",function(GridWrapper){
	var gridColumns=[{
		        name:"lineNumber",
		        title: "#",
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
				name:"season",
				title:"Seasons",
				field:"season",
				width:90
			}, {
				name:"qoh",
				title:"QOH",
				field:"qoh",
				width:80,
				attributes:{class:"numberColumn"},				
				format: "{0:##,#}",
			}, {
				name:"sq",
				title:"SQ",
				field:"sq",
				width:80,
				attributes:{class:"numberColumn"},				
				format: "{0:##,#}",
			}, {
				name:"pq",
				title:"PQ",
				field:"pq",
				width:80,
				attributes:{class:"numberColumn"},				
				format: "{0:##,#}",
			}, {
				name:"rrp",
				title:"RRP",
				field:"rrp",
				width:70,
				format: "{0:c}",
				attributes:{class:"numberColumn"}
			}, {
				name:"wsp",
				title:"WSP",
				field:"wsp",
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
	
	var thisGW;
	
	var InventoryGridWrapper=function(gridName){
		GridWrapper.call(this,gridName);
	 	this.setColumns(gridColumns)
		thisGW=this;
	}
	 
	InventoryGridWrapper.prototype=new GridWrapper();	//implement inheritance
	
	return InventoryGridWrapper;
	
}]);

invtApp.factory("UpcGridWrapper",["GridWrapper",function(GridWrapper){
	
	var thisGW;

	var getColumns=function(){
		var gridColumns=[{
		        name:"lineNumber",
		        title: "#",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 25,
			}, {
		         name: "upcNumber",
		         field: "upcNumber",
		         title: "UPC",
		         width: 140
		     }, {
		         name: "colour",
		         field: "colour",
		         title: "Colour",
		         width: 160,
		         editor: thisGW.readOnlyColumnEditor,
		         attributes:{style:"text-align:center;"},		
		     }, {
		         name: "size",
		         field: "size",
		         title: "Size",
		         width: 80,
		         editor: thisGW.readOnlyColumnEditor,
		         attributes:{style:"text-align:center;"},		

		     }, {
		         name: "qoh",
		         field: "qoh",
		         title: "QOH",
		         editor: thisGW.numberColumnEditor,
		         width: 80,
		         attributes:{style:"text-align:right;"},		
				 format: "{0:##,#}",
		     }, {
		         name: "sq",
		         field: "sq",
		         title: "SQ",
		         editor: thisGW.numberColumnEditor,
		         width: 80,
		         attributes:{style:"text-align:right;"},			
				 format: "{0:##,#}",
		     }, {
		         name: "pq",
		         field: "pq",
		         title: "PQ",
		         editor: thisGW.numberColumnEditor,
		         width: 80,
		         attributes:{style:"text-align:right;"},		
				 format: "{0:##,#}",
		     }, {
		    	 name:"remark",
		         field: "remark",
		         title: "Remark",
		}];
		return gridColumns;
	}
	
	var UpcGridWrapper=function(gridName){
	
			GridWrapper.call(this,gridName);
			thisGW=this;
		 	this.setColumns(getColumns());
		}
		 
	UpcGridWrapper.prototype=new GridWrapper();	//implement inheritance
	
	var reverseString=function(s)
		{
			splitext = s.split("");
			revertext = splitext.reverse();
			reversed = revertext.join("");
			return reversed;
		}

		// function to calculate EAN / UPC checkdigit
	UpcGridWrapper.prototype.eanCheckDigit=function(s){
			var result = 0;
			var rs = reverseString(s);
			for (counter = 0; counter < rs.length; counter++){
				result = result + parseInt(rs.charAt(counter)) * Math.pow(3, ((counter+1) % 2));
			}
			return (10 - (result % 10)) % 10;
		}	
	
	return UpcGridWrapper;
}]);

invtApp.factory("inventory",["InventoryGridWrapper","UpcGridWrapper",function(InventoryGridWrapper,UpcGridWrapper){
	
	var igw=new InventoryGridWrapper("inventoryGarmentGrid");
	var ugw=new UpcGridWrapper("inventoryUpcGrid");
	
	var garmentGridDataSource = new kendo.data.DataSource({
			transport: {
			    read: {
			        url: 'http://' + window.location.host + '/miniataweb/datasource/garmentInfoDao/read',
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
			pageSize: 15,
			serverPaging: true,
			serverFiltering: true,
			serverSorting: true,
 	     	filter: garmentGridFilter,

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

	var upcGridDataSource = new kendo.data.DataSource({
		     transport: {
		         read: {
		             url: 'http://' + window.location.host + '/miniataweb/datasource/garmentUpcDao/read',
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
		     filter: upcGridFilter,
		     sort: [{
		         field: "upcNumber",
		         dir: "asc"
		     }],
//		     pageSize: 10,
		     serverPaging: true,
		     serverFiltering: true,
		     serverSorting: true,
		     schema: {
		         data: "data",
		         total: "total",
		         model: { id: "id"}
	        }
		 });
	
	var garmentGridFilter=[{
        field: "brand",
        operator: "eq",
        value: "-"
    }];
	
	var upcGridFilter=[{
        field: "garmentId",
        operator: "eq",
        value: -1
    }];

	var loadDetail=function(garmentId){
			upcGridFilter[0].value=garmentId;
			upcGridDataSource.filter(upcGridFilter);
		}
	
	var inventory={
			
		brand:'',
		
		currentItem:{},
		
		wrapGarmentGrid:function(grid){
				igw.wrapGrid(grid);
			},
		wrapUpcGrid:function(grid){
				ugw.wrapGrid(grid);
			},
		
		garmentGridOptions:{
			dataSource:garmentGridDataSource,
			columns:igw.gridColumns,
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
				inventory.currentItem=this.dataItem(this.select());
				loadDetail(inventory.currentItem.id);
		    },
		    
		},
		
		upcGridOptions:{
			dataSource:upcGridDataSource,
			columns:ugw.gridColumns,
			selectable:"row",
			resizable:true,
			reorderable:true,
			filterable:false,
		},
		
		 splitterOptions:{
				orientation:"vertical",
				resize:function(e){

					var panes=e.sender.element.children(".k-pane"),
						garmentGridHeight=$(panes[1]).innerHeight()-37,
						upcGridHeight=$(panes[2]).innerHeight()-37;
						
 			      	window.setTimeout(function () {
			            igw.resizeGrid(garmentGridHeight);
			           // gwUpc.resizeGrid(upcGridHeight);
			      	},1); 
			 }
		 },
		 
		 load:function(){
			 this.currentItem={};
			 garmentGridFilter[0].value=this.brand;
			 garmentGridDataSource.filter(garmentGridFilter);
			 loadDetail(-1);	//clear detail
		 }
	};
	return inventory;
}]);


invtApp.controller("inventoryCtrl",["$scope","inventory" ,function($scope,inventory){
	$scope.inventory=inventory;
	$scope.inventoryToolbarOptions={items: [{
		        type: "button",
		        text: "New",
		        id:"btnNew",
		        click: function(e) {
		    		$scope.openProduct();
		       		 }
		    }, {
		        type: "button",
		        text: "Edit",
		        id:"btnEdit",
		        click: function(e) {
		        	if(inventory.currentItem){
			    		$scope.openProduct(inventory.currentItem.styleNumber);
		       		}else{
		       			alert("Please select an item to edit.");	
		       		}
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
		        type: "separator",
		    }, {
		        type: "button",
		        text: "Print",
		        id:"btnPrint"
		    }, {
		        type: "separator",
		    }, {	
		        type: "button",
		        text: "Transaction",
		        id: "btnTransaction",
		        click: function(e){
		        	$scope.openTransaction();
		            }
		    
		}]};
	
	/*
	 * 	If Splitter is initialized in an invisible Kendo UI Window, Javascript size calculations 
	 *  will not work and the Splitter cannot adjust its layut properly.
	 *	Please use kendo.resize() or the Splitter's resize() method in the Window's activate event.
	 */
 	$scope.garmentProductWindowOptions={
		activate:function(){
			$scope.garmentProduct.mainSplitter.resize();
		}
	}

	$scope.$on("kendoWidgetCreated", function(event, widget){
	// the event is emitted for every widget; if we have multiple
	// widgets in this controller, we need to check that the event
	// is for the one we're interested in.
		if (widget ===$scope.inventoryGarmentGrid) {
			inventory.wrapGarmentGrid(widget);
		}
		if (widget ===$scope.inventoryUpcGrid) {
			inventory.wrapUpcGrid(widget);
		}
	});	
	
	$scope.$watch("inventory.brand",function(){
		inventory.load();
	});
	
	$scope.openTransaction=function(){
		$scope.transactionEntry.clear();
		$scope.$apply();
		$scope.transactionEntryWindow.open();
	}
	
	$scope.openProduct=function(styleNumber){
		if(!!styleNumber){
			$scope.garmentProduct.load(inventory.currentItem.styleNumber);
		}else{
			$scope.garmentProduct.clear();
		}
		$scope.$apply();
		$scope.garmentProductWindow.open();
	}
	
	
	
}]);
</script>