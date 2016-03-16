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

directive("mapCombobox",function(){
	var template='<input kendo-combobox  k-options="comboBoxOptions" ></input>'; 
	return {
		restrict:"EA",
		replace:true,
		require: 'ngModel',
		scope:{
			/* c-filter="'isCsr,eq,true'" will be translated into
			filter: {
		    		logic: "and",
		    		filters: [{ field: "isCsr", operator: "eq", value: true}]
		  		}, */
			cOptions:'=',		//{name: dataTextField:, dataValueField:, url: ,filter:,dict:}
		},
		template:template,
		
		link:function(scope,element,attrs,controller){	//["scope","element","attrs","controller",

		    scope.element=element;
		                                              	   
			scope.kendoComboBox=element.getKendoComboBox();

			//not used in angular binding mode
			scope.clear=function(){
 	 		//	scope.kendoComboBox.selectedIndex=-1;
			//	scope.kendoComboBox.value(null);
			//	scope.kendoComboBox.text("");
			//	scope.kendoComboBox.setDataSource(scope.dataSource); 
			}
			
			var addItem=function(value){
				if(!(scope.cOptions.dict&&value)) return;
				
				scope.cOptions.dict.getItem(scope.cOptions.dataValueField,value)
					.then(function(gotItem){
						if(gotItem){
							scope.dataSource.add(gotItem);
							//scope.kendoComboBox.text(gotItem[scope.cOptions.dataTextField]);
						}
					});
			}
			
			scope.$watch(
					function(){
						return controller.$modelValue
						},
					function(newValue,oldValue){
						if (newValue!==oldValue && !!newValue)
	 						var di=scope.dataSource.get(newValue);
	 						if(!di){
	 							addItem(newValue);
		 					}
						}
	 				);
			
		},
		
		controller: ['$scope', function($scope) {
			
			var scope=$scope;
			if(scope.cOptions && scope.cOptions.name)
				scope.$parent[scope.cOptions.name]=scope;
			
			scope.dataSource=new kendo.data.DataSource({  
				transport: {
				    read: {
				        url: scope.cOptions.url,	//'../datasource/employeeInfoDao/read',
				        type: 'post',
				        dataType: 'json',
				        contentType: 'application/json',
				        
				    	//add extra parameters to options
				    	//field projection,return fields that needed instead of all fields of the table
				        data:{select:scope.cOptions.dataValueField+","+scope.cOptions.dataTextField}
				    },
				    parameterMap: function(options, operation) {
				    	//operation is alaways read here.
						if(!options.filter)
							options.filter={filters:[],logic:'and'};
						
				    	var filters=options.filter.filters;

				    	//prevent retrieving all records by setting id to a negenative vlaue
						//when first time click on the dropdown arrow without type in any character
						if(!!options.filter && options.filter.filters.length===0)
							filters.push({field:scope.cOptions.dataValueField,operator:'eq',value:-1});

				    	return JSON.stringify(options);
				    }
				},
				
				schema: {
				    data: "data",
				    model: {id: scope.cOptions.dataValueField}
				},
				
				serverFiltering: true,		

				//pageSize: 15, maxium records per request
				
				serverPaging: true,
				serverSorting: true,
				sort: [{
			         field: scope.cOptions.dataTextField,
			         dir: "asc"
			     }], 
          	});
			
			if(scope.cFilter){
				var filters=[];
				var s=scope.cFilter.split(',');
				filters.push({field:s[0],operator:s[1],value:s[2]});
				scope.dataSource.filter({logic:'and',filters:filters});
			}
			
			scope.comboBoxOptions={
					filter:"startswith",
					filtering: function(e) {
					      var filter = e.filter;
					      if (! (filter && filter.value)) {
					        //prevent filtering if the filter does not have value
					   //     e.preventDefault();
					      }
					  },					
	                dataTextField:scope.cOptions.dataTextField,
	                dataValueField: scope.cOptions.dataValueField,
					dataSource: scope.dataSource,
					autoBind:true,					//
					minLength:scope.cOptions.minLength?scope.cOptions.minLength:1,					//
	                //height: 400,		
	                cascade:function(e){
	                	var i=0;
	                }
				}
		}]
		
	}
}).

