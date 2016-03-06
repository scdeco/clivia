<script>
	'user strict';
	var orderApp = angular.module("orderApp",
			[ "ui.router", "kendo.directives","clivia" ]);
 //SO
orderApp.factory("SO",["$http","$q","$state","consts","cliviaDDS",function($http, $q, $state,consts,cliviaDDS){
	var _order={
			dataSet:{
					info:{},
					items:[],
					deleteds:[],
					upcs:[]
				},
				
			company:{
					info:{},
					contacts:[],
					buyerDataSource:new kendo.data.DataSource({data:[]}),					
				},
				
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
					order:consts.baseUrl+"im/",
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
				image:cliviaDDS.createDict("image",consts.baseUrl+"data/libImage/","onDemand"),
				brand:cliviaDDS.getDict("brand"),
				season:cliviaDDS.getDict("season"),
				},
				
			instance:{
				itemButtons:new kendo.data.ObservableArray([]),
				currentItemId:0,
				tmpId:1,
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
/* 				 if(item.itemType==="lineItem" && item.itemType!=="Generic"){
					 var a=item.spec.split(":");
					 item.spec+=";"+getCurrentSeason(a[1]);
				 } */
				 break;
			 }
		return item;
	}

	//setting,used by item.id,lineitem.id..., 
	_order.getTmpId=function(){
		return ++_order.instance.tmpId;
	}
	
    _order.clearDicts=function(){
		_order.dds.image.clear();
    }
    
    _order.clearInstance=function(){
    	instance.tmpId=0;
    	instance.currentItemId=0;
    	instance.itemButtons.splice(0,instance.itemButtons.length);
    }
    
	_order.clearDataSet=function(){
		var info=dataSet.info;
		
		for(var p in info)
		    if(info.hasOwnProperty(p))
		        info[p] = null;
		
		dataSet.items.splice(0,dataSet.items.length);
		for(var i=0;i<_order.setting.registeredItemTypes.length;i++){
			var dt=dataSet[_order.setting.registeredItemTypes[i].name+"s"];
			dt.splice(0,dt.length);
		}
		dataSet.deleteds.splice(0,dataSet.deleteds.length);	
		dataSet.upcs.splice(0,dataSet.upcs.length);
	}

    _order.clear=function(){
    	_order.clearDataSet();
    	_order.clearDicts();
    	_order.clearInstance();
    }
    
	
    _order.getCompany=function(){
    	var companyId=_order.dataSet.info.customerId;
		if(!!companyId && _order.company.info.companyId!==companyId){
			var url="../data/companyInfoDao/getitem?name=id&value="+companyId;
			$http.get(url).
				success(function(data, status, headers, config) {
					if(data){
						_order.company.info=data;
						if(data.repId && !_order.dataSet.info.id && !_order.dataSet.info.repId){
							_order.dataSet.info.repId=data.repId;
						}
					}
				}).
				error(function(data, status, headers, config) {
				});
			
			url="../data/companyContactDao/call/findListByCompanyId?param=i:"+companyId;

			_order.company.contacts=[];
			$http.get(url).
				success(function(data, status, headers, config) {
					if(data){
						_order.company.contacts=data;
						var buyers=[];
						for(var i=0;i<data.length;i++){
							buyers.push(data[i].fullName)
						}
						
						//PROBABEALY A KENDO'S BUG HERE
						//AFTER SET DATA TO DATASOURCE, THE VALUE OF THE COMBOBOX WAS SET TO "" (EMPTY STRING),
						//IF THE COMBOBOX IS CLICKED ONCE(SHOW UP THE DOPDOWN LSIT), THERE IS NO SUCH PROBLEM,
						//SO WE KEEP THE VALUE OF BUYER AND SET IT BACK AFTER CHANGING DATA OF DATASOURCE  
						var temp=_order.dataSet.info.buyer;
						_order.company.buyerDataSource.data(buyers);
						if(_order.dataSet.info.buyer!==temp)
							_order.dataSet.info.buyer=temp;
						
						//auto set the first contact as buyer if there's only one contact 
 						//if(data.length>0 && !_order.dataSet.info.id){
						//	_order.dataSet.info.buyer=data[0].fullName;
						//}
					}
				}).
				error(function(data, status, headers, config) {
				});

		}		
    }
	
	//populate data get from server into this model(_order.dataSet)
	var populate=function(data){
		_order.clearDataSet();
		if(!!data) {		//data is not empty
			if(data.info){
				dataSet.info=data.info;
			}

			if(data.items)
				dataSet.items=data.items;
			
			for(var i=0;i<setting.registeredItemTypes.length;i++){
				var itemType=setting.registeredItemTypes[i].name+"s",
					dataTable=dataSet[itemType],
					dataItems=data[itemType];
				if(dataItems)
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
	    		dataTable[i].id=null;
	    		dataTable[i].orderId=null;
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

		var url="get-order?number="+orderNumber;
		var deferred = $q.defer();
		
		$http.get(url).
			success(function(data, status, headers, config) {
		    	populate(data);
				_order.getCompany();
			    deferred.resolve(data);
			}).
			error(function(data, status, headers, config) {
				_order.clear();
				deferred.reject(data);
			});
				
		return deferred.promise;
	};
	
	_order.save=function() {

		var url="save-order";
		
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

		var url="delete-order";
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
		
        var oldId=instance.currentItemId;
        
		instance.currentItemId=orderItemId;	
		if(orderItemId>0) {
	        for(var i=0;i<instance.itemButtons.length;i++){
        		instance.itemButtons[i].selected=instance.itemButtons[i].orderItemId===orderItemId;
	        }
		       	  
	        dataItem=_order.getOrderItem(orderItemId);
		}
		
		if(dataItem){
			if(instance.currentItemId!==oldId){
	 		  	 $state.go('main.'+dataItem.type,{orderItemId:orderItemId});
			}
		}else{
			$state.go('main.blankitem');
		}
 	};
 	
 	
 	_order.getCurrentOrderItem=function(){
 		return _order.getOrderItem(instance.currentItemId)
 	}
 	
 	
 	_order.getOrderItem=function(itemId){
 		var dataItem=null;
 		for(var i=0;i<dataSet.items.length;i++)
 			if(itemId===dataSet.items[i].id){
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
 			if(buttons[i].orderItemId===item.id){
 				button=buttons[i];
 				break;
 			}
 		}
 		return button;
 	}

 	_order.addOrderItemButton=function(orderItem){
 		
        button={
        		text:orderItem.title, 
        		id: "btn"+orderItem.id, 
        		icon: "insert-n",
        		togglable: true, 
        		group: "OrderItem",
        		orderItemId:orderItem.id,
        	};
        
        instance.itemButtons.push(button);
        return button;
 	}
 	
    _order.addOrderItem = function(menuItem) {
     	var orderItemId=_order.getTmpId();
     	var orderItem={
    			orderId:dataSet.info.orderId ,
    			id:orderItemId,
    			lineNo:dataSet.items.length+1,
	     		title:menuItem.text,
 				type:menuItem.itemType,
 				spec:menuItem.spec,
 				snpId:menuItem.snpId,
     		};
     	
     	if(menuItem.itemType==="lineItem"){
     		var brand=_order.getBrandFromSpec(menuItem.spec);
   			var season=_order.getSeasonFromSpec(menuItem.spec);
   			orderItem.spec=season.brandId+":"+season.id;
     	}
     	dataSet.items.push(orderItem);
     	_order.addOrderItemButton(orderItem)
     	return orderItem;
       };	
       
    _order.removeOrderItem=function(orderItem){
    	
    	var idx=orderItem.lineNo-1;
    	var items=_order.dataSet.items,
    		itemButtons=_order.instance.itemButtons;
    	
    	//remove the orderItem from  _order.dataSet.items
    	items.splice(idx,1);
    	
    	//set lineNo same as item index+1
		for(var i=0;i<items.length;i++)
   			 items[i].lineNo=i+1;
    	
    	//remove the item button from _order.instance.itemButtons
    	itemButtons.splice(idx,1);
    	
    	//set new current orderItem. if no more item, set to blank.
    	if (idx===items.length)
    		idx--;
    	idx=idx>=0?items[idx].id:0;
   		_order.setCurrentOrderItem(idx);
   		
   		//register to deleted items
	   	_order.registerDeletedItem("item",orderItem.id);
	   	
    	//get dataTable from the dataSet, orderItem.type is the dataTable name
	   	 var dis=_order.dataSet[orderItem.type+"s"];  
		 for(var i=dis.length-1;i>=0;i--){
			 di=dis[i];
			 if(di.orderItemId===orderItem.id){
				 
		   		 //register to deleted items 
				_order.registerDeletedItem(orderItem.type,di.id);
		   		
				 //remove from the dataTable
			    dis.splice(i,1);
			 }
		 }
   		 
        };
       
	_order.registerDeletedItem=function(entity,id){
		if(id>=consts.maxTmpId){
			var deletedItem={entity:entity,id:id};
			dataSet.deleteds.push(deletedItem);
		}
	}
	
	_order.generateBillableItems=function(billOrderItem){
		if(!billOrderItem) return;
		if(billOrderItem.type!=="billItem") return;
		
		var	billableItems=[];
		var billableIdx={};
		var orderItems=dataSet.items;
		var orderId=_order.dataSet.info.id;
		var dictGarment=_order.dds.garment;
		
		for(var i=0,orderItem;i<orderItems.length;i++){
			orderItem=orderItems[i];
			if(orderItem.snpId){
				if(orderItem.type==="lineItem" ){
					if(!billableIdx[orderItem.type])
						billableIdx[orderItem.type]={};
					var idx=billableIdx[orderItem.type];
					var lineItems=dataSet.lineItems;
					
					for(var j=0,f,sid,lineItem,billableItem;j<lineItems.length;j++){
							
						lineItem=lineItems[j];
						
						if(lineItem.orderItemId===orderItem.id && lineItem.garmentId && lineItem.quantity){
							sid=String(lineItem.garmentId);
							f=idx[sid];
							if(typeof f!=='undefined'){
								billableItem=billableItems[f];
								billableItem.orderQty+=lineItem.quantity;
							}else{
								var garment=dictGarment.getGarmentById(lineItem.garmentId);
								if(garment){
									billableItem={
											orderId:orderId,
											orderItemId:billOrderItem.id,											
											snpId:orderItem.snpId,
											type:orderItem.type,
											key:lineItem.garmentId,
											description:lineItem.styleNo+"--"+lineItem.description,
											unit:"PCS",
											orderQty:lineItem.quantity,
											orderPrice:garment.wsp,
										}
									f=billableItems.push(billableItem);
									idx[sid]=f-1;
								}else{
									alert("Can not find garment.")
								}
							}
						}
					}	//end of for:j
				}
			}
		}//end of for:i
		
		var billItems=dataSet.billItems;
		var billItemsIdx={};
		
		for(var i=0,item;i<billItems.lenght;i++){
			item=billItems[i];
			if(item.type){			//auto generated item
				if(!billItemsIndex[item.type])
					billItemsIndex[item.type]={};
				var idx=billItemsIdx[item.type];
				idx[String(item.key)]=i;
				billItems[i].notChecked=true;
			}
		}
		
		var newAddBillItems=[];

		for (var i=0,j,idx,found,billableItem;i<billableItems.length;i++){
			billableItem=billableItems[i];
			
			idx=billItemsIdx[billableItem.snpId];
			j=-1;
			if(idx){
				j=idx[String(billableItem.key)];
				if(j>=0){
					billItem=billItems[j];
					billItem.orderQty=billableItem.orderQty;
					billItem.notChecked=false;
				}		
			}
			if(j<0){
				billItem=billableItem;
				newAddBillItems.push(billItem);
			}
			billItem.orderAmt=billItem.orderQty*billItem.orderPrice;
		}
		
		for(var i=billItems.length-1,item;i>=0;i--){
			item=billItems[i];
			if(item.type && item.notChecked)
				billItems.splice(i,1);
		}
		
		for(var i=0;i<newAddBillItems.length;i++)
			billItems.unshift(newAddBillItems[i]);
		
	}
	
	_order.generateUpcs=function(){
		var upcs=dataSet.upcs;
		
		upcs.splice(0,dataSet.upcs.length);
		
		var orderItems=dataSet.items;
		var orderId=_order.dataSet.info.id;
		for(var i=0,orderItem;i<orderItems.length;i++){
			orderItem=orderItems[i];
			if(orderItem.type==="lineItem"){
				var brand=_order.getBrandFromSpec(orderItem.spec);
				if(brand.hasInventory){
					var season=_order.getSeasonFromSpec(orderItem.spec);
					var sizes=season.sizeFields.split(",");
					var lineItems=dataSet.lineItems;
					for(var j=0,lineItem;j<lineItems.length;j++){
						lineItem=lineItems[j];
						if(lineItem.orderItemId===orderItem.id && lineItem.styleNo && lineItem.colour){
							
							
							for(var f=0,field,qty,upc;f<14;f++){
								field="qty"+("00"+f).slice(-2);
								qty=lineItem[field]?lineItem[field]:0;
								if(qty){
									upc={
										orderId:orderId,
										seasonId:lineItem.seasonId,
										styleNo:lineItem.styleNo,
										colour:lineItem.colour,
										size:sizes[f],
										qty:qty
									}
									upcs.push(upc);
								}
							}	//end of for:f	
							
						}
					}	//end of for:j
				}
			}
		}	//end of for:i
	}
	
	_order.getBrandFromSpec=function(orderItemSpec){
		var brand=null;
		if(orderItemSpec){
		   	var specs=orderItemSpec.split(":");
			brand=_order.dds.brand.getLocalItem("id",parseInt(specs[0]));
		}
		return brand;
	}
	
	_order.getSeasonFromSpec=function(orderItemSpec){
		var season=null;
		if(orderItemSpec){
			var specs=orderItemSpec.split(":");
			if(specs.length>1){
				season=_order.dds.season.getSeasonL(parseInt(specs[0]),parseInt(specs[1]));
			}else{
				season=_order.dds.season.getCurrentSeasonL(parseInt(specs[0]));
			}
		}
		return season; 
	}
	
        
   	return _order;
	
}]); /* end of CliviaOrder */
 

orderApp.controller("orderCtrl",["$scope",function($scope) {
	
	
}]);

	


</script>