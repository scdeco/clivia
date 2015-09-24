<script>

var orderApp=angular.module("orderApp", ["ui.router","kendo.directives"]);

orderApp.config(function($stateProvider, $urlRouterProvider) {
	
     $urlRouterProvider.otherwise('/');
   
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
        
        .state('main.lineitem', {
 	       	url: 'item/{orderItemId:[0-9]{1,3}}',
           	templateUrl: 'lineitem',
           	controller: 'lineItemCtrl'	
 	     }) 
 	     
 	     .state('main.orderimage', {
  	       	url: 'item/{orderItemId:[0-9]{1,3}}',
           	templateUrl: 'orderimage',
           	controller: 'orderImageCtrl'	
 	     })
        
});

orderApp.controller("orderCtrl",["$scope","$http",function($scope,$http) {
	$scope.setting={};	
	$scope.setting.lineItemCarryOn=false;
	
	$scope.searchOrderNumber="";

	$scope.order={};
	$scope.order.orderInfo={};
	$scope.order.orderItems=[];
	$scope.order.lineItems=new kendo.data.ObservableArray([]);
	$scope.order.imageItems=new kendo.data.ObservableArray([]);
	
	$scope.order.deletedItems=[];
	
	$scope.dict={};
	$scope.dict.garments=[];
    $scope.dict.colourway=[];//new kendo.data.ObservableArray([])
    $scope.dict.sizeRange=[];//new kendo.data.ObservableArray([])
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
		
		
	}
	
}]);

</script>