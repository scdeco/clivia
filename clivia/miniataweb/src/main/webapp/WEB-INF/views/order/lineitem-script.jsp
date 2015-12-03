<script>
orderApp.directive("garmentInputWindow",["GridWrapper",function(GridWrapper){
	
	return { 
		restrict:"EA",
		replace:true,
		scope:{
			name:'@',
			id:'@',
			dictGarment:'='
		},
		
		templateUrl:"garmentinputwindow",
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
			        	
			        	for(var c=0; c<this.columns.length-3; c++){
			        		var field="f"+("00"+c).slice(-2);
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
			        		scope.calcTotal();
			        	}
			        }
			};
			
			scope.getGrid= function(){
					var styleNumber=scope.styleNumber;
					scope.styleNumber="";
					scope.clearGrid();
					if(styleNumber){
						scope.garment=scope.dictGarment.getGarment(styleNumber);
						if(scope.garment){
							scope.createGrid();
						}else{
							scope.dictGarment.getRemoteGarment(styleNumber).
								then(function(data){		//sucess
									scope.garment=data;
									scope.createGrid();
								},						
								function(error){		//error
							    	//self.description=error;
								});
						}
						
					}
				};
				
			scope.clearGrid=function(){
					gridColumns.splice(1, gridColumns.length-1);
					gridData.splice(0, gridData.length);
					
					scope.total=0;
					scope.gridRebind++;
				};
				
			scope.clear=function(){
					scope.styleNumber="";
					scope.garment={};
					scope.clearGrid();
				};
				
			scope.add=function(){
					if(scope.addFunction){
						scope.addFunction();
						scope.clear();
					}
				};
				
			scope.ok=function(){
					scope.add();
					if(scope.window)
						scope.window.close();
				};
				
			scope.cancel=function(){
					scope.clear();
					if(scope.window)
						scope.window.close();
				};
				
				
			scope.createGrid=function(){
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
						gridData.push({id: i, colour: colours[i],total:null});

					scope.gridRebind++;

				};
				
			scope.calcTotal=function(){
					var total=0;
					for(var r=0;r<gridData.length;r++)
						if(gridData[r].total)	total+=gridData[r].total;
					scope.total=total;
				};
			
			
			scope.add=function(){
				var sizes=scope.garment.sizeRange.split(",");
				for(var r=0;r<gridData.length;r++){
					var di=this.data[r];		//dataItem
				    var newItem={
				    	orderId:SO.dataSet.info.orderId,
				    	orderItemId:orderItemId, 
				    	brand:$scope.lineItemBrand,
				    	styleNumber:this.garment.styleNumber,
				    	description:this.garment.styleName,
				    	colour:di.colour,
				    	quantity:di.total,
				    	remark:di.remark,
				    };
					for(var i=0;i<sizes.length;i++){  //exclude colour,total,remark
						var f="f"+("00"+i).slice(-2); 
						var q="qty"+("00"+sizeRangeFields.indexOf(sizes[i].trim().toUpperCase())).slice(-2); 
						newItem[q]=di[f];
					}
				    ggw.addRow(newItem,false);
				}
			};
		},
			
		controller: ['$scope', function($scope) {

		}]
	}
}]);
	
	
orderApp.controller("lineItemCtrl",["$scope","$http","$state","GarmentGridWrapper","SO",
         function($scope,$http,$state,GarmentGridWrapper,SO){

	if(SO.instance.currentItemId===0) return;
	$scope.SO=SO;
	var ggw=new GarmentGridWrapper("lineItemGrid");
	var orderItem=SO.getCurrentOrderItem(); 
	var orderItemId =orderItem.orderItemId;
	
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
	var sizeQtyEditor=ggw.numberColumnEditor;
	var sizeQtyAttr={style:"text-align:right;"};
	
	var sizeRangeFields=["12M","18M","2T","3T","4T","5/6","S","M","L","XL","XXL","XXXL","1X","2X"];
	var sizeRangeTitles=["12M","18M","2T","3T","4T","5/6","S","M","L","XL","2XL","3XL","1X","2X"];
	
	if(orderItem.spec==="DD"){
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
	
	$scope.setting={};

	$scope.setting.lineItemEditing=true;
	$scope.lineItemBrand=orderItem.spec;
	$scope.dict=ggw.dict;


    $scope.$on("kendoWidgetCreated", function(event, widget){
        // the event is emitted for every widget; if we have multiple
        // widgets in this controller, we need to check that the event
        // is for the one we're interested in.
        if (widget ===$scope.lineItemGrid) {
        	ggw.wrapGrid();
        }
    });	
    
    $scope.lineItemSplitterOptions={
    	resize:function(e){
			var panes=e.sender.element.children(".k-pane"),
			gridHeight=$(panes[1]).innerHeight();
	      	window.setTimeout(function(){ggw.resizeGrid(gridHeight)},1); 
	      	console.log("resize2:");
    	}		
    }
    
	$scope.lineItemBrand=orderItem.spec;
	
 	$scope.lineItemGridOptions = {
				autoSync: true,
		        dataSource: {
		        	data: SO.dataSet.lineItems, 
		    	    schema: {
		    	    	model: { id: "id" }
		    	    },	//end of schema
		    	    
   		    	    filter: {
		    	        field: "orderItemId",
		    	        operator: "eq",
		    	        value: orderItemId
		    	    },    
		    	    
		    	    serverFiltering:false,
		    	    pageSize: 0,			//paging in pager

		        }, //end of dataSource,
		    	
		        columns: gridColumns,

		        editable: true,
		        selectable: "cell",
		        navigatable: true,
		        resizable: true,
 		        pageable: {
 		            pageSizes:["all",16,15,14,13,12,11,10,9,8,7,6,5,4,3,2],
 		            numeric: true,
 		            previousNext:true,
/*  	 	            messages: {
 		            	//display: "Total line:{2}"
 	 	            } */
 		        },

//events:		 
		       	dataBinding: function(e) {
		       		console.log("event binding:"+e.action+" index:"+e.index+" items:"+JSON.stringify(e.items));
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
		        			$state.go('main.lineItem.detail',{orderItemId:orderItemId,lineItemId:dataItem.lineNumber});
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

	}; //end of lineItemGridOptions

  
	

//methods		   
 	$scope.lineItemGridSortableOptions = ggw.getSortableOptions();
						
	$scope.lineItemGridContextMenuOptions={
			closeOnClick:true,
			filter:".gridLineNumber,.gridLineNumberHeader",
			select:function(e){
			
				switch(e.item.id){
					case "menuAdd":
						$scope.setting.lineItemEditing=true;
						if(!ggw.isEditing)
							ggw.enableEditing(true);
						addLineItemRow(false);
						break;
					case "menuAddWindow":
						$scope.styleWindow.open();
						break;
					case "menuInsert":
						addLineItemRow(true);
						break;
					case "menuDelete":
						deleteLineItemRow();
						break;
				}
				
			}
			
		};
				
		var addLineItemRow=function(isInsert){
		    var newItem={
			    	orderId:SO.dataSet.info.orderId,
			    	orderItemId:orderItemId, 
			    	brand:$scope.lineItemBrand
			    };
		    ggw.addRow(newItem,isInsert);
		}
				
		var deleteLineItemRow=function (){
			var dataItem=this.getCurrentDataItem();
		    if (dataItem) {
		        if (confirm('Please confirm to delete the selected row.')) {
					if(dataItem.id)
						SO.dataSet.deleteds.push({entity:"lineItem",id:dataItem.id});
			
					ggw.deleteRow(dataTiem);
		        }
		    }
	   		else {
	        	alert('Please select a  row to delete.');
	   		}
		    
		}
		$scope.onClickLineItemEditing=function(){
			ggw.enableEditing($scope.setting.lineItemEditing);				
		}
		
		$scope.garmentInputWindowOptions={
				add:function(){
					
				}
		}

}]); 



</script>