directive("textCombobox",function(){
	var template='<input kendo-combobox  k-options="comboBoxOptions" ></input>'; 
	return {
		restrict:"EA",
		replace:true,
		require: 'ngModel',
		scope:{
			cOptions:'=',		//{name: , url: ,filter:,dict:}
		},
		template:template,
		
		link:function(scope,element,attrs,controller){	//["scope","element","attrs","controller",
		    scope.element=element;

			scope.kendoComboBox=element.getKendoComboBox();
		
			scope.getKendoComboBox=function(){
				element.getKendoComboBox();
			}
			
			scope.$watch(
					function(){
							return controller.$modelValue
						},
					function(newValue,oldValue){
							if (newValue!==oldValue){
								if(!!newValue){
									var i=0;
								}else{
									var j=0;
/* 									if(newValue==="" && !!oldValue && controller.$modelValue==="")
										controller.$modelValue=oldValue; */
								}
							}
						}
	 				);
			
		},
		
		controller: ['$scope', function($scope) {
			
			var scope=$scope;
			
			if(scope.cOptions && scope.cOptions.name)
				scope.$parent[scope.cOptions.name]=scope;
			
			scope.comboBoxOptions={
					dataSource: scope.cOptions.dataSource,
					autoBind:false,
	                cascade:function(e){
	                	var i=0;
	                }
				}
		}]
		
	}
}).


directive("brandDropdownlist",["cliviaDDS",function(cliviaDDS){
	var template='<select kendo-dropdownlist k-options="inputOptions" k-ng-delay="inputOptions"></select>';
	return {
		restrict:"EA",
		replace:true,
		scope:{
			cOptions:'=',		//{name:}
		},
		
		template:template,
		
		link:function(scope,element,attrs,controller){
			
			scope.element=element;
			
			scope.getKendoDropDownList=function(){
				return scope.element.getKendoDropDownList();
			}
			
			scope.getBrandName=function(){
				return scope.element.text();	
			}
			
			scope.dict.getItems()
			.then(function(items){
				var thisItems=[];
				 
				for(var i=0;i<items.length;i++){
					if(items[i].hasInventory){
						thisItems.push(items[i]);
					}
				}
				scope.inputOptions={
			            dataTextField: "name",
			            dataValueField: "id",			
						dataSource:{data:thisItems}, 
				};
		})},

		controller: ['$scope', function($scope) {
			var scope=$scope;
			scope.dict=cliviaDDS.getDict("brand");
			if(scope.cOptions && scope.cOptions.name)
				scope.$parent[scope.cOptions.name]=scope;
		}]
	}
}]).

directive("seasonDropdownlist",["cliviaDDS",function(cliviaDDS){
	var template='<select kendo-dropdownlist k-options="inputOptions" k-ng-delay="inputOptions" ></select>';
	return {
		restrict:"EA",
		replace:true,
		scope:{
			cBrandId:'=',
			cOptions:'=',		//{name: brandId:}
		},

		template:template,
		
		link:function(scope,element,attrs,controller){
		    scope.element=element;
			scope.getKendoDropDownList=function(){
				return scope.element.getKendoDropDownList();
			}
			scope.getSeasonName=function(){
				var temp=scope.getKendoDropDownList();
				return temp?temp.text():"";
			}
			
			scope.dict.getItems()
				.then(function(items){
					var thisItems=[];
					 
					for(var i=0;i<items.length;i++){
						if(items[i].brandId===scope.brandId){
							thisItems.push(items[i]);
						}
					}
					scope.inputOptions={
				            dataTextField: "name",
				            dataValueField: "id",			
							dataSource:{data:thisItems}, 
					};
			})},
		controller: ['$scope', function($scope) {
			
			var scope=$scope;
			scope.brandId=scope.cBrandId?scope.cBrandId:(scope.cOptions && scope.cOptions.brandId ?scope.cOptions.brandId:0);
			scope.dict=cliviaDDS.getDict("season");
			
			if(scope.cOptions && scope.cOptions.name)
				scope.$parent[scope.cOptions.name]=scope;
			}]
				
	}
}]).


