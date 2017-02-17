<script>
var backHome='<a href="http://192.6.2.204:8080/admin/login.php"><button class="k-button">Home</button></a>' //../../admin/main.php
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
  	            }, {
	                type: "separator",
 	            }, {
 	            	template:'Choose Theme:<theme-chooser></theme-chooser>'
	      		}]};
    
		$scope.queryToolbarOptions={
			items: [{
				        type: "button",
				        text: "Export To Excel",
				        id: "btnExcel",
				        click: function(e){
				        	$scope.queryGrid.saveAsExcel();
				            }
					}, {
						type: "separator",
				    }, {
				        type: "button",
				        text: "Choose Columns",
				        id: "btnChooseColumns",
				        click: function(e){
				        	$scope.queryGrid.chooseColumn();
				            }
				    }, {
				        type: "button",
				        text: "Clear All Filters",
				        id: "btnClearFilters",
				        click: function(e){
				        	$scope.queryGrid.clearAllFilters();
				            }
				    }, {
		}]};
    
    
    $scope.saveResultOptions={
             position: {
                 pinned: true,
                 top: 50,
                 left: 200,
                 bottom: null,
                 right: null,
                 autoHideAfter: 1000,
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
					  SO.printBill(billItems,false,true,id);		//if true,print billItems that from lineitem(typeid===2) only
					});
			}
		}
		
		if(id==="decoConfirmation"){
			SO.printDecoOrder();
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
				    	var currentOrderItemId=0;
				    	for(var i=0,item,button,el,itemScope;i<items.length;i++){
				    		item=items[i];
				    		
				    		el=$scope.orderItems.instance.itemElements[item.lineNo-1];
				    		el.orderItemId=item.id;
				    		
				    		button=$scope.orderItems.instance.itemButtons[item.lineNo-1];
				    		button.orderItemId=item.id;
				    		
				    		itemScope=$scope.orderItems[$scope.orderItems.instance.itemScopeNames[item.lineNo-1]];
				    		itemScope.orderItem=item;
				    		
				    		if(button.selected)
				    			currentOrderItemId=button.orderItemId;
				    	}		
				    	
				    	$scope.orderItems.instance.currentOrderItemId=currentOrderItemId;
				    	$scope.orderItems.setCurrentOrderItem(currentOrderItemId);
			    		$scope.orderInfo.infoForm.$setPristine();
			    		$scope.saveResult.show('<p style="width: 16em; height:2em; padding:1em;white-space:nowrap">Order #'+SO.dataSet.info.orderNumber+ ': save succeed. </p>',"info");
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
					for(var i=items.length-1;i>=0;i--){
						scope.removeOrderItem(items[i]);
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
							SO.generateBillOfGarmentSupply(orderItem);
							SO.generateBillOfServiceEmb(orderItem);
							//var billItemScope=scope.getOrderItemScope(orderItem);
							//billItemScope.
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
			 				isNewDi:true,
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
			    	
                  	scope.addOrderItemButton(orderItem);

			    	var itemType=SO.getRegisteredItemType(typeId);
	                var itemName=itemType.name+orderItem.id;
                 	var itemElements=$compile("<div "+itemType.directive+"='"+itemName+"' c-item-id='"+orderItem.id+"'></div>")(scope);
                  	scope.addOrderItemElement(orderItem,itemElements);
			    	scope.instance.itemScopeNames.push(itemName);
                  	
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
			    	element.remove();
			    }
			    
			    scope.removeOrderItemDi=function(orderItem){
			    	var items=SO.dataSet.items;
			    	
			    	//remove the orderItem from  _order.dataSet.items
			    	var idx=util.findIndex(items,"id",orderItem.id);
			    	items.splice(idx,1);
			    	
			    	
			   		//register deleted items
				   	SO.registerDeletedItem("orderItem",orderItem);

			    	for(var i=0,itemName,modelName;i<SO.setting.registeredItemTypes.length;i++){
			    		itemName=SO.setting.registeredItemTypes[i].name;
			    		modelName=SO.setting.registeredItemTypes[i].model;	//server model name
			    		SO.deleteDependentItems(itemName,modelName,"orderItemId",orderItem.id);
			    	}
			    	
			    	for(var i=0,itemName,modelName;i<SO.setting.registeredServices.length;i++){
			    		itemName=SO.setting.registeredServices[i].name;
			    		modelName=SO.setting.registeredServices[i].model;
			    		SO.deleteDependentItems(itemName,modelName,"orderItemId",orderItem.id);
			    	}
			   		
			    	//set lineNo same as item index+1
			    	scope.setOrderItemLineNo();
			    	if (idx===items.length)
			    		idx--;
			    	var id=idx>=0?items[idx].id:0;
			    	return id;
			    }
			    
			    scope.removeOrderItem=function(orderItem){
			    	
			    	scope.removeOrderItemScope(orderItem);
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
			    	var itemScope;
			    	for(var i=0,isn;i<scope.instance.itemScopeNames.length;i++){
			    		isn=scope.instance.itemScopeNames[i];
			    		if(scope[isn]&&scope[isn].orderItem.id===orderItem.id){
			    			itemScope=scope[isn];
			    			break;
			    		}
			    	}
			    	return itemScope;
			    }
			    
			    scope.removeOrderItemScope=function(orderItem){
			    	for(var i=0,isn;i<scope.instance.itemScopeNames.length;i++){
			    		isn=scope.instance.itemScopeNames[i];
			    		if(scope[isn].orderItem.id===orderItem.id){
			    			scope.instance.itemScopeNames.splice(i,1);
					    	var itemScope=scope[isn];
					    	delete scope[isn];
					    	itemScope.$destroy();
			    			break;
			    		}
			    	}
			    	
			    	
			    }
				
			},

			controller: ["$scope","SO","cliviaDDS","$element",function($scope,SO,cliviaDDS,$element) {
				$scope.SO=SO;
				
				$scope.$parent["orderItems"]=$scope;

				$scope.instance={
					orderItemElement:$element,
					itemButtons:new kendo.data.ObservableArray([]),
					itemElements:[],
					itemScopeNames:[],
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
			            	 
			           		 var elements=$scope.instance.itemElements,
		            		 	 element=elements.splice(e.oldIndex,1)[0];
		           		 
		            	 	 elements.splice(e.newIndex,0,element);
		            	 	 
			           		 var scopeNames=$scope.instance.itemScopeNames,
		            		 	 scopeName=scopeNames.splice(e.oldIndex,1)[0];
		           		 
			            	 scopeNames.splice(e.newIndex,0,scopeName);
		            	 	 
			            	 
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

				//pass to garmentGird directive to create new lineitem		        
		    	scope.newItemFunction=function(){
					
	    			var t=scope.garmentGridDataSource.view();
						
	    		    return {
		    			    	orderId:SO.dataSet.info.orderId,
		    			    	orderItemId:scope.orderItem.id, 
		    			    	brandId:scope.brand.id,
		    			    	seasonId:scope.season.id,
		    			    	id:SO.getTmpId(),
		    			    	isNewDi:true,
		    			    }
				}
				        
		    	//pass to garmentGird directive to register removed lineitem		        
		    	scope.registerDeletedItemFunction=function(dataItem){
		    		SO.registerDeletedItem("orderLineItem",dataItem);
		    		
		    		for(var j=0,serviceName,serviceModel;j<SO.setting.registeredServices.length;j++){
		    			serviceName=SO.setting.registeredServices[j].name;
		    			serviceModel=SO.setting.registeredServices[j].model;
		    			SO.deleteDependentItems(serviceName,serviceModel,"lineItemId",dataItem.id);
		    		}
		    			
		    	}
		    	
		    	
		    	scope.getDetailFunction=function(diLineItem){
		    		
		    			//put initDetail in setTimeout to avoid error "$apply already in progress"
		    			//caused by "add with dialog"  
		    			setTimeout(function(){
		    					scope.decoServices.initDetail(diLineItem);
		    				},1);
		    			
		    	}
		    	
		    	scope.resize=function(){
	    			scope.lineItemSplitter.resize();
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
				        	}		
				        }

				    	
				    	$scope.$watch("seasonId",function(newValue,oldValue){
				    		if(newValue && newValue!=oldValue){
				    			$scope.season=SO.dds.season.getLocalItem("id",parseInt(newValue));
				    			$scope.orderItem.spec=$scope.brand.id+":"+$scope.season.id;
				    		}
				    	});
				    	
				    	$scope.$watch("orderItem.id",function(newValue,oldValue){
				    		if(!!newValue&& newValue!=oldValue)
				    			$scope.garmentGrid.grid.setDataSource($scope.getGridDataSource());

				    	});
				    	
				    	$scope.getGridDataSource=function(){
				    		return new kendo.data.DataSource({
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
		    		    	    
		    		    	    change:function(e){
		    		    	    	var data=this.data();
		    		    	    }

		    		        }); //end of dataSource,
				    	}

				     	$scope.garmentGridDataSource=$scope.getGridDataSource();				    	
					
					
			}]	//end of controller
	};
	return directive;
});	//end of lineItem directive
	
	
orderApp.directive("decoService",function(SO,util){
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@decoService',
				},
			templateUrl:'decoservice',
			
			link:function(scope){

		    	scope.initDetail=function(lineItemDi){
		    		
		    		scope.lineItemDi=lineItemDi;
   	 	    		scope.serviceEmbGrid.grid.setDataSource(scope.getServiceEmbGridDataSource());
   	 	    		scope.serviceSpGrid.grid.setDataSource(scope.getServiceSpGridDataSource());

		    	}
		    	
		    	scope.serviceEmbNewItemFunction=function(){
	    		    return {
    			    	orderId:SO.dataSet.info.orderId,
    			    	orderItemId:scope.lineItemDi.orderItemId, 
    			    	lineItemId:scope.lineItemDi.id,
    			    	isNewDi:true,
    			    }

		    	}
		    	scope.serviceSpNewItemFunction=function(){
	    		    return {
    			    	orderId:SO.dataSet.info.orderId,
    			    	orderItemId:scope.lineItemDi.orderItemId, 
    			    	lineItemId:scope.lineItemDi.id,
    			    	isNewDi:true,
    			    }

		    	}
		    	
		    	scope.registerDeletedServiceEmbFunction=function(dataItem){
		    		SO.registerDeletedItem("orderServiceEmb",dataItem);
		    	}
		    	
		    	scope.registerDeletedServiceSpFunction=function(dataItem){
		    		SO.registerDeletedItem("orderServiceSp",dataItem);
		    	}
		    	
				scope.getServiceEmbGridDataSource=function(){
					return new kendo.data.DataSource({
	     		        	data:SO.dataSet.serviceEmbs, 
	    		    	    schema: {model: {id: "id" }},	
	    		    	    filter: {
	    		    	        field: "lineItemId",
	    		    	        operator: "eq",
	    		    	        value: scope.lineItemDi.id,
	    		    	    },    
	    		    	    
	    		    	    serverFiltering:false,
	    		    	    pageSize: 0,			//paging in pager
	
	    		        }); //end of dataSource,
				}

				scope.getServiceSpGridDataSource=function(){
					return new kendo.data.DataSource({
	     		        	data:SO.dataSet.serviceSps, 
	    		    	    schema: {model: {id: "id" }},	
	    		    	    filter: {
	    		    	        field: "lineItemId",
	    		    	        operator: "eq",
	    		    	        value: scope.lineItemDi.id,
	    		    	    },    
	    		    	    
	    		    	    serverFiltering:false,
	    		    	    pageSize: 0,			//paging in pager
	
	    		        }); //end of dataSource,
				}
				
				
				scope.duplicateDeco=function(overwrite){
	
					
					var fromDis=[];
 					var dis=scope["serviceEmbGrid"].grid.dataSource.view();
 					
 					for(var i=0,di;i<dis.length;i++){
 						di=dis[i];
 						fromDis.push({
 							id:di.id,
 							serviceType:"Emb",
 							location:di.location,
 							designNo:di.designNo,
 							designName:di.designName,
 							detail:di.threadCode+"    "+di.runningStep,
 							serviceDi:di
 						});
 					}
 					
 					scope.duplicateDecoGrid.setDataSource(new kendo.data.DataSource({data:fromDis}));
 					
 					
 					var toDis=[];
 					var dis=scope.$parent.garmentGridDataSource.view();
 					for(var i=0,di;i<dis.length;i++){
 						di=dis[i];
 						if(di.id!=scope.lineItemDi.id){
 							toDis.push({
 								id:di.id,
 								lineItemLineNo:di.lineNo,
 								style:(di.styleNo?di.styleNo:"")+" "+(di.description?di.description:""),
 								colour:di.colour,
 								sizes:SO.getLineItemSizes(di),
 								qty:di.quantity,
 								remark:di.remark,
 								lineItemDi:di,
 							});
 						}
 					}
 					
 					scope.duplicateLineItemGrid.setDataSource(new kendo.data.DataSource({data:toDis}));
 					
					scope.decoDuplicateWindow.open();
				} 
				
		        scope.getClick = function(item,grid){
		        	  //var grid=scope.duplicateLineItemGrid;
		              var selectedRows=grid.select();
		              for(var i = 0,di; i<selectedRows.length; i++){
		            	 var di=grid.dataItem(selectedRows[i]);
		            	 if(di!=item){
		            		 di.checkedItem=item.checkedItem;
		            	 }
		              }
  		        	  calculateSelectedLineItemQuantity(grid);
		          }
		        
		        scope.checkAll=function(checked,grid){
		        	var dataItems=grid.dataSource.data();
		        	for(var i=0;i<dataItems.length;i++){
		        		dataItems[i].checkedItem=checked;
		        	}
		        	calculateSelectedLineItemQuantity(grid);
		        }
		        
		        var calculateSelectedLineItemQuantity=function(grid){
		        	var dataItems=grid.dataSource.data();
		        	var sum=0;
		        	for(var i=0,di;i<dataItems.length;i++){
		        		di=dataItems[i];
		        		if(di.checkedItem && di.qty)
		        			sum+=di.qty;
		        	}
		        	
		        	scope.selectedLineItemQuantity=sum;
		        }
		        
 				scope.duplicateSelectedDecoToLineItem=function(){
 					var serviceSet={};
 					serviceSet["Emb"]=scope["serviceEmbGrid"].grid.dataSource.data();
 					
 					var duplicateDecoGridDis=scope.duplicateDecoGrid.dataSource.data();
 					var duplicateLineItemDis=scope.duplicateLineItemGrid.dataSource.data();
 					var selectedLineItemId={};
					var serviceEmbDis=serviceSet["Emb"];

					//remove services of selectedLineItems
 					for(var i=0,liDi;i<duplicateLineItemDis.length;i++){
 						liDi=duplicateLineItemDis[i];
 						if(liDi.checkedItem){
 	 						for(var j=0;j<serviceEmbDis.length;j++){
 	 							if(serviceEmbDis[j].lineItemId===liDi.id){
 	 								scope.registerDeletedServiceEmbFunction(serviceEmbDis[j]);
 	 								serviceEmbDis.splice(j,1);
 	 							}
 	 						}
 						}
 					}
 					
 					var selectedServiceDi,selectedLineItemDi;
		        	for(var i=0,di;i<duplicateDecoGridDis.length;i++){
		        		di=duplicateDecoGridDis[i];
		        		if(di.checkedItem){
		        			selectedServiceDi=di.serviceDi;
		        			serviceDis=serviceSet[di.serviceType];
		        			
		        			for(var j=0,newDi;j<duplicateLineItemDis.length;j++){
		        				selectedLinteItemDi=duplicateLineItemDis[j];
		        				if(selectedLinteItemDi.checkedItem){
		        					
		        					var newDi=util.duplicateObject(selectedServiceDi);
	        					
		        					newDi.lineItemId=selectedLinteItemDi.id;
		        					newDi.isNewDi=true;
		        					newDi.isDirty=true;
		        					serviceDis.push(newDi);
		        				}
		        			}
		        		}
		        	}
 				}
			},
			controller: ["$scope","cliviaGridWrapperFactory",function($scope,cliviaGridWrapperFactory) {
				
					$scope.SO=SO;
					if($scope.cName)
						$scope.$parent[$scope.cName]=$scope;
					
					$scope.lineItemDi={};
					$scope.lineItemDi.id=null;
					
					$scope.duplicateDecoGridOptions={
						dataSource:[],
						columns:[{
							headerTemplate: '<input ng-model = "duplicateDecoGridCheckAll" type="checkbox" ng-change="checkAll(duplicateDecoGridCheckAll,duplicateDecoGrid)"></input>',
							template: '<input ng-model = "dataItem.checkedItem" type="checkbox" ng-change="getClick(dataItem,duplicateDecoGrid)"></input>',
							width:40,
					    },{ 							
							field:"serviceType",
							title:"Service",
							width:"80px",
						},{
							field:"location",
							title:"Location",
							width:"100px",
						},{
							field:"designNo",
							title:"Design#",
							width:"100px",
							attributes:{style:"text-align:center;"},
						},{
							field:"quantity",
							title:"Quantity",
							width:"70px",
							attributes:{style:"text-align:right;"},
						},{
							field:"designName",
							title:"Design Name",
							width:"150px",
						},{
							field:"detail",
							title:"Detail",
						}],
						selectable: "multiple, row",
						resizable:true,
					}
					
					$scope.duplicateLineItemGridOptions={
							dataSource:[],
							columns:[{
								headerTemplate: '<input ng-model = "duplicateLineItemGridCheckAll" type="checkbox" ng-change="checkAll(duplicateLineItemGridCheckAll,duplicateLineItemGrid)"></input>',
								template: '<input ng-model = "dataItem.checkedItem" type="checkbox" ng-change="getClick(dataItem,duplicateLineItemGrid)"></input>',
								width:40,
							},{
								field:"lineItemLineNo",
								title:"#",
								width:30,
						    },{ 							
								field:"style",
								title:"Copy To Line Item",
								width:"300px",
							},{
								field:"colour",
								title:"Colour",
								width:"150px",
							},{
								field:"qty",
								title:"Line Qty",
								width:"70px",
								attributes:{style:"text-align:right;"},
							},{
								field:"sizes",
								title:"Sizes",
								width:"200px",
							},{
								field:"remark",
								title:"Remark",
							}],
							selectable: "multiple, row",
							resizable:true,
						}

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

				//pass to billGird directive to create new lineitem		        
				scope.newItemFunction=function(){
					    return {
						    	orderId:SO.dataSet.info.orderId,
						    	orderItemId:scope.orderItem.id, 
						    	snpId:0,
						    	orderAmt:0,
						    	isNewDi:true,
						    };
					}
					        
				//pass to billGrid directive to register removed billitem		        
				scope.registerDeletedItemFunction=function(dataItem){
					SO.registerDeletedItem("orderBillItem",dataItem);
				}
				
				scope.getDetailFunction=function(billItemDi){
					var html;
					
					if(billItemDi && billItemDi.billingKey){
						switch(billItemDi.snpId){
						case 14: //Garment Supply	
							 //if itemTypeId===2, the item is from lineItem and its billingKey is a string of garmentId
								html=SO.getBillingHtmlOfGarmentSupply(parseInt(billItemDi.billingKey));
							break;
						case 1:	//Embroidery Service
							html=SO.getBillingHtmlOfEmbService(billItemDi.billingKey);
							break;
							
						}
					}
					
					if(!html)
						html="<div></div>";
					scope.htmlBillItemDetail=$sce.trustAsHtml(html); 
				}
				

				scope.getTotalAmount=function(){
					if(!scope.billGrid) return "";
					var totalAmt=scope.billGrid.getTotal(),
						c=SO.company.info.country==="Canada"?"CA":"US",
						result=c+(totalAmt?kendo.toString(totalAmt,"c"):"");
					return result;
				}
				
				scope.setDiscount=function(oldValue,newValue){
					oldValue=parseFloat(oldValue);
					newValue=parseFloat(newValue);
					if(oldValue===newValue) 
						return;
					
					scope.orderItem.isDirty=true;
					scope.billGrid.gridWrapper.setDiscount(newValue,14);
					scope.billGrid.grid.refresh();
				}
				
		    	scope.resize=function(){
		    		scope.billItemSplitter.resize();
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
				//SO.generateBillableItems($scope.orderItem);

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
		    	$scope.$watch("orderItem.id",function(newValue,oldValue){
		    		if(!!newValue&& newValue!=oldValue)
		    			$scope.billGrid.grid.setDataSource($scope.getGridDataSource());

		    	});

			    $scope.getGridDataSource=function(){
			    	return new kendo.data.DataSource({
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

			    }
			    
			 	$scope.billGridDataSource=$scope.getGridDataSource();		    
			    
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
				scope=scope;
				
				scope.newItemFunction=function(){
					    return {
						    	orderId:SO.dataSet.info.orderId,
						    	orderItemId:scope.orderItem.id, 
						    	snpId:0,
						    	orderAmt:0,
						    	isNewDi:true,
						    };
					}
					        
				//pass to designGrid directive to register removed billitem		        
				scope.registerDeletedItemFunction=function(dataItem){
					SO.registerDeletedItem("orderDesignItem",dataItem);
				}

 				scope.resize=function(){
					//scope.designItemSplitter.resize();
		    	}				
 			},

			controller: ["$scope",function($scope) {
				$scope.SO=SO;
				if($scope.cName)
					$scope.$parent[$scope.cName]=$scope;
				
				$scope.orderItem=$scope.$parent.getOrderItemDi(parseInt($scope.cItemId));
				
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

				//pass to imageView directive to create new imageitem		        
				scope.newItemFunction=function(dataItem){
					return {
						    	orderId:SO.dataSet.info.id,
						    	orderItemId:scope.orderItem.id, 
						    	imageId:dataItem.id,
						    	isDirty:true,
						    	isNewDi:true,
						    }
					}
				scope.registerDeletedItemFunction=function(dataItem){
					SO.registerDeletedItem("orderImage",dataItem);
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

				//pass to contactView directive to create new contactitem		        
				scope.newItemFunction=function(){
				    return {
						    	orderId:SO.dataSet.info.id,
						    	orderItemId:scope.orderItem.id, 
						    	isBuyer:true,
						    	isActive:true,
						    	isNewDi:true,
						    }
					}


				
				scope.registerDeletedItemFunction=function(dataItem){
					SO.registerDeletedItem("orderContact",dataItem);
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

				//pass to contactView directive to create new contactitem		        
				scope.newItemFunction=function(){
				    var newItem={
						    	orderId:SO.dataSet.info.id,
						    	orderItemId:scope.orderItem.id, 
						    	billing:false,
						    	shipping:true,
						    	isNewDi:true,
						    }
					if(SO.company && SO.company.info && SO.company.info.id===SO.dataSet.info.customerId){
						
						newItem.country=SO.company.info.country;
						newItem.province=SO.company.info.province;
						newItem.city=SO.company.info.city;
					}
					return newItem;
				}

				scope.registerDeletedItemFunction=function(dataItem){
					SO.registerDeletedItem("orderAddress",dataItem);
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