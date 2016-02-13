<script>
'user strict';

clivia.
directive('capitalize', function() {
	   return {
	     require: 'ngModel',
	     link: function(scope, element, attrs, modelCtrl) {
	        var capitalize = function(inputValue) {
	           if(inputValue == undefined) inputValue = '';
	           var capitalized = inputValue.toUpperCase();
	           if(capitalized !== inputValue) {
	              modelCtrl.$setViewValue(capitalized);
	              modelCtrl.$render();
	            }         
	            return capitalized;
	         }
	         modelCtrl.$parsers.push(capitalize);
	         capitalize(scope[attrs.ngModel]);  // capitalize initial value
	     }
	   };
}).

directive("employeeCombobox",function(){
	var template='<input kendo-combobox k-options="employeeOptions" ></input>';
	return {
		restrict:"EA",
		replace:true,
		scope:true,
		template:template,
		link:function(scope,element,attrs){

			var employeeDataSource=new kendo.data.DataSource({  
					transport: {
					    read: {
					        url: '../datasource/employeeInfoDao/read',
					        type: 'post',
					        dataType: 'json',
					        contentType: 'application/json'
					    },
					    parameterMap: function(options, operation) {
					    	//operation is alaways read here.

					    	//add extra parameters to options
					    	//field projection,return fields that needed instead of all fields of the table
				    		options.data={select:"id,fullName"};	 						    	
				            return JSON.stringify(options);
					    }
					},
					
					schema: {
					    data: "data",
					    model: {id: "id"}
					},
					
					serverFiltering: true,		//
					//pageSize: 15,
					serverPaging: true,
					serverSorting: true,
						sort: [{
				         field: "fullName",
				         dir: "asc"
				     }], 
              });
             
			scope.employeeOptions={
				filter:"startswith",
				filtering: function(e) {
				      var filter = e.filter;
				      if (! (filter && filter.value)) {
				        //prevent filtering if the filter does not have value
				        e.preventDefault();
				      }
				  },					
                dataTextField: "fullName",
                dataValueField: "id",
				dataSource: employeeDataSource,
				autoBind:false,					//
				minLength:1,					//
                //height: 400,					
			}
		}
	}
}).

directive("companyCombobox",function(){
	var template='<input kendo-combobox k-options="companyOptions" ></input>';
	return {
		restrict:"EA",
		replace:true,
		scope:true,
		template:template,
		link:function(scope,element,attrs){

			var companyDataSource=new kendo.data.DataSource({  
					transport: {
					    read: {
					        url: '../datasource/companyInfoDao/read',
					        type: 'post',
					        dataType: 'json',
					        contentType: 'application/json'
					    },
					    parameterMap: function(options, operation) {
							//operation is alaways read here.

							if(!options.filter)
								options.filter={filters:[],logic:'and'};
							
					    	var filters=options.filter.filters;
							
							//prevent retrieving all records by setting id to a negenative vlaue
							//when first time click on the dropdown arrow without type in any character
							if(!!options.filter && options.filter.filters.length===0)
								filters.push({field:'id',operator:'eq',value:-1});

					    	//add extra parameters to options
					    	//field projection,return fields that needed instead of all fields of the table
					    		options.data={select:"id,businessName"};	 
					            return JSON.stringify(options);
					    },
					    
					},
					
					schema: {
					    data: "data",
					    model: {id: "id"}
					},
					
					serverFiltering: true,		//
					pageSize: 25,				//maxim return 25 matched records per request
					serverPaging: true,
					serverSorting: true,
						sort: [{
				         field: "businessName",
				         dir: "asc"
				     }], 
            });
             
			scope.companyOptions={
				filter:"startswith",
				filtering: function(e) {
				      var filter = e.filter;
				      if (! (filter && filter.value)) {
				        //prevent filtering if the filter does not have value
				        e.preventDefault();
				      }
				  },					
                dataTextField: "businessName",
                dataValueField: "id",
				dataSource: companyDataSource,
				autoBind:false,					//
				minLength:3,					//
                //height: 400,					
			}
		}
	}
}).

directive("customerInput",["cliviaDDS",function(cliviaDDS){
	var template='<input kendo-combobox k-options="customerOptions" k-ng-delay="customerOptions" ></input>';
	return {
		restrict:"EA",
		replace:true,
		scope:true,
		template:template,
		link:function(scope,element,attrs){
			
			cliviaDDS.getDict("customerInput").getItems()
				.then(function(items){
					scope.customerOptions={
				            dataTextField: "text",
				            dataValueField: "value",			
							dataSource: {data:items}, 
					};
				},function(error){
					console.log("dict:"+error);
				});
		}
	}
}]).

