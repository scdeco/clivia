<script>

orderApp.controller("orderMainCtrl", ["$scope","$state", "$filter","SO",function($scope,$state, $filter, SO) {
	$scope.SO=SO;
	
	var imgUrl="../resources/images/";
	
	var searchTemplate='<kendo-combobox name="searchOrderNumber" k-placeholder="\'Search Order#\'" ng-model="searchOrderNumber" ng-disabled="getOrderDisabled" k-options="searchOrderNumberOptions" style="width: 140px;" />';
						
						
    $scope.orderToolbarOptions = {
	        items: [{
	                type: "button",
	                text: "New",
	                id:"btnNew",
	                imageUrl:imgUrl+"i-new.ico",
	                click: function(e) {
	            		if(!$scope.orderIsDirty() || $scope.confirmDiscardChanges()){
		                	$scope.newOrder();
	            		}
	                }
	            }, {
	            	enable:false,
	                type: "button",
	                text: "Repeat",
	                id:"btnRepeat",
	                imageUrl:imgUrl+"i-repeat.ico",
	                click: function(e) {
	                	$scope.repeatOrder();
	                }
	            }, {
	                type: "separator",
	            }, {	
	                type: "button",
	                text: "save",
	                id: "btnSave",
	                imageUrl:imgUrl+"i-save.ico",
	                click: function(e){
	                	$scope.saveOrder();
	                }
	            }, {
	                type: "separator",
	            }, {	
	                template:searchTemplate,		                
/* 	            }, {
	                type: "button",
	                text: "Go",
	                imageUrl:imgUrl+"i-go.ico",
	                id:"btnGo",
	                click: function(e) {
	                	$scope.getOrder();
	                }	                 */
	            }, {
	                type: "button",
	                text: "Find",
	                imageUrl:imgUrl+"i-find.ico",
	                id:"btnFind",
	                click: function(e) {
	                	$scope.openQueryWindow();
	                }	                
	            }, {
	                type: "separator",
                },{
                    type: "splitButton",
                    text: "Print",
                    id:"btnPrint",
 	                imageUrl:imgUrl+"i-print.ico",
                    menuButtons: [{ 
		       				 text: "Garment Confirmation", 
		    				 id:"garmentConfirmation",
	                    },{
		       				 text: "Garment Confirmation Without Discount Columns", 
		    				 id:"garmentConfirmationWithoutDsicount",
		    				 
	                    },{
		       				 text: "Garment Packing Slip", 
		    				 id:"garmentPackingSlip",
	                    },{
		       				 text: "Deco Confirmation", 
		    				 icon: "insert-n",
		    				 id:"decoConfirmation",
	                    }],
	                    
              		click:function(e) {
              			$scope.printOrder(e.id);
              		}
  	            }, {
	                type: "separator",
 	            }, {
	                type: "button",
	                text: "Customer",
	                id:"btnCustomer",
	                imageUrl:imgUrl+"i-customer.ico",
	                click: function(e) {
		                	$scope.openCompany(SO.dataSet.info.customerId);
		                }
 	                
	       }]
	    };	
    $scope.saveResultOptions={
/*             templates: [{
                type: "ngTemplate",
                template: '<p style="width: 16em; heigth:5em; padding:1em;white-space:nowrap">Order# {{SO.dataSet.info.orderNumber}} save successful. </p>''
             }]*/
             position: {
                 pinned: true,
                 top: 50,
                 left: 200,
                 bottom: null,
                 right: null,
             }             
             
        };
    
    $scope.searchOrderNumberOptions={
    	dataSource:{data:[]},	//recent orders
    	//Fired when the value of the widget is changed by the user
    	change:function(e){
    		$scope.getOrder();
    	}
    }
    
	$scope.companyOptions={
		name:"companyComboBox",
		dataTextField:"businessName",
		dataValueField:"id",
		minLength:1,
		url:'../datasource/companyInfoDao/read',
	}

 	$scope.companyWindowOptions={
			activate:function(){
				$scope.companyCard.mainSplitter.resize();
			},
	}
	
	$scope.queryGridOptions={
			doubleClickEvent:function(e){
					if(e.currentTarget){
						var di=this.dataItem(e.currentTarget);
						if(di){
							$scope.searchOrderNumber=di.orderNumber;
							$scope.getOrder();
							if(e.target && e.target.cellIndex===0)
								$scope.queryWindow.close();
						}
						
					}
				}
	}
	
	$scope.generateUpcs=function(){
		SO.generateUpcs();
		$scope.$apply();
	};	
	
	
	$scope.newOrder=function(){
		$scope.orderItems.clearInstance();
		SO.clear();
		$scope.$apply();
	};	
	
	
	$scope.printOrder=function(id){
		if(id==="garmentConfirmation"||id==="garmentConfirmationWithoutDsicount"||id==="garmentPackingSlip"){
			
			var orderItem=$scope.orderItems.getCurrentOrderItemDi();
			if(orderItem && orderItem.typeId===1){	//billItem
				var dataSource=new kendo.data.DataSource({
							     	data:SO.dataSet.billItems, 
							   	    filter: {field: "orderItemId", operator: "eq",value: orderItem.id },    
								    sort:{field:"lineNo"},
							    }); //end of dataSource,
							    
				dataSource.fetch(function() {
					  var billItems = dataSource.view();
					  var file=(id==="garmentPackingSlip"?"printpackingslip":"printconfirmdd");
					  SO.printBill(billItems,false,true,id==="garmentConfirmationWithoutDsicount",file);		//if true,print billItems that from lineitem(typeid===2) only
					});
			}
		}
		
	}
	
	$scope.confirmDiscardChanges=function(){
		var discard=confirm("Changes to this order have not been saved. Do you want to DISCARD the changes?");
		if(discard)
			$scope.orderInfo.infoForm.$setPristine();
		return discard;
	}
	
	

	$scope.repeatOrder=function(){
		if(SO.isNew()) return;
		
		if(!$scope.orderIsDirty() || $scope.confirmDiscardChanges()){
			SO.repeat();
			$scope.$apply();
		}
	}

	$scope.getOrder=function(){
		if(!!$scope.searchOrderNumber && (!$scope.orderIsDirty() || $scope.confirmDiscardChanges())){
			if($scope.getOrderDisabled)
				return;
			
			$scope.getOrderDisabled=true;

			$scope.newOrder();
			
			SO.retrieve($scope.searchOrderNumber)
				.then(function(data){
				    if(data){
				    	var items=SO.dataSet.items;
			    		for(var i=0;i<items.length;i++)
			    			$scope.orderItems.addOrderItem(null,items[i]);

			    		//retrieve all items here
			    		//SO.dict.getRemoteImages();
			    		
			    		var orderItemId=items.length>0?items[0].id:0;
			    		$scope.orderItems.setCurrentOrderItem(orderItemId);
				    	
				    }else{
				    	alert("Can not find order:"+$scope.searchOrderNumber+".");
				    }
				    $scope.searchOrderNumber="";
					$scope.getOrderDisabled=false;;
				},function(data){
					alert( "failure message: " + JSON.stringify({data: data}));
					$scope.searchOrderNumber="";
					$scope.getOrderDisabled=false;;
				});
		}
		else{
			alert("Please input a Order# to search.");
			
		}
	}
	
	$scope.orderIsDirty=function(){
		if($scope.orderInfo && $scope.orderInfo.infoForm.$dirty)
			SO.dataSet.info.isDirty=true;
		
		return SO.isDirty();
		
	}
	
	$scope.saveOrder=function(){
		if($scope.orderIsDirty()){
			SO.save()
				.then(function(data){
				    if(data){
				    	//adjust new orderitem button orderItemId value
				    	
				    	var items=SO.dataSet.items;
				    	var currentId=0;
				    	for(var i=0,item,button;i<items.length;i++){
				    		item=items[i];
				    		button=SO.instance.itemButtons[item.lineNo-1];
				    		button.orderItemId=item.id;
				    		if(button.selected)
				    			currentId=button.orderItemId;
				    	}		
			    		SO.setCurrentOrderItem(currentId);
			    		$scope.orderInfo.infoForm.$setPristine();
			    		$scope.saveResult.show('<p style="width: 16em; height:2em; padding:1em;white-space:nowrap">Order#:'+SO.dataSet.info.orderNumber+ ' saved successfully. </p>',"info");
				    }else{
			    		alert("Can not find order:"+$scope.searchOrderNumber+".");
				    }
				},function(data){
					alert( "failure message: " + JSON.stringify({data: data}));
				});
		}
	}
	
	$scope.deleteOrder=function(){
		
		if(SO.isNew() && confirm("Please confirm to delete this order.")){
			SO.remove()
			.then(function(data){
			    if(data){
		    	
			    }else{
		    		alert("Can not delete this order:"+OrderModel.info.orderNumber+".");
			    }
			},function(data){
				alert( "failure message: " + JSON.stringify({data: data}));
			});
		}
	}
	
	$scope.openCompany=function(companyId){
 		if(!!companyId){
			$scope.companyCard.load(companyId);
		}else{
			$scope.companyCard.clear();
		}
 		$scope.$apply();
		$scope.companyWindow.open();
	}
	
	$scope.openQueryWindow=function(){
		$scope.queryWindow.open();
	}
	
	
}]);


