<script>
orderApp.controller("orderItemCtrl", ["$scope","SO",function($scope,SO) {
	 
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
	                     menuButtons: SO.setting.registeredOrderItems,
                   		click:function(e) {
                   			if(e.id!="additem"){
                   				var menuItem=SO.getRegisteredOrderItem(e.id);
                              	var item=SO.addOrderItem(menuItem.itemType,menuItem.text,menuItem.spec);
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