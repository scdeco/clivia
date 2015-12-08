<script>
orderApp.controller("imageItemCtrl",["$scope","$http","$stateParams","SO" ,function($scope,$http,$stateParams,SO){
	$scope.SO=SO;
	var orderItemId =parseInt($stateParams.orderItemId);
	
	$scope.setting={};
	
	var getImages=function(dataItems){
		var imageString="";
		for(var i=0;i<dataItems.length;i++){
			if(dataItems[i].imageId){
				imageString+=","+dataItems[i].imageId;
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
	
    var imageItemDataSource=new kendo.data.DataSource({
    	
	        	data:SO.dataSet.imageItems,
	        	
			    schema: {
			        model: {
			            id: "id",
		                fields: {
		                    id: {type: "number"},
		                    orderId: {type: "number"},
		                    orderItemId: {type: "number"},
		                    imageId:{type: "number"}
		                }
			        }
			    },
			    
			    filter: {
			        field: "orderItemId",
			        operator: "eq",
			        value: orderItemId
			    },    
			    
			    serverFiltering:false,
			    pageSize: 10,

			    change: function(e) {
			        //check the "response" argument to skip the local operations
		            getImages(e.items);
			    }
	        });
    
	$scope.imageItemGridOptions = {
			height: 300,
			autoSync: true,
	        dataSource:imageItemDataSource,
	        columns: [{
		            title: "#",
    	            width: 20,
    	            attributes:{style:"text-align:right;", class:"gridLineNumber"},
    	            headerAttributes:{style:"text-align:center;", class:"gridLineNumberHeader"}
				}, {					    
 					field: "id",
				    title: "Id",
				    hidden: false,
				    width: 80
				}, {
				    field: "orderId",
				    title: "Order Id",
				    hidden: false,
				    width: 80
				}, {
				    field: "orderItemId",
				    title: "Order Item Id",
				    hidden: false,
				    width: 80
				}, {
				    field: "lineNumber",
				    title: "Line Number",
				    hidden: false,
				    width: 100
				}, {
				    field: "imageId",
				    title: "Image Id",
				    hidden: false,
				    width: 100
				}, { 
				    field: "remark",
				    title: "Remark",
				    locked: false,
				    width: 120
			}],
			
	        selectable: "cell",
	        navigatable: true,
	        resizable: true,
		        pageable: {
		            pageSizes: true,					//["all",2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18],
		            numeric: true,
		            previousNext:true,
	 	            messages: {
		            	display: "Total line:{2}"
	 	            }
		        },
	        editable: {confirmation:false},

//events:		 
	       	dataBound: function(e) {
	    		 var pageSkip = (this.dataSource.page() - 1) * this.dataSource.pageSize();
	    		 if(!pageSkip) pageSkip=0;
	    		 pageSkip++;
	    		 
	    		 //index starts from 0
	       		$("#imageItemGrid td.gridLineNumber").text(function(index){
	       		//	console.log("line number index:"+index);
	       			return pageSkip+index;
	       		});	       		
	       	},	       	
	};
	
	$scope.imageItemListViewOptions={
			autoSync:true,
	        dataSource: imageItemDataSource,
	};
	
	$scope.toolbarOptions={
	        items: [{
                type: "button",
                text: "Add",
                id:"btnAdd",
                click: function(e){
                	$scope.newUploadWindow.open();
                }
            }, {
            	type: "separator"
            }]		
	};
	
	$scope.newUploadWindowOptions={
			open:function(e){
				$scope.imageItemToolbar.enable("#btnAdd",false);				
			},
			close:function(e){
				$scope.imageItemToolbar.enable("#btnAdd");				
			}
	}
	 
	$scope.newUploadOptions={
			async:{
				 saveUrl: SO.setting.url.library+'image/upload',
				 removeUrl:SO.setting.url.library+'image/removeupload',
				 autoUpload: false,
				 batch: false   
				 /* The selected files will be uploaded in separate requests */
			},
			
			localization:{
				uploadSelectedFiles: 'Upload'
			},
			upload:function (e) {
			    e.data = {user: SO.setting.user.userName};
			},
			success: function (e) {
			    if(e.response.status==="success"){
					var data = e.response.data;
					SO.dds.image.addItem(data);
					var newItem={
					    	orderId:SO.dataSet.info.orderId,
					    	orderItemId:orderItemId, 
					    	imageId:data.id,
					    	remark:e.response.message
					    };

					imageItemDataSource.add(newItem);
			    }
			
			},
			error:function(e){
	//	 		alert("failed:"+JSON.stringify(e.response.data));
			},
			complete:function(e){
			}
	};
	
	$scope.imagePagerOptions={
			dataSource:imageItemDataSource,
			pageSizes:[5,10,15,20,"all"]
			
	};
	$scope.showOriginalImage=function(fileId){
		if(fileId){
			var url=SO.setting.url.library+"image/getimage?id="+fileId;
			$http.get(url).
				success(function(data, status, headers, config) {
				    	$scope.previewOriginalImage=data;
				}).
				error(function(data, status, headers, config) {
					$scope.previewOriginalImage=null;
				   });					
		}
	};
	
}]);
</script>