orderApp.directive("orderInfo",["$http","cliviaDDS","util",function($http,cliviaDDS,util){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@orderInfo',
				},
			templateUrl:'orderinfo',
			
			link:function(scope){
				
			},
			
			controller: ["$scope","SO","cliviaDDS",function($scope,SO,cliviaDDS) {

				$scope.SO=SO;
				if($scope.cName)
					$scope.$parent[$scope.cName]=$scope;

				$scope.dateOptions={
						format: "yyyy-MM-dd",
					    parseFormats: ["yyyy-MM-dd"]
				}

				
				$scope.requireTimeOptions={
						format: "hh:mm tt",
						parseFormats:["HH:mm:ss"],
						min: new Date(2000, 0, 1, 8, 0, 0), 
						max: new Date(2000, 0, 1, 17, 0, 0)
				}
				
				$scope.orderTimeOptions={
						format: "hh:mm tt",
						parseFormats:["HH:mm:ss"],
				}
				
				$scope.buyerOptions={
						name:"buyerComboBox",
						dataSource:SO.company.buyerDataSource,
				}
				
				$scope.repOptions={
						name:"repComboBox",
						dataTextField:"fullName",
						dataValueField:"id",
						minLength:1,
						filter:"isRep,eq,true",
						url:"../datasource/employeeInfoDao/read",
						dict:cliviaDDS.getDict("employeeInput"),
						onValueChanged:function(e){
							console.log("Rep Changed:"+e.text);
							SO.repName=e.text;
						}
					}

				$scope.csrOptions={
						name:"csrComboBox",
						dataTextField:"fullName",
						dataValueField:"id",
						minLength:1,
						filter:"isCsr,eq,true",
						url:"../datasource/employeeInfoDao/read",
						dict:cliviaDDS.getDict("employeeInput"),
						onValueChanged:function(e){
							SO.csrName=e.text;
							console.log("Csr Changed:"+e.text);
						}
					}

				$scope.termsOptions={
						dataSource:util.getTerms()
				}
				
			}]
		};
	return directive;
				
}]);//end of orderInfo directive