directive("brandInput",["cliviaDDS",function(cliviaDDS){
	var template='<select kendo-dropdownlist k-options="brandOptions" k-ng-delay="brandOptions" ></select>';
	return {
		restrict:"EA",
		replace:true,
		scope:true,
		template:template,
		link:function(scope,element,attrs){
			
			cliviaDDS.getDict("garmentBrand").getItems()
				.then(function(items){
					scope.brandOptions={
				            dataTextField: "name",
				            dataValueField: "name",			
							dataSource:{data:items}, 
							value:"DD",					//default value
					};
				},function(error){
					console.log("dict:"+error);
				});
		}
	}
}]).

directive("garmentInput",["GridWrapper",function(GridWrapper){
	
	return { 
		restrict:"EA",
		replace:true,
		scope:{
			dictGarment:'=',			//type of DataDict
			addFunction:'='
		},
		templateUrl:'../common/garmentinput',
		link: function(scope,element,attrs){
			
			var gridSchema={model: {id: "id",
				fields: {
					id: { type: "number"},
					colour: { type: "string"},
					total: {type:"number"},
					remark: {type:"string"},
					f00: {type:"number"},
					f01: {type:"number"},
					f02: {type:"number"},
					f03: {type:"number"},
					f04: {type:"number"},
					f05: {type:"number"},
					f06: {type:"number"},
					f07: {type:"number"},
					f08: {type:"number"},
					f09: {type:"number"},
					f10: {type:"number"},
					f11: {type:"number"},
					f12: {type:"number"}
				}}};

			var gridColumns=[{title:"Colour",template:"<label>#: colour #</label>"}];
			var gridData=new kendo.data.ObservableArray([]);

			var readOnlyColumnEditor=function(container, options) {
		         $("<span>" + options.model.get(options.field)+ "</span>").appendTo(container);
		     };
		     
			var readOnlyColumnEditor=function(container, options) {
		         $("<span>" + options.model.get(options.field)+ "</span>").appendTo(container);
		     };
		     
		    var quantityColumnEditor=function(container, options) {
		    		if(options.model.id){
				        $('<input class="grid-editor" data-bind="value:' + options.field + '"/>')
			            .appendTo(container)
			            .kendoNumericTextBox({
			            	min: 0
			            });
		    		}else{
		    			readOnlyColumnEditor(container, options);
		    		}
			};
			
			var clearGrid=function(){
				gridData.splice(0, gridData.length);
				gridColumns.splice(1, gridColumns.length-1);

				scope.gridRebind++;
			};

			
			var createGrid=function(){
				if(!scope.garment) return;

				var sizes=scope.garment.sizeRange.split(",");
				var colours=scope.garment.colourway.split(",");
				
				for(var i=0;i<sizes.length;i++){
					var column={
							title: sizes[i],
							field:"f"+("00"+i).slice(-2),
							editor:quantityColumnEditor,
							width: 60,
							attributes: {style:"text-align: right;"},
							headerAttributes: {style:"text-align: right;"}
						};
					gridColumns.push(column);
				}
				
				gridColumns.push({
						title: "Subtotal", 
						field:"total", 
						editor:readOnlyColumnEditor, 
						width: 80, 
						attributes: {style:"text-align: right; font-weight: bold;"},
						headerAttributes: {style:"text-align: right;"}
				});
				
				gridColumns.push({title: "Remark", total:0, field: "remark"});

				scope.gridRebind++;	//cause the grid rebinds
			
				var di;
 				for(var i=0; i<colours.length; i++){
 					di={id: i+1, colour: colours[i].trim()};
 					gridData.push(di);
				}
 				di={id: 0, colour: "Subtotal:"};
 				gridData.push(di);

 				clearSubtotal();
			};
			
			var clearSubtotal=function(){
				var diSubtotal=gridData[gridData.length-1];
				for(var c=0,field; c<gridColumns.length-3; c++){
	        		field="f"+("00"+c).slice(-2);
	        		diSubtotal[field]=0;
				}
			}
			
			var calcTotal=function(){
				var total=0;
				
				clearSubtotal();
				diSubtotal=gridData[gridData.length-1];
				
				for(var r=0,di,t;r<gridData.length-1;r++){
					
					di=gridData[r];
					t=0;
		        	for(var c=0,field; c<gridColumns.length-3; c++){
		        		field="f"+("00"+c).slice(-2);
		        		if(di[field]){
		        			diSubtotal[field]+=di[field];
		        			t+=di[field];
		        		}
		        	}
		        	di.total=t;
		        	total+=t;
				}
				
				diSubtotal.total=total;
		        		
			};
			
			var closeWindow=function(){
				var parentWindow=element.closest(".k-window-content");			

				if(parentWindow){
					parentWindow.data("kendoWindow").close();
				}
			};
			
			scope.styleNumber="";
			scope.garment={};
			scope.gridRebind=0;

			scope.gridOptions={
					columns:gridColumns,
					dataSource:{
						data:gridData,
						schema:gridSchema,
					},
					autoSync: true,
			        editable: true,
			        selectable: "cell",
			        navigatable: true,
			        resizable: true,
			        dataBound: function(e){
						this.autoFitColumn(0);
			        },
			        save:function(e){
 			        	var t=0, changed=false;
			        	
 			        	for(var c=0,field; c<this.columns.length-3; c++){
			        		field="f"+("00"+c).slice(-2);
				        	if(typeof e.values[field]!== 'undefined'){
				        		if(e.values[field]!==e.model[field]){
					        		changed=true;
					        		e.model[field]=e.values[field];
				        		}
				        		break;
				        	}
			        	}
			        	
			        	if(changed){
			        		calcTotal();
			        	}  
			        }
			};
			
			scope.getGrid= function(){
					var styleNumber=scope.styleNumber.trim().toUpperCase();
					scope.styleNumber="";
					clearGrid();
					if(styleNumber){
						scope.dictGarment.getItem("styleNumber",styleNumber)
							.then(function(garment){
								scope.garment=garment;
								createGrid();
							},function(){
								
							});
					}
				};
				

			scope.clear=function(){
					scope.styleNumber="";
					scope.garment={};
					clearGrid();
				};
				
			scope.add=function(){
					if(scope.addFunction){
						if(gridData.length>0)
							gridData.pop();	//remove the subtotal line
						scope.addFunction(scope.garment,gridData);
						scope.clear();
					}
				};
				
			scope.ok=function(){
					scope.add();
					closeWindow();
				};
				
			scope.cancel=function(){
					scope.clear();
					closeWindow();
				};
		},
			
		controller: ['$scope', function($scope) {
		}]
	}
}]).
	
