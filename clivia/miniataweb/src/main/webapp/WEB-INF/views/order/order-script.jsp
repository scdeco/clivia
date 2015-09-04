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
        	
});

orderApp.controller("orderCtrl", ["$scope",function($scope) {
	
	$scope.searchOrderNumber="";

	$scope.order={};
	$scope.order.lineItems=new kendo.data.ObservableArray([]);
	
}]);

</script>