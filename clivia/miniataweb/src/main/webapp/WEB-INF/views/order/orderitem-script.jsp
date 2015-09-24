<script>
orderApp.controller("orderItemCtrl", ["$scope","$state",function($scope,$state) {
	
    $scope.addOrderItem = function(type) {
    	var orderItemId= $scope.order.orderItems.length+1;
    	var orderItem={
   			orderId:$scope.order.orderInfo.orderId ,
   			orderItemId:orderItemId,
   			lineNumber: orderItemId
    	};
    	
    	switch (type){
	    	case "LineItem":
	    		orderItem.title="Line Items";
	    		orderItem.type="lineitem";
	    		break;
	    	case "OrderImage":
	    		orderItem.title="Images";
	    		orderItem.type="orderimage";
	    		break;
    	}
        for(var i=0;i<$scope.setting.orderItemButtons.length;i++){
        	$scope.setting.orderItemButtons[i].selected=false;
       	}
    	button={text:orderItem.title, id: "btn"+orderItemId, togglable: true, group: "OrderItem" ,selected:true};
    	$scope.setting.orderItemButtons.push(button);
    	$scope.order.orderItems.push(orderItem);
    	$scope.setSelectedOrderItem(orderItem);

      };
	
     $scope.removeOrderItem=function(){
    	 $scope.order.orderItems.pop();
     };
     
   
     $scope.itemToolbarOptions = {
             items: [{
                         type: "buttonGroup",
                         buttons:$scope.setting.orderItemButtons,
                     },{ 
                    	 type: "separator" 
                     },{
	                     type: "splitButton",
	                     text: "Add Item",
	                     menuButtons: [{ 
	                        	 text: "Line Items", 
	                        	 icon: "insert-n",
	                        	 id:"LineItem",
	                        },{
	                        	text: "Designs", 
	                        	icon: "insert-m",
		                       	id:"Design"
	                        },{ 
	                        	text: "Images", 
	                        	icon: "insert-m",
		                       	id:"OrderImage"
	                        },{ 
	                        	text: "Files", 
	                        	icon: "insert-s",
		                       	id:"File",
	                        },{ 
	                        	text: "Send Receive",
		                       	id:"Shipping"
	                        }],
                     		click:function(e) {
                            	$scope.addOrderItem(e.id);
                     		}
	            	  
	              }],
             toggle:function(e){
            	 var itemId=parseInt(e.id.substr(3));
            	 var item=null;
            	 for(var i=0;i<$scope.order.orderItems.length;i++){
            		 if($scope.order.orderItems[i].orderItemId===itemId){
            			 item=$scope.order.orderItems[i];
            			 break;
        			}    		 	
            	 }
         
                 if(item!=null){
                	 $scope.setSelectedOrderItem(item);
                 } 
             }
 	 };
    	
  	 $scope.setSelectedOrderItem=function(item){
 	   	 $scope.selectedOrderItemId=item.orderItemId;
 	   	 $state.go('main.'+item.type,{orderItemId:item.orderItemId});
  	    };     
     
     


}]);
</script>