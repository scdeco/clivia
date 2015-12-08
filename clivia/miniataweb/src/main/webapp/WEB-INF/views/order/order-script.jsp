<script>
	'user strict';
	var orderApp = angular.module("orderApp",
			[ "ui.router", "kendo.directives","clivia" ]);



 //GarmentGridWrapper inherited from GridWrapper
 orderApp.factory("GarmentGridWrapper",["GridWrapper","SO",function(GridWrapper,SO){

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
				var self=this;
				SO.dds.garment.getItem("styleNumber",styleNumber)
					.then(function(garment){
						self.currentGarment=garment;
				    	model.set("description",self.currentGarment.styleName);
						self.setRowDict();
					},function(error){
						self.currentGarment=null;
				    	model.set("description","");
	    				self.setRowDict();
					});
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
 }]); /* end of GarmentGridWrapper */

 //SO
orderApp.factory("SO",["$http","$q","$state","consts","cliviaDDS",function($http, $q, $state,consts,cliviaDDS){
	var _order={
			dataSet:{info:{},items:[],deleteds:[]},
			
			setting:{
				user:{
					id:1000,
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
				
			dds:{
				garment:cliviaDDS.getDict("garment"),
				image:cliviaDDS.createDict("image",consts.baseUrl+"data/libImage/","onDemand")
				},
				
			instance:{
				itemButtons:new kendo.data.ObservableArray([]),
				currentItemId:0
				
				}};

	var dataSet=_order.dataSet, dict=_order.dict, setting=_order.setting, instance=_order.instance;
	
	
	for(var i=0;i<setting.registeredItemTypes.length;i++){
		dataSet[setting.registeredItemTypes[i].name+"s"]=new kendo.data.ObservableArray([]);	
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
		_order.dds.image.clear();
    }
    
    _order.clearInstance=function(){
    	instance.currentItemId=0;
    	instance.itemButtons.splice(0,instance.itemButtons.length);
    }
    
	_order.clearDataSet=function(){

		dataSet.info={orderId:0,orderNumber:'',customerId:''};
		dataSet.items.splice(0,dataSet.items.length);
		for(var i=0;i<_order.setting.registeredItemTypes.length;i++){
			var dt=dataSet[_order.setting.registeredItemTypes[i].name+"s"];
			dt.splice(0,dt.length);
		}
		dataSet.deleteds.splice(0,dataSet.deleteds.length);		
	}

    _order.clear=function(){
    	_order.clearDataSet();
    	_order.clearDicts();
    	_order.clearInstance();
    }
    
	
	
	//populate data get from server into this model(_order.dataSet)
	var populate=function(data){
		_order.clearDataSet();
		if(!!data) {		//data is not empty
			if(angular.isDefined(data.info))
				dataSet.info=data.info;
			if(data.items)
				dataSet.items=data.items;
			
			for(var i=0;i<setting.registeredItemTypes.length;i++){
				var itemType=setting.registeredItemTypes[i].name+"s",
					dataTable=dataSet[itemType],
					dataItems=data[itemType];
				if(angular.isDefined(dataItems))
			    	for(var j=0;j<dataItems.length;j++)
			    		dataTable.push(dataItems[j]);
			}
		}
	}
	
	
	//set rowId and orderId of tables in dataSet to empty for repeat order
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
			var itemType=_order.registeredItemTypes[i].name+"s";
			clearRowIdAndOrderId(itemType);
		}
	}
	
	//retrieve data from server with provided orderNumber and populate into order's dataSet
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