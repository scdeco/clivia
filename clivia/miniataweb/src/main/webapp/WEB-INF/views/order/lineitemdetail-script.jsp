<script>
orderApp.controller("lineitemdetailCtrl",["$scope","$http","$stateParams" ,function($scope,$http,$stateParams){
	var orderItemId =parseInt($stateParams.orderItemId);
	var lineItemId=parseInt($stateParams.lineItemId);
	
	$scope.detailOrderItemId=orderItemId;
	$scope.detailLineItemId=lineItemId;

}]);
</script>