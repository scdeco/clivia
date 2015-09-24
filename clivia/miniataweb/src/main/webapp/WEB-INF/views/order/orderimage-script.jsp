<script>
orderApp.controller("orderImageCtrl",["$scope","$http","$stateParams" ,function($scope,$http,$stateParams){
	
	var orderItemId =parseInt($stateParams.orderItemId);
	
	
    imageItemGridLineNumber=0;
    var imageItemDataSource=new kendo.data.DataSource({	
	        	data:$scope.order.imageItems,
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
			    pageSize: 16
	        });
    
	$scope.imageItemGridOptions = {
			height: 300,
			autoSync: true,
	        dataSource:imageItemDataSource/*  {	
	        	data:$scope.order.imageItems,
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
			    
			    serverFiltering:false
	        } */, //end of dataSource
	        columns: [{
	            title: " ",
	            template: "#= ++ imageItemGridLineNumber #",
	            locked: true,
	            width: 30,
	            attributes:{style:"text-align:right;"}
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
	       	dataBinding: function() {
	       		imageItemGridLineNumber = (this.dataSource.page() - 1) * this.dataSource.pageSize();
	    		 if(!imageItemGridLineNumber){
	    			 imageItemGridLineNumber=0;
	    		 }
	       	}
	};
	
	$scope.imageItemListViewOptions={
			autoSync:true,
	        dataSource: imageItemDataSource
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
				 saveUrl: '/miniataweb/upload/newimage',
				 removeUrl:'/miniataweb/upload/removeimage',
				 autoUpload: false,
				 batch: false   
				 /* The selected files will be uploaded in separate requests */
			},
			
			localization:{
				uploadSelectedFiles: 'Upload'
			},
			upload:function (e) {
			    e.data = {user: "jacob zhang"};
			},
			success: function (e) {
			    if(e.response.status==="success"){
					var data = e.response.data;
					$scope.dict.insertImage(data);
					var newItem={
					    	orderId:$scope.order.orderInfo.orderId,
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
			dataSource:imageItemDataSource
			
	}
	
}]);
</script>