directive("garmentInput",["GridWrapper",function(GridWrapper){
	
	return { 
		restrict:"EA",
		replace:true,
		scope:{
			cDictGarment:'=',			//type of DataDict
			cAddFunction:'=',
			cSeasonId:'=',
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
			
			scope.styleNo="";
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
					var styleNo=scope.styleNo.trim().toUpperCase();
					scope.styleNo="";
					clearGrid();
					if(styleNo){
						scope.garment=scope.dictGarment.getGarment(scope.seasonId,styleNo);
						createGrid();
					}
				};
				

			scope.clear=function(){
					scope.styleNo="";
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
			$scope.dictGarment=$scope.cDictGarment;
			$scope.addFunction=$scope.cAddFunction;
			$scope.seasonId=$scope.cSeasonId;
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
				cSeason:'=',
				cEditable:'=',
				cDataSource:'=',
				cPageable:'=',
				cNewItemFunction:'&',
				cRegisterDeletedItemFunction:'&',
			},
			
			templateUrl:'../common/garmentgrid',
			link:function(scope,element,attrs){
				
				scope.gridName=scope.cName+"Grid";
				scope.inputWindowName=scope.cName+"InputWindow";

				var ggw=new GarmentGridWrapper(scope.gridName);	
				ggw.setBrandSeason(scope.cBrand,scope.cSeason);		//columns is set in setBrand,so ggw.setColumns(gridColumns) is not needed here.

				scope.$watch("cSeason",function(newValue,oldValue){
					if(newValue && newValue!==oldValue){
						ggw.setBrandSeason(scope.cBrand,scope.cSeason);		//columns is set in setBrand,so ggw.setColumns(gridColumns) is not needed here.
						ggw.grid.setOptions({columns:ggw.gridColumns});
					}
				});
				
				scope.setting={};
				scope.setting.editing=true;
				scope.dict=ggw.dict;
				scope.dictGarment=ggw.dictGarment;
				scope.dds=cliviaDDS;

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
				 		       	console.log("event save:"+JSON.stringify(e.values));
			 		       		
					       		if(ggw.brand.hasInventory && typeof e.values.styleNo!== 'undefined'){		//styleNo changed
						       		
					       			//stop accept the default value,use the value after processed below
					       			e.preventDefault();
			 		       			if(e.values.styleNo===";"){
					       				ggw.copyPreviousRow();
					       				setTimeout(function(){
					       						ggw.calculateTotal();
					       						scope.$apply();	//show changes
											},1);
					       		 	}else {
						          		e.model.set("styleNo",e.values.styleNo.toUpperCase().trim());
						          		ggw.setCurrentGarment(e.model);
					          		}
					          	}else{
						        	for(var c=0,field; c<ggw.season.sizeFields.length; c++){
						        		field="qty"+("00"+c).slice(-2);
							        	if(typeof e.values[field]!== 'undefined'){
						       				setTimeout(function(){
					       						ggw.calculateTotal(true);
					       						scope.$apply();
											},1);
											break;
							        	}
						        	}
						        	
					          	}
					         },
					       	
					         //row or cloumn changed
					       	change:function(e){
/* 					       		var row=ggw.getCurrentRow();
					       		var	newRowUid=row?row.dataset["uid"]:"";
				        		if((typeof newRowUid!=="undefined") && (ggw.currentRowUid!==newRowUid)){		//row changed
				        			ggw.currentRowUid=newRowUid; */
				        		if(ggw.rowChanged()){
				        			var dataItem=ggw.getCurrentDataItem();
				        			ggw.setCurrentGarment(dataItem);
					        			//$state.go('main.lineItem.detail',{orderItemId:orderItemId,lineItemId:dataItem.lineNumber});
				        		};
					       	},
					       	
					        edit:function(e){
					        	console.log("event edit:");
					        	//without code below,when navigate with keybord like tab key, the editing cell will not be selected 
							    var editingCell=ggw.getEditingCell();
							    if(!!editingCell){
							    	this.select(editingCell);
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
					item.brandId=scope.cBrand.id;
				    ggw.addRow(item,isInsert);
				}
							
				var deleteRow=function (){
					var dataItem=ggw.getCurrentDataItem();
				    if (dataItem) {
				    	var confirmed=true;
				        if (dataItem.quantity){
				        	confirmed=confirm('Please confirm to delete the selected row.');	
				        }
				        if(confirmed){
					    	if(dataItem.id && scope.cRegisterDeletedItemFunction){
					    		var register=scope.cRegisterDeletedItemFunction();
					    		register(dataItem);
					    	}
							ggw.deleteRow(dataItem);
							ggw.calculateTotal();
							scope.$apply();
				        }
				    }
			   		else {
			        	alert('Please select a  row to delete.');
			   		}
				    
				}
					
				scope.inputWindowAddFunction=function(garment,dataItems){
					if(dataItems.length>0){
						var sizes=util.split(garment.sizeRange);
						var sizeFields=ggw.season.sizeFields.split(",");
						for(var r=0,nullRow,di,item;r<dataItems.length;r++){
							di=dataItems[r];		//dataItem
						    item=newItem(); 
						    nullRow=true;
						    item.styleNo=garment.styleNo;
						    item.garmentId=garment.id;
						    item.description=garment.styleName;
						    item.colour=di.colour;
						    item.quantity=di.total;
						    item.remark=di.remark;
							for(var i=0;i<sizes.length;i++){  //exclude colour,total,remark
								var f="f"+("00"+i).slice(-2); 	//right(2)
								var q="qty"+("00"+sizeFields.indexOf(sizes[i])).slice(-2); 
								item[q]=di[f];
								if(parseInt(di[f]))
									nullRow=false;
							}
							if(!nullRow)
							    ggw.addRow(item,false);
						}
						ggw.calculateTotal();
					}
				}
				
			}
			
	}
	return directive;
}]).

