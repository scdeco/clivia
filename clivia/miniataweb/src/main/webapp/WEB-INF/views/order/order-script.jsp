<script>
// 	orderApp.config
	'user strict';

	var orderApp = angular.module("orderApp",
			[ "ui.router", "kendo.directives" ]);

	orderApp.config(function($stateProvider, $urlRouterProvider) {

		$urlRouterProvider.otherwise('/');

		var orderItemUrl = 'item:{orderItemId:[0-9]{1,3}}';

		$stateProvider.state('main', {
			url : '/',
			views : {
				'main' : {
					templateUrl : 'ordermain',
					controller : 'orderMainCtrl'
				},
				'orderinfo@main' : {
					templateUrl : 'orderinfo',
					controller : 'orderInfoCtrl'
				},
				'orderitem@main' : {
					templateUrl : 'orderitem',
					controller : 'orderItemCtrl'
				}
			},

		});

		$stateProvider.state('main.blankitem', {
			url : '',
			template : '<h3>add new items</h3>',
		})

		$stateProvider.state('main.pricingitem', {
			url : orderItemUrl,
			templateUrl : 'item/pricingitem',
			controller : 'pricingitemCtrl'
		})

		.state('main.lineitem', {
			url : orderItemUrl,
			templateUrl : 'item/lineitem',
			controller : 'lineitemCtrl'
		})

		.state('main.lineitem.detail', {
			url : '/detail:{lineItemId:[0-9]{1,3}}',
			templateUrl : 'item/lineitemdetail',
			controller : 'lineitemdetailCtrl'
		})
		

		.state('main.imageitem', {
			url : orderItemUrl,
			templateUrl : 'item/imageitem',
			controller : 'imageitemCtrl'
		})

		.state('main.designitem', {
			url : orderItemUrl,
			templateUrl : 'item/designitem',
			controller : 'designitemCtrl'
		})

		.state('main.fileItem', {
			url : orderItemUrl,
			templateUrl : 'item/fileitem',
			controller : 'fileitemCtrl'
		})
	});

