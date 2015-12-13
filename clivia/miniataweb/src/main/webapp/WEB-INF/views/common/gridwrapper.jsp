<script>

angular.module("clivia",["kendo.directives" ]).

factory("util",["$http","$q",function($http,$q){
	return {
		find:function(items,propertyName,propertyValue){
			var result=null;
			for (var i = 0; i <items.length; i++) {
			    if (items[i][propertyName] === propertyValue) {
			    	result=items[i];
			    	break; 
			    }
			}
			return result;
		},
		
		getRemote:function(url){
			var deferred = $q.defer();
			$http.get(url).
				success(function(data, status, headers, config) {
					if(data){
						deferred.resolve(data)
					}else{
						deferred.reject("error:1");
					}
				}).
				error(function(data, status, headers, config) {
					deferred.reject("error:2");
				});			
			
			return deferred.promise;
		}
	}	
}]).

factory("DataDict",["$q","util",function($q,util){
	
	var DataDict=function(name,url,mode){
		if(name.name){
			this.name=name.name;
			this.url=name.url;
			this.loadMode=!!name.mode?name.mode:"lazy";		//lazy,onDemand,eager
		}else{
			this.name=name;
			this.url=url;
			this.loadMode=!!mode?mode:"lazy";		//lazy,onDemand,eager
		}
		this.items=[];
		this.isLoading=false;
		this.isLoaded=false;
		this.waitingDeferred=[];
		if(this.loadMode==="eager")
			this.load();
	}
	
	DataDict.prototype={
		clear:function(){
			this.isLoaded=false;
			this.items.splice(0,this.items.length);
		},
		
		addItem:function(item){
			this.items.push(item);
		},
		
		waitForLoaded:function(deferred){
			this.waitingDeferred.unshift(deferred);
			if(this.waitingDeferred.length===1){
				var url=this.url,
					self=this;
				
				util.getRemote(url)
					.then(function(loaded){
						self.finishLoading(true,loaded);
					},function(error){
						self.finishLoading(false,error);
					});
			}
		},
		
		startLoading:function(deferred){
			this.isLoading=true;	
			this.isLoaded=false;
			this.items.splice(0,this.items.length);
			this.waitForLoaded(deferred);
		},
		
		finishLoading:function(succeed,response){
			this.isLoading=false;
			if(succeed){
				if(response){
					this.isLoaded=true;
					this.items=response;
				}else{
					this.isLoaded=false
				}
			}else{
				this.isLoaded=false;
			}
			while(this.waitingDeferred.length>0){
				var deferred=this.waitingDeferred.pop();
				if(this.isLoaded)
					deferred.resolve(this.items);
				else
					deferred.reject("error");
			}
		},
		
		load:function(){
			var deferred = $q.defer();
			
			if(this.isLoading){
				this.waitForLoaded(deferred);
			}else{
				this.startLoading(deferred);
			}
			return deferred.promise;
		},
		
		
		loadItem:function(name,value){
			var deferred = $q.defer()
				self=this,
				url=this.url+"getitem?name="+name+"&value="+value;
			
			util.getRemote(url)
				.then(function(gotItem){
					if(gotItem){
			    		self.addItem(gotItem);
					}
					deferred.resolve(gotItem);
			},function(error){
				deferred.reject(error);
			});
			
			return deferred.promise;
		},
		
		loadItems:function(name,strValues){
			var deferred = $q.defer();

			self=this,
			url=this.url+"getitems?name="+name+"&value="+strValues;
		
			util.getRemote(url)
				.then(function(gotItems){
					if(gotItems){
						for(var i=0,item;i<gotItems.length;i++){
							item=gotItems[i];
				    		self.addItem(item);
						}
					}
					deferred.resolve(gotItems);
				},function(error){
					deferred.reject(error);
				});
			
			return deferred.promise;
		},
		
		
		
		//find the item in local item list only. 
		getLocalItem:function(name,value){
			return util.find(this.items,name,value);
		},
		
		getLocalItems:function(name,values){
			var valueList=values.split(",");
			var items=[]
			for(var i=0,item,value;i<valueList;i++){
				value=valueList[i];
				item=this.getLocalItem(name,value)
				if(item){
					items.push(item);
				}
			}
			return items;
		},
		
		//Return a promise.If resolved,data is the none null item;otherwise rejected with error info
		//If item is not catched, load it
		getItem:function(name,value){
			var deferred = $q.defer();
			var foundItem=null,self=this;
			
			if(this.loadMode==="onDemand"){
				foundItem=this.getLocalItem(name,value);
				if(foundItem){
					deferred.resolve(foundItem);
				}else{
					this.loadItem(name,value)
						.then(function(foundItem){
							if(foundItem)	//succeed
								deferred.resolve(foundItem);
							else
								deferred.reject("error:can not find");
						},function(error){
							deferred.reject(error);
						});
				}
			}else{
				if(this.isLoaded){
					foundItem=this.getLocalItem(name,value);
					if(foundItem)
						deferred.resolve(foundItem);
					else
						deferred.reject(foundItem);
				}else{
					this.load()
						.then(function(loaded){
							var foundItem=self.getLocalItem(name,value);
							if(foundItem)
								deferred.resolve(item);
							else
								deferred.reject("error:can not find");
						},function(error){
							deferred.reject(error);
						});
				}
			}
			return deferred.promise;
		},
		
		getItems:function(name,values){
			var deferred = $q.defer(),
				self=this;
			
			//get all items if name is not provided (call by getItems())
			if(!name){
				if(this.isLoaded){
					deferred.resolve(this.items);
				}else{
					this.load()
						.then(function(){
							deferred.resolve(self.items)
						},function(){
							deferred.reject("error");
						});
				}
			}else{

				var items=[];
				if(this.loadMode==="onDemand"){
					var valueList=values.split(",");
					var getValues=[];
					for(var i=0,item,value;i<valueList.length;i++){
						value=valueList[i];
						item=this.getLocalItem(name,value)
						if(item){
							items.push(item);
						}else{
							getValues.push(value);
						}
					}
				
					if(getValues.length>0){
						this.loadItems(name,getValues.join())
							.then(function(loadedItems){
								if(loadedItems){
									for(var i=0;i<loadedItems.length;i++){
										items.push(loadedItems[i]);
									}
									deferred.resolve(items)
								}else{
									deferred.reject("error");
								}
								
							},function(error){
								deferred.reject(error)
							});
					}else{
						deferred.resolve(items);
					}
					
				}else{
					if(this.isLoaded){
						items=this.getLocalItems(name,values);
						if(items.length>0){
							deferred.resolve(items);
						}else{
							deferred.reject("error");
						}
					}else{
						this.load()
							.then(function(){
								items=self.getLocalItems(name,values);
								if(items.length>0){
									deferred.resolve(items);
								}else{
									deferred.reject("error");
								}
							},function(){
								deferred.reject("error");
							});
					}
				}
			}
			
			return deferred.promise;
		}
			
	};
	
	return DataDict;
}]).


