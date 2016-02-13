<script>
'user strict';
var hrApp = angular.module("hrApp",
		[ "kendo.directives","clivia"]);
		
hrApp.directive("employee",["$http","cliviaDDS","util",function($http,cliviaDDS,util){
	
	var searchTemplate='Select:<employee-combobox id="searchEmployee" name="searchEmployee" style="width:200px;"  ng-model="search.employeeId"></employee-combobox>'+
	'<span ng-click="getEmployee()" class="k-icon k-i-search"></span>';

	var baseUrl="";	

	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@employee',
				},
			templateUrl:'employee',
			
			link:function(scope){

				scope.clearDataSet=function(){
 					scope.dataSet.info={};
 					for(var i=0,items,itemName;i<scope.employeeItemNames.length;i++){
 						itemName=scope.employeeItemNames[i];
 						items=scope.dataSet[itemName+'Items'];
 						items.splice(0,items.length);
 						
 						items=scope.dataSet[itemName+'DeletedItems'];
 						items.splice(0,items.length);
 					}
				}			    
			    
			    scope.clear=function(){
			    	scope.search.employeeId=null;
			    	scope.clearDataSet();
			    }
			    

				scope.getEmployee=function(){
			    	var employeeId=scope.search.employeeId;
			    	scope.search.employeeId=null;

			    	if(employeeId){
			    		scope.load(employeeId);
			    	}else{
						alert("Please input a employee to search.");
			    	}
				}

			    scope.load=function(employeeId){
					var url=baseUrl+"get-employee?id="+employeeId;
					scope.clear();

					$http.get(url).
						success(function(data, status, headers, config) {
					    	populate(data);
						}).
						error(function(data, status, headers, config) {
						});
			    }

			    scope.save=function(){
			    	if(!validEmployee()) return;
			    	
					var url=baseUrl+"save-employee";
					
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
					
					for(var i=0,scopeItems,dataItems,itemName;i<scope.employeeItemNames.length;i++){
						itemName=scope.employeeItemNames[i]+'Items';
						dataItems=data[itemName];
						if(dataItems){
							scopeItems=scope.dataSet[itemName];
							for(var j=0;j<dataItems.length;j++){
								scopeItems.push(dataItems[j]);
							}
						}
					}
				}
				
			 	var validEmployee=function(){
					var isValid=true;
					var errors="";

					if(!!!scope.dataSet.info.firstName){
						errors+="First name can not be empty.";
					}
					
					if (errors!=""){
						alert(errors);
						isValid=false;
					}
					
					return isValid;
				}
			 	
			 	scope.clear();
			},
			
			controller:["$scope","cliviaDDS","DataDict",
			            function($scope,cliviaDDS,DataDict){
				
				$scope.$parent[$scope.cName]=$scope;
				
				$scope.search={};

				$scope.employeeToolbarOptions ={items:[{
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
							type: "separator",
					}]};
				
				
				
				$scope.employeeItemNames=[];
				
				$scope.dataSet={info:{}};
				
				for(var i=0,itemName;i<$scope.employeeItemNames.length;i++){
					
					itemName=$scope.employeeItemNames[i];
					
					$scope.dataSet[itemName+'Items']=new kendo.data.ObservableArray([]);
					$scope.dataSet[itemName+'DeletedItems']=[];
					
					$scope[itemName+'GridSortableOptions'] = $scope[itemName+'GW'].getSortableOptions();
					
				 	$scope[itemName+'GridDataSource']=new kendo.data.DataSource({
				     	data:$scope.dataSet[itemName+'Items'],
					    schema: {
					    	model: { id: "id" }
					    },	//end of schema
					    
					    serverFiltering:false,
					    pageSize: 0,			//paging in pager

				    }); //end of dataSource,
				    
				    
				 	$scope[itemName+'GridOptions']={
							autoSync: true,
							columns:$scope[itemName+'GW'].gridColumns,
							dataSource:$scope[itemName+'GridDataSource'],
					        editable: true,
					        selectable: "cell",
					        navigatable: true,
					        resizable: true,
					};
				    
				    
					$scope[itemName+'GridContextMenuOptions']={
							closeOnClick:true,
							filter:".gridLineNumber,.gridLineNumberHeader",
							target:'#'+itemName+'Grid',
							select:function(e){
								if(!e.item.id) return;

								var itemGW='',operation='',itemName='';
								
								for(var i=0,p,operations=['Add','Insert','Delete'];i<operations.length;i++){
									p=e.item.id.indexOf(operations[i]);
									if(p>0){
										operation=operations[i];
										itemName=e.item.id.slice(0,p);
										itemGW=$scope[itemName+'GW'];
										break;
									}
								}
								switch(operation){
									case "Add":
										itemGW.addItem(false,$scope.dataSet.info);
										break;
									case "Insert":
										itemGW.addItem(true,$scope.dataSet.info);
										break;
									case "Delete":
										var id=itemGW.deleteItem();
										if(id>0)
											$scope.dataSet[itemName+'DeletedItems'].push(id);
										break;
								}
							}
					};

				}
				
				
				$scope.mainSplitterOptions={
						resize:function(e){
/*							var panes=e.sender.element.children(".k-pane"),
 							upcGridHeight=$(panes[1]).innerHeight()-37;
							
		 			      	window.setTimeout(function () {
					            $scope.ugw.resizeGrid(upcGridHeight);
					      	},1); 
 */						}
				}
				
				$scope.detailTabStripOptions={
						animation:false,
				};
				
				$scope.countryOptions={
					dataSource:["Canada","USA"]	
				}
				
				cliviaDDS.getDict("city").getItems()
					.then(function(items){
						$scope.cityOptions={
							dataSource: items, 
						};
				});
				
				cliviaDDS.getDict("province").getItems()
					.then(function(items){
						$scope.provinceOptions={
							dataSource: items, 
						};
				});
				
				$scope.hireDateOptions={
						format: "yyyy-MM-dd",
					    parseFormats: ["yyyy-MM-dd"]
				};

				
				$scope.departmentOptions={
					dataSource:['Deco','Garment','Production','Admin']
				}

				$scope.positionOptions={
					dataSource:['Sales','Operator','QC']
				}						    
				
				
			}]};
	return directive 
	
	
}]);//end of directive employee 