//GridWrapper
orderApp.factory("GridWrapper",function(){
	//constructor, need a kendoGrid's name
	var GridWrapper=function(gridName){
		this.gridName=gridName;
		this.grid=null;
		this.gridColumns=null;
		this.currentRowUid="";
		this.reorderRowEnabled=false;
	}
	
	GridWrapper.prototype.setColumns=function(columns){
		this.gridColumns=columns;
	}
	
	//call this method in kendoWidgetCreated event
	GridWrapper.prototype.wrapGrid=function(){
		this.grid=$("#"+this.gridName).data("kendoGrid");
		this.enableReorderRow();
		this.showLineNumber();
	}

	GridWrapper.prototype.getDataItemByRow=function (row){
		if(!this.grid) return null;
		return (!!row)?this.grid.dataItem(row):null;
	}
		
	GridWrapper.prototype.getDataItemByIndex=function (index){
		if(!this.grid) return null;
		var data=this.grid.dataSource.data();
		return (index>=0 && index<data.length)?data[index]:null;
	}
	GridWrapper.prototype.getDataItemIndex=function (dataItem){
		if(!this.grid) return null;
		var index = (!!dataItem)?this.grid.dataSource.indexOf(dataItem):null;
		console.log("dataItem index:"+index);
		return index;
	}
		
	GridWrapper.prototype.getCurrentDataItem=function (){
		if(!this.grid) return null;
		var row=this.getCurrentRow();
		return this.getDataItemByRow(row);
	}
		
	GridWrapper.prototype.getCurrentDataItemIndex=function (){
		if(!this.grid) return null;
		var dataItem= this.getCurrentDataItem();
		var idx = this.getDataItemIndex(dataItem);
		return idx;
	}

	GridWrapper.prototype.getRow = function(index){
		if(!this.grid) return null;
		return this.grid.tbody.children().eq(index);
	}

	//index starts from 0
	GridWrapper.prototype.getRowIndex=function (row){
		if(!this.grid) return null;
		 var index=(!!row)?($("tr", this.grid.tbody).index(row)):null;
			console.log("getRowIndex:"+index);
		 return index;
	}
		
	GridWrapper.prototype.getEditingCell=function (){
		if(!this.grid) return null;
		var cell=$("td.k-edit-cell",this.grid.tbody.children()).first();
		return cell;
	}
		
	GridWrapper.prototype.getCurrentRow=function (){
		if(!this.grid) return null;
		var cell=this.getEditingCell();
		if(!!cell)
		  cell=this.grid.current();
		var row=(!!cell)?cell.closest("tr"):null;
		console.log("getCurrentRow:"+(!!row));
		return row;
	}
	    
	GridWrapper.prototype.getCurrentRowIndex=function (){
		if(!this.grid) return null;
		var index=this.getRowIndex(this.getCurrentRow());
		return index;
	}

	GridWrapper.prototype.setLineNumber=function (){
		var dataItems=this.grid.dataSource.view();
		for(var i=0;i<dataItems.length;i++){ 
			dataItems[i].lineNumber=i+1;
		}
	}
		
	GridWrapper.prototype.addRow=function (dataItem,isInsert){
        var dataSource =this.grid.dataSource;

        if(!isInsert){ //append to last row
		    dataSource.add(dataItem);
		    this.setLineNumber();
		    if(dataSource.totalPages()>1)		//without the line will casue problem when add row  
		    	dataSource.page(dataSource.totalPages());
	    	this.grid.editRow(this.grid.tbody.children().last());
	    }else{		//insert before current row
				var rowIdx =this.getCurrentRowIndex();
	    	var idx = this.getCurrentDataItemIndex();
		    dataSource.insert((!!idx)?idx:0,dataItem);
		    this.setLineNumber();
	    	this.grid.editRow(this.getRow(rowIdx));
	    }
        var cell=this.getEditingCell();
        if(cell) this.grid.current(cell);
	}		
	
	GridWrapper.prototype.deleteRow=function (dataItem){
	    if (dataItem) {
        	this.grid.dataSource.remove(dataItem);
        	this.currentRow=-1;
        	this.setLineNumber();
        	this.grid.table.focus();
	    }					
	}		

	GridWrapper.prototype.copyPreviousRow=function(){
		var dataItem=this.getCurrentDataItem();
 		var dataItemIndex=this.getCurrentDataItemIndex();
		var copiedDataItem=this.getDataItemByIndex(dataItemIndex-1);
 		if(!!copiedDataItem){
 			for(var i=1;i<this.gridColumns.length;i++){
 				if(typeof copiedDataItem[this.gridColumns[i].field] !=='undefined')
     		 			dataItem[this.gridColumns[i].field]=copiedDataItem[this.gridColumns[i].field];
 			}
 		}
	}
	
	GridWrapper.prototype.enableReorderRow=function (){
		var self=this;		
		this.grid.table.kendoSortable({
             filter: ">tbody >tr:not(.k-grid-edit-row)",
             hint: $.noop,
             cursor: "move",
             placeholder: function(element) {
                 return element.clone().addClass("k-state-hover").css("opacity", 0.65);
             },
             container: "#"+this.gridName+ " tbody",
             change: function(e) {
             	 var dataSource,skip,oldIndex,newIndex,dataItem;
             	
                 dataSource=self.grid.dataSource;
              	 skip = !!dataSource.skip()?dataSource.skip():0;
                 oldIndex = e.oldIndex + skip;
                 newIndex = e.newIndex + skip;
                 dataItem = dataSource.getByUid(e.item.data("uid"));

                 dataSource.remove(dataItem);
                 dataSource.insert(newIndex, dataItem);
                 self.setLineNumber();
                 dataSource.sync();
                }
            });
		this.allowReorderRow=true;
	}
	
	//called from parenet resize event
	GridWrapper.prototype.resizeGrid=function(){
	    var gridElement =$("#"+this.gridName), 
	        dataArea = gridElement.find(".k-grid-content"),
	        gridHeight = gridElement.innerHeight(),
	        otherElements = gridElement.children().not(".k-grid-content"),
	        otherElementsHeight = 0;
		    otherElements.each(function(){
		        otherElementsHeight += $(this).outerHeight();
			    });
	   		dataArea.height(400 - otherElementsHeight);
	};	
	
	//called in grid's dataBound event 
	GridWrapper.prototype.showLineNumber= function() {
   		 if(this.grid){
   	   		 var pageSkip = (this.grid.dataSource.page() - 1) * this.grid.dataSource.pageSize();
   	   		 if(!pageSkip) pageSkip=0;
   	   		 pageSkip++;
   	   		 
   	   		 //index starts from 0
   	   		$("#"+this.gridName+" td.gridLineNumber").text(function(index){
   	   		//	console.log("line number index:"+index);
   	   			return pageSkip+index;
   	   		});	       		
   		 }
    };
    
    GridWrapper.prototype.numberColumnEditor=function(container, options) {
        $('<input class="grid-editor" data-bind="value:' + options.field + '"/>')
            .appendTo(container)
            .kendoNumericTextBox({
                spinners : false
            });
    };

    GridWrapper.prototype.readOnlyColumnEditor=function(container, options) {
         $("<span>" + options.model.get(options.field)+ "</span>").appendTo(container);
     };
	
	return GridWrapper;
	
 }); /* end of GridWrapper */	

 //GarmentGridWrapper
 orderApp.factory("GarmentGridWrapper",function(GridWrapper,SO){

	 var GarmentGridWrapper=function(gridName){
		GridWrapper.call(this,gridName);
		
		this.currentGarment=null;
		this.dict={};
		this.dict.colourway=[];
		this.dict.sizeRange=[];
		
		
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
orderApp.factory("SO",["$http","$q","$state",function($http, $q,$state){
	var _order={};
	_order.dataSet={};
	_order.setting={};
	_order.dict={};
	_order.instance={};

	var dataSet=_order.dataSet, dict=_order.dict, setting=_order.setting, instance=_order.instance;
	//correspongding to a dataTable in dataSet 
	setting.registeredItemTypes=["lineItem","imageItem","designItem","pricingItem","fileItem"];
	setting.registeredOrderItems=[{ 
		   	 text: "Line Item", 
			 icon: "insert-n",
			 id:"lineitem",
			 spec:"generic",
			 itemType:"lineitem"
		},{
			 text: "DD Line Item", 
			 icon: "insert-n",
			 id:"lineitemdd",
			 spec:"DD",
			 itemType:"lineitem"
		},{
			type: "separator" 
		},{
			 text: "Pricing Item", 
			 icon: "insert-n",
			 id:"pricingitem",
			 spec:"",
			 itemType: "pricingitem"
		},{
			text: "Design", 
			icon: "insert-m",
		   	id:"designitem",
			spec:"",
			itemType: "designitem"
		},{ 
			text: "Image", 
			icon: "insert-m",
		   	id:"imageitem",
			 spec:"",
			 itemType: "imageitem"
		},{ 
			text: "File", 
			icon: "insert-s",
		   	id:"fileitem",
			spec:"",
			itemType: "fileitem"
		},{ 
			text: "Send Receive",
		   	id:"shipping",
			spec:"",
			itemType: "shippingitem"
		}];
	
	_order.getRegisteredOrderItem=function(id){
		 var item=null;
		 for(var i=0;i<setting.registeredOrderItems.length;i++)
			 if(setting.registeredOrderItems[i].id===id){
				 item=setting.registeredOrderItems[i];
				 break;
			 }
		return item;
	}

	setting.baseUrl="/miniataweb/";
	setting.orderUrl=setting.baseUrl+"order/"
	setting.libraryUrl=setting.baseUrl+"library/";
	setting.garmentUrl=setting.baseUrl+"garment/";
	
	setting.layout={};
	setting.layout.lineItemGrid={};
	
	setting.layout.mainSplitterOrientation="horizontal";
	
	dict.garments=[];
	dict.images=[];
	
	dataSet.info={};
	dataSet.items=[];

	for(var i=0;i<setting.registeredItemTypes.length;i++){
		dataSet[setting.registeredItemTypes[i]+"s"]=new kendo.data.ObservableArray([]);	
	}

	dataSet.deletedItems=[];

	instance.itemButtons=new kendo.data.ObservableArray([]);
	instance.currentOrderItemId=null;
	
	//setting
	
    _order.clearDicts=function(){
		dict.garments.splice(0,dict.garments.length);
		dict.images.splice(0,dict.images.length);
    }
    
    _order.clearInstance=function(){
    	instance.currentItemId=null;
    	instance.itemButtons.splice(0,instance.itemButtons.length);
    }
    
	_order.clearDataSet=function(){

		dataSet.info={orderId:0,orderNumber:'',customerId:''};
		dataSet.items.splice(0,dataSet.items.length);
		for(var i=0;i<_order.setting.registeredItemTypes.length;i++){
			var dt=dataSet[_order.setting.registeredItemTypes[i]+"s"];
			dt.splice(0,dt.length);
		}
		dataSet.deletedItems.splice(0,dataSet.deletedItems.length);		
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
    	var url=setting.garmentUrl+"get-product?style="+styleNumber;
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
		if(!_order.isNew()){
			var imageString="";
			for(var i=0;i<dataSet.imageItems.length;i++){
				if(dataSet.imageItems[i].imageId){
					imageString+=","+dataSet.imageItems[i].imageId;
				}
			}
			if(imageString!==""){

				var url=setting.libraryUrl+"get-images?ids="+imageString.substr(1);
				
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

		_order.deletedItems=[];		

		for(var i=0;i<_order.registeredItemTypes.length;i++){
			var itemType=_order.registeredItemTypes[i]+"s";
			clearRowIdAndOrderId(itemType);
		}
	}
		
	_order.retrieve=function(orderNumber){

		var url=setting.orderUrl+"get-order?number="+orderNumber;
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

		var url=setting.orderUrl+"save-order";
		
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

		var url=setting.orderUrl+"delete-order";
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
	
 	_order.addOrderItemButton=function(orderItem){
        button={text:orderItem.title, id: "btn"+orderItem.orderItemId, togglable: true, group: "OrderItem"};
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
 				type:type.toLowerCase(),
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
 

orderApp.controller("orderCtrl",["$scope","$http",function($scope,$http) {
	
}]);

	


</script>