orderApp.directive("orderItems",["SO","cliviaDDS","util","$compile",function(SO,cliviaDDS,util,$compile){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@orderItems',
				},
			templateUrl:'orderitem',
			
			link:function(scope){
				scope.clearInstance=function(){
					var items=SO.dataSet.items;
					for(var i=0;i<items.length;i++){
						scope.removeOrderItemElement(items[i]);
						scope.removeOrderItemButton(items[i]);
					}
					scope.$apply();
				}
				
				scope.setCurrentOrderItem=function(orderItemId){
					var instance=scope.instance;
					if(!(orderItemId>0)) {
						instance.currentItemId=0;
						return;
					}
			       	if(instance.currentItemId!=orderItemId){
			       		
						var orderItem=scope.getOrderItemDi(orderItemId);
						if(orderItem.typeId===1){
							SO.generateBillableItems(orderItem);
							scope.$apply();
						}
						
						instance.currentItemId=orderItemId;
						if(orderItemId>0) {
					        for(var i=0;i<instance.itemButtons.length;i++){
				        		instance.itemButtons[i].selected=instance.itemButtons[i].orderItemId===orderItemId;
					        }
					        for(var i=0,el;i<instance.itemElements.length;i++){
					        	el=instance.itemElements[i];
				        		el.element[0].style.display=el.orderItemId===orderItemId?"inline":"none";
					        }
							//splitter size might be changed while the order item is hidden before set to current order item.
							//adjust size of the components in the new current order item
							var currentOrderItemScope=scope.getOrderItemScope(scope.getCurrentOrderItemDi());
							if(currentOrderItemScope&&currentOrderItemScope.resize){
								currentOrderItemScope.resize();
							}
						}
						
			       	}
					
				};
			 	
			 	
			 	scope.getCurrentOrderItemDi=function(){
			 		return scope.getOrderItemDi(scope.instance.currentItemId);
			 	}
			 	
			 	
			 	scope.getOrderItemDi=function(itemId){
			 		var item=null;
			 		var items=SO.dataSet.items;
			 		for(var i=0;i<items.length;i++)
			 			if(itemId===items[i].id){
			 				item=items[i];
			 				break;
			 			}
			 		return item;		
			 	}
				
			 	scope.getCurrentOrderItemButton=function(){
			 		var item=scope.getCurrentOrderItemDi();
			 		var buttons=scope.instance.itemButtons;
			 		var button=null;
			 		for(var i=0;i<buttons.length;i++){
			 			if(buttons[i].orderItemId===item.id){
			 				button=buttons[i];
			 				break;
			 			}
			 		}
			 		return button;
			 	}

			 	scope.getCurrentOrderItemElement=function(){
			 		var item=scope.getCurrentOrderItemDi();
			 		var elements=scope.instance.itemElements;
			 		var element=null;
			 		for(var i=0;i<elements.length;i++){
			 			if(elements[i].orderItemId===item.id){
			 				element=elements[i];
			 				break;
			 			}
			 		}
			 		return element;
			 	}
			 	
			 	scope.addOrderItemButton=function(orderItem){
			 		
			        var button={
			        		text:orderItem.title, 
			        		id: "btn"+orderItem.id, 
			        		icon: "insert-n",
			        		togglable: true, 
			        		group: "OrderItem",
			        		orderItemId:orderItem.id,
			        	};
			        scope.instance.itemButtons.push(button);
			        
			        return button;
			 	}
			 	
			 	
			 	
			 	scope.addOrderItemElement=function(orderItem,itemElement){
			        var element={
			        		orderItemId:orderItem.id,
			        		element:itemElement,
			        		
				        };
			        scope.instance.itemElements.push(element);
			        scope.instance.orderItemElement.append(itemElement);
			 	}
			
			 	//create an orderItem and add into dataSet.items
			   scope.addOrderItemDi = function(menuItem) {
				    
			     	var orderItemId=SO.getTmpId();
			     	var dataSet=SO.dataSet;
			     	var orderItem={
			    			orderId:dataSet.info.orderId ,
			    			id:orderItemId,
			    			lineNo:dataSet.items.length+1,
				     		title:menuItem.text,
			 				typeId:menuItem.itemTypeId,
			 				snpId:menuItem.snpId,
			 				spec:menuItem.spec,
			 				isDirty:true,
			     		};
			     	
			     	if(menuItem.itemTypeId===2){		//"lineItem"
			     		var brand=SO.getBrandFromSpec(menuItem.spec);
			   			var season=SO.getSeasonFromSpec(menuItem.spec);
			   			orderItem.spec=season.brandId+":"+season.id;
			     	}
			     	dataSet.items.push(orderItem);
			     	return orderItem;
			       };	
			    
			    //if is new ,provide menuItem, else orderItem has been created 
			    scope.addOrderItem=function(menuId,orderItem){
			    	var typeId;
			    	if(menuId){
	       				var menuItem=SO.getRegisteredOrderItem(menuId);
	                  	orderItem=scope.addOrderItemDi(menuItem);		//enuItem.itemType,menuItem.text,menuItem.spec
	                  	typeId=menuItem.itemTypeId;
			    	}else{
			    		typeId=orderItem.typeId;
			    	}
			    	var itemType=SO.getRegisteredItemType(typeId);
	                var itemName=itemType.name+orderItem.id;
                 	var itemElements=$compile("<div "+itemType.directive+"='"+itemName+"' c-item-id='"+orderItem.id+"'></div>")(scope);
                  	scope.addOrderItemButton(orderItem);
                  	scope.addOrderItemElement(orderItem,itemElements);
                  	return orderItem;
			    };
			       
			    scope.removeOrderItemButton=function(orderItem){
		    		var itemButtons=scope.instance.itemButtons;
			    	//remove the item button from _order.instance.itemButtons
			    	var idx=util.findIndex(itemButtons,"orderItemId",orderItem.id);
			    	itemButtons.splice(idx,1);
			    }
			    
			    scope.removeOrderItemElement=function(orderItem){
		    		var itemElements=scope.instance.itemElements;
			    	//remove element of orderitem from itemElements and parent element
			    	idx=util.findIndex(itemElements,"orderItemId",orderItem.id);
			    	var element=itemElements[idx].element;
			    	itemElements.splice(idx,1);
			    	kendo.destroy(element);
			    	
			    	var type=SO.getRegisteredItemType(orderItem.typeId);
			    	var tempScope=scope[type.name+orderItem.id];
			    	delete scope[type.name+orderItem.id];
			    	tempScope.$destroy();
			    	
			    	element.remove();
			    }
			    
			    scope.removeOrderItemDi=function(orderItem){
			    	var items=SO.dataSet.items;
			    	
			    	//remove the orderItem from  _order.dataSet.items
			    	var idx=util.findIndex(items,"id",orderItem.id);
			    	items.splice(idx,1);
			    	
			   		//register deleted items
				   	SO.registerDeletedItem("orderItem",orderItem.id,true);
			   		
			    	//get dataTable from the dataSet, orderItem.typeId registeredItemType.name is the dataTable name
					var type=SO.getRegisteredItemType(orderItem.typeId);
			    	var dis=SO.dataSet[type.name+"s"];  
					 for(var i=dis.length-1;i>=0;i--){
						 di=dis[i];
						 if(di.orderItemId===orderItem.id){
							 
					   		 //register to deleted items 
							SO.registerDeletedItem(type.model,di.id);
					   		
							 //remove from the dataTable
						    dis.splice(i,1);
						 }
					 }
			   		
			    	//set lineNo same as item index+1
			    	scope.setOrderItemLineNo();
			    	if (idx===items.length)
			    		idx--;
			    	var id=idx>=0?items[idx].id:0;
			    	return id;
			    }
			    
			    scope.removeOrderItem=function(orderItem){
			    	
			    	scope.removeOrderItemButton(orderItem);
			    	scope.removeOrderItemElement(orderItem);
					var newCurrentItemId=scope.removeOrderItemDi(orderItem);	
					
			    	//set new current orderItem. if no more item, set to blank.
			   		scope.setCurrentOrderItem(newCurrentItemId);
			    }
			        
			    scope.setOrderItemLineNo=function(){
			    	var items=scope.SO.dataSet.items;
			    	
			    	//set lineNo same as item index+1
					for(var i=0,lineNo;i<items.length;i++){
						lineNo=i+1;
						if(items[i].lineNo!==lineNo){
				  			 items[i].lineNo=lineNo;
				  			 items[i].isDirty=true;
						}
						
					}
			    }
			    
			    scope.getOrderItemScope=function(orderItem){
					 var type=SO.getRegisteredItemType(orderItem.typeId);
					 return scope[type.name+orderItem.id];
			    }
				
			},

			controller: ["$scope","SO","cliviaDDS","$element",function($scope,SO,cliviaDDS,$element) {
				$scope.SO=SO;
				
				$scope.$parent["orderItems"]=$scope;

				$scope.instance={
					orderItems:[],
					orderItemElement:$element,
					itemButtons:new kendo.data.ObservableArray([]),
					itemElements:[],
					currentItemId:0,
					};

			     $scope.itemToolbarOptions = {
			             items: [{
			                         type: "buttonGroup",
			                         buttons:$scope.instance.itemButtons,
			                     },{ 
			                    	 type: "separator" 
			                     },{
				                     type: "splitButton",
				                     text: "+",
				                     id:"additem",
				                     menuButtons: SO.setting.registeredOrderItems,
			                   		click:function(e) {
			                   			if(e.id!="additem"){
			                   				var item=$scope.addOrderItem(e.id);
			                              	$scope.setCurrentOrderItem(item.id);
			                   			}
			                   		}
				            	  
				              }],
			             toggle:function(e){
			            	 var itemButtons=$scope.instance.itemButtons;
			            	 for(var i=0,button;i<itemButtons.length;i++){
			            		 button=itemButtons[i];
			            		 if(button.id===e.id){
			                       	 $scope.setCurrentOrderItem(button.orderItemId);
			            			 break;
			            		 }
			            	 }
			             }
			 	 };
			     
			     $scope.itemToolbarSortableOptions={
						 filter: "a.k-toggle-button",	
						 disabled: "a:not(.k-state-active)",
			             hint: $.noop,
			             cursor: "move",
			             placeholder: function(element) {
			                 return element.clone().addClass("k-state-hover").css("opacity", 0.65);
			             },
			             container: "div.k-button-group",
			             change: function(e) {
			            	 var items=SO.dataSet.items,
			            	  	 item=items.splice(e.oldIndex,1)[0];
			            	 
			           		 items.splice(e.newIndex,0,item);
			           		 $scope.setOrderItemLineNo();

			           		 var buttons=$scope.instance.itemButtons,
			            		 button=buttons.splice(e.oldIndex,1)[0];
			           		 
			            	 buttons.splice(e.newIndex,0,button);
			             }
			              		 
			     };
			     
			     
			 	$scope.itemToolbarContextMenuOptions={
			 			closeOnClick: false,
			 			filter:"a.k-state-active",
			 			open: function(e){
			 				if ($(e.item).is("li"))  return;
			 				$scope.currentItemButton=$scope.getCurrentOrderItemButton();
			 				var menuText="<input type='text' class='k-textbox' ng-model='currentItemButton.text'>"
			 				var items = this.setOptions({
			 	                dataSource: [{
				 	 	                text: "Change Title", 
				 	 	                items: [{text:menuText,encoded: false, value: "menuRename"}]
				 	 	            }, {
				 	 	                text: "Remove",
				 	 	                value: "menuRemove"
				 	 	            }]
			 	            })
			 			},
			 			close:function(e){
			 				if($(e.item).is("li") && $scope.currentItemButton){
			 					var item=$scope.getCurrentOrderItemDi();
			 					if($scope.currentItemButton.text!==item.title){
			 						item.title=$scope.currentItemButton.text;
			 						item.isDirty=true;
			 					}
			 				}
			 			},
			 			select: function(e){
			 				if($(e.item).is("li") && e.item.textContent==="Remove"){
				 				this.close();
				 				var item=$scope.getCurrentOrderItemDi()
				 				if (confirm('Please confirm to remove the selected item: '+item.title+'.')) {
				 					$scope.removeOrderItem(item);
				 					$scope.$apply(); //refresh buttonItems
				 				}
			 				}
			 				
			 			}
			 		}				
			}]	//end of controller
	};
	return directive;
}]);	//end of orderItems directive
			
