<script>
'user strict';
var imApp = angular.module("imApp",
		[ "ui.router", "kendo.directives","clivia"]);
		
imApp.directive('garmentProduct',["$http","cliviaDDS","util",function($http,cliviaDDS,util){
	
	var seasonTemplate='<season-dropdownlist  style="width:100px;" c-brand-id="currentSetting.brandId" ng-model="currentSetting.seasonId" />';
	var searchStyle='<span class="k-textbox k-space-right" style="width: 140px;" >'+
		'<input type="text" name="searchStyleNo" class="k-textbox" placeholder="Style#" ng-model="search.styleNo" capitalize ng-trim="true"/>'+
		'<span ng-click="getProduct()" class="k-icon k-i-search"></span>' 
	
	var upcNextItemRefTemplate='Next Item Ref#:<input type="text" name="upcNextItemRef" class="k-textbox" ng-dblclick="setUpcNextItemRefInitialValue()"  ng-model="upcNextItemRef" style="width: 140px;"/>';
	
	var baseUrl="";
	
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@garmentProduct',
				cBrandId:'=',
				},
			templateUrl:'product',
			
			link:function(scope,element,attrs){
				
				scope.clearDataSet=function(){
 					scope.dataSet.info={};
 					scope.dataSet.upcItems.splice(0,scope.dataSet.upcItems.length);
 					scope.dataSet.imageItems.splice(0,scope.dataSet.imageItems.length);
 					scope.dataSet.deleteds=[];
				}	    
			    
			    scope.clear=function(){
			    	scope.clearDataSet();
			    }
			    
	        	scope.setDicts=function(seasonId){
	        		if(!seasonId) return;
	        		
 	 				var item=scope.dictSeason.getLocalItem("id",seasonId);
 	 				
					if(item && item.categories){
     	 				var tempCategory=scope.dataSet.info.category;

						var categories=item.categories.split(";");
						scope.brandCategories.splice(0,scope.brandCategories.length);
						for(var i=0;i<categories.length;i++){
							scope.brandCategories.push(categories[i]);
						}
						
						scope.dataSet.info.category=tempCategory;
					}
					
					if(item && item.sizeFields){
     	 				var tempSizeRange=scope.dataSet.info.sizeRange;
     	 				
						var sizeFields=item.sizeFields.split(',');
						var sizeTypeFields=item.sizeTypeFields.split(';');
						
						scope.brandSizes.splice(0,scope.brandSizes.length);
						for(var i=0,indices;i<sizeTypeFields.length;i++){
							indices=sizeTypeFields[i].split(',');
							for(j=0,s=[];j<indices.length;j++){
								s.push(sizeFields[indices[j]].trim());
							}
							scope.brandSizes.push(s.join(' ,'));
						}
						scope.dataSet.info.sizeRange=tempSizeRange;
					}
	        		
	        	}

			    
				scope.getProduct=function(){
			    	var styleNo=scope.search.styleNo;
			    	scope.search.styleNo="";
			    	if(styleNo)
			    		styleNo=styleNo.trim().toUpperCase();
			    	
			    	if(styleNo){
			    		scope.load(scope.currentSetting.seasonId,styleNo);
			    	}else{
						alert("Please input a Style# to search.");
			    	}
				}

			    scope.load=function(seasonId,styleNo){
					var url=baseUrl+"get-product?seasonId="+seasonId+"&styleNo="+styleNo;
					
					if(seasonId!==scope.currentSetting.seasonId)
						scope.currentSetting.seasonId=seasonId;
					
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
			    	
			    	if(scope.productForm.$dirty)
			    		scope.dataSet.info.isDirty=true;
			    	
			    	var imageItems=scope.dataSet.imageItems;
			    	if(imageItems.length>0){
			    		var imageId=imageItems[0].imageId;
			    		if(scope.dataSet.info.imageId!==imageId){
			    			scope.dataSet.info.imageId=imageId;
			    			scope.dataSet.info.isDirty=true;
			    		}
			    	}
			    		
			    	if(!scope.dataSet.info.id){
			    		scope.dataSet.info.brandId=scope.currentSetting.brandId;
			    		scope.dataSet.info.seasonId=scope.currentSetting.seasonId;
			    	}
			    	
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
					if(data){
						if(data.info)
							scope.dataSet.info=data.info;
						
						if(data.upcItems && data.upcItems.length>0){
							scope.sortUpcItems(data.upcItems);
							for(var i=0,items=data.upcItems;i<items.length;i++){
								scope.dataSet.upcItems.push(items[i]);
							}
						}

						if(data.imageItems && data.imageItems.length>0){
							scope.getImages(data.imageItems);
							for(var i=0,items=data.imageItems;i<items.length;i++){
								scope.dataSet.imageItems.push(items[i]);
							}
						}
						
					}
					
					scope.productForm.$setPristine();
				}
				
			 	var validGarment=function(){
					var isValid=true;
					var errors="";

					if(!!!scope.dataSet.info.styleNo){
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
					    				isDirty:true
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
						    				isDirty:true
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
			 	scope.setUpcNextItemRefInitialValue=function(){
			 		var url="../data/generic/sql?cmd=SELECT max(upcno) FROM garmentupc where left(upcno,6)="+scope.upcPrefix;
			 		util.getRemote(url)
			 			.then(function(lastRef){
			 				if(lastRef && lastRef.length>0){
			 					var n=parseInt(lastRef[0].substring(6,11))+1;
			 					scope.upcNextItemRef=("0000"+n).slice(-5);
			 					scope.producttoolbar.enable("#btnGenUpc",true);
			 				}
			 			})
			 	}
			 	
			 	
			 	
			 	scope.generateUpcNo=function(items,colour){
			 		for(var i=0,upcItemRef,n;i<items.length;i++){
			 			item=items[i];
			 			if(!colour||item.colour===colour)
				 			scope.generateItemUpcNo(item);
			 		}
			 	}
			 	
			 	scope.generateItemUpcNo=function(item){
		 			if(item && item.upcNo){
		 				if(item.upcNo.length===11){
		 					item.upcNo+=scope.ugw.eanCheckDigit(item.upcNo);
		 					item.isDirty=true;
		 				}
		 			}else{
		 				n=parseInt(scope.upcNextItemRef);
		 				upcItemRef=("0000"+n++).slice(-5);
		 				scope.upcNextItemRef=("0000"+n).slice(-5);
		 				
		 				item.upcNo=scope.upcPrefix+upcItemRef;
	 					item.upcNo+=scope.ugw.eanCheckDigit(item.upcNo);
	 					item.isDirty=true;
		 			}
			 		
			 	}
			 	
				scope.getImages=function(dataItems){
					var imageString="";
					for(var i=0;i<dataItems.length;i++){
						if(dataItems[i].imageId){
							imageString+=","+dataItems[i].imageId;
						}
					}
					if(imageString!==""){
						imageString=imageString.substring(1);
						scope.dictImage.getItems("id",imageString)
							.then(function(){
								
							},function(){
								
							});
						
					}
				}

			},
			
			controller: ['$scope',"cliviaDDS","DataDict","UpcGridWrapper", function($scope,cliviaDDS,DataDict,UpcGridWrapper) {
				
				$scope.productToolbarOptions ={
					items:[{
								template:seasonTemplate,		                
							}, {	
								template:searchStyle,		                
							}, {
								type: "separator",
							}, {
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
						        type: "buttonGroup",
	                            buttons: [
	                                 {  text: "UPC", togglable: true, group:"changeView", toggle:changeView, selected: true},
	                                 {  text: "Image", togglable: true, group:"changeView", toggle:changeView}
	                             ]							
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
									var cell=$scope.ugw.getCurrentCell();
									var item=$scope.ugw.getCurrentDataItem();
									var generated=false;
									if(item && cell){
										if(cell.cellIndex==1){
											$scope.generateItemUpcNo(item);
											generated=true;
										}		
										
										if(cell.cellIndex==2 && item.colour){
											$scope.generateUpcNo($scope.dataSet.upcItems,item.colour);
											generated=true;
										}		
									}
									
									if(!generated)
										$scope.generateUpcNo($scope.dataSet.upcItems);
									
									$scope.$apply();
								}
							}],
					 toggle: function(e) {
						 $scope.showUpcView=!(e.target.text()==="Image" && e.checked );
						 $scope.$apply();
					 }
				};
				
				
				$scope.showUpcView=true;
				
				var changeView=function(){
					$scope.producttoolbar;
				}
				
				if($scope.cName)
		        	$scope.$parent[$scope.cName]=$scope;		//expose this scope to parent scope with cName
				
				$scope.upcPrefix="671309";
		        	
				$scope.upcNextItemRef="";
				
				

				$scope.dictSeason=cliviaDDS.getDict("season");

				$scope.dictImage=cliviaDDS.createDict("image","../data/libImage/","onDemand"),
					
          	 	$scope.currentSetting={
          	 			brandId:$scope.cBrandId,
          	 			seasonId:$scope.dictSeason.getCurrentSeasonId($scope.cBrandId),
          	 	}
				
				$scope.dataSet={
						info:{brandId:$scope.cBrandId,seasonId:-1},
						upcItems:new kendo.data.ObservableArray([]),
						imageItems:new kendo.data.ObservableArray([]),
						deleteds:[],
					}
				
          	 	$scope.$watch('dataSet.info.seasonId',function(newValue,oldValue){
     	 			if(newValue!==oldValue && newValue){
     	 				$scope.setDicts(newValue);
     	 			}
         	 			
     	 		});			
          	 	

				
				$scope.search={styleNo:""};

				
				$scope.brandCategories=new kendo.data.ObservableArray([]);
				$scope.brandSizes=new kendo.data.ObservableArray([]);
				
				$scope.ugw=new UpcGridWrapper("productUpcGrid");
         	 	

				$scope.$on("kendoWidgetCreated", function(event, widget){
						if (widget ===$scope.productUpcGrid) {
							$scope.ugw.wrapGrid(widget);
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
         	 	
			    $scope.imageGridDataSource=new kendo.data.DataSource({
			    	    	data:$scope.dataSet.imageItems,
						    schema: {
						        model: {
						            id: "id",
					                fields: {
					                    imageId:{type: "number"}
					                }
						        }
						    },
						    
						    serverFiltering:false,
						    pageSize: 0,
		
				        });					    
					    
         	 	
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
				
				$scope.newImageItemFunction=function(dataItem){
				    return {
					    	imageId:dataItem.id,
					    }
				}
			
				$scope.registerDeletedImageItemFunction=function(dataItem){
					if(dataItem.id){
						var deletedItem={entity:"image",id:dataItem.id};
						scope.dataSet.deleteds.push(deletedItem);
						
					}
				}				
				
				
		}],
	}
	
	return directive;	
}]); //end of garmentProduct





imApp.directive('transactionEntry',["$http","cliviaDDS",function($http,cliviaDDS){
	
	var searchTemplate='<span class="k-textbox k-space-right" style="width: 140px;" >'+
	'<input type="text" name="searchTransNumber" class="k-textbox" placeholder="Search Transaction#" ng-model="searchTransNumber" />'+
	'<span ng-click="getTransaction()" class="k-icon k-i-search"></span>' ;
	
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@transactionEntry',
				cBrandId:'=',
			},
			templateUrl:'transaction',
			link:function(scope,element,attrs){
				var baseUrl="";
				var dictUpcUrl="../data/garmentWithDetail/call/findListIn?param=s:styleNo;s:s;s:";
				
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
					    	brandId:scope.dataSet.info.brandId,
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
				
				if(scope.cName)
		        	scope.$parent[scope.cName]=scope;
				
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

          	 	scope.$watch('dataSet.info.brandId',function(newValue,oldValue){
	     	 			if(scope.garmentEntryGrid && newValue!==oldValue)
	         	 			scope.garmentEntryGrid.create(newValue);
	     	 		});			

				
			}]
	}
	return directive;
}]);	//end of transactionEntry



