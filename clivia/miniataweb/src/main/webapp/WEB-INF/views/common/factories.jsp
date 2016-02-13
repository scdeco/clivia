<script>
'user strict';

clivia=angular.module("clivia",["kendo.directives" ]);

clivia.

factory("util",["$http","$q",function($http,$q){
	return {
		findIndex:function(items,propertyName,propertyValue){
			var result=-1;
			
			if(Array.isArray(propertyName) || Array.isArray(propertyValue)) {
				if(Array.isArray(propertyName) 
						&& Array.isArray(propertyValue) 
						&&	propertyName.length===propertyValue.length){
					
					var ns=propertyName,vs=propertyValue;
					for (var i = 0,item; i <items.length; i++) {
						item=items[i];
						j=0;
						while (j<propertyName.length){
						    if (item[ns[j]] !== vs[j]) {
						    	break; 
						    }
						    j++
						}
						if(j===propertyName.length){
							result=i;
							break;
						}
					}
				}
			}else{
				for (var i = 0; i <items.length; i++) {
				    if (items[i][propertyName] === propertyValue) {
				    	result=i;
				    	break; 
				    }
				}
			}
			return result;
		},
		
		find:function(items,propertyName,propertyValue){
			var index=this.findIndex(items,propertyName,propertyValue);
			return index<0?null:items[index];
		},
		
		getRemote:function(url,data){
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
		},
		
		split:function(originalStr){
			var strs=[];
			if(originalStr){
				strs=originalStr.split(',');
				for(var i=0;i<strs.length;i++){
					if(strs)
						strs[i]=strs[i].trim();
				}
			}
			return strs;
		},
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
			while(this.waitingDeferred.length>0){
				var deferred=this.waitingDeferred.pop();
				deferred.reject("error");
			}
			this.isLoading=false;
		},
		
		addItem:function(item){
			this.items.push(item);
		},
		
		waitForLoaded:function(deferred){
			this.waitingDeferred.unshift(deferred);
			if(this.waitingDeferred.length===1){
				var url=this.url,self=this;
				
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
			var deferred = $q.defer();
			var	self=this;
			var	url=this.url+"getitem?name="+name+"&value="+value;
			
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

			var self=this,
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
			var deferred = $q.defer();
			var	self=this;
			
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
factory("cliviaDDS",["DataDictSet",function(DataDictSet){
	var baseUrl="/miniataweb/";
	var dicts=[{
			name:"city",
			url:baseUrl+"dict/get?from=dictCity&textField=name&orderBy=name",
			mode:"eager"
		},{
			name:"province",
			url:baseUrl+"dict/get?from=dictProvince&textField=name&orderBy=name",
			mode:"eager"
		},{
			name:"customerInput",
			url:baseUrl+"dict/map?from=companyInfo&textField=businessName&valueField=id&orderBy=businessName",
			mode:"eager"
		},{
			name:"garment",
			url:baseUrl+"data/garmentInfo/",
			mode:"onDemand"
		},{
			name:"garmentBrand",
			url:baseUrl+"data/dictGarmentBrand/get",
			mode:"eager"

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
				this.hasDateColumnEditor=false;
				this.doubleClickEvent=null;
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
				var self=this;
				
				if(this.doubleClickEvent){
					this.grid.bind("dataBound",function(e){
						self.grid.tbody.find("tr").dblclick(self.doubleClickEvent);
					});
				}
				
				var showLineNumber=function(grid){
		   	   		 var pageSkip = (grid.dataSource.page() - 1) * grid.dataSource.pageSize();
	   	   		 
		   	   		 pageSkip=!pageSkip? 1:++pageSkip;
	   	   		 
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
				
				//if this grid has dataPickerEditor column, convert value of date type to string
				if(this.hasDateColumnEditor){
					this.grid.bind('save',function(e){
						var gridColumns=self.gridColumns;
						for(var i=0,gridColumn;i<gridColumns.length;i++){
							gridColumn=gridColumns[i];
							if(gridColumn.editor===self.dateColumnEditor && e.values[gridColumn.field]){
								e.preventDefault();
								var format=gridColumn.format?gridColumn.format:'{0:yyyy-MM-dd}';
								format=format.slice(3,format.length-1); //remove {0:} from format
								e.values[gridColumn.field]=kendo.toString(e.values[gridColumn.field],format);
								e.model[gridColumn.field]=e.values[gridColumn.field];
								break;
							}
						}
					});
				}
				
				if(this.enterMoveDown){
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
				var result=null;
				
				if(!this.grid) return result;
				var row=this.getCurrentRow();
				
				if(row){
					result=this.getDataItemByRow(row);
				}else{
					result=this.grid.dataItem(this.grid.select());
				}
				return result;
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
		    
		    GridWrapper.prototype.dateColumnEditor=function (container, options) {
		        $('<input  class="grid-editor" data-type="text" data-bind="value:' + options.field  + '"/>')
	            .appendTo(container)
	            .kendoDatePicker({
	            	format:options.format
	            });
			}

		    GridWrapper.prototype.readOnlyColumnEditor=function(container, options) {
		         $("<span>" + options.model.get(options.field)+ "</span>").appendTo(container);
		     };
			
		    GridWrapper.prototype.kendoComboBoxEditor=function(container,options,items){
				if(items){
				    $('<input class="grid-editor" data-bind="value:' + options.field + '"/>')
				    	.appendTo(container)
				    	.kendoComboBox({
					        autoBind: true,
					        dataSource: {data:items}
				    		});
				}
			};
		     
			return GridWrapper;
			
}). /* end of GridWrapper */	

//GarmentGridWrapper inherited from GridWrapper
factory("GarmentGridWrapper",["GridWrapper","cliviaDDS","DataDict","$q",function(GridWrapper,cliviaDDS,DataDict,$q){

	 var thisGGW;
		
	 var getColumns=function(brand){
		 
		    var sizeRangeFields=thisGGW.sizeRangeFields;
		    var sizeRangeTitles=thisGGW.sizeRangeTitles;
			var sizeQtyWidth=40;
			var sizeQtyEditor=thisGGW.sizeQtyEditor;
			var sizeQtyTemplate=thisGGW.sizeQtyTemplate;
			var sizeQtyAttr={style:"text-align:right;"};
			
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
				    title: "Name",
				    width: 240
				}, {
					name:"colour",
				    field: "colour",
				    title: "Colour",
				    editor:thisGGW.colourColumnEditor,
				    width: 150
				}, {
					name:"remark",
				    field: "remark",
				    title: "Remark"
					//extend last column if do not set its width 
			}];
			
			if(brand==="DD"){
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
				    editor: thisGGW.readOnlyColumnEditor,
				    width: 80,
				    attributes:sizeQtyAttr
					});
			}else{
				gridColumns.splice(4,0,{
						name:"size",
					    field: "size",
					    title: "Size",
					    editor:thisGGW.sizeColumnEditor,
					    width: 80
					}, {
						name:"quantity",
					    field: "quantity",
					    title: "Quantity",
					    editor: thisGGW.numberColumnEditor,
					    width: 80,
					    attributes:{style:"text-align:right;"}
					})
			}
			
			return gridColumns;
		}
		
	 var GarmentGridWrapper=function(gridName){
		 
		GridWrapper.call(this,gridName);
		
		this.currentGarment=null;
		this.dict={colourway:[],sizeRange:[]};
		this.dictGarment=cliviaDDS.getDict("garment");
		
		thisGGW=this;
	}
	 
	GarmentGridWrapper.prototype=new GridWrapper();
	//must set before calling wrapegrid
	GarmentGridWrapper.prototype.setBrand=function(brand){
		this.brand=brand?brand:"DD";
		
		this.sizeRangeFields=["12M","18M","2T","3T","4T","5/6","S","M","L","XL","XXL","XXXL","1X","2X"];
		this.sizeRangeTitles=["12M","18M","2T","3T","4T","5/6","S","M","L","XL","2XL","3XL","1X","2X"];
		
		var gridColumns=getColumns(this.brand);
		this.setColumns(gridColumns);
	}
	
	GarmentGridWrapper.prototype.setRowDict=function(){
  		var colourway=[],sizeRange=[];
  		if(this.currentGarment){
			colourway=String(this.currentGarment.colourway).split(',');
			sizeRange=String(this.currentGarment.sizeRange).split(',');
			for(var i=0;i<colourway.length;i++)
				colourway[i]=colourway[i].trim();
			
			for(var i=0;i<sizeRange.length;i++)
				sizeRange[i]=sizeRange[i].trim();
  		}
  		this.dict.colourway=colourway;
  		this.dict.sizeRange=sizeRange;
	}
	
	GarmentGridWrapper.prototype.setCurrentGarment=function(model){
   	if (!model) return;
   	if(!model.styleNumber) return;
   	
		var styleNumber=model.styleNumber;
		if(!styleNumber){
			this.currentGarment=null;
			this.setRowDict();
		}else{
			if(this.currentGarment && this.currentGarment.styleNumber===styleNumber){
		    	model.set("description",this.currentGarment.styleName);
			}else{
				garment=this.dictGarment.getLocalItem("styleNumber",styleNumber);
				if(garment){
					thisGGW.currentGarment=garment;
			    	model.set("description",thisGGW.currentGarment.styleName);
					thisGGW.setRowDict();
				}else{
					
					this.dictGarment.loadItem("styleNumber",styleNumber)
						.then(function(garment){
							thisGGW.currentGarment=garment;
					    	model.set("description",thisGGW.currentGarment.styleName);
							thisGGW.setRowDict();
						},function(error){
							thisGGW.currentGarment=null;
					    	model.set("description","");
		    				thisGGW.setRowDict();
						});
				}
			}
		}
	}

	var getDictUpc=function(dictUpc){
    	var deferred = $q.defer();
		
		dictUpc.load()
			.then(function(loaded){
				deferred.resolve(loaded);
			},function(error){
				deferred.reject(error);
			});

		return deferred.promise;
    }

	var getUpcItem=function(dict,styleNumber,colour,size){
    	var len=dict.items.length;
    	var result=null;
    	for(var i=0,item;i<len;i++){
    		item=dict.items[i];
    		if(styleNumber===item.styleNumber && colour===item.colour && size===item.size){
    			result=item;
    			break;
    		}
    	}
    	return result;
    }
    
	GarmentGridWrapper.prototype.parseFromLineItems=function(){
		
    	var deferred = $q.defer();
    	
    	var dictUpc=new DataDict("upc","","onDemand");
	   	var dictUpcUrl="../data/garmentWithDetail/call/findListIn?param=s:styleNumber;s:s;s:";

    	var dataItems=thisGGW.grid.dataItems();

		var styleNumbers="";
		
		for(var i=0;i<dataItems.length;i++){
			if(styleNumbers.indexOf(dataItems[i].styleNumber)<0)
				styleNumbers+=","+dataItems[i].styleNumber;
		}
		
		dictUpc.url=dictUpcUrl+styleNumbers.substring(1);

		getDictUpc(dictUpc)
			.then(function(){
				var items=[];

				var noError=true;
				for(var r=0,di,item;r<dataItems.length;r++){
					di=dataItems[r];		//dataItem
					for(var i=0;i<thisGGW.sizeRangeFields.length;i++){  //exclude colour,total,remark
						var field="qty"+("00"+i).slice(-2); 	//right(2)
						var quantity=parseInt(di[field]);
						if(quantity){
						    item={}; 
						    upcItem=getUpcItem(dictUpc,di.styleNumber,di.colour,thisGGW.sizeRangeFields[i])
						    if(upcItem){
						    	item.upcId=upcItem.upcId;
						    	item.rowNumber=r;
							    item.quantity=quantity;
							    item.remark=di.remark;
							    items.push(item);
						    }else{			//error can not find 
						    	noError=false;
						    	deferred.reject("error:failed to UPC item.");
						    	break;
						    }
						}
					}
				    if(!noError)
				    	break;
				}
				if(noError)
					deferred.resolve(items);
			},function(){
				deferred.reject("error:failed to get UPC")
			});
		return deferred.promise;
	}
	
	GarmentGridWrapper.prototype.parseToLineItems=function(items){
		
		if(!items) return;
		
    	var dictUpc=new DataDict("upc","","onDemand");
	   	var dictUpcUrl="../data/garmentWithDetail/call/findListIn?param=s:upcId;s:i;s:";

	   	var upcIds="";
	   	
		for(var i=0;i<items.length;i++){
			upcIds+=","+items[i].upcId;
		}
		
		dictUpc.url=dictUpcUrl+upcIds.substring(1);;
	   	
	   	getDictUpc(dictUpc)
			.then(function(){
					
					for (var i=0,rowNumber=-1,lineItem,item,index,field;i<items.length;i++){
						item=items[i];
						upcItem=dictUpc.getLocalItem("upcId",item.upcId);
						if(upcItem){
							if(rowNumber!==item.rowNumber){
								lineItem={
										styleNumber:upcItem.styleNumber,
										colour:upcItem.colour,
										description:upcItem.styleName,
										remark:item.remark
										};
								lineItem=thisGGW.grid.dataSource.add(lineItem);
								rowNumber=item.rowNumber;
							}
							index=thisGGW.sizeRangeFields.indexOf(upcItem.size);
							field="qty"+("00"+index).slice(-2); 
							lineItem[field]=item.quantity;
						}else{		//error:can not find upc item
							
						}
					}
					thisGGW.calculateTotal();
			},function(){
				var error="error:failed to get UPC";
			});
	}
	
	GarmentGridWrapper.prototype.calculateTotal=function() {
		var dataItems=thisGGW.grid.dataItems();
		var total=0;
		for(var r=0,di,t;r<dataItems.length;r++){
			di=dataItems[r];		//dataItem
			t=0;
			for(var i=0;i<thisGGW.sizeRangeFields.length;i++){  //exclude colour,total,remark
				var field="qty"+("00"+i).slice(-2); 	//right(2)
				var quantity=parseInt(di[field]);
				if(quantity){
					t+=quantity;	
				}
			}
			di.set("quantity",t);
			total+=t;
		}
		return total;
	}
	
	
	GarmentGridWrapper.prototype.colourColumnEditor=function(container, options) {
		if(thisGGW.reorderRowEnabled) return;
		$('<input class="grid-editor"  data-bind="value:' + options.field + '"/>')
	    	.appendTo(container)
	    	.kendoComboBox({
		        autoBind: true,
		        dataSource: {
		            data: thisGGW.dict.colourway
		        }
	    })
	}

	GarmentGridWrapper.prototype.sizeColumnEditor=function(container, options) {
		if(thisGGW.reorderRowEnabled) return;
	    $('<input class="grid-editor"  data-bind="value:' + options.field + '"/>')
	    	.appendTo(container)
	    	.kendoComboBox({
		        autoBind: true,
		        dataSource: {
		            data: thisGGW.dict.sizeRange
	        }
	    })
	}				    
	

	GarmentGridWrapper.prototype.sizeQtyEditor=function(container, options) {
		if(thisGGW.reorderRowEnabled) return;
		var column=thisGGW.getGridColumn(options.field);
		if(column)
			if(thisGGW.dict.sizeRange.indexOf(column.title)<0)
		        $("<span>-</span>").appendTo(container);
			else
				thisGGW.numberColumnEditor(container,options);
		else
	        thisGGW.readOnlyEditor(container,options);
	}				    
	
	return GarmentGridWrapper;
}]); /* end of GarmentGridWrapper */

</script>