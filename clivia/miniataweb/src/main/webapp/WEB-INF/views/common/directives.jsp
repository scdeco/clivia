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

directive('changeOnBlur', function() {
    return {
        restrict: 'A',
        require: 'ngModel',
        link: function(scope, elm, attrs, ngModelCtrl) {
            if (attrs.type === 'radio' || attrs.type === 'checkbox') 
                return;

            var expressionToCall = attrs.changeOnBlur;

            var oldValue = null;
            elm.bind('focus',function() {
                scope.$apply(function() {
                    oldValue = elm.val();
                });
            })
            elm.bind('blur', function() {
                scope.$apply(function() {
                    var newValue = elm.val();
                    if (newValue !== oldValue){
                        scope.$eval(expressionToCall+"('"+oldValue+"','"+newValue+"')");
                    }
                });         
            });
        }
    };
}).

directive('checklistModel', ['$parse', '$compile', function($parse, $compile) {
	  // contains
	  function contains(arr, item, comparator) {
	    if (angular.isArray(arr)) {
	      for (var i = arr.length; i--;) {
	        if (comparator(arr[i], item)) {
	          return true;
	        }
	      }
	    }
	    return false;
	  }

	  // add
	  function add(arr, item, comparator) {
	    arr = angular.isArray(arr) ? arr : [];
	      if(!contains(arr, item, comparator)) {
	          arr.push(item);
	      }
	    return arr;
	  }  

	  // remove
	  function remove(arr, item, comparator) {
	    if (angular.isArray(arr)) {
	      for (var i = arr.length; i--;) {
	        if (comparator(arr[i], item)) {
	          arr.splice(i, 1);
	          break;
	        }
	      }
	    }
	    return arr;
	  }

	  // http://stackoverflow.com/a/19228302/1458162
	  function postLinkFn(scope, elem, attrs) {
	     // exclude recursion, but still keep the model
	    var checklistModel = attrs.checklistModel;
	    attrs.$set("checklistModel", null);
	    // compile with `ng-model` pointing to `checked`
	    $compile(elem)(scope);
	    attrs.$set("checklistModel", checklistModel);

	    // getter / setter for original model
	    var getter = $parse(checklistModel);
	    var setter = getter.assign;
	    var checklistChange = $parse(attrs.checklistChange);
	    var checklistBeforeChange = $parse(attrs.checklistBeforeChange);

	    // value added to list
	    var value = attrs.checklistValue ? $parse(attrs.checklistValue)(scope.$parent) : attrs.value;


	    var comparator = angular.equals;

	    if (attrs.hasOwnProperty('checklistComparator')){
	      if (attrs.checklistComparator[0] == '.') {
	        var comparatorExpression = attrs.checklistComparator.substring(1);
	        comparator = function (a, b) {
	          return a[comparatorExpression] === b[comparatorExpression];
	        };
	        
	      } else {
	        comparator = $parse(attrs.checklistComparator)(scope.$parent);
	      }
	    }

	    // watch UI checked change
	    scope.$watch(attrs.ngModel, function(newValue, oldValue) {
	      if (newValue === oldValue) { 
	        return;
	      } 

	      if (checklistBeforeChange && (checklistBeforeChange(scope) === false)) {
	        scope[attrs.ngModel] = contains(getter(scope.$parent), value, comparator);
	        return;
	      }

	      setValueInChecklistModel(value, newValue);

	      if (checklistChange) {
	        checklistChange(scope);
	      }
	    });

	    function setValueInChecklistModel(value, checked) {
	      var current = getter(scope.$parent);
	      if (angular.isFunction(setter)) {
	        if (checked === true) {
	          setter(scope.$parent, add(current, value, comparator));
	        } else {
	          setter(scope.$parent, remove(current, value, comparator));
	        }
	      }
	      
	    }

	    // declare one function to be used for both $watch functions
	    function setChecked(newArr, oldArr) {
	      if (checklistBeforeChange && (checklistBeforeChange(scope) === false)) {
	        setValueInChecklistModel(value, scope[attrs.ngModel]);
	        return;
	      }
	      scope[attrs.ngModel] = contains(newArr, value, comparator);
	    }

	    // watch original model change
	    // use the faster $watchCollection method if it's available
	    if (angular.isFunction(scope.$parent.$watchCollection)) {
	        scope.$parent.$watchCollection(checklistModel, setChecked);
	    } else {
	        scope.$parent.$watch(checklistModel, setChecked, true);
	    }
	  }

	  return {
	    restrict: 'A',
	    priority: 1000,
	    terminal: true,
	    scope: true,
	    compile: function(tElement, tAttrs) {
	      if ((tElement[0].tagName !== 'INPUT' || tAttrs.type !== 'checkbox') && (tElement[0].tagName !== 'MD-CHECKBOX') && (!tAttrs.btnCheckbox)) {
	        throw 'checklist-model should be applied to `input[type="checkbox"]` or `md-checkbox`.';
	      }

	      if (!tAttrs.checklistValue && !tAttrs.value) {
	        throw 'You should provide `value` or `checklist-value`.';
	      }

	      // by default ngModel is 'checked', so we set it if not specified
	      if (!tAttrs.ngModel) {
	        // local scope var storing individual checkbox model
	        tAttrs.$set("ngModel", "checked");
	      }

	      return postLinkFn;
	    }
	  };
	}]).
	
