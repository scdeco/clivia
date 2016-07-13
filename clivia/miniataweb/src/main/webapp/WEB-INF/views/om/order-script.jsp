<script>
	'user strict';
	var orderApp = angular.module("orderApp",
			[ "ui.router", "kendo.directives","clivia","crmApp"]);
 //SO
orderApp.factory("SO",["$http","$q","$state","consts","cliviaDDS","util",function($http, $q, $state,consts,cliviaDDS,util){
	var _order={
			dataSet:{
					info:{},
					items:[],
					deleteds:[],
					upcItems:[]
				},
				
			company:{
					info:{},
					contacts:[],
					addresses:[],
					buyerDataSource:new kendo.data.DataSource({data:[]}),					
				},
			
			repName:"",
			csrName:"",
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
					library:consts.baseUrl+"lib/",
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
				image:cliviaDDS.createDict("image",consts.baseUrl+"data/libImage/","onDemand"),
				
				garment:cliviaDDS.getDict("garment"),
				brand:cliviaDDS.getDict("brand"),
				season:cliviaDDS.getDict("season"),
				upc:cliviaDDS.getDict("upc"),
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
	
	_order.getRegisteredItemType=function(id){
		 var item=null;
		 for(var i=0;i<setting.registeredItemTypes.length;i++)
			 if(setting.registeredItemTypes[i].id===id){
				 item=setting.registeredItemTypes[i];
				 break;
			 }
		return item;
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

	//setting,used by item.id,lineitem.id,billItemId..., 
	_order.getTmpId=function(){
		return ++_order.instance.tmpId;
	}
	
    _order.clearDicts=function(){
		_order.dds.image.clear();
    }
    
    _order.clearInstance=function(){
    	instance.isDirty=false;
    	instance.tmpId=0;
    	instance.currentItemId=0;
    	instance.itemButtons.splice(0,instance.itemButtons.length);
    }
    
	_order.clearDataSet=function(){
		util.clearProperties(dataSet.info);
		
		dataSet.items.splice(0,dataSet.items.length);
		for(var i=0;i<_order.setting.registeredItemTypes.length;i++){
			var dt=dataSet[_order.setting.registeredItemTypes[i].name+"s"];
			dt.splice(0,dt.length);
		}
		dataSet.deleteds.splice(0,dataSet.deleteds.length);	
		dataSet.upcItems.splice(0,dataSet.upcItems.length);
	}

    _order.clear=function(){
    	_order.repName="";
    	_order.csrName="";
    	_order.clearDataSet();
    	_order.clearDicts();
    	_order.clearInstance();
    }
    
	_order.getEmployee=function(id){
		
	}
    _order.getCompany=function(){
    	var companyId=_order.dataSet.info.customerId;
		if(!!companyId && _order.company.info.companyId!==companyId){
			
			var url="../crm/get-company?id="+companyId+"&list=contactItems,addressItems";
			$http.get(url).
				success(function(data, status, headers, config) {
					if(data){
						_order.company.info=data.info;
						var cinfo=_order.company.info;
						var oinfo=_order.dataSet.info;
						
						if(cinfo.repId && !oinfo.id && !oinfo.repId){
							oinfo.repId=cinfo.repId;
						}
						
						if(!oinfo.term)
							oinfo.term=cinfo.term;
						
						_order.company.contacts=data.contactItems;
						var buyers=[];
						for(var i=0;i<data.contactItems.length;i++){
							buyers.push(data.contactItems[i].fullName)
						}
						
						//PROBABEALY A KENDO'S BUG HERE
						//AFTER SET DATA TO DATASOURCE, THE VALUE OF THE COMBOBOX WAS SET TO "" (EMPTY STRING),
						//IF THE COMBOBOX IS CLICKED ONCE(SHOW UP THE DOPDOWN LSIT), THERE IS NO SUCH PROBLEM,
						//SO WE KEEP THE VALUE OF BUYER AND SET IT BACK AFTER CHANGING DATA OF DATASOURCE  
						var temp=oinfo.buyer;
						_order.company.buyerDataSource.data(buyers);
						if(oinfo.buyer!==temp)
							oinfo.buyer=temp;
						
						//auto set the first contact as buyer if there's only one contact 
 						//if(data.length>0 && !_order.dataSet.info.id){
						//	_order.dataSet.info.buyer=data[0].fullName;
						//}
						
						_order.company.addresses=data.addressItems;
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
			
			if(data.upcItems)
				dataSet.upcItems=data.upcItems;
			
		}
		
	}
	
	
	_order.isNew=function(){
		return !dataSet.info.id;
	}

	_order.isDirty=function(){
		if(dataSet.info.isDirty)
			return true;
		
		if(dataSet.deleteds.length>0)
			return true;
		
		for(var i=0;i<setting.registeredItemTypes.length;i++){
			var dis=dataSet[setting.registeredItemTypes[i].name+"s"];
			
			if(dis){
		    	for(var j=0;j<dis.length;j++){
		    		if(dis[j].isDirty)
		    			return true;
		    	}
				
			}
		}
		
		return false;
	}
	
	_order.repeat=function(){
		var info=dataSet.info;
		info.id=null;
		info.orderNumber="--";
		info.customerPO=null;
		info.finishDate=null;
		info.invoiceDate=null;
		info.isDirty=true;
		info.createBy=null;
		info.finishBy=null;
		info.invoiceBy=null;
		
		var mapOrderItemId={};
		
		var items=dataSet.items;
		
		for(var i=0,orderItem,orderItemId;i<items.length;i++){
			orderItem=items[i];
			orderItemId=String(orderItem.id);
			orderItem.id= _order.getTmpId();
			orderItem.orderId=null;
			orderItem.isDirty=true;
			mapOrderItemId[orderItemId]=orderItem.id;
		}
		
		var itemButtons=_order.instance.itemButtons;
		for(var i=0,ib;i<itemButtons.length;i++){
			ib=itemButtons[i];
			ib.orderItemId=mapOrderItemId[String(ib.orderItemId)];
		}
		
		var itemTypes=_order.setting.registeredItemTypes;
		for(var i=0;i<itemTypes.length;i++){
			var dt=itemTypes[i].name+"s";
			var dis=dataSet[dt];
			if(dis){
		    	for(var j=0,di;j<dis.length;j++){
		    		di=dis[j];
		    		di.id=null;
		    		di.orderId=null;
		    		di.orderItemId=mapOrderItemId[String(di.orderItemId)];
		    		di.isDirty=true;
		    	}
			}
		}
		
		dataSet.upcItems=[];

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
	    var error=_order.generateUpcItems();
	    
	    if(error){
	    	alert(error);
	    	return;
	    }

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
				var type=_order.getRegisteredItemType(dataItem.typeId);
	 		  	 $state.go('main.'+type.name,{orderItemId:orderItemId});
			}
		}else{
			$state.go('main.blankitem');
		}
 	};
 	
 	
 	_order.getCurrentOrderItem=function(){
 		return _order.getOrderItem(instance.currentItemId);
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
 				typeId:menuItem.itemTypeId,
 				snpId:menuItem.snpId,
 				spec:menuItem.spec,
 				isDirty:true,
     		};
     	
     	if(menuItem.itemTypeId===2){		//"lineItem"
     		var brand=_order.getBrandFromSpec(menuItem.spec);
   			var season=_order.getSeasonFromSpec(menuItem.spec);
   			orderItem.spec=season.brandId+":"+season.id;
     	}
     	dataSet.items.push(orderItem);
     	_order.addOrderItemButton(orderItem)
     	return orderItem;
       };	
       
    _order.removeOrderItem=function(orderItem){
    	
    	var items=_order.dataSet.items,
    		itemButtons=_order.instance.itemButtons;

    	//remove the item button from _order.instance.itemButtons
    	var idx=util.findIndex(itemButtons,"orderItemId",orderItem.id);
    	itemButtons.splice(idx,1);
    	
    	//remove the orderItem from  _order.dataSet.items
    	var idx=util.findIndex(items,"id",orderItem.id);
    	items.splice(idx,1);
    	
    	//set lineNo same as item index+1
    	_order.setOrderItemLineNo();

    	
    	//set new current orderItem. if no more item, set to blank.
    	if (idx===items.length)
    		idx--;
    	idx=idx>=0?items[idx].id:0;
   		_order.setCurrentOrderItem(idx);
   		
   		//register to deleted items
	   	_order.registerDeletedItem("orderItem",orderItem.id,true);
	   	
    	//get dataTable from the dataSet, orderItem.typeId registeredItemType.name is the dataTable name
		 var type=_order.getRegisteredItemType(orderItem.typeId);
	   	 var dis=_order.dataSet[type.name+"s"];  
		 for(var i=dis.length-1;i>=0;i--){
			 di=dis[i];
			 if(di.orderItemId===orderItem.id){
				 
		   		 //register to deleted items 
				_order.registerDeletedItem(type.model,di.id);
		   		
				 //remove from the dataTable
			    dis.splice(i,1);
			 }
		 }
   		 
        };
    _order.setOrderItemLineNo=function(){
    	var items=_order.dataSet.items;
    	
    	//set lineNo same as item index+1
		for(var i=0,lineNo;i<items.length;i++){
			lineNo=i+1;
			if(items[i].lineNo!==lineNo){
	  			 items[i].lineNo=lineNo;
	  			 items[i].isDirty=true;
			}
			
		}
    	
    }
    
	_order.registerDeletedItem=function(entity,id,hasDependent){
		var flag=(!!hasDependent)?id>=consts.maxTmpId:!!id
		if(flag){
			var deletedItem={entity:entity,id:id};
			dataSet.deleteds.push(deletedItem);
		}
	}
	
	_order.setDiscount=function(billOrderItem,discount){
		if(!billOrderItem) return;
		if(billOrderItem.typeId!==1) return;	//not a billItem	
		
		var billItems=dataSet.billItems;
		
		for(var i=0,item;i<billItems.length;i++){
			item=billItems[i];
			if(item.orderItemId===billOrderItem.id){
				item.discount=discount;
				item.orderPrice=(discount>0 && discount<1)?item.listPrice*(1-discount):item.listPrice;
				item.Amt=item.orderQty*item.orderPrice;
			}
		}
	}
	
	_order.generateBillableItems=function(billOrderItem){
		if(!billOrderItem) return;
		if(billOrderItem.typeId!==1) return;	//not a billItem
		if(!_order.company ||!_order.company.info) return;
		
		var useWSP=_order.company.info.useWsp;
		var useUSD=_order.company.info.country!=="Canada";
		var listPriceField=useWSP?(useUSD?"wsp":"wspCad"):(usedUSD?"rrp":"rrpCad");
		
		var	billableItems=[];
		var billableIdx={};
		var orderItems=dataSet.items;
		var orderId=_order.dataSet.info.id;
		var dictGarment=_order.dds.garment;
		
		var discount=billOrderItem.spec;
		
		for(var i=0,orderItem;i<orderItems.length;i++){
			orderItem=orderItems[i];
			if(orderItem.snpId){
				if(orderItem.typeId===2){		//"lineItem"
					var strTypeId=String(orderItem.typeId);
					if(!billableIdx[strTypeId])
						billableIdx[strTypeId]={};
					var idx=billableIdx[strTypeId];
					
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
									var listPrice=garment[listPriceField];
									var orderPrice=(discount>0 && discount<1)?listPrice*(1-discount):listPrice;
										if(orderPrice)
											orderPrice.toFixed(2);
									billableItem={
											orderId:orderId,
											orderItemId:billOrderItem.id,											
											snpId:orderItem.snpId,
											itemTypeId:orderItem.typeId,
											itemNumber:lineItem.styleNo,
											billingKey:String(lineItem.garmentId),
											description:lineItem.description,
											unit:"PCS",
											orderQty:lineItem.quantity,
											listPrice:listPrice,
											discount:discount,
											orderPrice:orderPrice,
											orderAmt:0,
											isDirty:true,
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
		
		for(var i=0,item;i<billItems.length;i++){
			item=billItems[i];
			if(item.itemTypeId){			//auto generated item
				var strItemTypeId=String(item.itemTypeId);
				if(typeof billItemsIdx[strItemTypeId]=='undefined')	//billItemsIdx[strItemTypeId] could be zero, so typeof must be used in condition
					billItemsIdx[strItemTypeId]={};
				var idx=billItemsIdx[strItemTypeId];
				idx[String(item.billingKey)]=i;
				billItems[i].checked=false;
			}
		}
		
		var newAddBillItems=[];

		for (var i=0,j,idx,billableItem,notFound;i<billableItems.length;i++){
			billableItem=billableItems[i];
			
			idx=billItemsIdx[String(billableItem.itemTypeId)];
			j=idx?idx[String(billableItem.billingKey)]:notFound;
			
			if(j>=0){	
				//if found, only quantity need to change and recalcuate the amount using the original price,
				//price might has been chaneged by user
				billItem=billItems[j];
				if(billItem.orderQty!==billableItem.orderQty){
					billItem.orderQty=billableItem.orderQty;
					billItem.isDirty=true;
				}

				billItem.orderAmt=billableItem.orderQty*billItem.orderPrice;	
				billItem.checked=true;
			}else{
				billableItem.orderAmt=billableItem.orderQty*billableItem.orderPrice;
				billItem=billableItem;
				billItem.isDirty=true;
				newAddBillItems.unshift(billItem);
			}
		}
		
		for(var i=billItems.length-1,item;i>=0;i--){
			item=billItems[i];
			if(item.itemTypeId && !item.checked){
				if(item.id)
					_order.registerDeletedItem("orderBillItem",item.id);
				billItems.splice(i,1);
			}
		}
		
		for(var i=0;i<newAddBillItems.length;i++)
			billItems.unshift(newAddBillItems[i]);
		
	}
	
 	_order.getStyleGridHtml=function(garmentId){

		var model=_order.createStyleGridModel(garmentId);
		var data=model?model.data:null;
		if(!data) return "";
		
		var imageId=model.garment.imageId;
		var row=data[0];
		var html="<div>";
		if(imageId){
			html+="<img style='float:left;' src=../lib/image/getimage?thumbnail=true&id="+imageId+">";
		}

		html+="<table style='float:left;text-align: right;'>";
		html+="<tr><th class='tal'>"+row[0]+"</th>";
		for(var i=1;i<row.length-1;i++){
			html+="<th class='billDetailQty tar'>"+row[i]+"</th>";
		}
		html+="<th class='tar lineqty'>"+row[i]+"</th></tr>";
		
		for(var i=1;i<data.length;i++){
			row=data[i];
			for(var j=0;j<row.length;j++){
				html+="<td class='tar'>"+(row[j]?row[j]:"")+"</td>";
			}
			html+="</tr>";
		}
		
		html+="</table></div>";
		
		return html;
	}	
 	
 	_order.getBillHeaderHtml=function(){
 		
 		
 	}

 	var createContactPrintModel=function(){
 		var companyContacts=_order.company.contacts;
		var buyer=_order.dataSet.info.buyer;
		
		var contact={
					name:buyer?buyer:"",
					phone:"",
					email:""
			}
		
 		var orderContacts=[];
 		//change contactItems from ObservableArray to Array
 		//ObservableArray dosen't have a concat method,
 		//orderContacts must prior to companyContacts
 		for(var i=0,c;i<_order.dataSet.contactItems.length;i++){
 			c=_order.dataSet.contactItems[i];
 			orderContacts.push({
 					 fullName:c.fullName?c.fullName:((c.firstName?c.firstName+" ":"")+(c.lastName?c.lastName:"")),
 				     phone:c.phone?c.phone:"",
 				     email:c.email?c.email:""
 				   });
 		}
		var contacts=orderContacts.concat(companyContacts);
		
		//when has a buyer name but can not find it in companyContacts 
		//and there is no order contacts, just use the buyer's name without phone and email
 		if(contacts.length>0){
 			var foundIndex=-1;
 			if(buyer){
 				buyer=buyer.trim().toUpperCase();
	 	 		for(var i=0,f;i<contacts.length;i++){
	 	 			f=contacts[i].fullName.trim().toUpperCase();
	 	 			if(f===buyer)
	 	 				foundIndex=i;
	 	 				break;
	 	 		}
	 	 		
	 	 		if(foundIndex<0 && orderContacts.length>0){
	 	 				foundIndex=0;
	 	 		}
	 	 		
 			}else{
 				foundIndex=0;
 			}
 			
 			if(foundIndex>=0){
 				var c=contacts[foundIndex];
 				contact={
 	 					 name:c.fullName?c.fullName:((c.firstName?c.firstName+" ":"")+(c.lastName?c.lastName:"")),
	 				     phone:c.phone?c.phone:"",
	 				     email:c.email?c.email:""
	 				   }
 			}
 		}
		return contact;

 	}
 	
 	var createAddressPrintModel=function(isBilling){
 		var address,c;
 		var addresses=_order.dataSet.addressItems;
 		for(var i=0,f;i<addresses.length;i++){
 			c=addresses[i];
 			f=isBilling?c.billing:c.shipping;
 			if(f){
 				address=c;
 				break;
 			}
 		}
 		
 		if(!address){
	 		addresses=_order.company.addresses;
	 		for(var i=0,f;i<addresses.length;i++){
	 			c=addresses[i];
	 			f=isBilling?c.billing:c.shipping;
	 			if(f){
	 				address=c;
	 				break;
	 			}
	 		}
 		}
 		
 		if(address){
			address={
				receiver:address.receiver,
				addr1:address.addr1,
				addr2:address.addr2,
				city:address.city,
				province:address.province,
				country:address.country,
				postalCode:address.postalCode,
				attn:address.attn,
			};
 		}else{
			address={
					receiver:"",
					addr1:"",
					addr2:"",
					city:"",
					province:"",
					country:"",
					postalCode:"",
					attn:"",
				};
 		}
 		if(!address.receiver){
 			address.receiver="";
 			if(isBilling||(c.billing && c.shipping))	
 	 			address.receiver=_order.company.info.businessName;
 		}
 		
		return address;
 		
 	}
 	
 	_order.createGarmentPrintModel=function(billItems,lineItemOnly,mainColorOnly,hideDiscount){
 		var info=_order.dataSet.info;
 		var company=_order.company;
 		var  model={
 				info:{
 					orderNo:info.orderNumber,
 					orderName:info.orderName,
 					orderDate:info.orderDate,
 					poNo:info.customerPO,
 					rep:_order.repName,
 					csr:_order.csrName,
 					company:company.info.businessName,
 					terms:info.term,
 					shipDate:info.requireDate,
 					cancelDate:info.cancelDate, 			//info.cancelDate,
 					remark:info.remark,
 					hideDiscount:hideDiscount,
				},
	 			items:[],
 			};
 		
 		model.info.contact=createContactPrintModel();
		model.info.billTo=createAddressPrintModel(true);
		model.info.shipTo=createAddressPrintModel(false);
		
		model.showDiscount=false;
 		
		var totalQty=0,totalAmt=0;
 		for(var i=0,bi,h,p;i<billItems.length;i++){
 			bi=billItems[i];

 			if(bi.discount>0)
 					model.showDiscount=true;
 			
 			
 			if(lineItemOnly?bi.itemTypeId===2:true){
 				mbi={
 					itemNo:bi.itemNumber?bi.itemNumber:"",
 					desc:bi.description?bi.description:"",
 					qty:bi.orderQty?kendo.toString(bi.orderQty,"##,#"):"",
 					listPrice:bi.listPrice?kendo.toString(bi.listPrice, "0.00"):"",	
 					discount:bi.discount?kendo.toString(bi.discount,"p2"):"",
 					price:bi.orderPrice?kendo.toString(bi.orderPrice, "0.00"):"",
 					amt:bi.orderAmt?kendo.toString(bi.orderAmt, "c"):"",
 				};
 				if(bi.itemTypeId===2){		//lineItem
					var styleModel=_order.createStyleGridModel(parseInt(bi.billingKey),mainColorOnly);	//show main color only
					if(styleModel){
						/* mbi.imageId=styleModel.garment.imageId; */
						mbi.data=styleModel.data;
					}
				} 				
 				
 				model.items.push(mbi);

 				totalAmt+=bi.orderAmt?bi.orderAmt:0;
 	 			totalQty+=bi.orderQty?bi.orderQty:0;
 				
 			}
 		}
 		
 		model.info.totalAmt=kendo.toString(totalAmt, "c");
 		model.info.totalQty=kendo.toString(totalQty,"##,#");
 		
 	//test data 	_order.printModel=model; 
 		return model;
 	}
 	
 	_order.createStyleGridModel=function(garmentId,mainColourOnly){
		
		if(!garmentId) return null;
		
		var garment=_order.dds.garment.getGarmentById(garmentId); 
		
		if(!garment) return null;
 		
 		var data=[];
		var season=_order.dds.season.getLocalItem("id",garment.seasonId)
		
		//use util.split to split the string with delimiter "," and trim the result
		var sizes=util.split(garment.sizeRange);
		var colours=util.split(garment.colourway);
		
		//sizefields in lineItem
		var sizeFields=util.split(season.sizeFields);	
		
		var colourIndex={};
		
		for(var i=0,row;i<colours.length;i++){
			//0 is colour,and sizes.length+1 is total qty of the colour, 1 to sizes.length is qty of size
			row=new Array(sizes.length+2);		
			row[0]=colours[i];
			colourIndex[colours[i]]=i;
			data.push(row);
		}
		var idxLineQty=sizes.length+1;
		
		var lineItems=_order.dataSet.lineItems;
		for(var i=0,r,lineItem,row;i<lineItems.length;i++){
			lineItem=lineItems[i];
			if(lineItem.garmentId===garmentId){
				r=colourIndex[lineItem.colour];
				if(r>=0){
					row=data[r];
					for(var j=0,k,field,qty;j<sizeFields.length;j++){
						field="qty"+("00"+j).slice(-2); 	//right(2)
						var qty=parseInt(lineItem[field]);
						if(qty){
							k=sizes.indexOf(sizeFields[j])+1;	//first is colour column
							row[k]=row[k]?row[k]+qty:qty;
							row[idxLineQty]=row[idxLineQty]?row[idxLineQty]+qty:qty;
						}
					}
				}
			}
		}
		
		if(mainColourOnly){
			
			for(var i=1,r,c;i<data.length;i++){
				r=data[i];
				c=r[0].split("/");
				r[0]=c[0];
			}
		}
		
		for(var i=data.length-1,row;i>=0;i--){
			row=data[i];
			if(!row[idxLineQty])
				data.splice(i,1);
		}

		var header=new Array(sizes.length+2);
		header[0]="";			   // "Main Color";
		for(var i=0;i<sizes.length;i++)
			header[i+1]=sizes[i];
		header[i+1]="Line Qty";
		data.unshift(header);
		
		return {garment:garment,data:data};
		
	}	 	
 	
 	_order.printBill=function(billItems,lineItemOnly,mainColourOnly,hideDiscount){
 		var data=_order.createGarmentPrintModel(billItems,lineItemOnly,mainColourOnly,hideDiscount);
 		util.printUrl("../om/print-confirm-dd",{data:JSON.stringify(data)},false);	//false=no preview
 		return;
 	}
	
	_order.generateUpcItems=function(){
		var dictUpc=_order.dds.upc;

		var orderUpcs=dataSet.upcItems;
		
		var upcs=[];
		
		var orderItems=dataSet.items;
		var orderId=_order.dataSet.info.id;
		var idxUpc={};
		
		var billItems=dataSet.billItems;
		var idxBill;
		for(var i=0,orderItem;i<orderItems.length;i++){
			orderItem=orderItems[i];
			if(orderItem.typeId===2){ //"lineItem"
				idxBill={};
				for(var j=0,billItem;j<billItems.length;j++){
					billItem=billItems[j];
					if(billItem.itemTypeId===orderItem.typeId && billItem.billingKey){
						idxBill[billItem.billingKey]=j;
					}
				}
				
				var brand=_order.getBrandFromSpec(orderItem.spec);
				if(brand.hasInventory){  
					var season=_order.getSeasonFromSpec(orderItem.spec);
					var sizes=util.split(season.sizeFields);
					var sizesLength=sizes.length;
					var lineItems=dataSet.lineItems;
					for(var j=0,lineItem,idx,billItem;j<lineItems.length;j++){
						lineItem=lineItems[j];
						if(lineItem.orderItemId===orderItem.id && lineItem.garmentId && lineItem.colour){
							
							idx=idxBill[lineItem.garmentId];
							
							if(!(idx>=0))
								return "Error: item has not been billed("+lineItem.styleNo+"-"+lineItem.garmentId+")";
							
							billItem=billItems[idx];
							
							for(var f=0,field,qty,upc,upcId;f<sizesLength;f++){
								field="qty"+("00"+f).slice(-2);
								qty=lineItem[field]?lineItem[field]:0;
								if(qty){
									
									//create index,combine qty of same upcId									
									upcId=dictUpc.getUpcId(lineItem.garmentId,lineItem.colour,sizes[f]);
									if(upcId){
										idx=idxUpc[String(upcId)];
										if(typeof idx!=='undefined'){ //idx starts from 0;
											upc=upcs[idx];
											upc.orderQty+=qty;
											
										}else{
											upc={
													upcId:upcId,
													billingKey:String(lineItem.garmentId),
													orderQty:qty,
													isDirty:true
												};
											idxUpc[String(upcId)]=upcs.push(upc)-1;
											
										}
										
										
									}else{
										return "Error: can not find item("+lineItem.styleNo+"-"+lineItem.garmentId+" colour-"+lineItem.colour+" size-"+sizes[f]+")";
									}
								}
							}	//end of for:f	
							
						}
					}	//end of for:j
				}
			}
		}	//end of for:i
		
		for(var i=orderUpcs.length,originalUpc,generatedUpc;i>0;i--){
			orderUpc=orderUpcs[i-1];
			idx=idxUpc[String(orderUpc.upcId)];
			if(typeof idx!=='undefined'){ //idx starts from 0;
				generatedUpc=upcs[idx];
				if(!(orderUpc.orderQty===generatedUpc.orderQty)){
					
					orderUpc.orderQty=generatedUpc.orderQty;
					orderUpc.isDirty=true;
				}
				
				generatedUpc.isDirty=false;
				
			}else{
				if(orderUpc.id){
					_order.registerDeletedItem("orderUpc",orderUpc.id);
				}
				orderUpcs.splice(i-1,1);
			}
		}
		
		for(var i=0,upc;i<upcs.length;i++){
			upc=upcs[i];
			if(upc.isDirty){
				orderUpcs.push(upc);
			}
		}
		
		return "";
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
				season=_order.dds.season.getLocalItem("id",parseInt(specs[1]));
			}else{
				season=_order.dds.season.getCurrentSeason(parseInt(specs[0]));
			}
		}
		return season; 
	}
	
        
   	return _order;
	
}]); /* end of CliviaOrder */
 

orderApp.controller("orderCtrl",["$scope",function($scope) {
	
	
}]);

	


</script>