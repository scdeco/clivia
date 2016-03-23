<script>
orderApp.config(function($stateProvider, $urlRouterProvider,consts) {

	$urlRouterProvider.otherwise('/');
	
	$stateProvider
		.state('main', {
			url : '/',
			views : {
				'main' : {
					templateUrl : 'ordermain',
					controller : 'orderMainCtrl'
				},

				'orderitem@main' : {
					templateUrl : 'orderitem',
					controller : 'orderItemCtrl'
				}
			},
	
		})
		.state('main.blankitem', {
			url : '',
			template : '<h3>add new items</h3>',
		});

	var itemUrl = 'item:{orderItemId:[0-9]{1,3}}';
	var itemTypes=consts.registeredItemTypes;
	
	for(var i=0; i<itemTypes.length; i++){
		var type=itemTypes[i];
		$stateProvider.state('main.'+type.name, {
			url : itemUrl,
			templateUrl : type.name,
			controller : type.name+'Ctrl'
		});
		if(type.hasDetail){
			$stateProvider.state('main.'+type.name+'.detail', {
				url : '/detail:{'+type.name+'Id:[0-9]{1,3}}',
				templateUrl : type.name+'Detail',
				controller : type.name+'DetailCtrl'
			});
		}
	}
	
/* 	.state('main.lineitem', {
		url : orderItemUrl,
		templateUrl : 'item/lineitem',
		controller : 'lineitemCtrl'
	})

	
	.state('main.lineitem.detail', {
		url : '/detail:{lineItemId:[0-9]{1,3}}',
		templateUrl : 'item/lineitemdetail',
		controller : 'lineitemdetailCtrl'
	}) */	
});
</script>