orderApp.directive("lineItem",function(SO){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@lineItem',
				cItemId:'@',
				},
			templateUrl:'lineItem',
			
			link:function(scope){
				$scope=scope;

				//pass to garmentGird directive to create new lineitem		        
		    	$scope.newItemFunction=function(){
						
						var orderItem=$scope.$parent.getCurrentOrderItemDi();
						var s=$scope.$parent.getOrderItemScope(orderItem);
		    		    return {
		    			    	orderId:SO.dataSet.info.orderId,
		    			    	orderItemId:orderItem.id, 
		    			    	brandId:s.brand.id,
		    			    	seasonId:s.season.id,
		    			    }
		    		}
		    		        
		    	//pass to garmentGird directive to register removed lineitem		        
		    	$scope.registerDeletedItemFunction=function(dataItem){
		    		SO.registerDeletedItem("orderLineItem",dataItem.id);
		    	}
		    	
		    	$scope.resize=function(){
		    		var orderItem=$scope.$parent.getCurrentOrderItemDi();
					var s=$scope.$parent.getOrderItemScope(orderItem);
		    		s.lineItemSplitter.resize();
		    	}
			},
			controller: ["$scope",function($scope) {
				
					$scope.SO=SO;
					if($scope.cName)
						$scope.$parent[$scope.cName]=$scope;
					
					$scope.orderItem=$scope.$parent.getOrderItemDi(parseInt($scope.cItemId));
					
			    	$scope.brand=SO.getBrandFromSpec($scope.orderItem.spec);
			    	$scope.season=SO.getSeasonFromSpec($scope.orderItem.spec);
			    	$scope.seasonId=$scope.season.id;

					
				    $scope.lineItemSplitterOptions={
				        	resize:function(e){

				        		var panes=e.sender.element.children(".k-pane"),
				    			gridHeight=$(panes[1]).innerHeight();
				    	      	window.setTimeout(function(){
				    	      		if($scope.garmentGrid)
				    		      		$scope.garmentGrid.resize(gridHeight);
				    		    },1);    
				    	      	console.log("resize2:");
				        	}		
				        }

				    	
				    	$scope.$watch("seasonId",function(newValue,oldValue){
				    		if(newValue && newValue!=oldValue){
				    			$scope.season=SO.dds.season.getLocalItem("id",parseInt(newValue));
				    			orderItem.spec=$scope.brand.id+":"+$scope.season.id;
				    		}
				    	});
				    	
				     	$scope.garmentGridDataSource=new kendo.data.DataSource({
				     		        	data:SO.dataSet.lineItems, 
				    		    	    schema: {
				    		    	    	model: { id: "id" }
				    		    	    },	//end of schema
				    		    	    
				       		    	    filter: {
				    		    	        field: "orderItemId",
				    		    	        operator: "eq",
				    		    	        value: $scope.orderItem.id,
				    		    	    },    
				    		    	    
				    		    	    serverFiltering:false,
				    		    	    pageSize: 0,			//paging in pager

				    		        }); //end of dataSource,
				    	
					
					
			}]	//end of controller
	};
	return directive;
});	//end of lineItem directive
	