factory("DataDictSet",["DataDict","util", function(DataDict,util){
	var dds=function(dicts){
		this.dicts=[];
		this.addDicts(dicts);
	}
	
	dds.prototype={
			
		createDict:function(name,url,mode){
			return new DataDict(name,url,mode);		
		},
		
	
		getDict:function(name){
			return util.find(this.dicts,"name",name);
		},
		
		
		getDicts:function(strNames){
			var result=[];
			var names=strNames.split(",");
			for(var i=0,dict;i<names.length;i++){
				dict=this.getDict(names[i].trim());
				if(dict)
					result.push[dict];
			}
			return result;
		},

		addDict:function(dict){
			if(dict) {
				this.dicts.push(dict);
			}
		},
		
		//dicts is a array of {name,url,mode}
		addDicts:function(dicts){
			if(dicts){
				for(var i=0,dict;i<dicts.length;i++){
					dict=this.createDict(dicts[i]);
					this.addDict(dict);
				}
			}
		},
		
		//load eager dict only
		load:function(){
			for(var i=0,dict;i<this.dicts.length;i++){
				dict=this.dicts[i];
				if(dict.loadMode==="eager")
					dict.load();
			}
		},
			
	};
	
	return dds;
}]).
//data dictionary set
factory("cliviaDDS",["DataDictSet","consts",function(DataDictSet,DataDict,consts){
	var baseUrl="/miniataweb/";
	var dicts=[{
			name:"customerInput",
			url:baseUrl+"dict/map?from=company&textField=businessName&valueField=id&orderBy=businessName",
			mode:"eager"
		},{
			name:"garment",
			url:baseUrl+"/data/garment/",
			mode:"onDemand"
		}];
	
	var cliviaDDS=new DataDictSet(dicts);
	return cliviaDDS
}]).

