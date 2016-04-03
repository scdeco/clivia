<script>
'user strict';
var gdApp = angular.module("gdApp",
		[ "kendo.directives","clivia"]);
		
gdApp.directive("grid",["$http","cliviaDDS","util",function($http,cliviaDDS,util){
	
	var searchTemplate='<span class="k-textbox k-space-right" style="width: 140px;" >'+
	'<input type="text" name="searchGridNo" class="k-textbox" placeholder="Grid#" ng-model="search.gridNo" capitalize ng-trim="true"/>'+
	'<span ng-click="getGrid()" class="k-icon k-i-search"></span>' 

	var baseUrl="";	

	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@grid',
				},
			templateUrl:'grid',
			
			link:function(scope){

				scope.clearDataSet=function(){
 					scope.dataSet.info={
 						};

 					scope.dataSet.columnItems.splice(0,scope.dataSet.columnItems.length);

 					scope.dataSet.deleteds=[];
				}			    
			    
			    scope.clear=function(){
			    	scope.search.gridNo="";
			    	scope.clearDataSet();
			    }
			    

				scope.getGrid=function(){
			    	var gridNo=scope.search.gridNo;
			    	scope.search.gridNo="";
			    	if(gridNo){
			    		scope.load(gridNo);
			    	}else{
						alert("Please input a grid to search.");
			    	}
				}

			    scope.load=function(gridNo){
					var url=baseUrl+"get-grid?gridNo="+gridNo;
					scope.clear();

					$http.get(url).
						success(function(data, status, headers, config) {
					    	populate(data);
						}).
						error(function(data, status, headers, config) {
						});
			    }

			    scope.save=function(){
			    	if(!validGrid()) return;
					var url=baseUrl+"save-grid";
					
					if(scope.gridForm.$dirty)
						scope.dataSet.info.isDirty=true;

					
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
					
					var columnItems=scope.dataSet.columnItems;
					for(var j=0;j<data.columnItems.length;j++){
						columnItems.push(data.columnItems[j]);
					}
					
					scope.gridForm.$setPristine();
				}
				
			 	var validGrid=function(){
					var isValid=true;
					var errors="";

					if(!!!scope.dataSet.info.gridNo){
						errors+="Style# can not be empty.";
					}
					if (errors!=""){
						alert(errors);
						isValid=false;
					}
					
					return isValid;
				}
			 	
			 	scope.getFieldList=function(){
			 		var daoName=scope.dataSet.info.daoName;
			 		if(daoName){
			 			var url="../data/"+daoName+"/getfieldlist";
			 			util.getRemote(url).then(
			 				function(data){
			 					if(data){
			 						scope.fields=[];
			 						for(var i=0;i<data.length;i++){
			 							scope.fields.push(data[i].name);
			 						}
			 						
			 						scope.selectedFields=[];
			 						for(var i=0,col;i<scope.dataSet.columnItems.length;i++){
			 							col=scope.dataSet.columnItems[i];
			 							if(col.name)
			 								scope.selectedFields.push(col.name);
			 						}
			 						if(scope.fields.length>0){
			 							scope.selectFieldWindow.open();
			 						}
			 							
			 						
			 					}
			 				});
			 			}
			 	}
			 	
			 	scope.preview=function(){
			 		scope.queryGridScope.createGrid();
					scope.previewWindow.open();
			 	}
			 	
			 	scope.clear();
			},
			
			controller:["$scope","cliviaDDS","DataDict",
			            function($scope,cliviaDDS,DataDict){
				var scope=$scope;
				
				scope.$parent[scope.cName]=scope;

				scope.search={gridNo:""};

				scope.gridToolbarOptions ={items:[{
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
							text: "Save",
							id: "btnSave",
							click: function(){
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
						}, {
							type: "separator",
						}, {
							type:"button",
							text:"Get Field List",
							id:"btnGetFieldList",
							click:function(){
								scope.getFieldList();
							}
						}, {
							type:"button",
							text:"Preview",
							id:"btnPreview",
							click:function(){
								scope.preview();
							}
					}]};
				
				scope.dataSet={
						info:{},
						columnItems:new kendo.data.ObservableArray([]), 
						deleteds:[]
					};
				
				
				 scope.columnGridDataSource=new kendo.data.DataSource({
				     	data:scope.dataSet.columnItems,
					    schema: {
					    	model: { id: "id", 
					    		fields:{
					    			width:{type:"number"}
					    		}}
					    },	//end of schema
					    
					    serverFiltering:false,
					    pageSize: 0,			//paging in pager

				    }); //end of dataSource,
				    

				$scope.mainSplitterOptions={
						resize:function(e){
/*							var panes=e.sender.element.children(".k-pane"),
 							upcGridHeight=$(panes[1]).innerHeight()-37;
							
		 			      	window.setTimeout(function () {
					            $scope.ugw.resizeGrid(upcGridHeight);
					      	},1); 
 */						}
				}
				
				$scope.pageSizeOptions={
				    		min:0,
				    		decimals:0,
				    		format:"#"
				    }
				
				$scope.newItemFunction=function(){
				    return {};
				}

				$scope.registerDeletedItemFunction=function(dataItem){
					var item= {entity:"column",dataItem:id};
					$scope.dataSet.deleteds.push(item);
				}				
			}]};
	
	return directive;
	
	
}]);//end of directive grid 