orderApp.directive("billItem",function(SO,$sce){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@billItem',
				cItemId:'@',
				},
			templateUrl:'billItem',
			
			link:function(scope){
				$scope=scope;
				
				//pass to billGird directive to create new lineitem		        
				$scope.newItemFunction=function(){
						//Don't know why the $scope changed to last added orderItem's scope
						var orderItem=$scope.$parent.getCurrentOrderItemDi();
					    return {
						    	orderId:SO.dataSet.info.orderId,
						    	orderItemId:orderItem.id, 
						    	snpId:0,
						    	orderAmt:0,
						    };
					}
					        
				//pass to billGrid directive to register removed billitem		        
				$scope.registerDeletedItemFunction=function(dataItem){
					SO.registerDeletedItem("orderBillItem",dataItem.id);
				}
				
				$scope.getDetailFunction=function(billItem){
					var html;
					//if itemTypeId===2, the item is from lineItem and its billingKey is a string of garmentId
					if(billItem && billItem.itemTypeId===2){
						html=SO.getStyleGridHtml(parseInt(billItem.billingKey),true);
					}
					
					if(!html)
						html="<div></div>";
					$scope.htmlBillItemDetail=$sce.trustAsHtml(html); 
				}
				

				$scope.getTotalAmount=function(){
					if(!$scope.billGrid) return "";
					var totalAmt=$scope.billGrid.getTotal(),
						c=SO.company.info.country==="Canada"?"CA":"US",
						result=c+(totalAmt?kendo.toString(totalAmt,"c"):"");
					return result;
				}
				
				$scope.setDiscount=function(oldValue,newValue){
					oldValue=parseFloat(oldValue);
					newValue=parseFloat(newValue);
					if(oldValue===newValue) 
						return;
					
					$scope.orderItem.isDirty=true;
					$scope.billGrid.gridWrapper.setDiscount(newValue);
					$scope.billGrid.grid.refresh();
				}
				
		    	$scope.resize=function(){
		    		var orderItem=$scope.$parent.getCurrentOrderItemDi();
					var s=$scope.$parent.getOrderItemScope(orderItem);
		    		s.billItemSplitter.resize();
		    	}				
			},

			controller: ["$scope",function($scope) {
				$scope.SO=SO;
				if($scope.cName)
					$scope.$parent[$scope.cName]=$scope;
				
				$scope.orderItem=$scope.$parent.getOrderItemDi(parseInt($scope.cItemId));
				if($scope.orderItem.spec==="")
					$scope.orderItem.spec=SO.company.info.discount;
				
				//generate auto bill items from lineItems...
				SO.generateBillableItems($scope.orderItem);

			    $scope.billItemSplitterOptions={
			        	resize:function(e){

			        		var panes=e.sender.element.children(".k-pane"),
			    			gridHeight=$(panes[1]).innerHeight();
			    	      	window.setTimeout(function(){
			    	      		if($scope.billGrid)
			    		      		$scope.billGrid.resize(gridHeight);
			    		    },1);    
			    	      	console.log("resize2:");
			        	}		
			        }
				
			 	$scope.billGridDataSource=new kendo.data.DataSource({
			     	data:SO.dataSet.billItems, 
				    schema: {
				    	model: { 
				    		id: "id" ,
				    		fields:{
				    			snpId: {type: "number"},
			 					listPrice:{type: "number"},
			 					orderQty:{type: "number"},
			 					orderPrice:{type: "number", validation: {  min: 0} },
			 					orderAmt:{type: "number"},
			 				}}
			 			
				    },	//end of schema
				    
			   	    filter: {
				        field: "orderItemId",
				        operator: "eq",
				        value: $scope.orderItem.id,
				    },    
				    
				    serverFiltering:false,
				    pageSize: 0,			//paging in pager

			    }); //end of dataSource,
			    
			    
				$scope.discountOptions={
						min: 0,
			         	max: 1,
			            step: 0.01,
			            format: "{0:p0}",
			            decimals:2
				}    
				
			}]	//end of controller
	};
	return directive;
});	//end of billItem directive

