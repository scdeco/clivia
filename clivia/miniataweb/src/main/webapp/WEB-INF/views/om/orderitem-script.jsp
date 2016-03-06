<script>
orderApp.controller("orderItemCtrl", ["$scope","SO",function($scope,SO) {
	
	 $scope.itemButtons=SO.instance.itemButtons;
     $scope.itemToolbarOptions = {
             items: [{
                         type: "buttonGroup",
                         buttons:$scope.itemButtons,
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
                              	var item=SO.addOrderItem(menuItem);		//enuItem.itemType,menuItem.text,menuItem.spec
                              	SO.setCurrentOrderItem(item.id);
                   			}
                   		}
	            	  
	              }],
             toggle:function(e){
            	 for(var i=0,button;i<$scope.itemButtons.length;i++){
            		 button=$scope.itemButtons[i];
            		 if(button.id===e.id){
                       	 SO.setCurrentOrderItem(button.orderItemId);
            			 break;
            		 }
            	 }
             }
 	 };
     
     $scope.itemToolbarSortableOptions={
			 filter: "a.k-toggle-button",	
			 disabled: "a:not(.k-state-active)",
             hint: $.noop,
             cursor: "move",
             placeholder: function(element) {
                 return element.clone().addClass("k-state-hover").css("opacity", 0.65);
             },
             container: "div.k-button-group",
             change: function(e) {
            	 var items=SO.dataSet.items,
            	  	 item=items.splice(e.oldIndex,1)[0];
            	 
           		 items.splice(e.newIndex,0,item);
           		 for(var i=0;i<items.length;i++)
           			 items[i].lineNo=i+1;
           		 
           		 var buttons=SO.instance.itemButtons,
            		 button=buttons.splice(e.oldIndex,1)[0];
           		 
            	 buttons.splice(e.newIndex,0,button);
             }
              		 
     };
     
     
 	$scope.itemToolbarContextMenuOptions={
 			closeOnClick: false,
 			filter:"a.k-state-active",
 			open: function(e){
 				if ($(e.item).is("li"))  return;
 				$scope.currentItemButton=SO.getCurrentOrderItemButton();
 				var menuText="<input type='text' class='k-textbox' ng-model='currentItemButton.text'>"
 				var items = this.setOptions({
 	                dataSource: [{
	 	 	                text: "Change Title", 
	 	 	                items: [{text:menuText,encoded: false, value: "menuRename"}]
	 	 	            }, {
	 	 	                text: "Remove",
	 	 	                value: "menuRemove"
	 	 	            }]
 	            })
 			},
 			close:function(e){
 				if($(e.item).is("li") && $scope.currentItemButton){
 					var item=SO.getCurrentOrderItem();
 					if($scope.currentItemButton.text!==item.title){
 						item.title=$scope.currentItemButton.text;
 					}
 				}
 			},
 			select: function(e){
 				if($(e.item).is("li") && e.item.textContent==="Remove"){
	 				this.close();
	 				var item=SO.getCurrentOrderItem()
	 				if (confirm('Please confirm to remove the selected item: '+item.title+'.')) {
	 					SO.removeOrderItem(item);
	 				}
 				}
 				
 			}
 		}

     
     
}]);




</script>