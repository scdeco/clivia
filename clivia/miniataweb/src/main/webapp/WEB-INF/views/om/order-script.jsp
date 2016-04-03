<script>
	'user strict';
	var orderApp = angular.module("orderApp",
			[ "ui.router", "kendo.directives","clivia" ]);
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
			
			url="../data/companyContactDao/call/findListBySuperId?param=s:companyId;i:"+companyId;

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
			
			if(data.upcItems)
				dataSet.upcItems=data.upcItems;
			
		}
	}
	
	
	_order.isNew=function(){
		return !dataSet.info.id;
	}

	
	_order.repeat=function(){
		
		var customerId=dataSet.info.customerId,
			buyer=dataSet.info.buyer,
			orderName=dataSet.info.orderName;
			repId=dataSet.info.repId;
		
		util.clearProperties(dataSet.info);	
		
		dataSet.info.customerId=customerId,
		dataSet.info.buyer=buyer;
		dataSet.info.orderName=orderName;
		dataSet.info.repId=repId;
		
		var mapOrderItemId={};
		
		for(var i=0,orderItem,orderItemId;i<dataSet.items.length;i++){
			orderItem=dataSet.items[i];
			orderItemId=String(orderItem.id);
			orderItem.id= _order.getTmpId();
			orderItem.orderId=null;
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
			var dataItems=dataSet[dt];
			if(dataItems){
		    	for(var i=0,di;i<dataItems.length;i++){
		    		di=dataItems[i];
		    		di.id=null;
		    		di.orderId=null;
		    		di.orderItemId=mapOrderItemId[String(di.orderItemId)];
		    	}
			}
		}

		_order.deleteds=[];		

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
	    _order.generateUpcItems();

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
	   	_order.registerDeletedItem("item",orderItem.id,true);
	   	
    	//get dataTable from the dataSet, orderItem.typeId registeredItemType.name is the dataTable name
		 var type=_order.getRegisteredItemType(dataItem.typeId);
	   	 var dis=_order.dataSet[type.name+"s"];  
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
       
	_order.registerDeletedItem=function(entity,id,hasDependent){
		var flag=(!!hasDependent)?id>=consts.maxTmpId:!!id
		if(flag){
			var deletedItem={entity:entity,id:id};
			dataSet.deleteds.push(deletedItem);
		}
	}
	
	_order.generateBillableItems=function(billOrderItem){
		if(!billOrderItem) return;
		if(billOrderItem.typeId!==1) return;	//not a billItem	
		
		var	billableItems=[];
		var billableIdx={};
		var orderItems=dataSet.items;
		var orderId=_order.dataSet.info.id;
		var dictGarment=_order.dds.garment;
		
		var useWsp=true;
		var discount=0.20;
		
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
									var listPrice=useWsp?garment.wsp:garment.rrp;
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
											orderPrice:(discount>0 && discount<1)?listPrice*(1-discount):listPrice,
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
				newAddBillItems.push(billItem);
			}
		}
		
		for(var i=billItems.length-1,item;i>=0;i--){
			item=billItems[i];
			if(item.type && !item.checked){
				if(item.id)
					_order.registerDeletedItem("billItem",item.id);
				billItems.splice(i,1);
			}
		}
		
		for(var i=0;i<newAddBillItems.length;i++)
			billItems.unshift(newAddBillItems[i]);
		
	}

 	_order.getStyleGridHtml=function(garmentId,print){
		if(!garmentId) return;
		var garId=parseInt(garmentId);
		var garment=_order.dds.garment.getGarmentById(garId);
		if(!garment) return;
		var season=_order.dds.season.getLocalItem("id",garment.seasonId)
		
		
		//use util.split to split the string with delimiter "," and trim the result
		var sizes=util.split(garment.sizeRange);
		var colours=util.split(garment.colourway);
		
		//sizefields in lineItem
		var sizeFields=util.split(season.sizeFields);	
		
		var data=[];
		var colourIndex={};

		for(var i=0,row;i<colours.length;i++){
			//0 is colour,and sizes.length+1 is total qty of the colour, 1 to sizes.length is qty of size
			row=new Array(sizes.length+2);		
			row[0]=colours[i];
			colourIndex[colours[i]]=i;
			data.push(row);
		}
		var idxColourQty=sizes.length+1;
		
		var lineItems=_order.dataSet.lineItems;
		for(var i=0,r,lineItem,row;i<lineItems.length;i++){
			lineItem=lineItems[i];
			if(lineItem.garmentId===garId){
				r=colourIndex[lineItem.colour];
				if(r>=0){
					row=data[r];
					for(var j=0,k,field,qty;j<sizeFields.length;j++){
						field="qty"+("00"+j).slice(-2); 	//right(2)
						var qty=parseInt(lineItem[field]);
						if(qty){
							k=sizes.indexOf(sizeFields[j])+1;	//first is colour column
							row[k]=row[k]?row[k]+qty:qty;
							row[idxColourQty]=row[idxColourQty]?row[idxColourQty]+qty:qty;
						}
					}
				}
			}
		}
		
		var html="<table class='billDetailLineItem'>";
		html+="<tr><th class='tal'>Colour</th>";
		for(var i=0;i<sizes.length;i++){
			html+="<th class='billDetailQty tar'>"+sizes[i]+"</th>";
		}
		html+="<th class='tar lineqty'>Line Qty</th></tr>";
		
		for(var i=0,row;i<colours.length;i++){
			row=data[i];
			if(!print || row[row.length-1]){
				html+="<tr><td class='tal'>"+colours[i]+"</td>";
				for(var j=1;j<row.length;j++){
					html+="<td class='tar'>"+(row[j]?row[j]:"")+"</td>";
				}
				html+="</tr>";
			}
		}
		
		html+="</table>";
		
		return html;
		
	}	
 	
 	_order.getBillHeaderHtml=function(){
 		
 		
 	}

 	
 	_order.printBill=function(billItems,lineItemOnly){
		var html="<table class='printBillItem'>";
		
		html+="<tr><th class='tal style'>Style</th><th class='tal desc'>Description</th><th class='tar qty'>Quantity</th><th class='tar price'>Unit Price</th><th class='tar amt'>Amount</th></tr>";
 		
		var totalQty=0,totalAmt=0;
 		for(var i=0,bi,h,p;i<billItems.length;i++){
 			bi=billItems[i];
 			
 			totalAmt+=bi.orderAmt?bi.orderAmt:0;
 			totalQty+=bi.orderQty?bi.orderQty:0;
 			
 			if(lineItemOnly?bi.itemTypeId===2:true){
	 			html+="<tr class='lineitemrow'><td class='tal'>"+(bi.itemNumber?bi.itemNumber:"")+"</td>"+
			 			"<td class='tal'>"+(bi.description?bi.description:"")+"</td>"+
	 		 			"<td class='tar'>"+(bi.orderQty?kendo.toString(bi.orderQty,"##,#"):"")+"</td>"+
			 			"<td class='tar'>"+(bi.orderPrice?kendo.toString(bi.orderPrice, "0.00"):"")+"</td>"+
			 			"<td class='tar'>"+(bi.orderAmt?kendo.toString(bi.orderAmt, "c"):"")+"</td>"; 
				if(bi.itemTypeId===2){		//lineItem
					h=_order.getStyleGridHtml(parseInt(bi.billingKey),true);
					if(h)
			 			html+="<tr class='styletablerow'><td></td>"+
			 			"<td colspan='2'><div class='styletable'>"+h+"</div></td>"+
			 			"<td></td>"+
			 			"<td></td></tr>";
				}
 			}
 		}
 		
 		html+="<tr class='totalrow'><td colspan='2'>Total:</td><td>"+kendo.toString(totalQty,"##,#")+
 			"</td><td colspan='2'>"+kendo.toString(totalAmt,"c")+ "</td></tr></table>";
 		
 		html+="<style> table{border-collapse: collapse;border-width:0; } "+
 			" table.printBillItem{width:100%;}"+
 			" th {border-bottom: 1px solid black;}"+
 	//		" tr.lineitemrow {background-color:#c0c0c0 !important;}" +
 			" tr.lineitemrow > td {padding-top:10px;} "+
 			" tr.styletablerow > td {padding-bottom:15px;} "+
 	//		" table.printBillItem>tbody>tr:last-child>td {border-bottom: 1px solid black;}"+
 			"tr.totalrow td{font-size:10pt; font-weight: bold;text-align:right;border-bottom: 1px solid black;border-top: 1px solid black; padding:10px 2px;}"+
 			" div.styletable{padding-left:50px; float:left;} "+ 
 			" div.styletable td {padding:2px 6px; font-size:8pt;} "+
 			" .tal{text-align:left;} .tac{text-align: center;} .tar{text-align: right;} </style>";		//th.desc{width:300pt;} td.billDetailQty{width:25px;}
 		
 		util.print(html);
 	}
	
	_order.generateUpcItems=function(){
		var dictUpc=_order.dds.upc;

		var orderUpcs=dataSet.upcItems;
		
		var upcs=[];
		
		var orderItems=dataSet.items;
		var orderId=_order.dataSet.info.id;
		var idxUpc={};
		
		for(var i=0,orderItem;i<orderItems.length;i++){
			orderItem=orderItems[i];
			if(orderItem.typeId===2){ //"lineItem"
				var brand=_order.getBrandFromSpec(orderItem.spec);
				if(brand.hasInventory){  
					var season=_order.getSeasonFromSpec(orderItem.spec);
					var sizes=util.split(season.sizeFields);
					var lineItems=dataSet.lineItems;
					for(var j=0,lineItem,idx;j<lineItems.length;j++){
						lineItem=lineItems[j];
						if(lineItem.orderItemId===orderItem.id && lineItem.garmentId && lineItem.colour){
							
							for(var f=0,field,qty,upc,upcId;f<14;f++){
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
											upc={upcId:upcId,orderQty:qty,isDirty:true};
											idxUpc[String(upcId)]=upcs.push(upc)-1;
										}
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
				if(orderUpc.orderQty!==generatedUpc.orderQty){
					orderUpc.orderQty=generatedUpc.orderQty;
					orderUpc.isDirty=true;
				}else{
					generatedUpc.isDirty=false;
				}
			}else{
				if(orderUpc.id){
					_order.registerDeletedItem("upc",orderUpc.id);
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