//dataSource set
factory("cliviaDSS",["cliviaDDS",function(cliviaDDS){
	var customerInput=new kendo.data.DataSource({
		 transport: {
 	        read: {
 	            url: '/miniataweb/dict/map?from=company&textField=businessName&valueField=id&orderBy=businessName',
 	            type: 'get',
 	            dataType: 'json',
  	            contentType: 'application/json'
 	        	}
			} 		
	});

	return{
		customerInput:customerInput,
	}	
}]).

factory("GridWrapper",function(){
			//constructor, need a kendoGrid's name
			var GridWrapper=function(gridName,gridColumns){
				this.gridName=gridName;
				this.grid=null;
				this.gridColumns=!!gridColumns?gridColumns:[];
				this.editingRowUid="";
				this.reorderRowEnabled=false;
				this.isEditing=true;
				this.enterKeyDown=false;
				this.enterMoveDown=false;
			}
			
			
			GridWrapper.prototype.setConfig=function(config){
				if(config){
					if(typeof config.columns!=='undefined')
						this.gridColumns=config.columns;
				}
			}
			
			GridWrapper.prototype.setColumns=function(columns){
				this.gridColumns=columns;
			}
			
			GridWrapper.prototype.enableEnterMoveDown=function(){
				this.enterMoveDown=true;
			}
			
			GridWrapper.prototype.getGridColumn=function(fieldName){
				var columns=this.gridColumns;
				var result="";
				for(var i=0;i<columns.length;i++){
					if(columns[i].field===fieldName){
						result=columns[i];
						break;
					}
				}
				return result;
			}
			
			//call this method in kendoWidgetCreated event
			GridWrapper.prototype.wrapGrid=function(grid){
				this.grid=grid;					//$("#"+this.gridName).data("kendoGrid");
				
				var showLineNumber=function(grid){
		   	   		 var pageSkip = (grid.dataSource.page() - 1) * grid.dataSource.pageSize();
	   	   		 
		   	   		 pageSkip=!pageSkip? 1:pageSkip++;
	   	   		 
	   	   		 	//index starts from 0
		   	   		 grid.tbody.find('td.gridLineNumber').text(function(index){
	   	   				return pageSkip+index;
	   	   				});	
				}
				
				//if name of the first column is "lineNumbershow, show lineNumber 
				if(this.gridColumns[0].name==="lineNumber"){
					this.grid.bind("dataBound",function(e){
						//e.sender is this.grid
			   	   		 showLineNumber(e.sender);
					});
				}
				//dataBound event triggered before wrapped
				showLineNumber(this.grid);
				
				if(this.enterMoveDown){
					var self=this;
					this.grid.tbody.bind('keydown', function (e) {
						if(self.enterMoveDown && e.keyCode === 13 ){
							self.enterKeyDown=true;
							console.log("keydown in wrapper:");
							// stop bubbling up of this event
					        e.stopPropagation();
						}
	                });
					this.grid.bind('save',function(e){
						if(self.enterMoveDown)
							if(self.enterKeyDown){
								self.enterKeyDown=false;
								console.log(self.gridName+" save in wrapper:");
								var row=self.getEditingRow();
								var cell=self.getEditingCell();
								if(row && cell){
							        var cellToEdit = $(row).next().find('td:eq('+cell.cellIndex+')');
				                    self.grid.editCell(cellToEdit);
								}
							}
					});
					
	            }			
			}
			
			
			GridWrapper.prototype.getDataItemIndexByRowIndex=function (rowIndex){
				if(!this.grid) return null;
				var row=this.getRow(rowIndex);
				var dataItem=this.getDataItemByRow(row);
				return this.getDataItemIndex(dataItem);
			}

			GridWrapper.prototype.getDataItemByRow=function (row){
				if(!this.grid) return null;
				return (!!row)?this.grid.dataItem(row):null;
			}
				
			GridWrapper.prototype.getDataItemByIndex=function (index){
				if(!this.grid) return null;
				var data=this.grid.dataSource.data();
				return (index>=0 && index<data.length)?data[index]:null;
			}
			GridWrapper.prototype.getDataItemIndex=function (dataItem){
				if(!this.grid) return null;
				var index = (!!dataItem)?this.grid.dataSource.indexOf(dataItem):null;
				console.log("dataItem index:"+index);
				return index;
			}
				
			GridWrapper.prototype.getCurrentDataItem=function (){
				if(!this.grid) return null;
				var row=this.getCurrentRow();
				return this.getDataItemByRow(row);
			}
				
			GridWrapper.prototype.getCurrentDataItemIndex=function (){
				if(!this.grid) return null;
				var dataItem= this.getCurrentDataItem();
				var idx = this.getDataItemIndex(dataItem);
				return idx;
			}

			GridWrapper.prototype.getRow = function(index){
				if(!this.grid) return null;
				return this.grid.tbody.children().eq(index);
			}

			//index starts from 0
			GridWrapper.prototype.getRowIndex=function (row){
				if(!this.grid) return null;
				 var index=(!!row)?($("tr", this.grid.tbody).index(row)):null;
					console.log("getRowIndex:"+index);
				 return index;
			}
				
			GridWrapper.prototype.getEditingCell=function (){
				if(!this.grid) return null;
				var cells=$("td.k-edit-cell",this.grid.tbody.children()).first();
				return cells.length>0?cells[0]:null;
			}
			
			GridWrapper.prototype.getCurrentCell=function(){
				if(!this.grid) return null;
				var cell=this.getEditingCell();
				if(!cell){
					cell=this.grid.current();
					if(cell)
						cell=cell[0];
				}
				return cell;
			}
				
			GridWrapper.prototype.getEditingRow=function (){
				if(!this.grid) return null;
				var cell=this.getEditingCell();
				var row=(!!cell)?$(cell).closest("tr"):null;
				return row?row[0]:null; 
			}
			
			GridWrapper.prototype.getCurrentRow=function(){
				if(!this.grid) return null;
				var cell=this.getCurrentCell();
				var row=(!!cell)?$(cell).closest("tr"):null;
				return row?row[0]:null; 
			}
			
			GridWrapper.prototype.getCurrentRowIndex=function (){
				if(!this.grid) return null;
				var index=this.getRowIndex(this.getCurrentRow());
				return index;
			}

			//lineNumber starts from 1
			GridWrapper.prototype.setLineNumber=function (){
				var ds=this.grid.dataSource;
				var dataItems=ds.view();
				var skip = !!ds.skip()?ds.skip():0;
				for(var i=0;i<dataItems.length;i++){ 
					dataItems[i].lineNumber=i+skip+1;
				}
			}
				
			GridWrapper.prototype.addRow=function (dataItem,isInsert){
		        var dataSource =this.grid.dataSource;

		        if(!isInsert){ //append to last row
				    dataSource.add(dataItem);
				    this.setLineNumber();
				    if(dataSource.totalPages()>1)		//without the line will casue problem when add row  
				    	dataSource.page(dataSource.totalPages());
			    	this.grid.editRow(this.grid.tbody.children().last());
			    }else{		//insert before current row
						var rowIdx =this.getCurrentRowIndex();
			    	var idx = this.getCurrentDataItemIndex();
				    dataSource.insert((!!idx)?idx:0,dataItem);
				    this.setLineNumber();
			    	this.grid.editRow(this.getRow(rowIdx));
			    }
		        var cell=this.getEditingCell();
		        if(cell) this.grid.current(cell);
			}		
			
			GridWrapper.prototype.deleteRow=function (dataItem){
			    if (dataItem) {
		        	this.grid.dataSource.remove(dataItem);
		        	this.currentRow=-1;
		        	this.setLineNumber();
		        	this.grid.table.focus();
			    }					
			}		
			
			

			GridWrapper.prototype.copyPreviousRow=function(){
				var idx=this.getCurrentRowIndex();
				if(idx>0){
					dis=this.grid.dataSource.view();
					diFrom=dis[idx-1];
					diTo=dis[idx];
		 			for(var i=1;i<this.gridColumns.length;i++){
		 				var field=this.gridColumns[i].field;
		 				if(typeof diFrom[field] !=='undefined')
		     		 		diTo[field]=diFrom[field];
		 			}
				}
//		 		var dataItem=this.getCurrentDataItem();
//		  		var dataItemIndex=this.getCurrentDataItemIndex();
//		 		var copiedDataItem=this.getDataItemByIndex(dataItemIndex-1);
//		  		if(!!copiedDataItem){
//		  			for(var i=1;i<this.gridColumns.length;i++){
//		  				if(typeof copiedDataItem[this.gridColumns[i].field] !=='undefined')
//		      		 			dataItem[this.gridColumns[i].field]=copiedDataItem[this.gridColumns[i].field];
//		  			}
//		  		}
			}

			
			GridWrapper.prototype.getSortableOptions=function (){
				var self=this;		
				return 	{
					 filter: ".k-grid tr[data-uid]:not(.k-grid-edit-row)",			
		             hint: $.noop,
		             cursor: "move",
		             placeholder: function(element) {
		                 return element.clone().addClass("k-state-hover").css("opacity", 0.65);
		             },
		             container:"#"+this.gridName+ " tbody",
		             change: function(e) {
		             	 var ds=self.grid.dataSource,
		                 	 idx=self.getDataItemIndexByRowIndex(e.newIndex),
		                 	 di= ds.getByUid(e.item.data("uid"));
		                 ds.remove(di);
		                 ds.insert(idx, di);
		 				 self.setLineNumber();
		                 ds.sync();
		                 
		                 if(typeof self.dragSorted!='undefined')
		                	 self.dragSorted();
		                }
		            };
			}
			
			
			GridWrapper.prototype.enableEditing=function(editing){
				this.isEditing=editing;
				this.grid.setOptions({
					editable:editing,
					selectable: editing?"cell":"row",
				});
			}
			
			//called from parenet resize event
			GridWrapper.prototype.resizeGrid=function(gridHeight){
			    var gridElement =this.grid.element, 
			        dataArea = gridElement.find(".k-grid-content"),
//			        gridHeight = gridElement.innerHeight()-37,
			        otherElements = gridElement.children().not(".k-grid-content"),
			        otherElementsHeight = 0;

			    	otherElements.each(function(){
				        otherElementsHeight += $(this).outerHeight();
					    });
			    	gridElement.innerHeight(gridHeight);
			   		dataArea.height(gridHeight - otherElementsHeight);
			};	
			
		    
		    GridWrapper.prototype.numberColumnEditor=function(container, options) {
		        $('<input class="grid-editor" data-bind="value:' + options.field + '"/>')
		            .appendTo(container)
		            .kendoNumericTextBox({
		                spinners : false
		            });
		    };

		    GridWrapper.prototype.readOnlyColumnEditor=function(container, options) {
		         $("<span>" + options.model.get(options.field)+ "</span>").appendTo(container);
		     };
			
		     
			return GridWrapper;
			
}). /* end of GridWrapper */	

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
							dataBound:function(e){
								console.log("customer list bound to customer combobox");
							}
					};
				},function(error){
					console.log("dict:"+error);
				});
		}
	}
}]).