//Sample directive.  Activate it by passing my-grid attribute to
//the div which constructs the grid.  It expects your div to also
//have a kendo-grid attribute, to activate the Kendo UI directive
//for creating a grid.
directive('checkSelect', ['$compile', function ($compile) {
	 var directive = {
	     restrict: 'A',
	     scope: true,
	     controller: function ($scope) {
	         window.crap = $scope;
	         $scope.toggleSelectAll = function(ev) {
	             var grid = $(ev.target).closest("[kendo-grid]").data("kendoGrid");
	             var items = grid.dataSource.data();
	             items.forEach(function(item){
	                 item.selected = ev.target.checked;
	             });
	         };
	     },
	     link: function ($scope, $element, $attrs) {
	         var options = angular.extend({}, $scope.$eval($attrs.kOptions));
	         options.columns.unshift({
	             template: "<input type='checkbox' ng-model='dataItem.selected' />",
	             title: "<input type='checkbox' title='Select all' ng-click='toggleSelectAll($event)' />",
	             width: 30
	         });
	     }
	 };
	 return directive;
}]).

directive('garmentGrid',["GarmentGridWrapper","cliviaDDS","util",function(GarmentGridWrapper,cliviaDDS,util){

	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@garmentGrid',
				cBrand:'=',
				cEditable:'=',
				cDataSource:'=',
				cPageable:'=',
				cNewItemFunction:'&',
			},
			templateUrl:'../common/garmentgrid',
			link:function(scope,element,attrs){
				
				scope.gridName=scope.cName+"Grid";
				scope.inputWindowName=scope.cName+"InputWindow";
				
				var ggw=new GarmentGridWrapper(scope.gridName);	
				ggw.setBrand(scope.cBrand);	
				
				//ggw.setColumns(gridColumns);
				
				scope.setting={};
				scope.setting.editing=true;
				scope.dict=ggw.dict;
				scope.dictGarment=ggw.dictGarment;
				scope.dds=cliviaDDS;

			    scope.$on("kendoWidgetCreated", function(event, widget){
			        // the event is emitted for every widget; if we have multiple
			        // widgets in this controller, we need to check that the event
			        // is for the one we're interested in.
			        if (widget ===scope[scope.gridName]) {
			        	ggw.wrapGrid(widget);
			        	if(scope.cName)
				        	scope.$parent[scope.cName]={
			        			name:scope.cName,
			        			grid:widget,
			        			gridWrapper:ggw,
			        			resize:function(gridHeight){
			        				ggw.resizeGrid(gridHeight);
			        			},
			        			
			        			create:function(brand){
			        				ggw.setBrand(brand);
			        				ggw.grid.setOptions({columns:ggw.gridColumns});
			        			},
			        			
			        			
			        	}
			        }
			    });	
			    
			    
			 	scope.gridSortableOptions = ggw.getSortableOptions();
			    
			 	scope.gridOptions = {
							autoSync: true,
					        columns: ggw.gridColumns,
					        dataSource: scope.cDataSource,
					        editable: scope.cEditable,
					        pageable:scope.cPageable,
					        selectable: "cell",
					        navigatable: true,
					        resizable: true,
						//events:		 
					       	dataBinding: function(e) {
					       		console.log("event binding:"+e.action+" index:"+e.index+" items:"+JSON.stringify(e.items));
					       	},
					       	
					       	dataBound:function(e){
					       		console.log("event databound:");
					       		
					       	},
					       	
			 		       	save: function(e) {
					       		if(typeof e.values.styleNumber!== 'undefined'){		//styleNumber changed
						       		console.log("event save:"+JSON.stringify(e.values));
				  	        		e.preventDefault();
			 		       			if(e.values.styleNumber===";"){
					       				ggw.copyPreviousRow();
					       		 	}else {
						          		e.model.set("styleNumber",e.values.styleNumber.toUpperCase().trim());
						          		ggw.setCurrentGarment(e.model);
					          		}
					          	}else{

					          		var t=0, changed=false;
					          		
						        	for(var c=0,field; c<ggw.sizeRangeFields.length; c++){
						        		field="qty"+("00"+c).slice(-2);
							        	if(typeof e.values[field]!== 'undefined'){
							        		t+=e.values[field];
							        		changed=true;
							        	}else{
							        		if(e.model[field])	
							        			t+=e.model[field];
							        	}
						        	}
						        	
						        	if(changed){
						        		e.model.quantity=(t!==0)?t:null;
						        		//calcTotal();
						        	}
					          	}
					         },
					       	
					         //row or cloumn changed
					       	change:function(e){
					       		var row=ggw.getCurrentRow();
					       		console.log("event change:");
					       		var	newRowUid=row?row.dataset["uid"]:"";
				        		if((typeof newRowUid!=="undefined") && (ggw.currentRowUid!==newRowUid)){		//row changed
				        			ggw.currentRowUid=newRowUid;
				        			var dataItem=ggw.getCurrentDataItem();
				        			if(dataItem){
					        			ggw.setCurrentGarment(dataItem);
					        			//$state.go('main.lineItem.detail',{orderItemId:orderItemId,lineItemId:dataItem.lineNumber});
				        			}
				        		};
					       	},
					       	
					        edit:function(e){
					        	console.log("event edit:");
							    var editingCell=ggw.getEditingCell();
							    if(!!editingCell){
							    	this.select(editingCell);
						        	console.log("set editing cell:");
							    }

					        }

				}; //end of garmetnGridOptions

									
				scope.gridContextMenuOptions={
					closeOnClick:true,
					filter:".gridLineNumber,.gridLineNumberHeader",
					target:'#'+scope.gridName,
					select:function(e){
					
						switch(e.item.id){
							case "menuAdd":
								scope.setting.editing=true;
								if(!ggw.isEditing)
									ggw.enableEditing(true);
								addRow(false);
								break;
							case "menuAddWindow":
								scope.garmentInputWindow.open();
								break;
							case "menuInsert":
								addRow(true);
								break;
							case "menuDelete":
								deleteRow();
								break;
						}
						
					}
					
				};
							
				var newItem=function(){
					if(!scope.cNewItemFunction)
						scope.cNewItemFunction=function(){
								return {};
							};
					var item=scope.cNewItemFunction();
					return item();
				}
				
				var addRow=function(isInsert){
					var item=newItem();
					item.brand=scope.cBrand;
				    ggw.addRow(item,isInsert);
				}
							
				var deleteRow=function (){
					var dataItem=ggw.getCurrentDataItem();
				    if (dataItem) {
				        if (confirm('Please confirm to delete the selected row.')) {
							ggw.deleteRow(dataItem);
				        }
				    }
			   		else {
			        	alert('Please select a  row to delete.');
			   		}
				    
				}
					
				scope.inputWindowAddFunction=function(garment,dataItems){
					if(dataItems.length>0){
						var sizes=util.split(garment.sizeRange);
						for(var r=0,nullRow,di,item;r<dataItems.length;r++){
							di=dataItems[r];		//dataItem
						    item=newItem(); 
						    nullRow=true;
						    item.styleNumber=garment.styleNumber;
						    item.description=garment.styleName;
						    item.colour=di.colour;
						    item.quantity=di.total;
						    item.remark=di.remark;
							for(var i=0;i<sizes.length;i++){  //exclude colour,total,remark
								var f="f"+("00"+i).slice(-2); 	//right(2)
								var q="qty"+("00"+ggw.sizeRangeFields.indexOf(sizes[i])).slice(-2); 
								item[q]=di[f];
								if(parseInt(di[f]))
									nullRow=false;
							}
							if(!nullRow)
							    ggw.addRow(item,false);
						}
					}
				}
				
			}
			
	}
	return directive;
}]);

</script>