gdApp.factory("GridGridWrapper",["GridWrapper",function(GridWrapper){
	var thisGW;
	var getColumns=function(){
		
	var gridColumns=[{
		        name:"lineNumber",
		        title: "#",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 40,
			}, {
		        name: "gridNo",
		        field: "gridNo",
		        title: "Grid#",
		        width: 120
			}, {
		         name: "name",
		         field: "name",
		         title: "Name",
		         width: 120
		     }, {
		         name: "dataUrl",
		         field: "dataUrl",
		         title: "Data Url",
		         width: 150,
		     }, {
		         name: "sortDescriptor",
		         field: "sortDescriptor",
		         title: "Sort Descriptor",
		         width: 90,
		     }, {
		         name: "baseFilter",
		         field: "baseFilter",
		         title: "Base Filter",
		         width: 90,
		     }, {
		         name: "pageSize",
		         field: "pageSize",
		         title: "Page Size",
		         width: 60,
		     }, {
		    	 name:"remark",
		         field: "remark",
		         title: "Remark",
		}];
		return gridColumns;
	}
	
	var gw=function(gridName){
		
		GridWrapper.call(this,gridName);
		thisGW=this;
	 	this.setColumns(getColumns());
	}
	
	gw.prototype=new GridWrapper();	//implement inheritance
	
	return gw;
}]); //end of GridWrapper


gdApp.controller("gdCtrl",["$scope","GridGridWrapper",function($scope,GridGridWrapper){
	
	$scope.gdToolbarOptions={items: [{
			        type: "button",
			        text: "New",
			        id:"btnNew",
			        click: function(e) {
			    		$scope.openGrid();
			       		 }
			    }, {
			        type: "button",
			        text: "Edit",
			        id:"btnEdit",
			        click: function(e) {
			        	var di=$scope.cgw.getCurrentDataItem();
 			        	if(di){
				    		$scope.openGrid(di.id);
			       		}else{
			       			alert("Please select a grid to edit.");	
			       		}			        	

 			        }
			    }, {
			        type: "separator",
			    }, {	
			        type: "button",
			        text: "Print",
			        id: "btnPrint",
			        click: function(e){
			            }
			    }, {
			        type: "separator",
			    }, {
			        type: "button",
			        text: "Export To Excel",
			        id: "btnExcel",
			        click: function(e){
			        	$scope.cgw.grid.saveAsExcel();
			            }
	}]};

	$scope.gw=new GridGridWrapper("gdGridGrid");
	
	$scope.$on("kendoWidgetCreated", function(event, widget){
		if (widget ===$scope.gdGridGrid) {
				$scope.gw.wrapGrid(widget);
		}
		
	});		
	
	$scope.gw.doubleClickEvent=function(e) {
    	var di=$scope.gw.getCurrentDataItem();
     	if(di){
    		$scope.openGrid(di.gridNo);
   		}else{
   			alert("Please select a grid to edit.");	
   		}
     }
	
	$scope.gdGridGridDataSource={
				transport: {
				    read: {
				        url: '../datasource/gridInfoDao/read',
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
			  //  filter: gdGridFilter,
				sort: [{
			         field: "gridNo",
			         dir: "asc"
			     }], 
				schema: {
				    data: "data",
				    total: "total",
				    model: {id: "id"}
				},
			};
	
	$scope.gdGridGridOptions={
				dataSource:$scope.gdGridGridDataSource,
				columns:$scope.gw.gridColumns,
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
/* 					inventory.currentItem=this.dataItem(this.select());
					loadDetail(inventory.currentItem.id);
 */			    },
			    
			};
	/*
	 * 	If Splitter is initialized in an invisible Kendo UI Window, Javascript size calculations 
	 *  will not work and the Splitter cannot adjust its layut properly.
	 *	Please use kendo.resize() or the Splitter's resize() method in the Window's activate event.
	 */
 	$scope.gridWindowOptions={
		activate:function(){
			$scope.gridCard.mainSplitter.resize();
		},
	}
		
	$scope.openGrid=function(gridId){
 		if(!!gridId){
			$scope.gridCard.load(gridId);
		}else{
			$scope.gridCard.clear();
		}
 		$scope.$apply();
		$scope.gridWindow.open();
	}
}]);

</script>