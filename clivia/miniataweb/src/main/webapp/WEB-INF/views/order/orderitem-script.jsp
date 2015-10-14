<script>
orderApp.controller("orderItemCtrl", ["$scope","SO",function($scope,SO) {
	 $scope.SO=SO;
     $scope.itemToolbarOptions = {
             items: [{
                         type: "buttonGroup",
                         buttons:SO.instance.itemButtons,
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
                              	var item=SO.addOrderItem(e.id, e.target.text());
                              	SO.setCurrentOrderItem(item.orderItemId);
                   			}
                   		}
	            	  
	              }],
             toggle:function(e){
            	 var itemId=parseInt(e.id.substr(3));
               	 SO.setCurrentOrderItem(itemId);
             }
 	 };

}]);
</script>