orderApp.directive("designItem",function(SO,$sce){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@designItem',
				cItemId:'@',
				},
			templateUrl:'designItem',
			
			link:function(scope){
				$scope=scope;
				
				$scope.newItemFunction=function(){
						//Don't know why the $scope changed to last added orderItem's scope
						var orderItem=$scope.$parent.getCurrentOrderItemDi();
					    return {
						    	orderId:SO.dataSet.info.orderId,
						    	orderItemId:orderItem.id, 
						    	snpId:0,
						    	orderAmt:0,
						    };
					}
					        
				//pass to designGrid directive to register removed billitem		        
				$scope.registerDeletedItemFunction=function(dataItem){
					SO.registerDeletedItem("orderDesignItem",dataItem.id);
				}

 				$scope.resize=function(){
		    		var orderItem=$scope.$parent.getCurrentOrderItemDi();
					var s=$scope.$parent.getOrderItemScope(orderItem);
					s.designItemSplitter.resize();
		    	}				
 			},

			controller: ["$scope",function($scope) {
				$scope.SO=SO;
				if($scope.cName)
					$scope.$parent[$scope.cName]=$scope;
				
				$scope.orderItem=$scope.$parent.getOrderItemDi(parseInt($scope.cItemId));
				if($scope.orderItem.spec==="")
					$scope.orderItem.spec=SO.company.info.discount;
				

			    $scope.designItemSplitterOptions={
			        	resize:function(e){

			        		var panes=e.sender.element.children(".k-pane"),
			    			gridHeight=$(panes[1]).innerHeight();
			    	      	window.setTimeout(function(){
			    	      		if($scope.designGrid)
			    		      		$scope.designGrid.resize(gridHeight);
			    		    },1);    
			    	      	console.log("resize2:");
			        	}		
			        }
				
			 	$scope.designGridDataSource=new kendo.data.DataSource({
			     	data:SO.dataSet.designItems, 
				    schema: {
				    	model: { 
				    		id: "id" ,
			 			}
			 			
				    },	//end of schema
				    
			   	    filter: {
				        field: "orderItemId",
				        operator: "eq",
				        value: $scope.orderItem.id,
				    },    
				    
				    serverFiltering:false,
				    pageSize: 0,			//paging in pager

			    }); //end of dataSource,
			    
				
			}]	//end of controller
	};
	return directive;
});	//end of designItem directive

