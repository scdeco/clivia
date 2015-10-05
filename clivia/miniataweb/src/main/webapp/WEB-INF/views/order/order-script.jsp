<script>

var orderApp=angular.module("orderApp", ["ui.router","kendo.directives"]);

orderApp.config(function($stateProvider, $urlRouterProvider) {
	
     $urlRouterProvider.otherwise('/');
   
     var orderItemUrl='item/{orderItemId:[0-9]{1,3}}';
     
	 $stateProvider
	 	.state('main',{
	 		  url:'/',
 	          views:{
	 			'main':{
	 				templateUrl:'ordermain',
	 				controller:'orderMainCtrl'
	 			},
        		'orderinfo@main':{
        			templateUrl:'orderinfo',
        			controller:'orderInfoCtrl'
        		},
        		'orderitem@main':{
        			templateUrl:'orderitem',
        			controller:'orderItemCtrl'
        		} 
        	},
        	
        })
        
        .state('main.blankitem',{
        	url:'',
        	template:'<h3>add new items</h3>',
        })
        
        .state('main.pricingitem', {
 	       	url: orderItemUrl,
           	templateUrl: 'item/pricingitem',
           	controller: 'pricingitemCtrl'	
 	     }) 

        .state('main.lineitem', {
 	       	url: orderItemUrl,
           	templateUrl: 'item/lineitem',
           	controller: 'lineitemCtrl'	
 	     }) 
 	     
 	     .state('main.imageitem', {
  	       	url: orderItemUrl,
           	templateUrl: 'item/imageitem',
           	controller: 'imageitemCtrl'	
 	     })
        
 	     .state('main.designitem', {
   	       	url:orderItemUrl ,
            templateUrl: 'item/designitem',
            controller: 'designitemCtrl'	
  	     })

 	     .state('main.fileitem', {
  	       	url: orderItemUrl,
           	templateUrl: 'item/fileitem',
           	controller: 'fileitemCtrl'	
   	     })
  	     
});

orderApp.controller("orderCtrl",["$scope","$http",function($scope,$http) {
	
	$scope.setting={};	
	$scope.setting.lineItemCarryOn=false;
	
	$scope.setting.baseUrl="/miniataweb/";
	$scope.setting.orderUrl=$scope.setting.baseUrl+"order/"
	$scope.setting.libraryUrl=$scope.setting.baseUrl+"library/";
	$scope.setting.garmentUrl=$scope.setting.baseUrl+"garment/";
	
	$scope.layout={};
	$scope.layout.lineItemGrid={};
	
	
	$scope.common={}
	$scope.common.itemGrid=null;
		
	$scope.searchOrderNumber="";

	$scope.order={};
	$scope.order.orderInfo={};
	$scope.order.orderItems=[];
	$scope.order.lineItems=new kendo.data.ObservableArray([]);
	$scope.order.imageItems=new kendo.data.ObservableArray([]);
	
	$scope.order.deletedItems=[];
	
	$scope.dict={};
	$scope.dict.garments=[];
    $scope.dict.colourway=[];
    $scope.dict.sizeRange=[];
    $scope.dict.images=[];


    
	$scope.dict.getGarment=function(styleNumber){

		var garment=null;
		if(styleNumber){
			for (i = 0; i < $scope.dict.garments.length; i++) {
			    if ($scope.dict.garments[i].styleNumber === styleNumber) {
			    	garment=$scope.dict.garments[i];
			    	break; 
			    }
			}		
		}
		return garment;
	};
	
	
	$scope.dict.insertGarment=function(garment){
		$scope.dict.garments.push(garment);
	};
	
	$scope.dict.getImage=function(imageId){
		var image=null;
		if(imageId){
			for (i = 0; i < $scope.dict.images.length; i++) {
			    if ($scope.dict.images[i].id ===imageId) {
			    	image=$scope.dict.images[i];
			    	break; 
			    }
			}		
		}
		return image;
	}
	
	$scope.dict.insertImage=function(image){
		$scope.dict.images.push(image);
	};
	
	$scope.dict.getRemoteImages=function(){
		
		if($scope.order.orderInfo.orderId){
			var imageString="";
			for(var i=0;i<$scope.order.imageItems.length;i++){
				if($scope.order.imageItems[i].imageId){
					imageString+=","+$scope.order.imageItems[i].imageId;
				}
			}
			if(imageString!==""){

				var url=$scope.setting.libraryUrl+"get-images?ids="+imageString.substr(1);
				$http.get(url).
					success(function(data) {

					    if(data){
					    	$scope.dict.images=data;
					    }
					}).
					error(function(data, status, headers, config) {
						  alert( "failure message: " + JSON.stringify({data: data}));
					   });	
			}
		}
	}
	
}]);

</script>