hrApp.factory("EmployeeGridWrapper",["GridWrapper",function(GridWrapper){
	var thisGW;
	var getColumns=function(){
		
	var gridColumns=[{
		        name:"lineNumber",
		        title: "#",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 25,
			}, {
		         name: "fullName",
		         field: "fullName",
		         title: "Name",
		         width: 120
		     }, {
		         name: "hireDate",
		         field: "hireDate",
		         title: "Hired",
		         format:"{0:yyyy-MM-dd}",
		         filterable:{ui:'datepicker'},
		         editor: thisGW.dateColumnEditor,
		         width: 80,
		     }, {
		         name: "userName",
		         field: "userName",
		         title: "User",
		         width: 80,
		     }, {
		         name: "department",
		         field: "department",
		         title: "Dept",
		         filterable:{multi:true},
		         width: 80,
		     }, {
		         name: "country",
		         field: "country",
		         title: "Country",
		         filterable:{multi:true},
		         width: 80,
		     }, {
		         name: "province",
		         field: "province",
		         title: "Province",
		         filterable:{multi:true},
		         width: 80,
		     }, {
		         name: "city",
		         field: "city",
		         title: "City",
		         filterable:{multi:true},
		         width: 80,
		         
		     }, {
		         name: "isRep",
		         field: "isRep",
		         title: "Rep",
		         template: '<input type="checkbox" #= isRep ? checked="checked" : "" # disabled="disabled" />',
		         filterable:{multi: true, dataSource: [{ isRep: true }, { isRep: false }, {isRep:null}]},
		         width: 70,
		     }, {
		         name: "isCsr",
		         field: "isCsr",
		         title: "CSR",
		         template: '<input type="checkbox" #= isCsr ? checked="checked" : "" # disabled="disabled" />',
		         filterable:{multi: true, dataSource: [{ isCsr: true }, { isCsr: false }, {isCsr:null}]},
		         width: 70,
		     }, {
		         name: "isActive",
		         field: "isActive",
		         title: "Active",
		         template: '<input type="checkbox" #= isActive ? checked="checked" : "" # disabled="disabled" />',
		         filterable:{multi: true, dataSource: [{isActive: true }, {isActive: false }, {isActive:null}]},
		         width: 80,
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
}]); //end of ContactGridWrapper


hrApp.controller("hrCtrl",["$scope","EmployeeGridWrapper",function($scope,EmployeeGridWrapper){
	
	$scope.$on("kendoWidgetCreated", function(event, widget){
		if (widget ===$scope.hrEmployeeGrid) {
				$scope.employeeGW.wrapGrid(widget);
		}

	});	

	
	
	$scope.hrToolbarOptions={items: [{
			        type: "button",
			        text: "New",
			        id:"btnNew",
			        click: function(e) {
			    		$scope.openEmployee();
			       		 }
			    }, {
			        type: "button",
			        text: "Edit",
			        id:"btnEdit",
			        click: function(e) {
			        	var di=$scope.employeeGW.getCurrentDataItem();
 			        	if(di){
				    		$scope.openEmployee(di.id);
			       		}else{
			       			alert("Please select an employee to edit.");	
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
			}]};
	
	$scope.employeeGW=new EmployeeGridWrapper("hrEmployeeGrid");
	$scope.employeeGW.doubleClickEvent=function(e) {
    	var di=$scope.employeeGW.getCurrentDataItem();
     	if(di){
    		$scope.openEmployee(di.id);
   		}else{
   			alert("Please select an employee to edit.");	
   		}
     }
	
	$scope.hrEmployeeGridDataSource={
				transport: {
				    read: {
				        url: '../datasource/employeeInfoDao/read',
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
			  //  filter: hrGridFilter,
				sort: [{
			         field: "firstName",
			         dir: "asc"
			     }], 
				schema: {
				    data: "data",
				    total: "total",
				    model: {id: "id"}
				},
			};
	
	$scope.hrEmployeeGridOptions={
				dataSource:$scope.hrEmployeeGridDataSource,
				columns:$scope.employeeGW.gridColumns,
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
 	$scope.employeeWindowOptions={
		activate:function(){
			$scope.employeeCard.mainSplitter.resize();
		},
	}
		
	$scope.openEmployee=function(employeeId){
 		if(!!employeeId){
			$scope.employeeCard.load(employeeId);
		}else{
			$scope.employeeCard.clear();
		}
		$scope.$apply();
		$scope.employeeWindow.open();
	}
}]);

</script>

