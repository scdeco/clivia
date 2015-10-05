<script>
orderApp.controller("orderItemCtrl", ["$scope","$state",function($scope,$state) {
	
    $scope.addOrderItem = function(type,title) {
    	var orderItemId= $scope.order.orderItems.length+1;
    	var orderItem={
   			orderId:$scope.order.orderInfo.orderId ,
   			orderItemId:orderItemId,
   			lineNumber: orderItemId,
    		title:title,
			type:type
    	};
    	
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
	                     text: "+",
	                     id:"additem",
	                     menuButtons: [{ 
	                        	 text: "Pricing Item", 
	                        	 icon: "insert-n",
	                        	 id:"pricingitem",
	                        },{
	                        	 text: "Line Item", 
	                        	 icon: "insert-n",
	                        	 id:"lineitem",
	                        },{
	                        	type: "separator" 
	                        },{
	                        	text: "Design", 
	                        	icon: "insert-m",
		                       	id:"designitem"
	                        },{ 
	                        	text: "Image", 
	                        	icon: "insert-m",
		                       	id:"imageitem"
	                        },{ 
	                        	text: "File", 
	                        	icon: "insert-s",
		                       	id:"fileitem",
	                        },{ 
	                        	text: "Send Receive",
		                       	id:"shipping"
	                        }],
                   		click:function(e) {
                   			if(e.id!="additem"){
                              	$scope.addOrderItem(e.id, e.target.text());
                   			}
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