directive('billGrid',["BillGridWrapper","cliviaDDS","util",function(BillGridWrapper,cliviaDDS,util){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@billGrid',
				cEditable:'=',
				cDataSource:'=',
				cPageable:'=',
				cNewItemFunction:'&',
				cRegisterDeletedItemFunction:'&',
				cGetBillDetailFunction:'&',
			},
			
			templateUrl:'../common/billgrid',
			link:function(scope,element,attrs){	
				scope.gridName=scope.cName+"Grid";

				var bgw=new BillGridWrapper(scope.gridName);	
				bgw.setColumns();
				
				scope.$on("kendoWidgetCreated", function(event, widget){

					if (widget ===scope[scope.gridName]) {
			        	bgw.wrapGrid(widget);
			        	bgw.calculateTotal(true);
			        	
			        	//without setTimeout,scope.$apply() will cause digesting error
			        	setTimeout(function(){scope.$apply();},100);

			        	if(scope.cName){
				        	scope.$parent[scope.cName]={
			        			name:scope.cName,
			        			grid:widget,
			        			gridWrapper:bgw,
			        			hasRow:function(){
			        				return !!(bgw.getRowCount());
			        				},
			        			getTotal:function(){
			        				return bgw.total
			        				},
			        			resize:function(gridHeight){
			        				bgw.resizeGrid(gridHeight);
			        				},
				        	}
			        	}
			        }
			    });	

				scope.setting={};
				scope.setting.editing=true;
				
				scope.gridSortableOptions = bgw.getSortableOptions();
				
				scope.gridOptions = {
						autoSync: true,
				        columns: bgw.gridColumns,
				        dataSource: scope.cDataSource,
				        editable: scope.cEditable,
				        pageable:scope.cPageable,
				        selectable: "cell",
				        navigatable: true,
				        resizable: true,
						
				        //events:		 
				       	dataBinding: function(e) {
				       		console.log("bill grid event: binding--"+e.action+" index:"+e.index+" items:"+JSON.stringify(e.items));
				       	},
				       	
				       	dataBound:function(e){
				       		console.log("bill grid event: dataBound");
				       	},
				       	
		 		       	save: function(e) {
				       		console.log("bill grid event: save");
				       		
		 		       		if(typeof e.values.snpId!== 'undefined'){
		 		       			var unit="";
		 		       			if(e.values.snpId){
		 		       				var snpItem=bgw.getSnpItem(e.values.snpId);
		 		       				unit=(snpItem)?snpItem.unit:"";		 		       				
		 		       			}
		 		       			e.model.set("unit",unit);
		 		       		}
		 		       		if(typeof e.values.orderQty!== 'undefined' || 
		 		       		   typeof e.values.listPrice!== 'undefined'||
		 		       		   typeof e.values.orderPrice!== 'undefined'||
		 		       		   typeof e.values.discount!== 'undefined'){
		 		       			
		 		       			if(typeof e.values.listPrice!== 'undefined'){
		 		       				var orderPrice=calculateOrderPrice(e.values.listPrice,e.model.discount)
		 		       				if(orderPrice>0)
		 		       					e.model.set("orderPrice",orderPrice);
		 		       			}
		 		       			if(typeof e.values.discount!== 'undefined'){
		 		       				var orderPrice=calculateOrderPrice(e.model.listPrice,e.values.discount)
		 		       				if(orderPrice>0)
		 		       					e.model.set("orderPrice",orderPrice);
		 		       			}
		 		       			if(typeof e.values.orderPrice!== 'undefined'){
		 		       				if(e.model.listPrice>0){
		 		       					var discount=(1-e.values.orderPrice/e.model.listPrice);
		 		       					e.model.set("discount",discount);
		 		       				}
		 		       			}
		 		       			//value in model have not been set into dataitems in bgw.so wait for the update finish.
		 		       			setTimeout(function(){
		 		       					bgw.calculateTotal(true);
		 		       					scope.$apply();
		 		       				},1);

		 		       		}
				         },
				       	
				         //row or cloumn changed
				       	change:function(e){
				       		console.log("bill grid event: change");
				       	
			        		if(bgw.rowChanged()){
					       		console.log("bill grid event: row changed");
					       		setTimeout(function(){
				        			var dataItem=bgw.getCurrentDataItem();
				        			getBillDetail(dataItem);
				        			scope.$apply();
					       		},1)
				        			//$state.go('main.lineItem.detail',{orderItemId:orderItemId,lineItemId:dataItem.lineNumber});
			        		};

				       		
				       	}, 
				       	
				        edit:function(e){
				        	console.log("bill grid event: edit");
				        	
/* 				        	//without code below,when navigate with keybord like tab key, the editing cell will not be selected 
						    var editingCell=bgw.getEditingCell();
						    if(!!editingCell){
						    	this.select(editingCell);
						    } 				        	 */
				        }

			}; //end of billGridOptions

								
			scope.gridContextMenuOptions={
				closeOnClick:true,
				filter:".gridLineNumber,.gridLineNumberHeader",
				target:'#'+scope.gridName,
				select:function(e){
				
					switch(e.item.id){
						case "menuAdd":
							scope.setting.editing=true;
							if(!bgw.isEditing)
								bgw.enableEditing(true);
							addRow(false);
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
			
			var calculateOrderPrice=function(listPrice,discount){
				var result=0;
				if(listPrice>0 && discount>0 && discount<1)
					result=listPrice*(1-discount);
				return result;
			}
			
			var getBillDetail=function(billItem){
				var detail;
				if(scope.cGetBillDetailFunction){
					var f=scope.cGetBillDetailFunction({billItem:billItem});
				}
				return detail;
			}
			
			
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
			    bgw.addRow(item,isInsert);
			}
						
			var deleteRow=function (){
				var dataItem=bgw.getCurrentDataItem();
		    	var confirmed=true;
			    if (dataItem) {
			        if (dataItem.orderAmt){
			        	confirmed=confirm('Please confirm to delete the selected row.');	
			        }
			        if(confirmed){
				    	if(dataItem.id && scope.cRegisterDeletedItemFunction){
				    		var register=scope.cRegisterDeletedItemFunction();
				    		register(dataItem);
				    	}
						bgw.deleteRow(dataItem);
						bgw.calculateTotal();
						scope.$apply();
			        }
			    }
		   		else {
		        	alert('Please select a  row to delete.');
		   		}
			    
			}

				
		}	//end of billGrid:link
	}
	
	return directive;
}]).

