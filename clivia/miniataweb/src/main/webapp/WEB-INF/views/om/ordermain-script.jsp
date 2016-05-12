<script>
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
	                	$scope.newOrder();
	                }
	            }, {
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
	
	$scope.generateBillableItems=function(){
		
		var currentOrderItem=SO.getCurrentOrderItem();
		SO.generateBillableItems(currentOrderItem);
		$scope.$apply();
	};	
	
	$scope.newOrder=function(){
		if(!$scope.orderIsDirty() || $scope.confirmDiscardChanges()){
			SO.clear();
			SO.setCurrentOrderItem(0);		//$state.go('main.blankitem');

		}
	};	
	
	
	$scope.printOrder=function(id){
		if(id==="garmentConfirmation"||id==="garmentConfirmationWithoutDsicount"){
			
			var orderItem=SO.getCurrentOrderItem();
			if(orderItem && orderItem.typeId===1){	//billItem
				var dataSource=new kendo.data.DataSource({
							     	data:SO.dataSet.billItems, 
							   	    filter: {field: "orderItemId", operator: "eq",value: orderItem.id },    
								    sort:{field:"lineNo"},
							    }); //end of dataSource,
							    
				dataSource.fetch(function() {
					  var billItems = dataSource.view();
					  SO.printBill(billItems,true,true,id==="garmentConfirmationWithoutDsicount");		//if true,print billItems that from lineitem(typeid===2) only
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

			SO.clear();
			SO.retrieve($scope.searchOrderNumber)
				.then(function(data){
				    if(data){
				    	var items=SO.dataSet.items;
			    		for(var i=0;i<items.length;i++)
			    			SO.addOrderItemButton(items[i]);

			    		//retrieve all items here
			    		//SO.dict.getRemoteImages();
			    		
			    		var orderItemId=items.length>0?items[0].id:0;
				    	SO.setCurrentOrderItem(orderItemId);
				    	
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
	
	$scope.newOrder();
	
}]);
</script>