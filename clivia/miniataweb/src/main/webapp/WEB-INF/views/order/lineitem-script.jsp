<script>
orderApp.controller("lineitemCtrl",["$scope","$http","$state","GarmentGridWrapper","SO" ,
         function($scope,$http,$state,GarmentGridWrapper,SO){

	var garmentGridWrapper=new GarmentGridWrapper("lineItemGrid");
	var currentOrderItem=SO.getCurrentOrderItem(); 
	var orderItemId =currentOrderItem.orderItemId;
	
	var gridColumns=[{
		        name:"lineNumber",
		        title: "#",
				//use $(".gridLineNumber").text(function(index)) to generate lineNumber 	
				// need to call gridWrapper.showLineNumber in dataBound event
		        //locked: true, if true will cause the wrong cell get focus when add new row
		        width: 25,
		        attributes:{style:"text-align:right;", class:"gridLineNumber"},
		        headerAttributes:{style:"text-align:center;", class:"gridLineNumberHeader"}
	    
			}, {			
				name:"styleNumber",
			    field: "styleNumber",
			    title: "Style#",
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
			    editor:function(container, options){garmentGridWrapper.colourColumnEditor(container, options)},
			    width: 150
			}, {
				name:"size",
			    field: "size",
			    title: "Size",
			    editor:function(container, options){garmentGridWrapper.sizeColumnEditor(container, options)},
			    width: 80
			}, {
				name:"quantity",
			    field: "quantity",
			    title: "Quantity",
			    editor: garmentGridWrapper.numberColumnEditor,
			    width: 80,
			    attributes:{style:"text-align:right;"}
			}, {
				name:"remark",
			    field: "remark",
			    title: "Remark"
				//extend last column if not setting its width 
		
			}];
	var sizeQtyWidth=40;
	var sizeQtyEditor=garmentGridWrapper.numberColumnEditor;
	var sizeQtyAttr={style:"text-align:right;"};
	if(currentOrderItem.spec==="DD"){
			gridColumns.splice(4,2,{
				name:"qty01",
				field:"qty01",
				title:"12M",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"qty02",
				field:"qty02",
				title:"18M",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"qty03",
				field:"qty03",
				title:"2T",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"qty04",
				field:"qty04",
				title:"3T",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"qty05",
				field:"qty05",
				title:"4T",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"qty06",
				field:"qty06",
				title:"5/6",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"qty07",
				field:"qty07",
				title:"S",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"qty08",
				field:"qty08",
				title:"M",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"qty09",
				field:"qty09",
				title:"L",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"qty10",
				field:"qty10",
				title:"XL",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"qty11",
				field:"qty11",
				title:"2XL",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"qty12",
				field:"qty12",
				title:"3XL",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"qty13",
				field:"qty13",
				title:"1L",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"qty14",
				field:"qty14",
				title:"2L",
			    editor:sizeQtyEditor,
			    width: sizeQtyWidth,
			    attributes:sizeQtyAttr
			},{
				name:"quantity",
			    field: "quantity",
			    title: "Total",
			    editor: garmentGridWrapper.readOnlyColumnEditor,
			    width: 80,
			    attributes:{style:"text-align:right;"}

			});
	}
	
	
	garmentGridWrapper.setColumns(gridColumns);
	
	$scope.setting={};

	$scope.setting.lineItemEditing=true;
	$scope.lineItemBrand=currentOrderItem.spec;
	$scope.dict=garmentGridWrapper.dict;


    $scope.$on("kendoWidgetCreated", function(event, widget){
        // the event is emitted for every widget; if we have multiple
        // widgets in this controller, we need to check that the event
        // is for the one we're interested in.
        if (widget ===$scope.lineItemGrid) {
        	garmentGridWrapper.wrapGrid();
        }
    });	
    
	$scope.lineItemBrand=currentOrderItem.spec;
	
 	$scope.lineItemGridOptions = {
				autoSync: true,
		        dataSource: {
		        	data: SO.dataSet.lineItems, 
		    	    schema: {
		    	        model: {
		    	            id: "id",                                                                                                                                                                                                                                                                                                                                     
/* 	    	                fields: {
	    	                    id: { type: "number"},
	    	                    orderId: { type: "number"},
	    	                    orderItemId: {type: "number"},
	    	                    brand: {type: "string"},
	    	                    styleNumber: {type: "string"},
	    	                    description: {type: "string"},
	    	                    colour: { type: "string"},
	    	                    size: {type: "string"},
	    	                    quantity: {type: "number"},
	    	                    remark: { type: "string"},
	    	                } //end of fields */
		    	        }	//end of model
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
 	 	            messages: {
 		            	//display: "Total line:{2}"
 	 	            }
 		        },

//events:		 
		       	dataBinding: function(e) {
		       		console.log("event binding:"+e.action+" index:"+e.index+" items:"+JSON.stringify(e.items));
		       	},
		       	
 		       	dataBound:function(e){
 		       		console.log("event bound:");
 		       		garmentGridWrapper.showLineNumber();
 		       	},
 		       		
		       	save: function(e) {
		       		if(typeof e.values.styleNumber!== 'undefined'){		//styleNumber changed
			       		console.log("event save:"+JSON.stringify(e.values));
	  	        		e.preventDefault();
 		       			if(e.values.styleNumber===";"){
		       				garmentGridWrapper.copyPreviousRow();
		       		 	}else {
			          		e.model.set("styleNumber",e.values.styleNumber.toUpperCase().trim());
			          		garmentGridWrapper.setCurrentGarment(e.model);
		          		}
		          	}
		         },
		       	
		         //row or cloumn changed
		       	change:function(e){
		       		var row=garmentGridWrapper.getCurrentRow();
		       		console.log("event change:");
		       		var	newRowUid=row?row.data("uid"):"";
	        		if((typeof newRowUid!=="undefined") && (garmentGridWrapper.currentRowUid!==newRowUid)){		//row changed
	        			garmentGridWrapper.currentRowUid=newRowUid;
	        			var dataItem=garmentGridWrapper.getCurrentDataItem();
	        			if(dataItem){
		        			garmentGridWrapper.setCurrentGarment(dataItem);
	//	        			$state.go('main.lineitem.detail',{orderItemId:orderItemId,lineItemId:dataItem.lineNumber});
	        			}
	        			
	        		};
		       	},
		       	
		        edit:function(e){
		        	console.log("event edit:");
				    var editingCell=garmentGridWrapper.getEditingCell();
				    if(!!editingCell){
				    	this.select(editingCell);
			        	console.log("set editing cell:");
				    }

		        }

	}; //end of lineItemGridOptions

       
//methods		   
 	$scope.lineItemGridSortableOptions = garmentGridWrapper.getSortableOptions();
						
	$scope.lineItemGridContextMenuOptions={
			closeOnClick:true,
			filter:".gridLineNumber,.gridLineNumberHeader",
			select:function(e){
			
				switch(e.item.id){
					case "menuAdd":
						$scope.setting.lineItemEditing=true;
						if(!garmentGridWrapper.isEditing)
							garmentGridWrapper.enableEditing(true);
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
		    garmentGridWrapper.addRow(newItem,isInsert);
		}
				
		var deleteLineItemRow=function (){
			var dataItem=this.getCurrentDataItem();
		    if (dataItem) {
		        if (confirm('Please confirm to delete the selected row.')) {
					if(dataItem.id)
						SO.dataSet.deletedItems.push({entity:"lineItem",id:dataItem.id});
			
					garmentGridWrapper.deleteRow(dataTiem);
		        }
		    }
	   		else {
	        	alert('Please select a  row to delete.');
	   		}
		    
		}
		$scope.onClickLineItemEditing=function(){
			garmentGridWrapper.enableEditing($scope.setting.lineItemEditing);				
		}
		
		$scope.styleWin={
				styleNumber: "",
				total: 0,
				garment: {},
				columns: new kendo.data.ObservableArray([{title:"Colour",template:"<label>#: colour #</label>"}]),
				data: new kendo.data.ObservableArray([]),
				
				options:{
					modal: false,
					title: "Add Line Item",
					appendTo: "#lineItem",
					resizable: true,
					draggable: true,
					actions: [ "Close", "Maximize" ],
					position: {top: 10, lft: 20 }					
				},
				
				getGrid: function(){
					var styleNumber=this.styleNumber;
					this.styleNumber="";
					this.clearGrid();
					if(styleNumber){
						this.garment=SO.dict.getGarment(styleNumber);
						if(this.garment){
							this.createGrid();
						}else{
							var self=this;
							SO.dict.getRemoteGarment(styleNumber).
								then(function(data){		//sucess
									self.garment=data;
									self.createGrid();
								},						
								function(error){		//error
							    	//self.description=error;
								});
						}
						
					}
				},
				
				add: function(){
					for(var r=0;r<this.data.length;r++){
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
					    garmentGridWrapper.addRow(newItem,false);						
						
					}
					
					this.clear();
				},
				
				clear: function(){
					this.styleNumber="";
					this.garment={};
					this.clearGrid();
				},
				
				clearGrid:function(){
					this.columns.splice(1, this.columns.length-1);
					this.data.splice(0, this.data.length);
					this.total=0;
				},
				
				createGrid: function(){
					if(!this.garment) return;
					var sizes=this.garment.sizeRange.split(",");
					for(var i=0;i<sizes.length;i++){
						var column={
								field: "f"+("00"+i).slice(-2),
								title: sizes[i],
								width: 60,
								//attributes: {style:"text-align: right;"}
							};
						this.columns.push(column);
					}
					this.columns.push({title: "Total", field:"total",editor:garmentGridWrapper.readOnlyColumnEditor, width: 60}); //, attributes: {style:"text-align: right;"}
					this.columns.push({title: "Remark",field: "remark"});
					
					var colours=this.garment.colourway.split(",");
					for(var i=0; i<colours.length; i++)
						this.data.push({id: i, colour: colours[i],total:null});
				},
				
				calcTotal: function(){
					var total=0;
					for(var r=0;r<this.data.length;r++)
						if(this.data[r].total)	total+=this.data[r].total;
					this.total=total;
				}
		};
		
		$scope.styleWin.gridOptions={
			autoSync: true,
	        dataSource: {
	        	data: $scope.styleWin.data,
	        	schema: {model: {id: "id",
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
	        		}}}},
	        columns: $scope.styleWin.columns,
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
		        		if(e.model[field])	t+=e.model[field];
		        	}
	        	}
	        	
	        	if(changed){
	        		e.model.total=(t!==0)?t:null;
		        	$scope.styleWin.calcTotal();
	        	}
	        }
	        
		};

		


}]); 



</script>