directive('imageGrid',["ImageGridWrapper","cliviaDDS","util",function(ImageGridWrapper,cliviaDDS,util){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@imageGrid',
				cEditable:'=',
				cDataSource:'=',
				cPageable:'=',
				cDictImage:'=',
				cNewItemFunction:'&',
				cRegisterDeletedItemFunction:'&',
				cShowImageDetailFunction:'&',
			},
			
			templateUrl:'../common/imagegrid',
			link:function(scope,element,attrs){	
				scope.gridName=scope.cName+"Grid";

				var igw=new ImageGridWrapper(scope.gridName);	
				igw.setColumns();
				
				scope.$on("kendoWidgetCreated", function(event, widget){

					if (widget ===scope[scope.gridName]) {
			        	igw.wrapGrid(widget);
			        	
			        	if(scope.cName){
				        	scope.$parent[scope.cName]={
			        			name:scope.cName,
			        			grid:widget,
			        			gridWrapper:igw,
			        			resize:function(gridHeight){
			        				igw.resizeGrid(gridHeight);
			        				},
				        	}
			        	}
			        }
			    });	

				scope.setting={};
				scope.setting.editing=true;
				
				scope.gridSortableOptions = igw.getSortableOptions();
				
				scope.gridOptions = {
						autoSync: true,
				        columns: igw.gridColumns,
				        dataSource: scope.cDataSource,
				        editable: scope.cEditable,
				        pageable:scope.cPageable,
				        selectable: "cell",
				        navigatable: true,
				        resizable: true,
						
				        //events:		 
				       	dataBinding: function(e) {
				       		console.log("image grid event: binding--"+e.action+" index:"+e.index+" items:"+JSON.stringify(e.items));
				       	},
				       	
				       	dataBound:function(e){
				       		console.log("image grid event: dataBound");
				       	},
				       	
		 		       	save: function(e) {
				       		console.log("image grid event: save");
				         },
				       	
				         //row or cloumn changed
				       	change:function(e){
				       		console.log("image grid event: change");
				       	
			        		if(igw.rowChanged()){
					       		console.log("image grid event: row changed");
					       		setTimeout(function(){
				        			var dataItem=igw.getCurrentDataItem();
				        			showImageDetail(dataItem);
				        			scope.$apply();
					       		},1)
				        			//$state.go('main.lineItem.detail',{orderItemId:orderItemId,lineItemId:dataItem.lineNumber});
			        		};

				       		
				       	}, 
				       	
				        edit:function(e){
				        	console.log("image grid event: edit");
				        	
/* 				        	//without code below,when navigate with keybord like tab key, the editing cell will not be selected 
						    var editingCell=igw.getEditingCell();
						    if(!!editingCell){
						    	this.select(editingCell);
						    } 				        	 */
				        }

			}; //end of imageGridOptions

								
			scope.gridContextMenuOptions={
				closeOnClick:true,
				filter:".gridLineNumber,.gridLineNumberHeader",
				target:'#'+scope.gridName,
				select:function(e){
				
					switch(e.item.id){
						case "menuAdd":
							scope.setting.editing=true;
							if(!igw.isEditing)
								igw.enableEditing(true);
//							addRow(false);
							break;
						case "menuUpload":
//							addRow(true);
							break;
						case "menuDelete":
							deleteRow();
							break;
					}
					
				}
				
			};
			
			scope.getImage=function(imageId){
				return scope.cDictImage.getLocalItem('id',imageId);
			}
			
			var showImageDetail=function(imageItem){
				if(scope.cShowImageDetailFunction){
					scope.cShowImageDetailFunction({imageItem:imageItem});
				}
			}
			
			
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
			    igw.addRow(item,isInsert);
			}
						
			var deleteRow=function (){
				var dataItem=igw.getCurrentDataItem();
		    	var confirmed=true;
			    if (dataItem) {
			        if (dataItem.orderAmt){
			        	confirmed=confirm('Please confirm to delete the selected row.');	
			        }
			        if(confirmed){
				    	if(dataItem.id && scope.cRegisterDeletedItemFunction){
				    		var register=scope.cRegisterDeletedItemFunction();
				    		register(dataItem);
				    	}
						igw.deleteRow(dataItem);
			        }
			    }
		   		else {
		        	alert('Please select a  row to delete.');
		   		}
			    
			}

				
		}	//end of imageGrid:link
	}
	
	return directive;
}]).

