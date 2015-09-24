<script>
orderApp.controller("lineItemCtrl",["$scope","$http","$stateParams" ,function($scope,$http,$stateParams){

		var orderItemId =parseInt($stateParams.orderItemId);
		
	    lineItemGridLineNumber=0;
	    lineItemGridCurrenRow=-1;
	    lineItemGridCurrenCol=-1;
	    lineItemGridCurrentGarment=null;
	    lineItemGridCurrentDataItem=null;
	    

		$scope.lineItemBrand='DD';
 		$scope.lineItemGridOptions = {
 				height: 600,
				autoSync: true,
		        dataSource: {
		        	data: $scope.order.lineItems, 
		    	    schema: {
		    	        model: {
		    	            id: "id",
	    	                fields: {
	    	                    id: {
	    	                        type: "number",
	    	                    },
	    	                    orderId: {
	    	                        type: "number",
	    	                    },
	    	                    orderItemId: {
	    	                        type: "number",
	    	                    },
	    	                    brand: {
	    	                        type: "string",
	    	                    },
	    	                    styleNumber: {
	    	                        type: "string",
	    	                    },
	    	                    description: {
	    	                        type: "string",
	    	                    },
	    	                    colour: {
	    	                        type: "string",
	    	                    },
	    	                    size: {
	    	                        type: "string",
	    	                    },
	    	                    quantity: {
	    	                        type: "number",
	    	                    },
	    	                    price: {
	    	                        type: "number",
	    	                    },
	    	                    amount: {
	    	                        type: "number",
	    	                        editable:true,
	    	                    },
	    	                    remark: {
	    	                        type: "string",
	    	                    },
	    	                } //end of fields
		    	        }	//end of model
		    	    },	//end of schema
		    	    
   		    	    filter: {
		    	        field: "orderItemId",
		    	        operator: "eq",
		    	        value: orderItemId
		    	    },    
		    	    
		    	    serverFiltering:false,
		    	    
		    	    change: function(e) {
		    	    }		    	    

		        }, //end of dataSource,
		    	
		        columns: [{
		            title: " ",
		            template: "#= ++ lineItemGridLineNumber #",
		            locked: true,
		            width: 30,
		            attributes:{style:"text-align:right;"}
					}, {					    
/* 						field: "id",
					    title: "Id",
					    hidden: true,
					    width: 0
					}, {
					    field: "orderId",
					    title: "Order Id",
					    hidden: true,
					    width: 0
					}, {
					    field: "orderItemId",
					    title: "Order Item Id",
					    hidden: true,
					    width: 0
					}, {
					    field: "lineNumber",
					    title: "Line Number",
					    hidden: true,
					    width: 100
					}, { */
					    field: "brand",
					    title: "Brand",
					    hidden:true,
					    locked:true,
				        editor: brandColumnEditor,
				        width: 80
					}, {
					    field: "styleNumber",
					    title: "Style Number",
					    locked: false,
					    width: 120
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
					    field: "price",
					    title: "Price",
					    format:"{0:c2}",
					    editor: numberColumnEditor,
					    width: 80,
					    attributes:{style:"text-align:right;"},
					}, {				//read only column
					    field: "amount",
					    title: "Amount",
					    format:"{0:c2}",
				        editor: readOnlyColumnEditor,
					    width: 80,
					    attributes:{style:"text-align:right;"},
					}, {
					    field: "remark",
					    title: "Remark",
					    width: 120
	 			}],  //end of columns
		        
		        selectable: "cell",
		        navigatable: true,
		        resizable: true,
 		        pageable: {
 		            pageSizes: false,					//["all",2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18],
 		            numeric: false,
 		            previousNext:false,
 	 	            messages: {
 		            	display: "Total line:{2}"
 	 	            }
 		        },
		        editable: {confirmation:false},

//events:		 
		       	dataBinding: function() {
		    		 lineItemGridLineNumber = (this.dataSource.page() - 1) * this.dataSource.pageSize();
		    		 if(!lineItemGridLineNumber){
		    			 lineItemGridLineNumber=0;
		    		 }
		       	},
		       	

		    }; //end of lineItemGridOptions
		    $scope.lineitemBrandOptions={
		            dataSource: {
		                data: ['DD', 'VIE', 'Vestige']
		            }	
		    };
		    $scope.lineItemToolbarOptions = {
			        items: [{
		                type: "button",
		                text: "Add",
		                id:"btnAdd",
		                click: addLineItemRow
		            }, {
		                type: "button",
		                text: "Insert",
		                id:"btnInsert",
		                click: addLineItemRow
		            }, {
		            	type: "separator"
		            }, {
		                type: "button",
		                text: "Carry On",
		                id:"btnCarryOn",
		                togglable: true,
		                selected:$scope.setting.lineItemCarryOn,
		                toggle:function (e){
							$scope.setting.lineItemCarryOn=!$scope.setting.lineItemCarryOn;
						}
		            }, {
		            	type: "separator"
		            }, {
			                type: "button",
			                text: "Delete",
			                id: "btnDelete",
			                click: deleteLineItemRow
			            }, {
			                type: "splitButton",
			                text: "Insert",
			                menuButtons: [{
			                    text: "Insert above",
			                    icon: "insert-n"
			                }, {
			                    text: "Insert between",
			                    icon: "insert-m"
			                }, {
			                    text: "Insert below",
			                    icon: "insert-s"
			                }]
			            }]
			    }; //end of toolbarOptions

//k-on event handlers			    
			    
			    $scope.onLineItemGridChange=function(dataItem,columns) {
			    	if(columns.length>0){
			    		lineItemGridCurrentDataItem=dataItem;
			    		var col=columns[0];
			    		var row=dataItem.lineNumber;
			    		if(row!=lineItemGridCurrenRow){		//row changed
			    			
			    			lineItemGridCurrenRow=row;
			    			getGarment("",dataItem);;
			    		};
/* 			    		if(col!=lineItemGridCurrenCol){		//column changed
			    			lineItemGridCurrenCol=col;
			    			if(col===6){	//colourway column
			    			};
			    			if(col===7){	//size column
			    			};
			    		} */
			    	}
  		          };	     
  		          
  		        $scope.onLineItemGridSave = function(e) {
  		        	if(e.values.styleNumber && e.values.styleNumber!=e.model.styleNumber){
  		        		e.preventDefault();
  		        		e.model.set("styleNumber",e.values.styleNumber.toUpperCase().trim())
  		        		getGarment("",e.model);
  		        	}
  		        	if(e.values.quantity){
  		        		var amount=e.values.quantity * e.model.price;
  		        		if(!angular.isNumber(amount)) amount=0;
  		        		e.model.set("amount", amount);
  		        	}
  		        	
  		        	if(e.values.price){
  		        		var amount= e.values.price * e.model.quantity;
  		        		if(!angular.isNumber(amount)) amount=0;
  		        		e.model.set("amount",amount);
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
				    	.appendTo(container).kendoComboBox({
				        autoBind: true,
				        dataSource: {
				            data: $scope.dict.colourway
				        }
				    })
				};	

				function sizeColumnEditor(container, options) {
				    $('<input class="grid-editor"  data-bind="value:' + options.field + '"/>')
				    	.appendTo(container).kendoComboBox({
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
	        		}
				}
			                
		        function getGarment(brand,model){
					var styleNumber=model.styleNumber;
					if(!styleNumber){
						lineItemGridCurrentGarment=null;
	    				setRowDict();
					}else{
						
		    			lineItemGridCurrentGarment=$scope.dict.getGarment(styleNumber);
		    			if(!lineItemGridCurrentGarment){
			    			var url="/miniataweb/garment/get-product?style="+styleNumber;
			    			$http.get(url).
			    				success(function(data, status, headers, config) {
			    				    if(data){
			    				    	lineItemGridCurrentGarment=data;
			    				    	$scope.dict.insertGarment(data);
								    	model.set("description",lineItemGridCurrentGarment.styleName);
					    				setRowDict();
			    				    }
			    			   }).
			    			   error(function(data, status, headers, config) {
			    				  alert( "failure message: " + JSON.stringify({data: data}));
			    			   });		    			   
		    			} else {
					    	model.set("description",lineItemGridCurrentGarment.styleName);
		    				setRowDict();
		    			}
					}
		    	}
		        
				function addLineItemRow(e){
		            var dataSource =$scope.lineItemGrid.dataSource;
				    var total = dataSource.view().length;
				    var newItem={
					    	orderId:$scope.order.orderInfo.orderId,
					    	orderItemId:orderItemId, 
//					    	lineNumber:total+1,
					    	brand:$scope.lineItemBrand
					    };
				    
 				    if($scope.setting.lineItemCarryOn && lineItemGridCurrentDataItem){
				    	newItem.styleNumber=lineItemGridCurrentDataItem.styleNumber;
				    	newItem.description=lineItemGridCurrentDataItem.description;
				    	newItem.colour=lineItemGridCurrentDataItem.colour;
				    }
 				    
				    if(e.id==="btnAdd"){ //append to last row
					    dataSource.add(newItem);
					    setLineNumber();
					    dataSource.page(dataSource.totalPages());
					    $scope.lineItemGrid.editRow($scope.lineItemGrid.tbody.children().last());
				    }else{		//insert before current row
				    	if(lineItemGridCurrentDataItem){
	 	 				   	var idx = dataSource.indexOf(lineItemGridCurrentDataItem);
					    	dataSource.insert(idx,newItem);
					    	setLineNumber();
				    	}else{
				    		
				    	}
				    }
 				    lineItemGridCurrentDataItem=newItem;
					
				}
		        
				function deleteLineItemRow(e){
				    if (lineItemGridCurrentDataItem) {
				        if (confirm('Please confirm to delete the selected row.')) {
//				        	alert(JSON.stringify(lineItemGridCurrentDataItem));
							if(lineItemGridCurrentDataItem.id){
								$scope.order.deletedItems.push({entity:"lineItem",id:lineItemGridCurrentDataItem.id});
							}
							
				        	$scope.lineItemGrid.dataSource.remove(lineItemGridCurrentDataItem);
				        	lineItemGridCurrentDataItem=null;
				        	lineItemGridCurrenRow=-1;
				        	setLineNumber();
				        }
				    } else {
				        alert('Please select a  row to delete.');
				    }					
				}
				
				function setLineNumber(){
					var dataItems=$scope.lineItemGrid.dataSource.view();
					for(var i=0;i<dataItems.length;i++){
						dataItems[i].lineNumber=i+1;
					}
				}
}]); 



</script>