<script>
orderApp.controller("lineitemCtrl",["$scope","$http","$state","$stateParams","GridWrapper","SO" ,function($scope,$http,$state,$stateParams,GridWrapper,SO){

	var gridWrapper=new GridWrapper("lineItemGrid");
	var orderItemId =parseInt($stateParams.orderItemId);
	var lineItemGridColumns=["lineNumber","styleNumber","description","colour","size","quantity","remark"];

	$scope.setting={};

	$scope.dict={};
	$scope.dict.colourway=[];
	$scope.dict.sizeRange=[];

    SO.instance.lineItemGridCurrentGarment=null;

    
    $scope.$on("kendoWidgetCreated", function(event, widget){
        // the event is emitted for every widget; if we have multiple
        // widgets in this controller, we need to check that the event
        // is for the one we're interested in.
        if (widget ===$scope.lineItemGrid) {
        	gridWrapper.wrapGrid();
        	$scope.onClickLineItemEditing();
        }
    });				
	
	$scope.lineItemBrand='DD';
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
		    	
		        columns: [{
		            title: "#",
//use $(".LineItemGridLineNumber").text(function(index)) to generate lineNumber 	
//template: "#= ++ lineItemGridLineNumber #",
		            //locked: true, if true will cause the wrong cell get focus when add new row
		            width: 20,
		            attributes:{style:"text-align:right;", class:"gridLineNumber"},
		            headerAttributes:{style:"text-align:center;", class:"gridLineNumberHeader"}
		        
					}, {					    
					    field: "styleNumber",
					    title: "Style#",
					    width: 40
					}, {
					    field: "description",
					    title: "Description",
					    width: 240
					}, {
					    field: "colour",
					    title: "Colour",
					    editor:colourColumnEditor,
					    width: 150
					}, {
					    field: "size",
					    title: "Size",
					    editor:sizeColumnEditor,
					    width: 80
					}, {
					    field: "quantity",
					    title: "Quantity",
					    editor: numberColumnEditor,
					    width: 80,
					    attributes:{style:"text-align:right;"},
					}, {
					    field: "remark",
					    title: "Remark",
					    width: 120
	 			}],  //end of columns

		        editable: false,
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
		       		
//use $(".LineItemGridLineNumber").text(function(index)) to generate lineNumber  indested of  commented code below
		       	/*
		       		lineItemGridLineNumber = (this.dataSource.page() - 1) * this.dataSource.pageSize();
		    		 if(!lineItemGridLineNumber){
		    			 lineItemGridLineNumber=0;
		    		 }
				*/		
 //    		 alert("binding:"+e.action+" index:"+e.index+" items:"+JSON.stringify(e.items));
		       	},
		       	
 		       	dataBound: function(e) {
		       		console.log("event bound:");
 		       		
		    		 var pageSkip = (this.dataSource.page() - 1) * this.dataSource.pageSize();
		    		 if(!pageSkip) pageSkip=0;
		    		 pageSkip++;
		    		 
		    		 //index starts from 0
		       		$("#lineItemGrid td.gridLineNumber").text(function(index){
		       		//	console.log("line number index:"+index);
		       			return pageSkip+index;
		       		});	       		
		       	},
		       	
		       	save: function(e) {
		       		if(typeof e.values.styleNumber!== 'undefined'){
			       		console.log("event save:"+JSON.stringify(e.values));
		       			if(e.values.styleNumber===";"){
		  	        		e.preventDefault();
			       			var dataItem=gridWrapper.getCurrentDataItem();
		       		 		var dataItemIndex=gridWrapper.getCurrentDataItemIndex();
		       		 		console.log("save dataItemIndex:"+dataItemIndex);
			       		 	var copiedDataItem=gridWrapper.getDataItemByIndex(dataItemIndex-1);
		       		 		if(!!copiedDataItem){
		       		 			for(var i=1;i<lineItemGridColumns.length;i++){
		       		 				if(typeof copiedDataItem[lineItemGridColumns[i]] !=='undefined')
				       		 			dataItem[lineItemGridColumns[i]]=copiedDataItem[lineItemGridColumns[i]];
		       		 			}
		       		 		}
		       		 	}else {
			          		e.preventDefault();

			          		e.model.set("styleNumber",e.values.styleNumber.toUpperCase().trim());
			          		getGarment(e.model);
			          		
//				       		console.log("get garment:"+e.values.styleNumber);

		          		}
		          	}
		         },
		       	
		       	change:function(e){
		       		var row=gridWrapper.getCurrentRow();
		       		console.log("event change:");
		       		
	        		if(row!==gridWrapper.currentRow){		//row changed
	        			gridWrapper.currentRow=row;
	        			var dataItem=gridWrapper.getCurrentDataItem();
	        			if(dataItem){
		        			getGarment(dataItem);
		        			$state.go('main.lineitem.detail',{orderItemId:orderItemId,lineItemId:dataItem.lineNumber});
	        			}
	        			
	        		};
		       	},
		       	
		        edit:function(e){
		        	console.log("event edit:");
				    var editingCell=gridWrapper.getEditingCell();
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
    
    function colourColumnEditor(container, options) {
	    $('<input class="grid-editor"  data-bind="value:' + options.field + '"/>')
	    	.appendTo(container)
	    	.kendoComboBox({
		        autoBind: true,
		        dataSource: {
		            data: $scope.dict.colourway
		        }
	    })
	};	

	function sizeColumnEditor(container, options) {
	    $('<input class="grid-editor"  data-bind="value:' + options.field + '"/>')
	    	.appendTo(container)
	    	.kendoComboBox({
		        autoBind: true,
		        dataSource: {
		            data: $scope.dict.sizeRange
	        }
	    })
	};				    
    
    function numberColumnEditor(container, options) {
       $('<input class="grid-editor" data-bind="value:' + options.field + '"/>')
           .appendTo(container)
           .kendoNumericTextBox({
               spinners : false
           });
   };

   function readOnlyColumnEditor(container, options) {
        $("<span>" + options.model.get(options.field)+ "</span>").appendTo(container);
    };
    
       
//methods		   
				function setRowDict(){
	        		$scope.dict.colourway.splice(0,$scope.dict.colourway.length);
	        		$scope.dict.sizeRange.splice(0,$scope.dict.sizeRange.length);
	        		if(lineItemGridCurrentGarment){
						$scope.dict.colourway=String(lineItemGridCurrentGarment.colourway).split(',');
						$scope.dict.sizeRange=String(lineItemGridCurrentGarment.sizeRange).split(',');
						console.log("set row dict:"+String(lineItemGridCurrentGarment.colourway));
	        		}
				}
			                
		        function getGarment(model){
		        	if (!model) return;
		        	if(!model.styleNumber) return;
		        	
					var styleNumber=model.styleNumber;
					if(!styleNumber){
						lineItemGridCurrentGarment=null;
	    				setRowDict();
					}else{
						if(lineItemGridCurrentGarment && lineItemGridCurrentGarment.styleNumber===styleNumber){
					    	model.set("description",lineItemGridCurrentGarment.styleName);
						}else{
							SO.dict.getGarment(styleNumber).
								then(function(data){		//sucess
			    				    	lineItemGridCurrentGarment=data;
								    	model.set("description",lineItemGridCurrentGarment.styleName);
					    				setRowDict();
									},						
									function(error){		//error
										lineItemGridCurrentGarment=null;
								    	model.set("description","");
					    				setRowDict();
									});
						}
					}
		    	}
		        

				
						
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
				
				function addLineItemRow(isInsert){
				    var newItem={
					    	orderId:SO.dataSet.info.orderId,
					    	orderItemId:orderItemId, 
					    	brand:$scope.lineItemBrand
					    };
				    gridWrapper.addNewRow(newItem,isInsert);
				}
				
				function deleteLineItemRow(){
					var dataItem=this.getCurrentDataItem();
				    if (dataItem) {
				        if (confirm('Please confirm to delete the selected row.')) {
							if(dataItem.id)
								SO.dataSet.deletedItems.push({entity:"lineItem",id:dataItem.id});
					
							gridWrapper.deleteRow(dataTiem);
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

					gridWrapper.enableReorderRow();
				}


}]); 



</script>