directive("garmentInput",["GridWrapper",function(GridWrapper){
	var template='<div>'+	   	
	'<form name="addStyle" ng-submit="getGrid()" novalidate>'+
		'<span class="k-textbox k-space-right" style="width: 140px;" >'+
		'<input type="text"  class="k-textbox" placeholder="Search Style#" ng-model="styleNumber"/>'+
		'<label ng-click="getGrid()" class="k-icon k-i-search"></label></span></form>'+		
	'<h4>{{garment.styleNumber}}:&nbsp;{{garment.styleName}}</h4>'+
	'<div  kendo-grid="styleGrid" id="styleGrid"  k-options="gridOptions"  k-rebind="gridRebind" k-height=200></div>'+ 		
	'<div> <input type="button" value="Add" ng-click="add()">'+
	  	'<input type="button" value="OK" ng-click="ok()">'+
	  	'<label style="margin-left: 100px; font-weight: bold;" >Total:{{total}}</label>'+
	  	'<input type="button" value="Clear" ng-click="clear()" style="margin-left:100px;">'+
	  	'<input type="button" value="Cancel" ng-click="cancel()">	</div></div>';
	
	return { 
		restrict:"EA",
		replace:true,
		scope:{
			dictGarment:'=',			//type of DataDict
			addFunction:'='
		},
		template:template,
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

			var gridColumns=new kendo.data.ObservableArray([{title:"Colour",template:"<label>#: colour #</label>"}]);
			var gridData=new kendo.data.ObservableArray([]);

			var clearGrid=function(){
				gridColumns.splice(1, gridColumns.length-1);
				gridData.splice(0, gridData.length);
				
				scope.total=0;
				scope.gridRebind++;
			};

			
			var createGrid=function(){
				if(!scope.garment) return;
				var sizes=scope.garment.sizeRange.split(",");
				for(var i=0;i<sizes.length;i++){
					var column={
							field: "f"+("00"+i).slice(-2),
							title: sizes[i],
							width: 60,
							//attributes: {class:"gridNumberColumn"}
						};
					gridColumns.push(column);
				}
				gridColumns.push({title: "Total", field:"total",editor:GridWrapper.readOnlyColumnEditor, width: 60});  //,attributes: {style:"text-align: right; font-weight: bold;"}
				gridColumns.push({title: "Remark",field: "remark"});

				var colours=scope.garment.colourway.split(",");
				for(var i=0; i<colours.length; i++)
					gridData.push({id: i, colour: colours[i].trim(),total:null});

				scope.gridRebind++;	//cause the grid rebinds

			};
			
			var calcTotal=function(){
				var total=0;
				for(var r=0;r<gridData.length;r++)
					if(gridData[r].total)	total+=gridData[r].total;
				scope.total=total;
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
						schema:gridSchema
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
				        		t+=e.values[field];
				        		changed=true;
				        	}else{
				        		if(e.model[field])	
				        			t+=e.model[field];
				        	}
			        	}
			        	
			        	if(changed){
			        		e.model.total=(t!==0)?t:null;
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

directive('garmentGrid',["GarmentGridWrapper",function(GarmentGridWrapper){
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
			templateUrl:'garmentgrid',
			link:function(scope,element,attrs){
				
				scope.gridName=scope.cName+"Grid";
				scope.inputWindowName=scope.cName+"InputWindow";
				
				var ggw=new GarmentGridWrapper(scope.gridName);
				
				var gridColumns=[{
					        name:"lineNumber",
					        title: "#",
					        //locked: true, if true will cause the wrong cell get focus when add new row
					        attributes:{class:"gridLineNumber"},
					        headerAttributes:{class:"gridLineNumberHeader"},
					        width: 25,
				    
						}, {			
							name:"styleNumber",
						    field: "styleNumber",
						    title: "Style",
						    width: 60
						}, {
							name:"description",
						    field: "description",
						    title: "Description",
						    width: 240
						}, {
							name:"colour",
						    field: "colour",
						    title: "Colour",
						    editor:function(container, options){ggw.colourColumnEditor(container, options)},
						    width: 150
						}, {
							name:"remark",
						    field: "remark",
						    title: "Remark"
							//extend last column if do not set its width 
					
						}];
				
				var sizeQtyWidth=40;
				var sizeQtyEditor=ggw.sizeQtyEditor;
				var sizeQtyTemplate=ggw.sizeQtyTemplate;
				var sizeQtyAttr={style:"text-align:right;"};
				
				var sizeRangeFields=["12M","18M","2T","3T","4T","5/6","S","M","L","XL","XXL","XXXL","1X","2X"];
				var sizeRangeTitles=["12M","18M","2T","3T","4T","5/6","S","M","L","XL","2XL","3XL","1X","2X"];
				
				if(scope.cBrand==="DD"){
					var j=4;
					for(var i=0;i<sizeRangeFields.length;i++){
						var field="qty"+("00"+i).slice(-2);
						gridColumns.splice(j++,0,{
							name:field,
							field:field,
							title:sizeRangeTitles[i],
						    editor:sizeQtyEditor,
						    width: sizeQtyWidth,
						    attributes:sizeQtyAttr
						});			
					}
					gridColumns.splice(j,0,{
						name:"quantity",
					    field: "quantity",
					    title: "Total",
					    editor: ggw.readOnlyColumnEditor,
					    width: 80,
					    attributes:sizeQtyAttr
						});
				}else{
					gridColumns.splice(4,0,{
							name:"size",
						    field: "size",
						    title: "Size",
						    editor:function(container, options){ggw.sizeColumnEditor(container, options)},
						    width: 80
						}, {
							name:"quantity",
						    field: "quantity",
						    title: "Quantity",
						    editor: ggw.numberColumnEditor,
						    width: 80,
						    attributes:{style:"text-align:right;"}
						})
				}
			
				ggw.setColumns(gridColumns);
				
				scope.setting={};
				scope.setting.editing=true;
				scope.dict=ggw.dict;
				scope.dictGarment=ggw.dictGarment;

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
			        	}
			        }
			    });	
			    
			 	scope.gridSortableOptions = ggw.getSortableOptions();
			    
			 	scope.gridOptions = {
							autoSync: true,
					        columns: gridColumns,
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
					item.brand=scope.brand;
				    ggw.addRow(item,isInsert);
				}
							
				var deleteRow=function (){
					var dataItem=this.getCurrentDataItem();
				    if (dataItem) {
				        if (confirm('Please confirm to delete the selected row.')) {
							if(dataItem.id)
								SO.dataSet.deleteds.push({entity:"lineItem",id:dataItem.id});
					
							ggw.deleteRow(dataItem);
				        }
				    }
			   		else {
			        	alert('Please select a  row to delete.');
			   		}
				    
				}
					
				scope.inputWindowAddFunction=function(garment,dataItems){
					if(dataItems.length>0){
						var sizes=garment.sizeRange.split(",");
						for(var r=0;r<dataItems.length;r++){
							var di=dataItems[r];		//dataItem
						    var item=newItem(); 
						    item.styleNumber=garment.styleNumber;
						    item.description=garment.styleName;
						    item.colour=di.colour;
						    item.quantity=di.total;
						    item.remark=di.remark;
							for(var i=0;i<sizes.length;i++){  //exclude colour,total,remark
								var f="f"+("00"+i).slice(-2); 
								var q="qty"+("00"+sizeRangeFields.indexOf(sizes[i].trim().toUpperCase())).slice(-2); 
								item[q]=di[f];
							}
						    ggw.addRow(item,false);
						}
					}
				}
				
			}
			
	}
	return directive;
}]);	


</script>