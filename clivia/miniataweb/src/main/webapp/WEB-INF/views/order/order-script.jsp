<script>
// 	orderApp.config
	'user strict';

	var orderApp = angular.module("orderApp",
			[ "ui.router", "kendo.directives","cliviagrid" ]);



 //GarmentGridWrapper inherited from GridWrapper
 orderApp.factory("GarmentGridWrapper",function(GridWrapper,SO){

	 var GarmentGridWrapper=function(gridName){
		GridWrapper.call(this,gridName);
		
		this.currentGarment=null;
		this.dict={colourway:[],sizeRange:[]};
	}
	 
	GarmentGridWrapper.prototype=new GridWrapper(); 
	
	GarmentGridWrapper.prototype.setRowDict=function(){
		
   		this.dict.colourway.splice(0,this.dict.colourway.length);
   		this.dict.sizeRange.splice(0,this.dict.sizeRange.length);
   		if(this.currentGarment){
			this.dict.colourway=String(this.currentGarment.colourway).split(',');
			this.dict.sizeRange=String(this.currentGarment.sizeRange).split(',');
			console.log("set row dict:"+String(this.currentGarment.colourway));
   		}
	}
	
	GarmentGridWrapper.prototype.setCurrentGarment=function(model){
    	if (!model) return;
    	if(!model.styleNumber) return;
    	
		var styleNumber=model.styleNumber;
		if(!styleNumber){
			this.currentGarment=null;
			this.setRowDict();
		}else{
			if(this.currentGarment && this.currentGarment.styleNumber===styleNumber){
		    	model.set("description",this.currentGarment.styleName);
			}else{
				var garment=SO.dict.getGarment(styleNumber);
				if(garment){
					this.currentGarment=garment;
					this.setRowDict();
				}else{
					var self=this;
					SO.dict.getRemoteGarment(styleNumber).
						then(function(data){		//sucess
    				    	self.currentGarment=data;
					    	model.set("description",self.currentGarment.styleName);
		    				self.setRowDict();
						},						
						function(error){		//error
							self.currentGarment=null;
					    	model.set("description","");
		    				self.setRowDict();
						});
				}
			}
		}
	}
	
	GarmentGridWrapper.prototype.colourColumnEditor=function(container, options) {
		var self=this;		
		$('<input class="grid-editor"  data-bind="value:' + options.field + '"/>')
	    	.appendTo(container)
	    	.kendoComboBox({
		        autoBind: true,
		        dataSource: {
		            data: self.dict.colourway
		        }
	    })
	};	

	GarmentGridWrapper.prototype.sizeColumnEditor=function(container, options) {
		if(this.reorderRowEnabled) return;
		var self=this;		
	    $('<input class="grid-editor"  data-bind="value:' + options.field + '"/>')
	    	.appendTo(container)
	    	.kendoComboBox({
		        autoBind: true,
		        dataSource: {
		            data: self.dict.sizeRange
	        }
	    })
	};				    
    
	
	return GarmentGridWrapper;
 }); /* end of GarmentGridWrapper */

 //SO