directive("themeChooser",function(){
	var template='<select kendo-dropdownlist="themeDropDownList"  k-options="listOptions" ></select>'; 
	return {
		restrict:"EA",
		replace:true,
		scope:{
		},
		template:template,
		
		link:function(scope,element){

		    scope.element=element;
		                                              	   
			scope.kendoDropDownList=element.getKendoDropDownList();
			
		    var preloadStylesheet=function(file, callback) {
		        var tempElement = $("<link rel='stylesheet' media='print' href='" + file + "'").appendTo("head");
		        
		        setTimeout(function () {
		            callback();
		            tempElement.remove();
		        }, 100);
		    }
		    
			scope.changeTheme=function(newSkinName, animate) {
			    var oldSkinLink =scope.getSkinLinks().eq(0);
			    var oldSkinName=scope.getSkinName();
		        var url = oldSkinLink.attr("href").replace(oldSkinName, newSkinName );

			    if (animate) {
			        preloadStylesheet(url, replaceTheme);
			    } else {		//replace theme
			    	
			    	var newSkinLink;
			        if (kendo.support.browser.msie) {
			            newSkinLink = document.createStyleSheet(url);
			        } else {
			            newSkinLink = oldSkinLink.clone().attr("href", url);
			            newSkinLink.insertBefore(oldSkinLink);
			        }
			        
			        oldSkinLink.remove();

			        $(document.documentElement).removeClass("k-" + oldSkinName).addClass("k-" + newSkinName);
			    }
			};
		},
		
		controller: ['$scope','util', function($scope,util){

			$scope.getSkinLinks=function(){
				var doc = document,
		        	kendoLinks = $("link[href*='kendo.']", doc.getElementsByTagName("head")[0]),
		        	commonLink = kendoLinks.filter("[href*='kendo.common']"),
		        	skinLinks = kendoLinks.filter(":not([href*='kendo.common'])");
				return skinLinks.eq(0);
			}
			$scope.getSkinName=function(){
				var skinLinks=$scope.getSkinLinks();
                var skinLink=skinLinks.eq(0).attr("href").replace(".min.css","");
                var skinName = skinLink.substring(skinLink.lastIndexOf(".")+1);
                return skinName;
			 }			
			
			$scope.listOptions={
				    dataSource: [
				                { text: "Black", value: "black" },
				                { text: "Blue Opal", value: "blueopal" },
				         		{ text: "Bootstrap", value: "bootstrap" },
				                { text: "Default", value: "default" },
				         		{ text: "Flat", value: "flat" },
				         		{ text: "High Contrast", value: "highcontrast" },
				         		{ text: "Material", value: "material" },
				         		{ text: "Material Black", value: "materialblack" },
				                { text: "Metro", value: "metro" },
				         		{ text: "Metro Black", value: "metroblack" },
				         		{ text: "Moonlight", value: "moonlight" },
				                { text: "Silver", value: "silver" },
				         		{ text: "Uniform", value: "uniform" },
				         		{ text: "Fiori", value: "fiori" },
				         		{ text: "Nova", value: "nova" },
				             ],
				             dataTextField: "text",
				             dataValueField: "value",
				             value:($scope.getSkinName()||"default").toLowerCase(),
				             change: function (e) {
				                 var theme = (this.value() || "default").toLowerCase();
				                 $scope.changeTheme(theme);
			                	 util.getRemote("../service/save-theme?theme="+theme);
				             }	
			}
			
		}]
	}
}).