orderApp.directive("imageItem",function(SO,$sce){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@imageItem',
				cItemId:'@',
				},
			templateUrl:'imageItem',
			
			link:function(scope){
				$scope=scope;

				//pass to imageView directive to create new imageitem		        
				$scope.newItemFunction=function(dataItem){
					var orderItem=$scope.$parent.getCurrentOrderItemDi();
					return {
						    	orderId:SO.dataSet.info.id,
						    	orderItemId:orderItem.id, 
						    	imageId:dataItem.id,
						    	isDirty:true,
						    }
					}
				$scope.registerDeletedItemFunction=function(dataItem){
					SO.registerDeletedItem("orderImage",dataItem.id);
				}
								
				
			},
			controller: ["$scope",function($scope) {
				$scope.SO=SO;
				if($scope.cName)
					$scope.$parent[$scope.cName]=$scope;
				
				$scope.orderItem=$scope.$parent.getOrderItemDi(parseInt($scope.cItemId));
				
				var getImages=function(dataItems){
					var imageString="";
					for(var i=0,imageId;i<dataItems.length;i++){
						imageId=dataItems[i].imageId;
						if( imageId && !SO.dds.image.getLocalItem("id",imageId)){
							imageString+=","+imageId;
						}
					}
					if(imageString!==""){
						imageString=imageString.substring(1);
						SO.dds.image.getItems("id",imageString)
							.then(function(){
								
							},function(){
								
							});
						
					}
				}
				
			    $scope.imageGridDataSource=new kendo.data.DataSource({
	    	    	data:SO.dataSet.imageItems,
				    schema: {
				        model: {
				            id: "id",
			                fields: {
			                    imageId:{type: "number"}
			                }
				        }
				    },
				    
				    filter: {
				        field: "orderItemId",
				        operator: "eq",
				        value: $scope.orderItem.id
				    },    
				    
				    serverFiltering:false,
				    pageSize: 0,

				    change: function(e) {
				    	var i=0;
				        //check the "response" argument to skip the local operations
			           getImages(e.items);
				    }
		        });
	    
				
			}]	//end of controller
	};
	return directive;
});	//end of imageItem directive


