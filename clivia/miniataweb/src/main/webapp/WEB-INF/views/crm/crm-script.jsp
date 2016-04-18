<script>
'user strict';
var crmApp = angular.module("crmApp",
		[ "kendo.directives","clivia"]);
		
crmApp.directive("company",["$http","cliviaDDS","util",function($http,cliviaDDS,util){
	
	var searchTemplate='Select:<map-combobox  style="width:300px;"  c-options="search.options" ng-model="search.companyId"> </map-combobox>'+
	'<span ng-click="getCompany()" class="k-icon k-i-search"></span>';

	var baseUrl="../crm/";	

	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@company',
				},
			templateUrl:baseUrl+'company',
			
			link:function(scope){

				scope.clearDataSet=function(){
 					scope.dataSet.info={
 							discount:0.20,
 							useWsp:true,
 							isCustomer:true
 						};
 					for(var i=0,items,itemName;i<scope.companyItemNames.length;i++){
 						itemName=scope.companyItemNames[i];
 						items=scope.dataSet[itemName+'Items'];
 						items.splice(0,items.length);
 					}
 					scope.dataSet.deleteds=[];
				}			    
			    
			    scope.clear=function(){
			    	scope.search.companyId=null;
			    	scope.clearDataSet();
			    }
			    

				scope.getCompany=function(){
			    	var companyId=scope.search.companyId;
			    	scope.search.companyId=null;
			    	if(companyId){
			    		scope.load(companyId);
			    	}else{
						alert("Please input a company to search.");
			    	}
				}

			    scope.load=function(companyId){
					var url=baseUrl+"get-company?id="+companyId;
					scope.clear();

					$http.get(url).
						success(function(data, status, headers, config) {
					    	populate(data);
						}).
						error(function(data, status, headers, config) {
						});
			    }

			    scope.save=function(){
			    	if(!validCompany()) return;
					var url=baseUrl+"save-company";
					
					if(scope.companyForm.$dirty||scope.instructionsForm.$dirty)
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
					
					for(var i=0,scopeItems,dataItems,itemName;i<scope.companyItemNames.length;i++){
						itemName=scope.companyItemNames[i]+'Items';
						dataItems=data[itemName];
						if(dataItems){
							scopeItems=scope.dataSet[itemName];
							for(var j=0;j<dataItems.length;j++){
								scopeItems.push(dataItems[j]);
							}
						}
					}
					
					scope.companyForm.$setPristine();
					scope.instructionsForm.$setPristine();
				}
				
			 	var validCompany=function(){
					var isValid=true;
					var errors="";

					if(!!!scope.dataSet.info.businessName){
						errors+="Style# can not be empty.";
					}
					if (errors!=""){
						alert(errors);
						isValid=false;
					}
					
					return isValid;
				}
			 	
			 	scope.clear();
			},
			
			controller:["$scope","cliviaDDS","DataDict","ContactGridWrapper","AddressGridWrapper","JournalGridWrapper",
			            function($scope,cliviaDDS,DataDict,ContactGridWrapper,AddressGridWrapper,JournalGridWrapper){
				var scope=$scope;
				
				scope.$parent[scope.cName]=scope;

				scope.search={
						companyId:null,
						options:{
							name:"searchComboBox",
							dataTextField:"businessName",
							dataValueField:"id",
							minLength:2,
							url:'../datasource/companyInfoDao/read',
							dict:cliviaDDS.getDict("customerInput"),
						}
					};

				scope.companyToolbarOptions ={items:[{
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
						}, {
							type: "separator",
					}]};
				
				scope.companyItemNames=['contact','address','journal'];
				
				scope.dataSet={info:{html:"test"}, deleteds:[]};
				
				
				for(var i=0,itemName;i<scope.companyItemNames.length;i++){
					
					itemName=scope.companyItemNames[i];
					
					scope.dataSet[itemName+'Items']=new kendo.data.ObservableArray([]);
					
				 	scope[itemName+'GridDataSource']=new kendo.data.DataSource({
				     	data:scope.dataSet[itemName+'Items'],
					    schema: {
					    	model: { id: "id" }
					    },	//end of schema
					    
					    serverFiltering:false,
					    pageSize: 0,			//paging in pager

				    }); //end of dataSource,
				    
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
				$scope.discountOptions={
						min: 0,
		             	max: 1,
			            step: 0.01,
			            format: "{0:p0}",
			            decimals:2
				}
				
				$scope.termOptions={
						dataSource:util.getTerms()
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
				
				$scope.newContactItemFunction=function(){
				    return {isActive:true,isBuyer:true};
				}

				$scope.newAddressItemFunction=function(){
					var item={billing:false,shipping:true};
					var info=$scope.dataSet.info;
					if(info){
						if(info.country)
							item.country=info.country;
						if(info.province)
							item.province=info.province;
						if(info.city)
							item.city=info.city;
					}
				    return item;
				}

				$scope.newJournalItemFunction=function(){
				    return {};
				}
				
				var registerDeletedItem=function(itemType,id){
					
					var item= {entity:itemType,id:id};
					$scope.dataSet.deleteds.push(item);
				}
				
				$scope.registerDeletedContactItemFunction=function(dataItem){
					registerDeletedItem("companyContact",dataItem.id);
				}				

				$scope.registerDeletedAddressItemFunction=function(dataItem){
					registerDeletedItem("companyAddress",dataItem.id);
				}				

				$scope.registerDeletedJournalItemFunction=function(dataItem){
					registerDeletedItem("companyJournal",dataItem.id);
				}				
			}]};
	
	return directive;
	
	
}]);//end of directive company 







