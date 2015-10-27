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
            			 items[i].lineNumber=i+1;
            		 buttons=SO.instance.itemButtons;
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
 				menuText="<input type='text' class='k-textbox' ng-model='currentItemButton.text'>"
 				var items = [{
 	                text: "Change Title", 
 	                id: "menuRename", 
 	                items: [{text:menuText,encoded: false}]
 	            }, {
 	                text: "Remove",
 	                id: "menuRemove"
 	            }];
 	            this.setOptions({
 	                dataSource: items
 	            })
 			},
 			close:function(e){
 				if(e.item.id==="menuRename" && $scope.currentItemButton){
 					item=SO.getCurrentOrderItem();
 					if($scope.currentItemButton.text!==item.title){
 						item.title=$scope.currentItemButton.text;
 					}
 				}
 			},
 			select: function(e){
 			
 				switch(e.item.id){
 					case "menuRename":
 						console.log(e.item.title);
 						break;
 					case "menuRemove":
 						alert("remove");
 						break;
 				}
 				
 			}
 		}

     
     
}]);




</script>