orderApp.directive("contactItem",function(SO,$sce){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@contactItem',
				cItemId:'@',
				},
			templateUrl:'contactItem',
			
			link:function(scope){
				$scope=scope;

				//pass to contactView directive to create new contactitem		        
				$scope.newItemFunction=function(){
					var orderItem=$scope.$parent.getCurrentOrderItemDi();
				    return {
						    	orderId:SO.dataSet.info.id,
						    	orderItemId:orderItem.id, 
						    	isBuyer:true,
						    	isActive:true,
						    }
					}


				
				$scope.registerDeletedItemFunction=function(dataItem){
					SO.registerDeletedItem("orderContact",dataItem.id);
				}
								
				
			},
			controller: ["$scope",function($scope) {
				$scope.SO=SO;
				if($scope.cName)
					$scope.$parent[$scope.cName]=$scope;
				
				$scope.orderItem=$scope.$parent.getOrderItemDi(parseInt($scope.cItemId));
				
			    $scope.contactGridDataSource=new kendo.data.DataSource({
	    	    	data:SO.dataSet.contactItems,
				    schema: {
				        model: {
				            id: "id"
				        }
				    },
				    
				    filter: {
				        field: "orderItemId",
				        operator: "eq",
				        value: $scope.orderItem.id
				    },    
				    
				    serverFiltering:false,
				    pageSize: 0,

		        });
		
				
			}]	//end of controller
	};
	return directive;
});	//end of contactItem directive

orderApp.directive("addressItem",function(SO,$sce){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@addressItem',
				cItemId:'@',
				},
			templateUrl:'addressItem',
			
			link:function(scope){
				$scope=scope;

				//pass to contactView directive to create new contactitem		        
				$scope.newItemFunction=function(){
					var orderItem=$scope.$parent.getCurrentOrderItemDi();
				    var newItem={
						    	orderId:SO.dataSet.info.id,
						    	orderItemId:orderItem.id, 
						    	billing:false,
						    	shipping:true
						    }
					if(SO.company && SO.company.info && SO.company.info.id===SO.dataSet.info.customerId){
						
						newItem.country=SO.company.info.country;
						newItem.province=SO.company.info.province;
						newItem.city=SO.company.info.city;
					}
					return newItem;
				}

				$scope.registerDeletedItemFunction=function(dataItem){
					SO.registerDeletedItem("orderAddress",dataItem.id);
				}
								
				
			},
			controller: ["$scope",function($scope) {
				$scope.SO=SO;
				if($scope.cName)
					$scope.$parent[$scope.cName]=$scope;
				
				$scope.orderItem=$scope.$parent.getOrderItemDi(parseInt($scope.cItemId));
				
			    $scope.addressGridDataSource=new kendo.data.DataSource({
	    	    	data:SO.dataSet.addressItems,
				    schema: {
				        model: {
				            id: "id"
				        }
				    },
				    
				    filter: {
				        field: "orderItemId",
				        operator: "eq",
				        value: $scope.orderItem.id
				    },    
				    
				    serverFiltering:false,
				    pageSize: 0,

		        });
		
				
			}]	//end of controller
	};
	return directive;
});	//end of addressItem directive




</script>