crmApp.factory("CompanyGridWrapper",["GridWrapper",function(GridWrapper){
	var thisGW;
	var getColumns=function(){
		
	var gridColumns=[{
		        name:"lineNumber",
		        title: "#",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 40,
			}, {
		         name: "businessName",
		         field: "businessName",
		         title: "Business Name",
		         width: 300
		     }, {
		         name: "category",
		         field: "category",
		         title: "Category",
				 filterable: { multi:true},
		         width: 90,
		     }, {
		         name: "repName",
		         field: "repName",
		         title: "Rep.",
				 filterable: { multi:true},
		         width: 90,
		     }, {
		         name: "csrName",
		         field: "csrName",
		         title: "CSR",
				 filterable: { multi:true},
		         width: 90,
		     }, {
		         name: "city",
		         field: "city",
		         title: "City",
				 filterable: { multi:true,search: true},
		         width: 90,
		     }, {
		         name: "province",
		         field: "province",
		         title: "Province",
				 filterable: { multi:true,search: true},
		         width: 80,
		     }, {
		         name: "country",
		         field: "country",
		         title: "Country",
				 filterable: { multi:true},
		         width: 85,
		     }, {
		         name: "discount",
		         field: "discount",
		         title: "% Off",
		         format: "{0:p0}",
		         width: 60,
		     }, {
		         name: "term",
		         field: "term",
		         title: "Term",
		         width: 100,
		         
 		     }, {
		         name: "useWsp",
		         field: "useWsp",
		         title: "Use WSP",
		         width: 80,
		         template: '<input type="checkbox" #= useWsp ? checked="checked" : "" # disabled="disabled" />',
		         filterable:{multi: true, dataSource: [{ useWsp: true }, { useWsp: false }, {useWsp:null}]}, 
		         
		     }, {
		         name: "website",
		         field: "website",
		         title: "Website",
		         width: 80,
		         hidden:true,
		     }, {
		         name: "status",
		         field: "status",
		         title: "Status",
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


crmApp.controller("crmCtrl",["$scope","CompanyGridWrapper",function($scope,CompanyGridWrapper){
	
	$scope.$on("kendoWidgetCreated", function(event, widget){
		if (widget ===$scope.crmCompanyGrid) {
				$scope.cgw.wrapGrid(widget);
		}
		
		if ($scope.companyCard){
			if(widget ===$scope.companyCard.regularEditor)
		        $("[data-role='editor']").each(function () {
		            $(this).getKendoEditor().refresh();
		        });
		}

	});	

	
	
	$scope.crmToolbarOptions={items: [{
			        type: "button",
			        text: "New",
			        id:"btnNew",
			        click: function(e) {
			    		$scope.openCompany();
			       		 }
			    }, {
			        type: "button",
			        text: "Edit",
			        id:"btnEdit",
			        click: function(e) {
			        	var di=$scope.cgw.getCurrentDataItem();
 			        	if(di){
				    		$scope.openCompany(di.id);
			       		}else{
			       			alert("Please select a company to edit.");	
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
	
	$scope.cgw=new CompanyGridWrapper("crmCompanyGrid");
	$scope.cgw.doubleClickEvent=function(e) {
    	var di=$scope.cgw.getCurrentDataItem();
     	if(di){
    		$scope.openCompany(di.id);
   		}else{
   			alert("Please select a company to edit.");	
   		}
     }
	
	$scope.crmCompanyGridDataSource={
				transport: {
				    read: {
				        url: '../datasource/companyWithInfoDao/read',
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
			  //  filter: crmGridFilter,
				sort: [{
			         field: "businessName",
			         dir: "asc"
			     }], 
				schema: {
				    data: "data",
				    total: "total",
				    model: {id: "id"}
				},
			};
	
	$scope.crmCompanyGridOptions={
				dataSource:$scope.crmCompanyGridDataSource,
				columns:$scope.cgw.gridColumns,
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
	 *  will not work and the Splitter cannot adjust its layout properly.
	 *	Please use kendo.resize() or the Splitter's resize() method in the Window's activate event.
	 */
 	$scope.companyWindowOptions={
		activate:function(){
			$scope.companyCard.mainSplitter.resize();
		},
	}
		
	$scope.openCompany=function(companyId){
 		if(!!companyId){
			$scope.companyCard.load(companyId);
		}else{
			$scope.companyCard.clear();
		}
 		$scope.$apply();
		$scope.companyWindow.open();
	}
}]);

</script>