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
		        width: 20,
		        attributes:{style:"text-align:right;", class:"gridLineNumber"},
		        headerAttributes:{style:"text-align:center;", class:"gridLineNumberHeader"}
	    
			}, {			
				name:"styleNumber",
			    field: "styleNumber",
			    title: "Style#",
			    width: 40
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
			    attributes:{style:"text-align:right;"},
			}, {
				name:"remark",
			    field: "remark",
			    title: "Remark",
			    width: 120
		
			}];
	garmentGridWrapper.setColumns(gridColumns);
	
	$scope.setting={};
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
	    	                fields: {
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
	    	                } //end of fields
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

	$scope.lineitemBrandOptions={
            dataSource: {
                data: ['DD', 'VIE', 'Vestige']
            }	
    };

      
//column editors

    function brandColumnEditor(container, options) {
        $('<input class="grid-editor"  data-bind="value:' + options.field + '"/>')
        	.appendTo(container).kendoDropDownList({
            autoBind: false,
            dataSource: {
                data: ['DD', 'VIE', 'Vestige']
            }
        });
    }
    
       
//methods		   
						
				$scope.lineItemGridContextMenuOptions={
						closeOnClick:true,
						filter:".gridLineNumber,.gridLineNumberHeader",
						select:function(e){
						
							switch(e.item.id){
								case "menuAdd":
									addLineItemRow(false);
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
					$scope.lineItemGrid.setOptions({
						editable:$scope.setting.lineItemEditing,
						selectable: (!!$scope.setting.lineItemEditing)?"cell":"multiple, row",
					});
					var options=$scope.lineItemGrid.getOptions();
//					console.log("grid options: editable="+options.editable+"  selectable="+options.selectable);
//					console.log("grid options:"+JSON.stringify(options));

					garmentGridWrapper.enableReorderRow();
				}


}]); 



</script>