orderApp.factory("SO",["$http","$q","$state","consts",function($http, $q, $state,consts){
	var _order={
			dataSet:{info:{},items:[],deleteds:[]},
			
			setting:{
				user:{
					userName: "Jacob",
					role:"Admin",
					firstName: "Jacob",
					lastName:"Zhang",
					fullName: function(){this.firstName+" "+this.lastName}
					},
				
				url:{
					base:consts.baseUrl,
					order:consts.baseUrl+"order/",
					library:consts.baseUrl+"library/",
					garment:consts.baseUrl+"garment/"
					},
				layout:{
					lineItemGrid:{},
					mainSplitterOrientation:"horizontal"
					},
					
				//correspongding to a dataTable in dataSet 
				registeredItemTypes:consts.registeredItemTypes,
				//corresponding to a menu item of insertable items
				registeredOrderItems:consts.registeredOrderItems,
				
				
				},
				
			dict:{garments:[],images:[],customers:[], garmentBrands:[]},
			
			instance:{
				itemButtons:new kendo.data.ObservableArray([]),
				currentItemId:0
				
				}};

	var dataSet=_order.dataSet, dict=_order.dict, setting=_order.setting, instance=_order.instance;
	
	
	for(var i=0;i<setting.registeredItemTypes.length;i++){
		dataSet[setting.registeredItemTypes[i]+"s"]=new kendo.data.ObservableArray([]);	
	}
	
	
	_order.getRegisteredOrderItem=function(id){
		 var item=null;
		 for(var i=0;i<setting.registeredOrderItems.length;i++)
			 if(setting.registeredOrderItems[i].id===id){
				 item=setting.registeredOrderItems[i];
				 break;
			 }
		return item;
	}

	//setting
	
    _order.clearDicts=function(){
		dict.garments.splice(0,dict.garments.length);
		dict.images.splice(0,dict.images.length);
    }
    
    _order.clearInstance=function(){
    	instance.currentItemId=0;
    	instance.itemButtons.splice(0,instance.itemButtons.length);
    }
    
	_order.clearDataSet=function(){

		dataSet.info={orderId:0,orderNumber:'',customerId:''};
		dataSet.items.splice(0,dataSet.items.length);
		for(var i=0;i<_order.setting.registeredItemTypes.length;i++){
			var dt=dataSet[_order.setting.registeredItemTypes[i]+"s"];
			dt.splice(0,dt.length);
		}
		dataSet.deleteds.splice(0,dataSet.deleteds.length);		
	}

    _order.clear=function(){
    	_order.clearDataSet();
    	_order.clearDicts();
    	_order.clearInstance();
    }
    
    dict.getGarment=function(styleNumber){
		var garment=null;
		if(styleNumber){
			for (i = 0; i <dict.garments.length; i++) {
			    if (dict.garments[i].styleNumber === styleNumber) {
			    	garment=dict.garments[i];
			    	break; 
			    }
			}
		}
		return garment;
    }

    dict.getRemoteGarment=function(styleNumber){	
    	var url=setting.url.garment+"get-product?style="+styleNumber;
    	var deferred = $q.defer();
		$http.get(url).
			success(function(data, status, headers, config) {
				if(data){
					dict.insertGarment(data);
					deferred.resolve(data)
				}else{
					deferred.reject("1");
				}
			}).
			error(function(data, status, headers, config) {
				deferred.reject("2");
			});
		return deferred.promise;
	};
	
	
    dict.getRemoteDicts=function(dicts){
    	var url=setting.url.garment+"get-product?style="+styleNumber;
    	var deferred = $q.defer();
		$http.get(url).
			success(function(data, status, headers, config) {
				if(data){
					dict.insertGarment(data);
					deferred.resolve(data)
				}else{
					deferred.reject("1");
				}
			}).
			error(function(data, status, headers, config) {
				deferred.reject("2");
			});
		return deferred.promise;
    	
    }
	
	
	dict.insertGarment=function(garment){
		dict.garments.push(garment);
	};
	
	dict.getImage=function(imageId){
		var image=null;
		if(imageId){
			for (i = 0; i < dict.images.length; i++) {
			    if (dict.images[i].id ===imageId) {
			    	image=dict.images[i];
			    	break; 
			    }
			}		
		}
		return image;
	}
	
	dict.insertImage=function(image){
		dict.images.push(image);
	};
	
	dict.getRemoteImages=function(){
    	var deferred = $q.defer();
		if(!_order.isNew() && angular.isDefined(dataSet.imageItems)){
			var imageString="";
			if(dataSet.imageItems)
			for(var i=0;i<dataSet.imageItems.length;i++){
				if(dataSet.imageItems[i].imageId){
					imageString+=","+dataSet.imageItems[i].imageId;
				}
			}
			if(imageString!==""){

				var url=setting.url.library+"get-images?ids="+imageString.substr(1);
				
				$http.get(url).
					success(function(data, status, headers, config) {
					    if(data){
					    	dict.images=data;
					    	deferred.resolve(data);
					    }else{
							deferred.reject("1");
					    }
					}).
					error(function(data, status, headers, config) {
						deferred.reject("2");
					});
			}else{
				deferred.reject("3");
			}
		}else{
			deferred.reject("4");
		}
		return deferred.promise;
	}
	
	
	//dataSet
	var populate=function(data){
		
		_order.clearDataSet();
		dataSet.info=data.info;
		dataSet.items=data.items;
		
		for(var i=0;i<setting.registeredItemTypes.length;i++){
			
			var itemType=setting.registeredItemTypes[i]+"s",
				dataTable=dataSet[itemType],
				dataItems=data[itemType];
			if(angular.isDefined(dataItems))
		    	for(var j=0;j<dataItems.length;j++)
		    		dataTable.push(dataItems[j]);
		}
	}
	
	var clearRowIdAndOrderId=function (dataTableName){
		
		var dataTable=dataSet[dataTableName];
		if(dataTable){
	    	for(var i=0;i<dataTable.length;i++){
	    		dataTable[i].id="";
	    		dataTable[i].orderId=0;
	    	}
		}
	}
	
	_order.isNew=function(){
		return !dataSet.info.id;
	}

	
	_order.repeat=function(){
		var customerId=dataSet.info.customerId,buyer=dataSet.info.buyer,orderName=dataSet.info.OrderName;
		
		dataSet.info={
				orderId:0,
				orderNumber:'',
				customerId:customerId,
				buyer:buyer,
				orderName:orderName
		}
		
		clearRowIdAndOrderId("items");

		_order.deleteds=[];		

		for(var i=0;i<_order.registeredItemTypes.length;i++){
			var itemType=_order.registeredItemTypes[i]+"s";
			clearRowIdAndOrderId(itemType);
		}
	}
		
	_order.retrieve=function(orderNumber){

		var url=setting.url.order+"get-order?number="+orderNumber;
		var deferred = $q.defer();
		
		$http.get(url).
			success(function(data, status, headers, config) {
		    	populate(data);
		    	
			    deferred.resolve(data);
			}).
			error(function(data, status, headers, config) {
				_order.clear();
				deferred.reject(data);
			});
				
		return deferred.promise;
	};
	
	_order.save=function() {

		var url=setting.url.order+"save-order";
		
		/*implement on server isde
			if(!$scope.order.orderInfo.orderDate)
				$scope.order.orderInfo.orderDate = $filter('date')(new Date(),'yyyy-MM-dd');	
	    */

		var deferred = $q.defer();
		
		$http.post(url, dataSet).
			success(function(data, status, headers, config) {
		    	populate(data);
			    deferred.resolve(data);
			}).
			error(function(data, status, headers, config) {
				deferred.reject(data);
			});
				
		return deferred.promise;
	}
	
	
	_order.remove=function(){

		var url=setting.url.order+"delete-order";
		var deferred = $q.defer();
		
		$http.post(url, dataSet.info.orderNumber).
			success(function(data, status, headers, config) {
			    _order.clear();
				deferred.resolve(data);
			}).
			error(function(data, status, headers, config) {
				deferred.reject(data);
			});
				
		return deferred.promise;
	}
	
	
	_order.setCurrentOrderItem=function(orderItemId){
        var dataItem=null;
		
		if(orderItemId===0 && instance.itemButtons.length>0) 
			orderItemId=parseInt(instance.itemButtons[0].id.substr(3))
		
		instance.currentItemId=orderItemId;	
			
		if(orderItemId>0) {
	        for(var i=0;i<instance.itemButtons.length;i++)
		       	 instance.itemButtons[i].selected= instance.itemButtons[i].id===("btn"+orderItemId);
	        dataItem=_order.getOrderItem(orderItemId);
		}
		
		if(dataItem)
 		  	 $state.go('main.'+dataItem.type,{orderItemId:orderItemId});
		else
			$state.go('main.blankitem');
 	};
 	
 	
 	_order.getCurrentOrderItem=function(){
 		return _order.getOrderItem(instance.currentItemId)
 	}
 	
 	_order.getOrderItem=function(itemId){
 		var dataItem=null;
 		for(var i=0;i<dataSet.items.length;i++)
 			if(itemId===dataSet.items[i].orderItemId){
 				dataItem=dataSet.items[i];
 				break;
 			}
 		return dataItem;		
 	}
	
 	_order.getCurrentOrderItemButton=function(){
 		var item=_order.getCurrentOrderItem();
 		var buttons=instance.itemButtons;
 		var button=null;
 		for(var i=0;i<buttons.length;i++){
 			if(buttons[i].id==="btn"+item.orderItemId){
 				button=buttons[i];
 				break;
 			}
 		}
 		return button;
 	}

 	_order.addOrderItemButton=function(orderItem){
        button={text:orderItem.title, id: "btn"+orderItem.orderItemId, icon: "insert-n",togglable: true, group: "OrderItem"};
        instance.itemButtons.push(button);
        return button;
 	}
 	
    _order.addOrderItem = function(type,title,spec) {
     	var orderItemId= dataSet.items.length+1;
     	var orderItem={
    			orderId:dataSet.info.orderId ,
    			orderItemId:orderItemId,
    			lineNumber: orderItemId,
	     		title:title,
 				type:type,
 				spec:spec
     		};
     	dataSet.items.push(orderItem);
     	_order.addOrderItemButton(orderItem)
     	return orderItem;
       };	
       
    _order.removeOrderItem=function(){
       	 //$scope.order.orderItems.pop();
        };
       
	
   	return _order;
	
}]); /* end of CliviaOrder */
 

orderApp.controller("orderCtrl",["$scope","$http",function($scope, $http) {
	
}]);

	


</script>