directive("mapCombobox",function(){
	var template='<input kendo-combobox="comboBox"  k-options="comboBoxOptions" ></input>'; 
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
 							scope.valueChanged(value);
							//scope.kendoComboBox.text(gotItem[scope.cOptions.dataTextField]);
						}
					});
			}
			
			scope.getText=function(){
				return scope.text;
			}
			
			scope.valueChanged=function(newValue){
				if(scope.cOptions.onValueChanged){
					scope.value=newValue;
					
					var di=scope.dataSource.get(newValue);
					scope.text=di?di[scope.cOptions.dataTextField]:null;
					
		    		scope.cOptions.onValueChanged(scope); 
				}
			}
			
			scope.$watch(
					function(){
						return controller.$modelValue
						},
					function(newValue,oldValue){
						if (newValue!=oldValue && (newValue || oldValue)){
							if(!!newValue){
		 						var di=scope.dataSource.get(newValue);
		 						if(!di){
		 							addItem(newValue);
			 					}else{
		 							scope.valueChanged(newValue);
		 						}
	 						}
						}
						
					});
			
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
	                },

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
							if (newValue!==oldValue && (newValue || oldValue)){
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
			
			scope.$on('$destroy',function(){
				////console.log("destroying...");
			})
			
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

			var gridColumns=[{
				title:"Colour",
				template:"<label>#: colour #</label>",
				attributes: {style:"text-align: left;"}
				}];
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
				cGetDetailFunction:'&',
			},
			
			templateUrl:'../common/garmentgrid',
			link:function(scope,element,attrs){
				var tmpId=util.getTmpId();
				scope.element=element;
				scope.gridName=scope.cName+tmpId;
				scope.gridContextMenuName=scope.gridName+"ContextMenu";
				scope.garmentInputWindowName=scope.gridName+"InputWindow";

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
					       		////console.log("event binding:"+e.action+" index:"+e.index+" items:"+JSON.stringify(e.items));
					       		////console.log("event binding:");
					       	},
					       	
					       	dataBound:function(e){
					       		////console.log("event databound:");
					       		
					       	},
					       	
			 		       	save: function(e) {
			 		       		
					       		if( typeof e.values.styleNo!== 'undefined'){		//styleNo changed,ggw.brand.hasInventory &&
						       		
					       			//stop accept the default value,use the value after processed below
			 		       			if(e.values.styleNo===";"){
						       			e.preventDefault();
					       				ggw.copyPreviousRow();
					       				setTimeout(function(){
					       						ggw.calculateTotal();
					       						scope.$apply();	//show changes
											},1);
					       		 	}else if(ggw.brand.hasInventory){
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
				        			if(scope.cGetDetailFunction){
				        				var getDetail=scope.cGetDetailFunction();
				        				getDetail(dataItem);
				        			}				        				
				        		};
					       	},
					       	
					        edit:function(e){
					        	////console.log("event edit:");
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
					
						switch(e.item.textContent){
						case "Add":	
							scope.setting.editing=true;
							if(!ggw.isEditing)
								ggw.enableEditing(true);
							addRow(false);
							break;
						case "Add With dialog...":	
							if(!scope[scope.garmentInputWindowName])
								scope[scope.garmentInputWindowName]=$("#"+scope.garmentInputWindowName).data("kendoWindow");
							scope[scope.garmentInputWindowName].center().open();
							break;
						case "Insert":
							addRow(true);
							break;
						case "Delete":	
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
				var tmpId=util.getTmpId();
				scope.element=element;
				scope.gridName=scope.cName+tmpId;
				scope.gridContextMenuName=scope.gridName+"ContextMenu";

				var bgw=new BillGridWrapper(scope.gridName);	
				bgw.setColumns();
				scope.$on('$destroy', function() {

		      	});
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
				       		////console.log("bill grid event: binding--"+e.action+" index:"+e.index+" items:"+JSON.stringify(e.items));
				       	},
				       	
				       	dataBound:function(e){
				       		////console.log("bill grid event: dataBound");
				       	},
				       	
		 		       	save: function(e) {
				       		////console.log("bill grid event: save");
				       		var model=e.model;
				       		
		 		       		if(typeof e.values.snpId!== 'undefined'){
		 		       			var unit="";
		 		       			if(e.values.snpId){
		 		       				var snpItem=bgw.getSnpItem(e.values.snpId);
		 		       				unit=(snpItem)?snpItem.unit:"";		 		       				
		 		       			}
		 		       			model.set("unit",unit);
		 		       		}
		 		       		if(typeof e.values.orderQty!== 'undefined' || 
		 		       		   typeof e.values.listPrice!== 'undefined'||
		 		       		   typeof e.values.orderPrice!== 'undefined'||
		 		       		   typeof e.values.discount!== 'undefined'){
								
		 		       			e.preventDefault();
			 		       			
		 		       			if(typeof e.values.orderQty!== 'undefined'){
			 		       			model.set("orderQty",e.values.orderQty);
		 		       			}
		 		       			
		 		       			if(typeof e.values.listPrice!== 'undefined'){
		 		       				model.set("listPrice",e.values.listPrice);
			 		       			calculateOrderPrice(model);
		 		       			}
		 		       			
		 		       			if(typeof e.values.discount!== 'undefined'){
		 		       				model.set("discount",e.values.discount);
			 		       			calculateOrderPrice(model);
			 		       			
		 		       			}
		 		       			
		 		       			if(typeof e.values.orderPrice!== 'undefined'){
		 		       				model.set("orderPrice",e.values.orderPrice);
		 		       				if(model.listPrice>0){
		 		       					var discount=(1-e.values.orderPrice/model.listPrice);
		 		       					model.set("discount",discount);
		 		       				}
		 		       			}
		 		       			model.set("orderAmt",(model.orderQty?model.orderQty:0)*(model.orderPrice?model.orderPrice:0));
		 		       			
		 		       			bgw.updateTemplateColumn(e,"orderAmt");
		 		       			//value in model have not been set into dataitems in bgw.so wait for the update finish.
		 		       			setTimeout(function(){
		 		       					bgw.calculateTotal();
		 		       					scope.$apply();
		 		       				},1);

		 		       		}
				         },
				       	
				         //row or cloumn changed
				       	change:function(e){
				       		////console.log("bill grid event: change");
				       	
			        		if(bgw.rowChanged()){
					       		////console.log("bill grid event: row changed");
					       		setTimeout(function(){
				        			var dataItem=bgw.getCurrentDataItem();
				    				if(scope.cGetBillDetailFunction){
				    					var getDetail=scope.cGetBillDetailFunction();
				    					getDetail(dataItem);
					        			scope.$apply();
				    				}
					       		},1)
			        		};

				       		
				       	}, 
				       	
				        edit:function(e){
				        	////console.log("bill grid event: edit");
				        	
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
					
					switch(e.item.textContent){
						case "Add":
							scope.setting.editing=true;
							if(!bgw.isEditing)
								bgw.enableEditing(true);
							addRow(false);
							break;
						case "Insert":
							addRow(true);
							break;
						case "Delete":
							deleteRow();
							break;
					}
					
				}
				
			};
			
			//calculate and set orderPrice of model based on listPrice and discount 
			var calculateOrderPrice=function(model){
				var result=0,discount=model.discount,listPrice=model.listPrice;
				if(listPrice>0 && discount>=0 && discount<1){
					result=listPrice*(1-discount);
					result=result?result.toFixed(2):result;
					model.orderPrice=result;
				}
				return result;
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
				var tmpId=util.getTmpId();
				scope.element=element;
				scope.gridName=scope.cName+tmpId;
				scope.gridContextMenuName=scope.gridName+"ContextMenu";
				
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
				       		////console.log("image grid event: binding--"+e.action+" index:"+e.index+" items:"+JSON.stringify(e.items));
				       	},
				       	
				       	dataBound:function(e){
				       		////console.log("image grid event: dataBound");
				       	},
				       	
		 		       	save: function(e) {
				       		////console.log("image grid event: save");
				         },
				       	
				         //row or cloumn changed
				       	change:function(e){
				       		////console.log("image grid event: change");
				       	
			        		if(igw.rowChanged()){
					       		////console.log("image grid event: row changed");
					       		setTimeout(function(){
				        			var dataItem=igw.getCurrentDataItem();
				        			showImageDetail(dataItem);
				        			scope.$apply();
					       		},1)
			        		};

				       		
				       	}, 
				       	
				        edit:function(e){
				        	////console.log("image grid event: edit");
				        	
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
				cName:'@imageView',
				cEditable:'=',
				cDataSource:'=',
				cPageable:'=',
				cDictImage:'=',
				cNewItemFunction:'&',
				cRegisterDeletedItemFunction:'&',
			},
			
			templateUrl:'../common/imageview',
			link:function(scope,element,attrs){	
				
				var tmpId=util.getTmpId();
				scope.element=element;
				scope.gridName=scope.cName+tmpId;
				scope.gridContextMenuName=scope.gridName+"ContextMenu";

				var gw=new ImageGridWrapper(scope.gridName);	
				gw.setColumns();
				
				scope.$on("kendoWidgetCreated", function(event, widget){

					if (widget ===scope[scope.gridName]) {
			        	gw.wrapGrid(widget);
			        	
			        	if(scope.cName){
				        	scope.$parent[scope.cName]={
			        			name:scope.cName,
			        			grid:widget,
			        			gridWrapper:gw,
			        			resize:function(gridHeight){
			        				gw.resizeGrid(gridHeight);
			        				},
				        	}
			        	}
			        }
			    });	

				scope.setting={};
				scope.setting.editing=true;
				
				scope.gridSortableOptions = gw.getSortableOptions();
				
				scope.gridOptions = {
						autoSync: true,
				        columns: gw.gridColumns,
				        dataSource: scope.cDataSource,
				        editable: scope.cEditable,
				        pageable:scope.cPageable,
				        selectable: "cell",
				        navigatable: true,
				        resizable: true,
						
				        //events:		 
				       	dataBinding: function(e) {
				       		//console.log("image grid event: binding--"+e.action+" index:"+e.index+" items:"+JSON.stringify(e.items));
				       	},
				       	
				       	dataBound:function(e){
				       		//console.log("image grid event: dataBound");
				       	},
				       	
		 		       	save: function(e) {
				       		//console.log("image grid event: save");
				         },
				       	
				         //row or cloumn changed
				       	change:function(e){
				       		//console.log("image grid event: change");
				       	
			        		if(gw.rowChanged()){
					       		//console.log("image grid event: row changed");
					       		setTimeout(function(){
				        			var dataItem=gw.getCurrentDataItem();
				        			showImageDetail(dataItem);
				        			scope.$apply();
					       		},1)
			        		};

				       		
				       	}, 
				       	
				        edit:function(e){
				        	//console.log("image grid event: edit");
				        	
/* 				        	//without code below,when navigate with keybord like tab key, the editing cell will not be selected 
						    var editingCell=gw.getEditingCell();
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
				
					switch(e.item.textContent){
						case "menuAdd":
							scope.setting.editing=true;
							if(!gw.isEditing)
								gw.enableEditing(true);
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
							handleSuccess(e.response.data);
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
			    gw.addRow(item,isInsert);
			}
						
			var deleteRow=function (){
				var dataItem=gw.getCurrentDataItem();
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
						gw.deleteRow(dataItem);
			        }
			    }
		   		else {
		        	alert('Please select a  row to delete.');
		   		}
			    
			}

			var showImageDetail=function(dataItem){
				var imageId=dataItem.imageId;
				if(imageId){
					var url="../lib/image/getimage?base64=true&id="+imageId;
					util.getRemote(url).then(
						function(data, status, headers, config) {
						    	scope.previewOriginalImage=data;
							},
						function(data, status, headers, config) {
								scope.previewOriginalImage=null;
						});					
				}else{
					scope.previewOriginalImage=null;
				}

			};		
			
			scope.handlePaste=function(e) {
				var items=e.originalEvent.clipboardData.items;
			    for (var i = 0 ; i < items.length ; i++) {
			        var item = items[i];
			        //console.log("Item: " + item.type);
			        item.getAsString(function(s){
			        	//console.log("-----"+s);
			        	});
			       
			        if (item.type.indexOf("image")!==-1) {
			            util.uploadImage(item.getAsFile(),'../lib/image/upload').then(
			            		function(e){
			            			if(!e.message)
				            			handleSuccess(e.data);
			            			});
			           
			        } else {
			            //console.log("Discardingimage paste data");
			        }
			    }
			}
			
			var handleSuccess=function(data){
				if(data){
					scope.cDictImage.addItem(data);
					addRow(data,false);
				}
			}

				
		}	//end of imageGrid:link
	}
	
	return directive;
}]).

directive('embDesignView',["DesignGridWrapper","cliviaDDS","util",function(DesignGridWrapper,cliviaDDS,util){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@designView',
				cEditable:'=',
				cPageable:'=',

				cEmbDataSource:'=',
				cColourwayDataSource:'=',
				
				cNewEmbItemFunction:'&',
				cNewColourwayItemFunction:'&',
				
				cRegisterDeletedEmbItemFunction:'&',
				cRegisterDeletedColourwayItemFunction:'&',
			},
			
			templateUrl:'../common/designview',
			link:function(scope,element,attrs){	
				
				var tmpId=util.getTmpId();
				scope.element=element;
				scope.gridName=scope.cName+tmpId;
				scope.gridContextMenuName=scope.gridName+"ContextMenu";

				var gw=new DesignGridWrapper(scope.gridName);	
				gw.setColumns();
				
				scope.$on("kendoWidgetCreated", function(event, widget){

					if (widget ===scope[scope.gridName]) {
			        	gw.wrapGrid(widget);
			        	
			        	if(scope.cName){
				        	scope.$parent[scope.cName]={
			        			name:scope.cName,
			        			grid:widget,
			        			gridWrapper:gw,
			        			resize:function(gridHeight){
			        				gw.resizeGrid(gridHeight);
			        				},
				        	}
			        	}
			        }
			    });	

				scope.setting={};
				scope.setting.editing=true;
				
				scope.gridSortableOptions = gw.getSortableOptions();
				
				scope.gridOptions = {
						autoSync: true,
				        columns: gw.gridColumns,
				        dataSource: scope.cDataSource,
				        editable: scope.cEditable,
				        pageable:scope.cPageable,
				        selectable: "cell",
				        navigatable: true,
				        resizable: true,
				         //row or cloumn changed
				       	change:function(e){
				       	
				       	}, 
				       	
				        edit:function(e){
				        	
/* 				        	//without code below,when navigate with keybord like tab key, the editing cell will not be selected 
						    var editingCell=gw.getEditingCell();
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
				
					switch(e.item.textContent){
						case "Add":
							scope.setting.editing=true;
							if(!gw.isEditing)
								gw.enableEditing(true);
							addRow(false);
							break;
						case "Insert":
							scope.setting.editing=true;
							if(!gw.isEditing)
								gw.enableEditing(true);
							addRow(true);
							break;
						case "Delete":
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
				var f=scope.cNewItemFunction();
				return f();
			}
			
			var addRow=function(isInsert){
				var item=newItem();
			    gw.addRow(item,isInsert);
			}
						
			var deleteRow=function (){
				var dataItem=gw.getCurrentDataItem();
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
						gw.deleteRow(dataItem);
			        }
			    }
		   		else {
		        	alert('Please select a  row to delete.');
		   		}
			    
			}

				
		}	//end of designView:link
	}
	
	return directive;
}]).	//end of designView:directive

directive('cliviaGrid',["cliviaGridWrapperFactory","cliviaDDS","util",function(cliviaGridWrapperFactory,cliviaDDS,util){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@cliviaGrid',
				cGridWrapperName:'=',
				cCallFrom:'=',
				cEditable:'=',
				cDataSource:'=',
				cPageable:'=',
				cNewItemFunction:'&',
				cRegisterDeletedItemFunction:'&',
			},
			
			templateUrl:'../common/cliviagrid',
			link:function(scope,element,attrs){	
				var tmpId=util.getTmpId();
				scope.element=element;
				scope.gridName=scope.cName+tmpId;
				scope.gridContextMenuName=scope.gridName+"ContextMenu";

				var gw=cliviaGridWrapperFactory.getGridWrapper(scope.cGridWrapperName,scope.gridName,scope.cCallFrom);	
				
				scope.$on("kendoWidgetCreated", function(event, widget){

					if (widget ===scope[scope.gridName]) {
			        	gw.wrapGrid(widget);
			        	
			        	if(scope.cName){
				        	scope.$parent[scope.cName]={
			        			name:scope.cName,
			        			grid:widget,
			        			gridWrapper:gw,
			        			resize:function(gridHeight){
			        					gw.resizeGrid(gridHeight);
			        				},
				        	}
			        	}
			        }
			    });	
				

				scope.setting={};
				scope.setting.editing=true;
				
				scope.gridSortableOptions = gw.getSortableOptions();
				
				scope.gridOptions = {
						autoSync: true,
				        columns: gw.gridColumns,
				        dataSource: scope.cDataSource,
				        editable: scope.cEditable,
				        pageable:scope.cPageable,
				        selectable: "cell",
				        navigatable: true,
				        resizable: true,
						
				        //events:		 
				       	dataBinding: function(e) {
				       		//console.log("grid event: binding--"+e.action+" index:"+e.index+" items:"+JSON.stringify(e.items));
				       	},
				       	
				       	dataBound:function(e){
				       		//console.log("grid event: dataBound");
				       	},
				       	
		 		       	save: function(e) {
				       		//console.log("grid event: save");
				         },
				       	
				         //row or cloumn changed
				       	change:function(e){
				       		//console.log("grid event: change");
				       	}, 
				       	
				        edit:function(e){
				        	//console.log("grid event: edit");
				        	
/* 				        	//without code below,when navigate with keybord like tab key, the editing cell will not be selected 
						    var editingCell=gw.getEditingCell();
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
				
					switch(e.item.textContent){
						case "Add":
							scope.setting.editing=true;
							if(!gw.isEditing)
								gw.enableEditing(true);
							addRow(false);
							break;
						case "Insert":
							addRow(true);
							break;
						case "Delete":
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
			    gw.addRow(item,isInsert);
			}
						
			
			var deleteRow=function (){
				var dataItem=gw.getCurrentDataItem();
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
						gw.deleteRow(dataItem);
			        }
			    }else {
		        	alert('Please select a  row to delete.');
		   		}
			    
			}
		}
	}
	
	return directive;
}]).


directive('queryGrid',["cliviaDDS","util",function(cliviaDDS,util){
	var directive={
			restrict:'EA',
			replace:false,	//must set to false, otherwise will cause error Error: $compile:multidir
			scope:{
				cName:'@queryGrid',
				cGridNo:'=',
				cGridData:'=',	//{info: , columnItems, deleteds:}
				cOptions:'=',
				
			},
			
			template:'<div kendo-grid="queryGrid" k-options="query.gridOptions" k-rebind="query.rebind" ></div>',
			link:function(scope,element,attrs){	
				
				scope.gridName=scope.cName;
				if(scope.cName)
		        	scope.$parent[scope.cName+"Scope"]=scope;
				
				
				scope.createGrid=function(gridNo){
					if(gridNo){					
						var url="../gd/get-grid?gridNo="+gridNo;

						util.getRemote(url).then(
							function(data){
								if(data){
									scope.dataSet=data;
									scope.query.gridOptions=getGridOptions();
									scope.query.rebind++;
								}
							}
						);
				    }else if(scope.cGridData){	//used in grid define: gd-script.jsp to preview grid
				    	scope.dataSet=scope.cGridData;
						scope.query.gridOptions=getGridOptions();
						scope.query.rebind++;	
						scope.$apply();
				    }
				};
				
				
				
				var getDataSource=function(){
					var info=scope.dataSet.info;
					if(info.daoName){
						var url=info.dataUrl?info.dataUrl : "../datasource/"+info.daoName+"/read";
						var fields={};
						var columnItems=scope.dataSet.columnItems;
						
						for(var i=0,column;i<columnItems.length;i++){
							column=columnItems[i];
							if(column.dataType){
								fields[column.name]={type:column.dataType};
							}
						}
						
						return {
							transport: {
							    read: {
							        url:url, 		//'../datasource/orderInfoViewDao/read',
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
							pageSize: info.pageSize?info.pageSize:25,
							serverPaging: true,
							serverFiltering: true,
							serverSorting: true,

	/* 						sort: [{
						         field: "orderNumber",
						         dir: "asc"
						     }], 
	 */						schema: {
							    data: "data",
							    total: "total",
							    model: {fields:fields},
							},
						}
					}else{
						
					}
					
				}; //end of getDataSource()
				
				var showLineNumber=function(grid){
		   	   		 var pageSkip = (grid.dataSource.page() - 1) * grid.dataSource.pageSize();
	   	   		 
		   	   		 pageSkip=!pageSkip? 1:++pageSkip;
	   	   		 
	   	   		 	//index starts from 0
		   	   		 grid.tbody.find('td.gridLineNumber').text(function(index){
	   	   				return pageSkip+index;
	   	   				});	
				};
				
				var getColumns=function(){

					var columns=scope.dataSet.info.showLineNo?[{
				        name:"lineNumber",
				        title: "#",
				        attributes:{class:"gridLineNumber"},
				        headerAttributes:{class:"gridLineNumberHeader"},
				        width: 35,
					}]:[];

					columnItems=scope.dataSet.columnItems;
					
					for(var i=0,col,column;i<columnItems.length;i++){
						column=columnItems[i];		
						col={field:column.name};
					
						if(!!column.title)
							col.title=column.title;
						
						if(!!column.template)
							col.template=column.template;

						if(column.width>=0)
							col.width=column.width;
						
						if(column.displayFormat)
							col.format=column.displayFormat;
						if(column.sortable===false)
							col.sortable=false;
						
						if(column.filterable===false)
							col.filterable=false;
						
						if(column.filterable){
							col.filterable=column.filterable===true?true:JSON.parse(column.filterable);
						}
						
						if(column.hidden)
							col.hidden=true;
						
						if(column.locked)
							col.locked=true;
						
						if(column.textAlign)
							col.attributes={style:"text-align:"+column.textAlign+";"};

						if(column.textAlignFixed)
							col.headerAttributes={style:"text-align:"+column.textAlign+";"};
						
						
						columns.push(col);
					}
					return columns;
				}; //end of getColumns()
				
				var getGridOptions=function(){
					var info=scope.dataSet.info;
					var options={
							
						dataSource:getDataSource(),
						columns:getColumns(),
						
						reorderable:info.columnMovable,
						resizable:info.columnResizable,
						filterable:info.filterable,
						groupable: info.groupable,
						
						selectable: "multiple cell",
					    allowCopy: true,
					    excel: {
			                allPages: true
			            },
						
					    pageable: {
					    	pageSizes:["all",40,35,30,25,20,15,10,5],
					        refresh: true,
					        buttonCount: 5
					    },
					    
					    dataBound:function(e){
					    	showLineNumber(this);
					    }
					};
					
					if(info.sortable)
						options.sortable={ allowUnsort: true};

					return options;
				};	//end of getGridOptions()
			
			},	//end of queryGrid:link
			
		controller: ["$scope","cliviaDDS",
			            function($scope,cliviaDDS){
			
			$scope.query={
					rebind:0,
					gridNo:"",
					filterable:{mode:"row"},
			}
			
			$scope.dataSet={};
				
			$scope.$watch("cGridNo",function(newValue,oldValue){
				if(newValue && newValue!==$scope.query.gridNo){
					$scope.createGrid(newValue);					
					$scope.query.gridNo=newValue;
				}
			});
			
			var onDoubleClick=function(e){
				$scope.cOptions.doubleClickEvent.call($scope.queryGrid,e);
			}
			
			if($scope.cOptions && $scope.cOptions.doubleClickEvent)
				$scope.$on("kendoWidgetCreated", function(event, widget){
					if (widget ===$scope.queryGrid){
						var self=widget;					
						widget.bind("dataBound",function(e){
							this.tbody.find("tr").dblclick(onDoubleClick);
						});
					}
				});
			
		}]
	}
	
	return directive;
}]);


</script>