<script>
	'user strict';
	var orderApp = angular.module("orderApp",
			[ "ui.router", "kendo.directives","clivia","crmApp","embdesign"]);
 //SO
orderApp.factory("SO",["$http","$q","$state","consts","cliviaDDS","util","dictThread",function($http, $q, $state,consts,cliviaDDS,util,dictThread){
	var _order={
			dataSet:{
					info:{isDirty:false,isNewDi:true},
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
				
				registeredServices:consts.registeredServices,
				},
				
			dds:{
				image:cliviaDDS.createDict("image",consts.baseUrl+"data/libImage/","onDemand"),
				
				garment:cliviaDDS.getDict("garment"),
				brand:cliviaDDS.getDict("brand"),
				season:cliviaDDS.getDict("season"),
				upc:cliviaDDS.getDict("upc"),
				},
				
			instance:{
				tmpId:1,
				}};

	var dataSet=_order.dataSet, dict=_order.dict, setting=_order.setting, instance=_order.instance;
	
	
	for(var i=0;i<setting.registeredItemTypes.length;i++){
		dataSet[setting.registeredItemTypes[i].name+"s"]=new kendo.data.ObservableArray([]);	
	}
	
	for(var i=0;i<setting.registeredServices.length;i++){
		dataSet[setting.registeredServices[i].name+"s"]=new kendo.data.ObservableArray([]);	
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
    }
    
	_order.clearDataSet=function(){
		util.clearProperties(dataSet.info);
		
		dataSet.info.isNewDi=true;
		dataSet.info.isDirty=false;
		
		dataSet.items.splice(0,dataSet.items.length);
		for(var i=0;i<_order.setting.registeredItemTypes.length;i++){
			var dt=dataSet[_order.setting.registeredItemTypes[i].name+"s"];
			dt.splice(0,dt.length);
		}

		for(var i=0;i<_order.setting.registeredServices.length;i++){
			var dt=dataSet[_order.setting.registeredServices[i].name+"s"];
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
			
			var url="../crm/get-company?id="+companyId+"&list=contacts,addresses";
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
						
						_order.company.contacts=data.contacts;
						var buyers=[];
						for(var i=0;i<data.contacts.length;i++){
							buyers.push(data.contacts[i].fullName)
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
						
						_order.company.addresses=data.addresses;
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

			for(var i=0;i<setting.registeredServices.length;i++){
				var serviceName=setting.registeredServices[i].name+"s",
					dataTable=dataSet[serviceName],
					dataItems=data[serviceName];
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
		
		var dis=dataSet.items;
		for(var i=0;i<dis.length;i++)
			if(dis[i].isDirty)
				return true;
		
		for(var i=0;i<setting.registeredItemTypes.length;i++){
			dis=dataSet[setting.registeredItemTypes[i].name+"s"];
			
			if(dis){
		    	for(var j=0;j<dis.length;j++){
		    		if(dis[j].isDirty)
		    			return true;
		    	}
				
			}
		}

		for(var i=0;i<setting.registeredServices.length;i++){
			dis=dataSet[setting.registeredServices[i].name+"s"];
			
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
		info.isNewDi=true;
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
	
	
    
	_order.registerDeletedItem=function(entity,di){
		if(!di.isNewDi){
			var deletedItem={entity:entity,id:di.id};
			dataSet.deleteds.push(deletedItem);
		}
	}
	
	_order.deleteDependentItems=function(dependentItemName,modelName,superIdName,superIdValue){
    	var dis=_order.dataSet[dependentItemName+"s"];  
    	
		for(var i=dis.length-1;i>=0;i--){
			 di=dis[i];
			 if(di[superIdName]===superIdValue){
				 
		   		 //register to deleted items 
				_order.registerDeletedItem(modelName,di);
		   		
				 //remove from the dataTable
			    dis.splice(i,1);
			 }
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
	
	
	_order.generateBillOfServiceEmb=function(billOrderItem){//itemTypreId:11,billingKey:designNo+";"+garmentType
	
		var startTime=(new Date()).getTime();
		var serviceDis=_order.dataSet.serviceEmbs,serviceDi;
	
		var lineItemDis=_order.dataSet.lineItems,lineItemDi;
		var lineItemDisIdx=util.createIndexOnId(lineItemDis);
	
		var generatedBillDis=[],generatedBillDi,generatedBillDiIdx;
		var generatedBillDisIdx={};
		
		for(var i=0,billingKey;i<serviceDis.length;i++){
			serviceDi=serviceDis[i];
			if(!!serviceDi.designNo){
				lineItemDi=lineItemDisIdx[String(serviceDi.lineItemId)];
				if(lineItemDi.quantity>0){
					billingKey=serviceDi.designNo+";"+"Garment"					//lineItemDi.type;
	
					generatedBillDiIdx=generatedBillDisIdx[billingKey];

					if(generatedBillDiIdx>=0){
						generatedBillDi=generatedBillDis[generatedBillDiIdx];
					}else{
						generatedBillDi={
								
								orderId:serviceDi.orderId,
								orderItemId:billOrderItem.id,
								snpId:1,			//Embroidery Service
								itemTypeId:11,			//registeredSerives[i].id
								billingKey:billingKey,
								itemNumber:serviceDi.designNo,	//+" "+serviceDi.ks+",000st"
								description:serviceDi.designName,
								unit:"PCS",
								listPrice:0,
								discount:0,
								orderPrice:0,
								orderAmt:0,
								orderQty:0,
								isNewDi:true,
								isDirty:true,
								
								
							};
						generatedBillDiIdx=generatedBillDis.push(generatedBillDi)-1;
						generatedBillDisIdx[billingKey]=generatedBillDiIdx;
					}
					
					generatedBillDi.orderQty+=lineItemDi.quantity;
				}
			}
		}
		
		
		var billItemDis=_order.dataSet.billItems,billItemDi;
		var firstServiceInBillItemsIdx=billItemDis.length;
		
		for(var i=billItemDis.length-1;i>=0;i--){
			billItemDi=billItemDis[i];
			if(billItemDi.itemTypeId===11){
				firstServiceInBillItemsIdx=i;
				generatedBillDiIdx=generatedBillDisIdx[billItemDi.billingKey];
				if(generatedBillDiIdx>=0){
					generatedBillDi=generatedBillDis[generatedBillDiIdx];
					if(generatedBillDi.orderQty!==billItemDi.orderQty){
						billItemDi.orderQty=generatedBillDi.orderQty;
						billItemDi.orderAmt=(billItemDi.orderQty?billItemDi.orderQty:0)*(billItemDi.orderPrice?billItemDi.orderPrice:0);
						billItemDi.isDirty=true;
					}
					
					generatedBillDis[generatedBillDiIdx]=null;
				}else{
					_order.registerDeletedItem("orderBillItem",billItemDi);
					billItemDis.splice(i,1);
				}
			}
		}
		
		for(var i=0,di;i<generatedBillDis.length;i++){
			di=generatedBillDis[i];
			if(di){
				billItemDis.splice(firstServiceInBillItemsIdx++,0,di);
			}
		}
		
		console.log("generateBillOfServiceEmb:"+((new Date()).getTime()-startTime));

		
	}
	
	_order.generateBillOfGarmentSupply=function(billOrderItem){
		if(!billOrderItem) return;
		if(billOrderItem.typeId!==1) return;	//not a billItem
		if(!_order.company ||!_order.company.info) return;
		
		var useWSP=_order.company.info.useWsp;
		var useUSD=_order.company.info.country!=="Canada";
		var listPriceField=useWSP?(useUSD?"wsp":"wspCad"):(useUSD?"rrp":"rrpCad");
		
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
											isNewDi:true,
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
			if(item.itemTypeId===2){			//auto generated item from lineItem
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
				//price might has been changed by user
				billItem=billItems[j];
				if(billItem.orderQty!==billableItem.orderQty){
					billItem.orderQty=billableItem.orderQty;
					billItem.orderAmt=billableItem.orderQty*billItem.orderPrice;	
					billItem.isDirty=true;
				}

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
			if(item.itemTypeId===2 && !item.checked){	//2:generated from lineitem
				if(item.id)
					_order.registerDeletedItem("orderBillItem",item);
				billItems.splice(i,1);
			}
		}
		
		for(var i=0;i<newAddBillItems.length;i++)
			billItems.unshift(newAddBillItems[i]);
		
	}
	
 	_order.getBillingHtmlOfGarmentSupply=function(garmentId){

		var model=_order.createStyleGridModel(garmentId,_order.dataSet.lineItems);

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
 	
 	_order.getBillingHtmlOfEmbService=function(billingKey){
 		var model=_order.getEmbServiceBillingDetailModel(billingKey);
 		var html="<table style='float:left;text-align:left;'>";
		html+="<tr><th class='tal'>Style</th><th>Colour</th><th>Location</th><th>Sizes</th><th>Qty</th>";
 		for(var i=0,di;i<model.length;i++){
 			di=model[i];
 			html+="<tr><td>"+di.style+"</td><td>"+di.colour+"</td><td>"+di.location+"</td><td>"+di.sizes+"</td><td>"+di.qty+"</td>";
 		} 			
		html+="</table></div>";
 		return html;
 	}
 	
	_order.getEmbServiceBillingDetailModel=function(billingKey){	//billingKey:designNo+garmentType,
		
		var lineItemDis=_order.dataSet.lineItems,lineItemDi;
		var lineItemDisIdx=util.createIndexOnId(lineItemDis);
		var dis=[];
		var serviceDis=_order.dataSet.serviceEmbs,serviceDi;
		for(var i=0,di;i<serviceDis.length;i++){
			serviceDi=serviceDis[i];
			lineItemDi=lineItemDisIdx[serviceDi.lineItemId];
			if(serviceDi.designNo+";Garment"===billingKey){
				di={
					style:(lineItemDi.styleNo?lineItemDi.styleNo:"")+" "+(lineItemDi.description?lineItemDi.description:""),
					colour:lineItemDi.colour,
					location:serviceDi.location,
					sizes:_order.getLineItemSizes(lineItemDi),
					qty:lineItemDi.quantity,
				}
				dis.push(di);
			}
		}
		return dis;
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
 	
 	
 	//print garment confirmation
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
 					currency:company.info.country==="USA"?"US$":"CA$",
				},
	 			items:[],
 			};
 		
 		model.info.contact=createContactPrintModel();
		model.info.billTo=util.createAddress(company.info,_order.dataSet.addressItems,_order.company.addresses,true);
		model.info.shipTo=util.createAddress(company.info,_order.dataSet.addressItems,_order.company.addresses,false);
		
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
					var styleModel=_order.createStyleGridModel(parseInt(bi.billingKey),_order.dataSet.lineItems,mainColorOnly);	//show main color only
					if(styleModel){
						/* mbi.imageId=styleModel.garment.imageId; */
						mbi.data=styleModel.data;
					}
	 	 			totalQty+=bi.orderQty?bi.orderQty:0;
				} 				
 				
 				model.items.push(mbi);

 				totalAmt+=bi.orderAmt?bi.orderAmt:0;
 				
 			}
 		}
 		
 		model.info.totalAmt=kendo.toString(totalAmt, "c");
 		model.info.totalQty=kendo.toString(totalQty,"##,#");
 		
 	 	_order.printModel=model; //for testing data
 		
 		return model;
 	}
 	
 	//for print deco order
 	_order.createDecoOrderPrintModel=function(){
 		var info=_order.dataSet.info;
 		var company=_order.company;
		
 		var model={
					customer:company.info.businessName,
					jobNo:info.orderNumber,
 					jobName:info.orderName,
 					date:info.orderDate,
 					poNo:info.customerPO,
 					buyer:info.buyer,
 					terms:info.term,
 					currency:company.info.country==="USA"?"US$":"CA$",
 					shipment:"",
 					phone:"",
 					email:"",
 					issued:_order.csrName,
 					require:info.requireDate,
 					note:info.note,
 					special:info.remark,
 		};
 		
 		model.ddLineItems=_order.createGarmentServicePrintModel();
 		model.services=_order.createPricingPrintModel();
 		model.decoEmbs=_order.createServiceEmbPrintModel();
 		_order.printModel=model; //for testing data
 		
 		return model;
 	}
 	
 	//for print Deco Order;
 	_order.createGarmentServicePrintModel=function(){
 		var printDis=[];
 		
 		
 		//create index of serviceEmbs on lineItemId
 		var idxServices={};	//index of serviceEmbs,serviceSps,serviceHts,...on lineItemId
 		
 		var  serviceDis=_order.dataSet.serviceEmbs,serviceDi;
 		for(var i=0,sId,idx;i<serviceDis.length;i++){
 			serviceDi=serviceDis[i];
 			sId=String(serviceDi.lineItemId);
 			idx=idxServices[sId];
 			if(!idx){
 				idx={serviceKey:"",services:[]};
 				idxServices[sId]=idx;
 			}
 			idx.serviceKey+="|1|"+serviceDi.designNo+"|"+serviceDi.location;
 			idx.services.push({deco:"Emb",position:serviceDi.location,designNo:serviceDi.designNo});
 		}
 		
 		var lineItemDis=_order.dataSet.lineItems,lineItemDi;
 		var group={},groupChanged;
 		var i=0,style;
 		while(i<lineItemDis.length){
 			
			groupChanged=false;
 			lineItemDi=lineItemDis[i];
			service=idxServices[String(lineItemDi.id)];

			if(service){
				
	 			if(lineItemDi.styleNo!==group.itemNo||service.serviceKey!==group.serviceKey){
	 				groupChanged=true;
	 			}else{
					group.qty+=lineItemDi.quantity;
					group.lineItems.push(lineItemDi);
					i++;
	 			}
	 			if(groupChanged|| i===lineItemDis.length){
	 				
					if(group.garmentId){
		 				style=_order.createStyleGridModel(group.garmentId,group.lineItems,true);	//true-main colour only
		 				group.data=style.data;
		 				delete group.serviceKey;
		 				delete group.lineItems;
		 				delete group.garmentId,
	 					printDis.push(group);
					}
	 				group={				//create a new group
							itemNo:lineItemDi.styleNo,
							garmentId:lineItemDi.garmentId,
							desc:lineItemDi.description,
							serviceKey:service.serviceKey,
							qty:0,
							lineItems:[],
							data:[],
							services:service.services
					};
	 			}
			}else{
				i++;
			}
 		}
 		return printDis;
 	}
 	
 	//for print deco order
 	_order.createPricingPrintModel=function(){
 		var billItemDis=_order.dataSet.billItems.filter(function(value){
 			return value.snpId!=14;
 		});
			
	 	var billItemDi;
		var model=[];
		var idxDictSnp=util.createIndexOnId(cliviaDDS.getDict("snp").items);
		for(var i=0,service;i<billItemDis.length;i++){
			  billItemDi=billItemDis[i];
			  service=idxDictSnp[String(billItemDi.snpId)];
			  model.push({
				 service: service.name,
				 description:billItemDi.description,
				 qty:billItemDi.orderQty,
				 unit:billItemDi.unit,
				 price:billItemDi.orderPrice,
				 amt:billItemDi.orderAmt,
				 remark:billItemDi.remark,
			  });
		 }
		  
		 return model;
 	}
 	
	_order.getLineItemSizes=function(lineItemDi){
		var dictGarment=_order.dds.garment;
		var dictSeason=_order.dds.season;
		var season,sizes="";
		if(lineItemDi.garmentId){
			var garment=dictGarment.getGarmentById(lineItemDi.garmentId);
				season=dictSeason.getLocalItem("id",garment.seasonId);
		}else{
			season=dictSeason.getLocalItem("id",3);	//general lineItem
		}	
		var sizeFields=season.sizeFields.split(",");
		var sizeTitles=season.sizeTitles.split(",");
		for(var i=0,q;i<sizeFields.length;i++){
			q="qty"+("00"+i).slice(-2);
			if(lineItemDi[q]){
				sizes+=sizeTitles[i]+":"+lineItemDi[q]+"   ";
			}
		}
		return sizes;
		//var sizeFields=
	}
 	
 	
 	//for print deco order
 	_order.createServiceEmbPrintModel=function(){
		var lineItemDis=_order.dataSet.lineItems,lineItemDi;
		var idxLineItemDis={};

		
		
		for(var i=0,di;i<lineItemDis.length;i++){
			lineItemDi=lineItemDis[i];
			idxLineItemDis[String(lineItemDi.id)]={
					lineNo:lineItemDi.lineNo,
					style:((lineItemDi.styleNo?lineItemDi.styleNo:"")+"  "+(lineItemDi.description?lineItemDi.description:"")).trim(),
					totalQty:lineItemDi.quantity,
					colour:lineItemDi.colour,
					sizes:_order.getLineItemSizes(lineItemDi),
				}
			
		}
		util.createIndexOnId(lineItemDis);
		
		var sortedServiceDis=[],serviceDi;
		
		//sort _order.dataSet.serviceEmbs on lineItems.LineNo and serviceEmbs.lineNo 
		var serviceDis=_order.dataSet.serviceEmbs;
		for(var i=0;i<serviceDis.length;i++){
			serviceDi=serviceDis[i];
			lineItemDi=idxLineItemDis[String(serviceDi.lineItemId)];
			sortedServiceDis.push({
				lineNo:("000"+lineItemDi.lineNo).slice(-3)+("000"+serviceDi.lineNo).slice(-3),
				serviceDi:serviceDi,
				lineItemDi:lineItemDi,
			});
		}		
		
		sortedServiceDis.sort(function(a,b){
			return a.lineNo>b.lineNo?1:(a.lineNo<b.lineNo?-1:0);
		});
		
		var designs=[],design,idxDesignNo={};
		var colourway,garment;
		
		for(var i=0,s;i<sortedServiceDis.length;i++){
			
			serviceDi=sortedServiceDis[i].serviceDi;
			lineItemDi=sortedServiceDis[i].lineItemDi;
			
			design=idxDesignNo[serviceDi.designNo];
			
			if(!design){
				design={
						designNo:serviceDi.designNo,
						description:serviceDi.designName,
						stitches:serviceDi.stitchCount,
						steps:"",				//serviceDi.stepCount,
						totalQty:0,
						colourways:[],
						idxColourway:{},
					};
				designs.push(design);
				idxDesignNo[serviceDi.designNo]=design;
			}
			
			s=serviceDi.threadCode+"|"+serviceDi.runningStep;
			colourway=design.idxColourway[s];
			if(!colourway){
				colourway={
						threads:dictThread.getThreads(serviceDi.threadCode),
						runningStep:serviceDi.runningStep,
						totalQty:0,
						garments:[],
				}
				design.colourways.push(colourway);
				design.idxColourway[s]=colourway;
			}
			
			garment={
				position:serviceDi.location,
				style:lineItemDi.style,
				colour:lineItemDi.colour,
				sizes:lineItemDi.sizes,
				totalQty:lineItemDi.totalQty,
			}
			
			colourway.garments.push(garment);
			
			colourway.totalQty+=garment.totalQty;
			design.totalQty+=garment.totalQty;
			
		}
		
		for(var i=0;i<designs.length;i++){
			design=designs[i];
			delete design.idxColourway;
		}
		
		return designs;
 	}
 	
 	_order.createStyleGridModel=function(garmentId,lineItems,mainColourOnly){
		
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
 	
 	_order.printDecoOrder=function(){
 		var data=_order.createDecoOrderPrintModel();
 		url="../om/print-order?file=printdecoorder";
 		util.printUrl(url,{data:JSON.stringify(data)},true);	//false=no preview
 		return;
 	}
 	
 	_order.printBill=function(billItems,lineItemOnly,mainColourOnly,printTypeId){
		var hideDiscount=printTypeId==="garmentConfirmationWithoutDsicount"; 
 		var data=_order.createGarmentPrintModel(billItems,lineItemOnly,mainColourOnly,hideDiscount);
 		data.info.listType=printTypeId==="garmentPackingSlip"?"packing":"order";
 // to get testing data of print model		
 	_order.printModel=data;
 		url="../om/print-order?file=printgarmentorder";
 
 		util.printUrl(url,{data:JSON.stringify(data)},true);	//false=no preview
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
													isDirty:true,
													isNewDi:true,
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
					_order.registerDeletedItem("orderUpc",orderUpc);
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