imApp.factory("InventoryGridWrapper",["GridWrapper",function(GridWrapper){
	var gridColumns=[{
		        name:"lineNumber",
		        title: "#",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 25,
			}, {
				name:"styleNo",
				title:"Style#",
				field:"styleNo",
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
				filterable: { multi:true},
				width:140
			}, {
				name:"season",
				title:"Season",
				field:"season",
				filterable: { multi:true},
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
				title:"RRP-US$",
				field:"rrp",
				width:70,
				format: "{0:c}",
				attributes:{class:"numberColumn"}
			}, {
				name:"wsp",
				title:"WSP-US$",
				field:"wsp",
				width:70,
				format: "{0:c}",
				attributes:{class:"numberColumn"}
			}, {
				name:"rrpCad",
				title:"RRP-CA$",
				field:"rrpCad",
				width:70,
				format: "{0:c}",
				attributes:{class:"numberColumn"}
			}, {
				name:"wspCad",
				title:"WSP-CA$",
				field:"wspCad",
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

imApp.factory("UpcGridWrapper",["GridWrapper",function(GridWrapper){
	
	var thisGW;

	var getColumns=function(){
		var gridColumns=[{
		        name:"lineNumber",
		        title: "#",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 25,
			}, {
		         name: "upcNo",
		         field: "upcNo",
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

imApp.factory("inventory",["InventoryGridWrapper","UpcGridWrapper",function(InventoryGridWrapper,UpcGridWrapper){
	
	var igw=new InventoryGridWrapper("inventoryGarmentGrid");
	var ugw=new UpcGridWrapper("inventoryUpcGrid");
	
	var garmentGridDataSource = new kendo.data.DataSource({
			transport: {
			    read: {
			        url: '../datasource/garmentWithInfoDao/read',
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
		         field: "styleNo",
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
		             url: '../datasource/garmentUpcDao/read',
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
		         field: "upcNo",
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
        field: "brandId",
        operator: "eq",
        value: -1
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
			
		brand:{},
		
		brandId:2,
		
		inventoryGW:igw,
		
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
				loadDetail(inventory.currentItem.garmentId);
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
			 garmentGridFilter[0].value=this.brandId;
			 garmentGridDataSource.filter(garmentGridFilter);
			 loadDetail(-1);	//clear detail
		 }
	};
	return inventory;
}]);


imApp.controller("inventoryCtrl",["$scope","inventory","cliviaDDS",function($scope,inventory,cliviaDDS){
	$scope.inventory=inventory;
	var brandDict=cliviaDDS.getDict("brand");
	brandDict.getItem("id",inventory.brnadId)
		.then(function(brand){
			inventory.brand=brand;
		});
	
	inventory.inventoryGW.doubleClickEvent=function(e) {
    	var di=$scope.inventory.inventoryGW.getCurrentDataItem();
     	if(di){
    		$scope.openProduct(di.seasonId,di.styleNo);
   		}
     }


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
			    		$scope.openProduct(inventory.currentItem.styleNo);
		       		}else{
		       			alert("Please select an item to edit.");	
		       		}
		        }
		    }, {
		        type: "separator",
		    }, {	
		        type: "button",
		        text: "Export To Excel",
		        id: "btnExcel",
		        click: function(e){
		        	$scope.inventory.inventoryGW.grid.saveAsExcel();
		            }
		    }, {
		        type: "separator",
		    },{	
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
		},
		open:function(){
			//$scope.brandInput.readOnly=true;
		},
		close:function(){
			//$scope.brandInput.readOnly=false;
			
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
	
	$scope.$watch("inventory.brandId",function(newValue,oldValue){
		var i=0;
		inventory.brand=$scope.brandInput.dict.getLocalItem("id",inventory.brnadId);
		inventory.load();
	});
	
	$scope.openTransaction=function(){
		$scope.transactionEntry.clear();
		$scope.$apply();
		$scope.transactionEntryWindow.open();
	}
	
	$scope.openProduct=function(seasonId,styleNo){
		if(!!styleNo){
			$scope.garmentProduct.load(seasonId,styleNo);
		}else{
			$scope.garmentProduct.clear();
		}
		$scope.$apply();
		$scope.garmentProductWindow.title($scope.brandInput.getBrandName);
		$scope.garmentProductWindow.open();
	}
	
	
	
}]);
</script>