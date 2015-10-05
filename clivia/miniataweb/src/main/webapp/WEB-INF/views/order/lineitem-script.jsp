<script>
orderApp.controller("lineitemCtrl",["$scope","$http","$stateParams" ,function($scope,$http,$stateParams){

	var orderItemId =parseInt($stateParams.orderItemId);
	
//    lineItemGridLineNumber=0;
    lineItemGridCurrentRow=null;

    lineItemGridCurrentGarment=null;

    

	$scope.lineItemBrand='DD';
 	$scope.lineItemGridOptions = {
	 			columnMenu: true,
				autoSync: true,
		        dataSource: {
		        	data: $scope.order.lineItems, 
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
		            width: 30,
		            attributes:{style:"text-align:right;", class:"lineItemGridLineNumber"},
		            headerAttributes:{style:"text-align:center;", class:"lineItemGridLineNumberHeader"}
		        
					}, {					    
					    field: "styleNumber",
					    title: "Style Number",
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
					    field: "remark",
					    title: "Remark",
					    width: 120
	 			}],  //end of columns

		        editable: {
		            createAt: "bottom"
		        },
		        
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
		    		 var pageSkip = (this.dataSource.page() - 1) * this.dataSource.pageSize();
		    		 if(!pageSkip) pageSkip=0;
		    		 pageSkip++;
		    		 
		    		 //index starts from 0
		       		$(".lineItemGridLineNumber").text(function(index){
		       		//	console.log("line number index:"+index);
		       			return pageSkip+index;
		       		});	       		
		       	},
		       	
		       	save: function(e) {
		       		var fieldName;
		       		var fieldValue;
		       		for(var i=0;i<this.columns.length;i++){
		       			if (typeof e.values[this.columns[i].field]!='undefined'){
		       				fieldName=this.columns[i].field;
		       				fieldValue=e.values[fieldName];
		       				break;
		       			}
		       		}
		       		
		       		if(fieldValue===";"){
		       		 	
		       			alert("asdfasdf");
		       			
		       		}else if(typeof e.values.styleNumber!== 'undefined'){
		          		if(e.values.styleNumber!=e.model.styleNumber){
			          		e.preventDefault();
			          		e.model.set("styleNumber",e.values.styleNumber.toUpperCase().trim());
			          		getGarment(e.model);
//				       		console.log("get garment:"+e.values.styleNumber);

		          		}
		          	}
		          	
		         },
		       	
		       	change:function(e){
		       		var row=getCurrentRow();
	        		if(row!==lineItemGridCurrentRow){		//row changed
	        			lineItemGridCurrentRow=row;
	        			var dataItem=getCurrentDataItem();
	        			getGarment(dataItem);;
	        		};
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
						console.log("set row dict:"+String(lineItemGridCurrentGarment.colourway));
	        		}
				}
			                
		        function getGarment(model){
					var styleNumber=model.styleNumber;
					if(!styleNumber){
						lineItemGridCurrentGarment=null;
	    				setRowDict();
					}else{
						
		    			lineItemGridCurrentGarment=$scope.dict.getGarment(styleNumber);
		    			if(!lineItemGridCurrentGarment){
			    			var url=$scope.setting.garmentUrl+"get-product?style="+styleNumber;
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
		        
				function addLineItemRow(isInsert){
					var grid=$scope.lineItemGrid;
  		            var dataSource =grid.dataSource;
				    var newItem={
					    	orderId:$scope.order.orderInfo.orderId,
					    	orderItemId:orderItemId, 
					    	brand:$scope.lineItemBrand
					    };
 				    
				    if(!isInsert){ //append to last row
					    dataSource.add(newItem);
					    setLineNumber();
					    if(dataSource.totalPages()>1)		//without the line will casue problem when add row  
					    	dataSource.page(dataSource.totalPages());
				    	grid.editRow(grid.tbody.children().last());
					    
				    }else{		//insert before current row
		 				var rowIdx =getCurrentRowIndex();
				    	var idx = getCurrentDataItemIndex();
					    dataSource.insert((!!idx)?idx:0,newItem);
					    setLineNumber();
				    	grid.editRow(getRow(rowIdx));
				    }
				    
				}
				
				function getDataItem(row){
					if(!$scope.lineItemGrid) return null;
					return (!!row)?$scope.lineItemGrid.dataItem(row):null;
				}
				
				
				function getDataItemIndex(dataItem){
					if(!$scope.lineItemGrid) return null;
					var index = (!!dataItem)?$scope.lineItemGrid.dataSource.indexOf(dataItem):null;
					console.log("dataItem index:"+index);
					return index;
				}
				
				function getCurrentDataItem(){
					if(!$scope.lineItemGrid) return null;
					var row=getCurrentRow();
					return getDataItem(row);
				}
				
				function getCurrentDataItemIndex(){
					if(!$scope.lineItemGrid) return null;
					var dataItem= getCurrentDataItem();
					var idx = getDataItemIndex(dataItem);
					return idx;
				}
				
				function getRow(index){
					if(!$scope.lineItemGrid) return null;
					return $scope.lineItemGrid.tbody.children().eq(index)
				}

				//index starts from 0
				function getRowIndex(row){
					if(!$scope.lineItemGrid) return null;
					 var index=(!!row)?($("tr", $scope.lineItemGrid.tbody).index(row)):null;
					 return index;
				}
				
				
				function getCurrentRow(){
					if(!$scope.lineItemGrid) return null;
					var cell=$scope.lineItemGrid.current();
					return (!!cell)?cell.closest("tr"):null;
				}
				
				
		        
				function getCurrentRowIndex(){
					if(!$scope.lineItemGrid) return null;
					return getRowIndex(getCurrentRow());
				}
				

				function deleteLineItemRow(){
					var dataItem=getCurrentDataItem();
					var grid=$scope.lineItemGrid;
					
				    if (dataItem) {
				        if (confirm('Please confirm to delete the selected row.')) {
							if(dataItem.id)
								$scope.order.deletedItems.push({entity:"lineItem",id:dataItem.id});
							
				        	grid.dataSource.remove(dataItem);
				        	lineItemGridCurrentRow=-1;
				        	setLineNumber();
				        	grid.table.focus();
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
				
			    $scope.$on("kendoWidgetCreated", function(event, widget){
			        // the event is emitted for every widget; if we have multiple
			        // widgets in this controller, we need to check that the event
			        // is for the one we're interested in.
			        if (widget ===$scope.lineItemGrid) {
			        	$scope.common.itemGrid=$scope.lineItemGrid;
			        	enableReorderRow($scope.lineItemGrid,true);
			        }
			    });				
				
				function enableReorderRow(grid,enable){
					if(enable){
						
	 					grid.table.kendoSortable({
		                    filter: ">tbody >tr:not(.k-grid-edit-row)",
		                    hint: $.noop,
		                    cursor: "move",
		                    placeholder: function(element) {
		                        return element.clone().addClass("k-state-hover").css("opacity", 0.65);
		                    },
		                    container: "#lineItemGrid tbody",
		                    change: function(e) {
		                    	var dataSource,skip,oldIndex,newIndex,dataItem;
		                    	
		                        dataSource=$scope.lineItemGrid.dataSource;
			                    skip = !!(dataSource.skip())?(dataSource.skip()):0;
		                        oldIndex = e.oldIndex + skip;
		                        newIndex = e.newIndex + skip;
		                        dataItem = dataSource.getByUid(e.item.data("uid"));
	
		                        dataSource.remove(dataItem);
		                        dataSource.insert(newIndex, dataItem);
		                        setLineNumber();
		                        dataSource.sync();
		                    }
		                });
					}else{
	 					grid.table.kendoSortable({});
					}
				}
				
				
				$scope.lineItemGridContextMenuOptions={
						closeOnClick:true,
						filter:".lineItemGridLineNumber,.lineItemGridLineNumberHeader",
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


}]); 



</script>