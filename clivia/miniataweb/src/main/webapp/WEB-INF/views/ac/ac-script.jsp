<script>
'user strict';
var accountingApp = angular.module("accountingApp",
		["kendo.directives","clivia","crmApp"]);


accountingApp.directive("invoice",["$http","cliviaDDS","util",function($http,cliviaDDS,util){
	
	var imgUrl="../resources/images/";
	var baseUrl="../ac/";
	
	var searchTemplate='<kendo-combobox name="searchInvoiceNumber" k-placeholder="\'Search Invoice#\'" ng-model="searchInvoiceNumber"  k-options="searchInvoiceNumberOptions" style="width: 140px;" />';

	var addOrderTemplate='<input type="text"  name="addOrderNumber" class="k-textbox" placeholder="Add Order#" ng-model="addOrderNumber" on-enter-key-pressed="addOrder()" style="width: 140px;" />';
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@invoice',
				},
			templateUrl:baseUrl+'invoice',
			
			link:function(scope){

				scope.clearDataSet=function(){
 					scope.dataSet.info={
 						};
 					
 					scope.dataSet.items.splice(0,scope.dataSet.items.length);
 					scope.dataSet.deleteds=[];
				}			    
				
			    scope.clear=function(){
			    	scope.searchInvoiceNumber="";
			    	scope.clearDataSet();
			    }
			    
			    scope.addOrder=function(){
			    	var orderNumber=(scope.addOrderNumber||"").trim();
			    	scope.addOrderNumber="";
			    	
			    	if(orderNumber){
				    	var url="../om/get-order?number="+orderNumber+"&list=billItems,addressItems";
			    		$http.get(url).
							success(function(data, status, headers, config) {
						    	if(data){
									populateOrder(data);	    		
						    	}
							}).
							error(function(data, status, headers, config) {
							});
			    	}
			    	
			    }
			    	
			   var populateOrder=function(data){
				   var order=data;
				   if(!scope.dataSet.info.customerId){
					   scope.dataSet.info.customerId=order.info.customerId;
					   scope.dataSet.info.repId=order.info.repId;
					   scope.dataSet.info.term=order.info.term;
					   
						var url="../crm/get-company?id="+order.info.customerId+"&list=addresses";
						$http.get(url).
							success(function(data, status, headers, config) {
								if(data){
									var company=data;
									scope.dataSet.info.billTo=util.createAddress(company.info,order.addressItems,company.addresses,true,true);
									scope.dataSet.info.shipTo=util.createAddress(company.info,order.addressItems,company.addresses,false,true);
								}
							}).
							error(function(data, status, headers, config) {
							});
					   
				   }else{
					   if(scope.dataSet.info.customerId!==data.info.customerId){
						   alert("Orders different cutomer can not be put into the same invoice.")
						   return;
					   }
				   }
				   
				   for(var i=0,desc,info=data.info,dis=data.billItems,di,itemDi;i<dis.length;i++){
					   di=dis[i];
					   
					   
					   
					   itemDi={
							  poNo:info.customerPO,
							  orderNo:info.orderNumber,
							  
							  orderId:info.orderId,
							  orderBillingItemId:di.id,
							  
							  snpId:di.snpId,
							  description:di.description,
							  quantity:di.finishQty?di.finishQty:di.orderQty,
							  unit:di.unit,
							  price:di.orderPrice,
							  amount:di.orderAmt,
							  isNewDi:true,
							  isDirty:true,
					   }
					   
					   scope.dataSet.items.push(itemDi);
				   }
				   
			   }

				//p={id:100001,number:'Inv10000001'} id and number can not both be null
			    scope.load=function(p){	

			    	var url=baseUrl+"get-invoice?"+(p.id?("id="+p.id):("number="+p.number));
					scope.clear();

					$http.get(url).
						success(function(data, status, headers, config) {
					    	populate(data);
						}).
						error(function(data, status, headers, config) {
						});
			    }

			    scope.save=function(){
			    	if(!validInvoice()) return;
					var url=baseUrl+"save-invoice";
					
					if(scope.invoiceForm.$dirty)
						scope.dataSet.info.isDirty=true;

					
					$http.post(url,scope.dataSet).
						  success(function(data, status, headers, config) {
							  populate(data)
						  }).
						  error(function(data, status, headers, config) {
							  alert( "failure message: " + JSON.stringify({data: data}));
						  });		
			    }
			    
			    scope.remove=function(){
			    	
			    }
			    
				var populate=function(data){
					scope.clearDataSet();
					scope.dataSet.info=data.info;
					var items=scope.dataSet.items;
					for(var i=0;i<data.items.length;i++){
						items.push(data.items[i]);
					}
					
					scope.invoiceForm.$setPristine();
				}
				
			 	var validInvoice=function(){
					var isValid=true;
					var errors="";
					
					return isValid;
				}
			 	
		    	scope.newItemFunction=function(){
	    		    return {
				    	isNewDi:true,
				    	amount:0,
				    }
		    	}
		    	
		    	scope.registerDeletedItemFunction=function(dataItem){
		    		
		    	}

			 	scope.clear();
			},
			
			controller:["$scope",
			            function($scope){
				
				$scope.dataSet={
						info:{},
						items:new kendo.data.ObservableArray([]), 
						deleteds:[]
					};
				
				
				$scope.invoiceToolbarOptions={items: [{
				        type: "button",
				        text: "New",
				        id:"btnNew",
		                imageUrl:imgUrl+"i-new.ico",
				        click: function(e) {
				        	$scope.clear();
					    	$scope.$apply();
			       		 }
		            }, {
		                type: "separator",
				    }, {
				        type: "button",
				        text: "Save",
				        id:"btnSave",
		                imageUrl:imgUrl+"i-save.ico",
				        click: function(e) {
				        	$scope.save();
					        }
	  	            }, {
		                type: "separator",
		            }, {	
		                template:addOrderTemplate,		                
	  	            }, {
		                type: "separator",
		            }, {	
		                template:searchTemplate,		                
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
				    }, {
				        type: "button",
				        text: "Print",
				        id: "btnPrint",
				        click: function(e){
				        	$scope.print();
				        	}  
	  	            }, {
		                type: "separator",
	 	            }, {
	 	            	template:'Choose Theme:<theme-chooser></theme-chooser>'
				}]};
				
			    $scope.searchInvoiceNumberOptions={
			        	dataSource:{data:[]},	//recent invoices
			        	
			        	//Fired when the value of the widget is changed by the user
			        	change:function(e){
					    	var invoiceNumber=$scope.searchInvoiceNumber;
					    	if(invoiceNumber){
					    		$scope.load({number:invoiceNumber});
					    	}else{
								alert("Please input a invoice number to search.");
					    	}
			        	}
			        }

				$scope.dateOptions={
						format: "yyyy-MM-dd",
					    parseFormats: ["yyyy-MM-dd"]
				}

				$scope.termOptions={
						dataSource:util.getTerms()
				}

		    	
		    	
		    	$scope.invoiceGridDataSource={
	 		        	data:$scope.dataSet.items, 
			    	    schema: {
			    	    	model: { id: "id" }
			    	    },	//end of schema
			    	    
			        };

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

				
				
			}]
	};
	
	return directive;
	
	
}]);

accountingApp.controller("acCtrl",
		["$scope","$http",function($scope,$http){

	        
			
}]);

</script>