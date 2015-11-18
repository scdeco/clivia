<script>

angular.module("cliviagrid",
		["kendo.directives" ]).

factory("GridWrapper",function(){
			//constructor, need a kendoGrid's name
			var GridWrapper=function(gridName){
				this.gridName=gridName;
				this.grid=null;
				this.gridColumns=null;
				this.currentRowUid="";
				this.reorderRowEnabled=false;
				this.isEditing=true;
			}
			
			GridWrapper.prototype.setColumns=function(columns){
				this.gridColumns=columns;
			}
			
			//call this method in kendoWidgetCreated event
			GridWrapper.prototype.wrapGrid=function(){
				this.grid=$("#"+this.gridName).data("kendoGrid");
				//this.enableReorderRow();
				this.showLineNumber();
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
				var cell=$("td.k-edit-cell",this.grid.tbody.children()).first();
				return cell;
			}
				
			GridWrapper.prototype.getCurrentRow=function (){
				if(!this.grid) return null;
				var cell=this.getEditingCell();
				if(!!cell)
				  cell=this.grid.current();
				var row=(!!cell)?cell.closest("tr"):null;
				console.log("getCurrentRow:"+(!!row));
				return row;
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
		             container: "#"+this.gridName+ " tbody",
		             change: function(e) {
		             	 var ds=self.grid.dataSource,
		                 	 idx=self.getDataItemIndexByRowIndex(e.newIndex),
		                 	 di= ds.getByUid(e.item.data("uid"));
		                 ds.remove(di);
		                 ds.insert(idx, di);
		 				 self.setLineNumber();
		                 ds.sync();
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
			GridWrapper.prototype.resizeGrid=function(){
			    var gridElement =$("#"+this.gridName), 
			        dataArea = gridElement.find(".k-grid-content"),
			        gridHeight = gridElement.innerHeight(),
			        otherElements = gridElement.children().not(".k-grid-content"),
			        otherElementsHeight = 0;
				    otherElements.each(function(){
				        otherElementsHeight += $(this).outerHeight();
					    });
			   		dataArea.height(400 - otherElementsHeight);
			};	
			
			//called in grid's dataBound event 
			GridWrapper.prototype.showLineNumber= function() {
		   		 if(this.grid){
		   	   		 var pageSkip = (this.grid.dataSource.page() - 1) * this.grid.dataSource.pageSize();
		   	   		 if(!pageSkip) pageSkip=0;
		   	   		 pageSkip++;
		   	   		 
		   	   		 //index starts from 0
		   	   		$("#"+this.gridName+" td.gridLineNumber").text(function(index){
		   	   		//	console.log("line number index:"+index);
		   	   			return pageSkip+index;
		   	   		});	       		
		   		 }
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
}]);	//end of directive	



</script>