directive('imageView',["ImageGridWrapper","cliviaDDS","util",function(ImageGridWrapper,cliviaDDS,util){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@imageGrid',
				cEditable:'=',
				cDataSource:'=',
				cPageable:'=',
				cDictImage:'=',
				cNewItemFunction:'&',
				cRegisterDeletedItemFunction:'&',
			},
			
			templateUrl:'../common/imageview',
			link:function(scope,element,attrs){	
				scope.gridName=scope.cName+"Grid";

				var igw=new ImageGridWrapper(scope.gridName);	
				igw.setColumns();
				
				scope.$on("kendoWidgetCreated", function(event, widget){

					if (widget ===scope[scope.gridName]) {
			        	igw.wrapGrid(widget);
			        	
			        	if(scope.cName){
				        	scope.$parent[scope.cName]={
			        			name:scope.cName,
			        			grid:widget,
			        			gridWrapper:igw,
			        			resize:function(gridHeight){
			        				igw.resizeGrid(gridHeight);
			        				},
				        	}
			        	}
			        }
			    });	

				scope.setting={};
				scope.setting.editing=true;
				
				scope.gridSortableOptions = igw.getSortableOptions();
				
				scope.gridOptions = {
						autoSync: true,
				        columns: igw.gridColumns,
				        dataSource: scope.cDataSource,
				        editable: scope.cEditable,
				        pageable:scope.cPageable,
				        selectable: "cell",
				        navigatable: true,
				        resizable: true,
						
				        //events:		 
				       	dataBinding: function(e) {
				       		console.log("image grid event: binding--"+e.action+" index:"+e.index+" items:"+JSON.stringify(e.items));
				       	},
				       	
				       	dataBound:function(e){
				       		console.log("image grid event: dataBound");
				       	},
				       	
		 		       	save: function(e) {
				       		console.log("image grid event: save");
				         },
				       	
				         //row or cloumn changed
				       	change:function(e){
				       		console.log("image grid event: change");
				       	
			        		if(igw.rowChanged()){
					       		console.log("image grid event: row changed");
					       		setTimeout(function(){
				        			var dataItem=igw.getCurrentDataItem();
				        			showImageDetail(dataItem);
				        			scope.$apply();
					       		},1)
				        			//$state.go('main.lineItem.detail',{orderItemId:orderItemId,lineItemId:dataItem.lineNumber});
			        		};

				       		
				       	}, 
				       	
				        edit:function(e){
				        	console.log("image grid event: edit");
				        	
/* 				        	//without code below,when navigate with keybord like tab key, the editing cell will not be selected 
						    var editingCell=igw.getEditingCell();
						    if(!!editingCell){
						    	this.select(editingCell);
						    } 				        	 */
				        }

			}; //end of imageGridOptions

								
			scope.gridContextMenuOptions={
				closeOnClick:true,
				filter:".gridLineNumber,.gridLineNumberHeader",
				target:'#'+scope.gridName,
				select:function(e){
				
					switch(e.item.id){
						case "menuAdd":
							scope.setting.editing=true;
							if(!igw.isEditing)
								igw.enableEditing(true);
//							addRow(false);
							break;
						case "menuUpload":
							scope.newUploadWindow.open();
							break;
						case "menuRemove":
							deleteRow();
							break;
					}
					
				}
				
			};

			
			scope.newUploadWindowOptions={
					open:function(e){
//						$scope.imageItemToolbar.enable("#btnAdd",false);				
					},
					close:function(e){
//						$scope.imageItemToolbar.enable("#btnAdd");				
					}
			}
			 
			scope.newUploadOptions={
					async:{
						 saveUrl: '../lib/image/upload',
						 removeUrl:'../lib/image/removeupload',
						 autoUpload: false,
						 batch: false   
						 /* The selected files will be uploaded in separate requests */
					},
					
					localization:{
						uploadSelectedFiles: 'Upload'
					},
					upload:function (e) {
					   // e.data = {user: SO.setting.user.userName};
					},
					success: function (e) {
					    if(e.response.status==="success"){
							var data = e.response.data;
							
							if(data){
								scope.cDictImage.addItem(data);
								addRow(data,false);
							}
				    	}
					},
					error:function(e){
			//	 		alert("failed:"+JSON.stringify(e.response.data));
					},
					complete:function(e){
					}
			};
						
			
			scope.getImage=function(imageId){
				return scope.cDictImage.getLocalItem('id',imageId);
			}
			
		
			var newItem=function(dataItem){
				if(!scope.cNewItemFunction)
					scope.cNewItemFunction=function(){
							return {};
						};
				var f=scope.cNewItemFunction();
				return f(dataItem);
			}
			
			var addRow=function(data,isInsert){
				var item=newItem(data);
			    igw.addRow(item,isInsert);
			}
						
			var deleteRow=function (){
				var dataItem=igw.getCurrentDataItem();
		    	var confirmed=true;
			    if (dataItem) {
			        if (dataItem.orderAmt){
			        	confirmed=confirm('Please confirm to remove the selected row.');	
			        }
			        if(confirmed){
				    	if(dataItem.id && scope.cRegisterDeletedItemFunction){
				    		var register=scope.cRegisterDeletedItemFunction();
				    		register(dataItem);
				    	}
						igw.deleteRow(dataItem);
			        }
			    }
		   		else {
		        	alert('Please select a  row to delete.');
		   		}
			    
			}

			showImageDetail=function(dataItem){
				var imageId=dataItem.imageId;
				if(imageId){
					var url="../lib/image/getimage?id="+imageId;
					util.getRemote(url).then(
						function(data, status, headers, config) {
						    	scope.previewOriginalImage=data;
							},
						function(data, status, headers, config) {
								scope.previewOriginalImage=null;
						});					
				}else{
					$scope.previewOriginalImage=null;
				}

			};			
				
		}	//end of imageGrid:link
	}
	
	return directive;
}]);

</script>